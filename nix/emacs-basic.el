;; initialize package
(require 'package)
(package-initialize)
(package-initialize 'noactivate)

(require 'use-package)
(require 'use-package-ensure)
(setq use-package-always-ensure t)

; Show column numbers
(setq-default column-number-mode t)

; Clean trailing whitespace, show it if it happens
(setq-default show-trailing-whitespace t)
(use-package ws-butler
             :ensure t)
(ws-butler-global-mode 1)

; Never use tabs to indent
(setq-default indent-tabs-mode nil)

; show unicode whitespace
;(require 'unicode-whitespace)
;(unicode-whitespace-setup 'subdued-faces)

; Show tabs
;(setq whitespace-style '(face tabs tab-mark))
;(setq-default global-whitespace-mode t)

; Show key bindings
(use-package which-key
             :ensure t)
