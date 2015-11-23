From: Borislav Petkov <bp@alien8.de>
Subject: Re: nfnetlink warnings
Date: Mon, 23 Nov 2015 10:54:55 +0100
Message-ID: <20151123095455.GB5134@pd.tnic>
References: <20151123093607.GA5134@pd.tnic>
 <5652E12E.3070500@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
To: Michael Wang <yun.wang@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5652E12E.3070500@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Michael,

On Mon, Nov 23, 2015 at 10:49:34AM +0100, Michael Wang wrote:
> Why not just initialized it as NULL, or mark it as uninitialized_var()?

because I'd like us to save us the redundant NULL initialization in the
if-case.

I'm not saying any of the approaches are good visually, though. Who
knows, someone might have a better idea like, maybe "Oh, I wanted to
rewrite that code and this handlong is going to be different anyway ..."
or so. Or something to that effect.

Btw, please do not top-post.

Thanks.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
