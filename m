From: Thomas Jacob <jacob@internet24.de>
Subject: [PATCH 0/3] Further speedup of iptables when modifying an existing ruleset
Date: Wed,  2 Jul 2008 20:00:32 +0200
Message-ID: <1215021635-28691-1-git-send-email-jacob@internet24.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:55460 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYGBSAO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 14:00:14 -0400
Received: from mailin03.ims-firmen.de ([192.168.1.112])
	by mailout02.ims-firmen.de with esmtp (Exim 4.67)
	(envelope-from <jacob@internet24.de>)
	id 1KE6cn-0002Iq-LK
	for netfilter-devel@vger.kernel.org; Wed, 02 Jul 2008 20:00:13 +0200
Received: from [213.174.32.254] (helo=localhost.localdomain)
	by mailin03.ims-firmen.de with esmtpa (Exim 4.69)
	(envelope-from <jacob@internet24.de>)
	id 1KE6cn-0002JJ-JJ
	for netfilter-devel@vger.kernel.org; Wed, 02 Jul 2008 20:00:13 +0200
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This version includes the coding style changes, but still employs the macro
to implement the binary interval search.


