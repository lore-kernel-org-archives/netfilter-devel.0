From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 0/2] NFLOG and NFQUEUE fixes
Date: Tue,  4 Mar 2008 10:46:01 +0100
Message-ID: <1204623963-10600-1-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:50961 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbYCDJqE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:46:04 -0500
Received: from khasse.inl.fr ([192.168.33.176])
	by fydelkass.inl.fr with esmtps (TLS-1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <regit@inl.fr>)
	id 1JWTil-0000Wt-8V
	for netfilter-devel@vger.kernel.org; Tue, 04 Mar 2008 10:46:03 +0100
Received: from regit by khasse.inl.fr with local (Exim 4.69)
	(envelope-from <regit@khasse.inl.fr>)
	id 1JWTil-0002qI-6L
	for netfilter-devel@vger.kernel.org; Tue, 04 Mar 2008 10:46:03 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

This patchset is against latest git tree and contains the same fixes as the
patchset against 2.6.24.3 that I've just sent.

Extended information: 

The following two patches fix similar bugs in NFQUEUE and NFLOG. The allocated
size of the skb use for the netlink message was too small due to the use of
NLMSG_ALIGN instead of NLMSG_SPACE. In fact, the size for the initial netlink
header was missing.

The effect on my setup was the drop of all queued packets of length inside
the range [8*k+41, 8*k+48] with k an integer.

Effect on NFLOG has not been tested and is not known.

BR,
--
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
