From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 0/5] UID dump support in NFLOG, IPCMPv6 support in SQL
Date: Sat,  9 Feb 2008 13:36:30 +0100
Message-ID: <12025605952271-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:54965 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752822AbYBIMgh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:36:37 -0500
Received: from eric by localhost with local (Exim 4.67)
	(envelope-from <eric@bayen.regit.org>)
	id 1JNowd-00077y-MK
	for netfilter-devel@vger.kernel.org; Sat, 09 Feb 2008 13:36:35 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

This patchset starts with two minor code cleaning patches.

The rest of patchset contains some more significative things:
 * Add UID in NFLOG (ood.uid) and make PRINTPKT able to display the key if
 present
 * Add IPCMPv6 support to SQL schema

BR,
--
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
