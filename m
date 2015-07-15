From: Jan Engelhardt <jengelh@inai.de>
Subject: iptables: AH/ESP init fix, and a build fix
Date: Wed, 15 Jul 2015 14:53:37 +0200
Message-ID: <1436964819-28109-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:33666 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbbGOMxm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 08:53:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


One build fix I needed to get it running again, and then a lightly-tested
(manual only, without python) fix for
the email thread

"Subject: [Q] iptables AH module api mismatch between -master and 1.4.7"
(Message-ID: <20150715121521.GK2034@uranus>)


===
The following changes since commit 16964a99a61ff1d7cb0c260ed50b9f91f7b7a783:

  extensions: libxt_socket: add --restore-skmark option (2015-06-30 17:26:37 +0200)

are available in the git repository at:

  git://git.inai.de/iptables HEAD

for you to fetch changes up to 8c03f8ee5e4959bd5057e6b85314c6314e46843d:

  extensions: restore matching any SPI id by default (2015-07-15 14:50:51 +0200)

----------------------------------------------------------------
Jan Engelhardt (2):
      build: resolve build error involving libnftnl
      extensions: restore matching any SPI id by default

 extensions/GNUmakefile.in | 2 +-
 extensions/libip6t_ah.c   | 9 +++++++++
 extensions/libip6t_ah.t   | 1 +
 extensions/libip6t_rt.c   | 8 ++++++++
 extensions/libip6t_rt.t   | 1 +
 extensions/libipt_ah.c    | 8 ++++++++
 extensions/libipt_ah.t    | 1 +
 extensions/libxt_esp.c    | 8 ++++++++
 extensions/libxt_esp.t    | 1 +
 9 files changed, 38 insertions(+), 1 deletion(-)
