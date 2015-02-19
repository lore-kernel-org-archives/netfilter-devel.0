From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 1/7] extensions: remove MIRROR
Date: Thu, 19 Feb 2015 14:28:53 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1502191428000.27892@nerf60.vanv.qr>
References: <1424351483-27617-1-git-send-email-fw@strlen.de> <1424351483-27617-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares61.inai.de ([5.9.23.85]:46905 "EHLO ares60.inai.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752758AbbBSN2z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2015 08:28:55 -0500
In-Reply-To: <1424351483-27617-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2015-02-19 14:11, Florian Westphal wrote:

>removed from the kernel back in 2003.

Last time I remember, Pablo wanted to keep this. Because modern iptables 
may still be used with overly old preexisting kernels.
