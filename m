From: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH nf-next v2] ipvs: use nf_ct_kill helper
Date: Fri, 12 Aug 2016 13:21:10 +0200
Message-ID: <20160812112108.GA4464@verge.net.au>
References: <1470230488-302-1-git-send-email-fw@strlen.de>
 <20160812102443.GA3086@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	lvs-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:54358 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbcHLLVS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 07:21:18 -0400
Content-Disposition: inline
In-Reply-To: <20160812102443.GA3086@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Fri, Aug 12, 2016 at 12:24:43PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 03, 2016 at 03:21:28PM +0200, Florian Westphal wrote:
> > Once timer is removed from nf_conn struct we cannot open-code
> > the removal sequence anymore.
> 
> @Simon and other IPVS folks: I'm going to take this patch since
> Florian needs this merged for follow up patches.
> 
> So I'm dealing with this small one.

Sure, please do.
