From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 0/12] add support for VLAN header filtering in bridge
 family
Date: Mon, 21 Sep 2015 16:18:24 +0200
Message-ID: <20150921141824.GB931@breakpoint.cc>
References: <1439751955-31190-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49615 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431AbbIUOS0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Sep 2015 10:18:26 -0400
Content-Disposition: inline
In-Reply-To: <1439751955-31190-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> This adds the following features:
> - stacked headers: vlan sits on top of ethernet, so when vlan id 42 is requested,
>   add a dependency on eth and also adjust payload offsets by the size of ethernet
>   header.
> 
> - allow matching header fields of lengths and/or offsets that are not byte divisible,
>   e.g. vlan id, vlan pcp, ip hdrlength, etc.

pushed it to master.
