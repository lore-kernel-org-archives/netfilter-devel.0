From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: nfnetlink warnings
Date: Mon, 23 Nov 2015 11:20:18 +0100
Message-ID: <5652E862.7000605@profitbricks.com>
References: <20151123093607.GA5134@pd.tnic>
 <5652E12E.3070500@profitbricks.com> <20151123095455.GB5134@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151123095455.GB5134@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 11/23/2015 10:54 AM, Borislav Petkov wrote:
> Hi Michael,
> 
> On Mon, Nov 23, 2015 at 10:49:34AM +0100, Michael Wang wrote:
>> Why not just initialized it as NULL, or mark it as uninitialized_var()?
> 
> because I'd like us to save us the redundant NULL initialization in the
> if-case.

Well, I would vote initialized with NULL, rather than use another else
branch to do the same thing.

> 
> I'm not saying any of the approaches are good visually, though. Who
> knows, someone might have a better idea like, maybe "Oh, I wanted to
> rewrite that code and this handlong is going to be different anyway ..."
> or so. Or something to that effect.

Who want to do that would take responsibility to make an else branch at
that time, but reserve the branch at this moment sounds unnecessary, and
not that pretty frankly speaking.

> 
> Btw, please do not top-post.

Enjoy ;-)

Regards,
Michael Wang

> 
> Thanks.
> 
