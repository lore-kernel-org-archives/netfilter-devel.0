From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH 0/1] iptables: extensions: add idletimer target extension
Date: Mon, 14 Jun 2010 17:33:09 +0300
Message-ID: <1276525990-7058-1-git-send-email-luciano.coelho@nokia.com>
Cc: netfilter-devel@vger.kernel.org, jukka.rissanen@nokia.com
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:36482 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab0FNOeJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:34:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This is my patch to add the idletimer target extension to the iptables tool, to
provide userspace support for the related patch I sent to the kernel.

I'm not sure whether this needs to wait until the kernel patch is released in
Linus's tree before we can include it into the iptables tool, but I'm sending
it already now, in case someone wants to try it out and use it.  We can revisit
this later when the kernel patch is released, if needed.

Cheers,
Luca.

Luciano Coelho (1):
  extensions: add idletimer xt target extension

 extensions/libxt_IDLETIMER.c           |  141 ++++++++++++++++++++++++++++++++
 extensions/libxt_IDLETIMER.man         |   19 ++++
 include/linux/netfilter/xt_IDLETIMER.h |   45 ++++++++++
 3 files changed, 205 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libxt_IDLETIMER.c
 create mode 100644 extensions/libxt_IDLETIMER.man
 create mode 100644 include/linux/netfilter/xt_IDLETIMER.h

