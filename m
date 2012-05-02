From: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH v3 2/2] netfilter: ipvs: use GFP_KERNEL allocation where
 possible
Date: Wed, 2 May 2012 10:19:50 +0900
Message-ID: <20120502011949.GA20415@verge.net.au>
References: <1334421467-30313-1-git-send-email-levinsasha928@gmail.com>
 <1334421467-30313-2-git-send-email-levinsasha928@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: wensong@linux-vs.org, ja@ssi.bg, kaber@trash.net,
	davem@davemloft.net, davej@redhat.com, netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Sasha Levin <levinsasha928@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:34988 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab2EBBjb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 May 2012 21:39:31 -0400
Content-Disposition: inline
In-Reply-To: <1334421467-30313-2-git-send-email-levinsasha928@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 14, 2012 at 12:37:47PM -0400, Sasha Levin wrote:
> Use GFP_KERNEL instead of GFP_ATOMIC when registering an ipvs protocol.
> 
> This is safe since it will always run from a process context.

For the benefit of patchwork, this patch is in ipvs-next.

Thanks again for the good work.
