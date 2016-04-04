From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH] conntrack-tools: Fix build for old automake
Date: Mon,  4 Apr 2016 11:29:38 +0200
Message-ID: <1459762179-10041-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at03-1.mx.upcmail.net ([62.179.121.151]:11370 "EHLO
	vie01a-dmta-at03-1.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334AbcDDJ3v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Apr 2016 05:29:51 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at03.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1an0pO-0001Xw-C0
	for netfilter-devel@vger.kernel.org; Mon, 04 Apr 2016 11:29:46 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Good day,

on my old system with automake 1.11 creating the build environment
with autoreconf fails.
I'm a automake newb, but this patch solves this for me.
I hope it's appropriate.

Best regards,
Mart

