From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/1] netfilter: nf_tables: fix big endian problems
Date: Sat, 12 Apr 2014 13:17:56 +0200
Message-ID: <1397301477-16204-1-git-send-email-kaber@trash.net>
Cc: arturo.borrero.glez@gmail.com, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42491 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbaDLLSG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2014 07:18:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is the last patch required to fix the big endian problems observed
by Arturo on Sparc. The changelog contains a detailed explanation of the
problem.

This should also go to -stable.

