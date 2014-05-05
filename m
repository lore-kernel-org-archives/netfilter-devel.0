From: Sergey Popovich <popovich_sergei@mail.ru>
Subject: [PATCH 0/2] hash:net,net and hash:net,port,net fixes and debug output extending
Date: Mon,  5 May 2014 11:07:04 +0300
Message-ID: <cover.1399275196.git.popovich_sergei@mail.ru>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fallback4.mail.ru ([94.100.176.42]:53419 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbaEEIJr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 May 2014 04:09:47 -0400
Received: from smtp4.mail.ru (smtp4.mail.ru [94.100.176.44])
	by fallback4.mail.ru (mPOP.Fallback_MX) with ESMTP id A745B246002C
	for <netfilter-devel@vger.kernel.org>; Mon,  5 May 2014 12:07:30 +0400 (MSK)
Received: from [195.234.68.4] (port=40497 helo=tuxracer.skif.com.ua)
	by smtp4.mail.ru with esmtpa (envelope-from <popovich_sergei@mail.ru>)
	id 1WhDvc-0003Yx-OM
	for netfilter-devel@vger.kernel.org; Mon, 05 May 2014 12:07:13 +0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This small series present two patches one of which fixes
problem with element ranges support in hash:net,net and
hash:net,port,net set types. Second one just extends debugging
output for three dimension sets when ipset/library compiled
with IPSET_DEBUG.

See individual patch description for more information.

Sergey Popovich (2):
  libipset: print third element in debugging
  netnet,netportnet: Fix value range support for IPv4

 kernel/net/netfilter/ipset/ip_set_hash_netnet.c     |   13 +++++++------
 kernel/net/netfilter/ipset/ip_set_hash_netportnet.c |    6 ++++--
 lib/parse.c                                         |    4 +++-
 3 files changed, 14 insertions(+), 9 deletions(-)

-- 
1.7.10.4

