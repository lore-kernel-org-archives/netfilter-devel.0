From: Peter Warasin <peter@endian.com>
Subject: [PATCH 0/2] adds ebt_nflog watcher
Date: Tue, 05 Feb 2008 19:29:20 +0100
Message-ID: <20080205185521.051763000@andrew.endian.com>
Cc: ebtables-devel@lists.sourceforge.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:58850 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbYBES4V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:56:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi guys

The following patches add ebt_nflog to the kernel tree and
the ebtables userland tool in order to make it possible to
use ebtables with ulogd2 through nfnetlink_log.

ebtables patches are against svn, kernel patches are against
2.6.22.16. I will rebase if necessary.

For now the ulog2 log lines look like this:

Feb  5 18:52:36 efw-1201175446 ulogd[13898]: EBTABLES IN=br0 \
OUT= MAC=00:e0:4c:77:11:bb:ff:ff:08:00:0c:00 

Not much information, I know. It's necessary to 
teach ulogd_raw2packet_BASE.c to understand the PF_BRIDGE
protocol. I will start with that work now, just wanted to 
post these patches to request comments, in order to make sure
I'm going the right direction.

BTW: As far as I can say, the ebt_ulog watcher is completely
broken. I think it's outdated and could be removed, since it
does log only bogus with recent ulogdX, due to wrong (not
updated) structs.
I tried to fix it also, but i think the effort is not worth.

kind regards,
peter

--
