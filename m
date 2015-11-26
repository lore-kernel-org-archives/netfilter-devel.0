From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 0/3] src: trace infrastructure support
Date: Thu, 26 Nov 2015 18:59:36 +0100
Message-ID: <1448560779-28989-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37510 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442AbbKZR7s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 12:59:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is V2 of the nft trace patch set.

See the individual patches for a change vs. v1 description.

Patrick: I did a quick test w. your last public patches
(plus a few minor changes to make it build again) and things
seem to work fine.

What does not work correctly is decoding of vlan header.
I think whats happening is that we cannot splice sub-byte
sized quantities from a larger chunk.

Other than that, things appear to work correctly.

Cheers,
Florian

