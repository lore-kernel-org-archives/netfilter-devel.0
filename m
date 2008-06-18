From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 0/3] Misc fixes
Date: Wed, 18 Jun 2008 17:30:10 +0200
Message-ID: <1213803013-19433-1-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:44478 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYFRPaO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:30:14 -0400
Received: from khasse.inl.fr ([192.168.33.176])
	by fydelkass.inl.fr with esmtps (TLS-1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <regit@inl.fr>)
	id 1K8zbx-0005p7-MU
	for netfilter-devel@vger.kernel.org; Wed, 18 Jun 2008 17:30:13 +0200
Received: from regit by khasse.inl.fr with local (Exim 4.69)
	(envelope-from <regit@khasse.inl.fr>)
	id 1K8zbx-00054h-JO
	for netfilter-devel@vger.kernel.org; Wed, 18 Jun 2008 17:30:13 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This patchset contains three patches:
 1. Fix compilation of input plugin when libnetfilter library are non globally available.
 2. Fix warning about undeclared function.
 3. Backport of bugzilla 535: PCAP fix

Patchset statistics:
 input/flow/Makefile.am           |    3 ++-
 input/packet/Makefile.am         |    3 ++-
 input/packet/ulogd_inppkt_ULOG.c |    1 +
 output/pcap/ulogd_output_PCAP.c  |    2 +-
4 files changed, 6 insertions(+), 3 deletions(-)

BR,
--
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

