From: Eric Leblond <eric@inl.fr>
Subject: [stable-patch 0/2] NFQUEUE and NFLOG fixes.
Date: Tue,  4 Mar 2008 10:40:57 +0100
Message-ID: <1204623659-9507-1-git-send-email-eric@inl.fr>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:49995 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894AbYCDJlB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:41:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

The following two patches fix similar bugs in NFQUEUE and NFLOG. The allocated 
size of the skb use for the netlink message was too small due to the use of 
NLMSG_ALIGN instead of NLMSG_SPACE. In fact, the size for the initial netlink 
header was missing.

The effect on my setup was the drop of all queued packets of length inside
the range [8*k+41, 8*k+48] with k an integer.

Effect on NFLOG has not been tested and is not known.

BR,
--
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
