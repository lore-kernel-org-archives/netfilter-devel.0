From: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH nf-next] netfilter: ipvs: Remove useless ipvsh param of
 frag_safe_skb_hp
Date: Wed, 22 Nov 2017 19:14:28 +0100
Message-ID: <20171122181428.qaqyodgflfmhtm25@verge.net.au>
References: <1510585098-27428-1-git-send-email-gfree.wind@vip.163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: wensong@linux-vs.org, ja@ssi.bg, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
To: gfree.wind@vip.163.com
Return-path: <lvs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1510585098-27428-1-git-send-email-gfree.wind@vip.163.com>
Sender: lvs-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Nov 13, 2017 at 10:58:18PM +0800, gfree.wind@vip.163.com wrote:
> From: Gao Feng <gfree.wind@vip.163.com>
> 
> The param of frag_safe_skb_hp, ipvsh, isn't used now. So remove it and
> update the callers' codes too.
> 
> Signed-off-by: Gao Feng <gfree.wind@vip.163.com>
> ---
>  Simon advise me send the patch to netfilter group

Acked-by: Simon Horman <horms+renesas@verge.net.au>

Pablo, can you take this through the nf-next tree?
