From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: xt_LED and docs
Date: Sun,  6 Jun 2010 13:23:52 +0200
Message-ID: <1275823437-12089-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45390 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab0FFLYA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Jun 2010 07:24:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 132538f5c9f697702e6e08a11b796bdcaaba5fea:

  utils: add missing include flags to Makefile (2010-05-24 07:49:25 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Adam Nielsen (1):
      extensions: add the LED target

Jan Engelhardt (3):
      doc: xt_string: correct copy-and-pasting in manpage
      doc: xt_hashlimit: fix a typo
      doc: xt_LED: nroff formatting requirements

 extensions/libxt_LED.c         |  155 ++++++++++++++++++++++++++++++++++++++++
 extensions/libxt_LED.man       |   30 ++++++++
 extensions/libxt_hashlimit.man |    2 +-
 extensions/libxt_string.man    |    4 +-
 4 files changed, 189 insertions(+), 2 deletions(-)
 create mode 100644 extensions/libxt_LED.c
 create mode 100644 extensions/libxt_LED.man
