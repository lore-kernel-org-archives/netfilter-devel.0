From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 7/7] extensions: libip6t_dst: make inversion work
Date: Thu, 19 Feb 2015 14:33:04 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1502191432250.27892@nerf60.vanv.qr>
References: <1424351483-27617-1-git-send-email-fw@strlen.de> <1424351483-27617-8-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares61.inai.de ([5.9.23.85]:46918 "EHLO ares60.inai.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753156AbbBSNdF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2015 08:33:05 -0500
In-Reply-To: <1424351483-27617-8-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2015-02-19 14:11, Florian Westphal wrote:

>The inversion flag wasn't set in the match struct.

The documentation needs to be updated too.

It reflected what source code did: not supportting the "!" option at 
all/silently ignoring it.
