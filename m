From: Jan Engelhardt <jengelh@medozas.de>
Subject: Ulogd patch series
Date: Tue, 20 Jan 2009 12:16:05 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901201214520.13700@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: eric@inl.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39847 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407AbZATLQJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Jan 2009 06:16:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


here are a bunch of patches that seemed to come in handy whilst 
packaging ulogd as rpm.

Please pull from
	git://dev.medozas.de/ulogd master

to recieve:
Jan Engelhardt (5):
      build: compile fix
      Update .gitignore and remove install-sh
      build: use -avoid-version for modules
      build: resolve autotools suggestions to use AC_CONFIG_MACRO_DIR
      build: update configure.ac


Patches will be posted for review as replies.
