From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/7] extensions: remove MIRROR
Date: Thu, 19 Feb 2015 14:34:40 +0100
Message-ID: <20150219133440.GA24297@breakpoint.cc>
References: <1424351483-27617-1-git-send-email-fw@strlen.de>
 <1424351483-27617-2-git-send-email-fw@strlen.de>
 <alpine.LSU.2.11.1502191428000.27892@nerf60.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58518 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746AbbBSNem (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2015 08:34:42 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1502191428000.27892@nerf60.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> On Thursday 2015-02-19 14:11, Florian Westphal wrote:
> 
> >removed from the kernel back in 2003.
> 
> Last time I remember, Pablo wanted to keep this. Because modern iptables 
> may still be used with overly old preexisting kernels.

Fair enough, I can just omit the target/match removal patches when
pushing the changes.
