From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/3] netfilter: nf_tables: cleanup and a bugfix
Date: Sat, 29 Mar 2014 10:43:00 +0000
Message-ID: <1396089783-3984-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 219.Red-2-139-50.dynamicIP.rima-tde.net ([2.139.50.219]:19630
	"EHLO macbook.localnet" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751394AbaC2K46 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Mar 2014 06:56:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches contain some cleanup and preparation for variable sized data.
To support variable sized data, we need the length of each key for validation
of the register load. Move the key validation back into the init functions
of meta/ct to do this. This also qualifies as a cleanup in my opinion, the
split is quite unnatural and the code is easier to read by handling get and
set operations seperately.

Additionally a patch to add a missing ifdef for NFT_CT_MARK is included.

Please apply.
