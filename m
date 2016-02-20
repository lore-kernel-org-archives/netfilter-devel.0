From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: bridge: nf queue verdict to
 use NFQA_VLAN and NFQA_L2HDR
Date: Sat, 20 Feb 2016 10:56:31 +0100
Message-ID: <20160220095631.GB15411@breakpoint.cc>
References: <1455959230-3680-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1455959230-3680-3-git-send-email-stephane.ml.bryant@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Stephane Bryant <stephane.ml.bryant@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54117 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1427442AbcBTJ4e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Feb 2016 04:56:34 -0500
Content-Disposition: inline
In-Reply-To: <1455959230-3680-3-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephane Bryant <stephane.ml.bryant@gmail.com> wrote:
> This makes nf queues use NFQA_VLAN and NFQA_L2HDR in verdict to modify the
> original skb

Looks good to me, thanks for addressing all my comments.

