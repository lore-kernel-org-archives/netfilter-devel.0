From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH v2] conntrack-tools: Fix build for old automake
Date: Mon,  4 Apr 2016 11:39:39 +0200
Message-ID: <1459762780-10255-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at02-3.mx.upcmail.net ([62.179.121.150]:30848 "EHLO
	vie01a-dmta-at02-3.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755006AbcDDJj7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Apr 2016 05:39:59 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-pe01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1an0z8-0000cA-WF
	for netfilter-devel@vger.kernel.org; Mon, 04 Apr 2016 11:39:51 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Good day,

on my old system with automake 1.11 creating the build environment
with autoreconf fails.
I'm a automake newb, but this patch solves this for me.
I hope it's appropriate.

Resending this as missing signed off and format-patch didn't put a newline after subject.

Best regards,
Mart
