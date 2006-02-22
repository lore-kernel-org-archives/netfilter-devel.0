From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 1/4] Fix expectaction mask dumping, take #3
Date: Wed, 22 Feb 2006 22:01:46 +0900 (JST)
Message-ID: <200602221301.k1MD1lpV023665@toshiba.co.jp>
References: <43F44794.1080203@trash.net> <43FB0FBA.4060609@netfilter.org>
	<43FBD887.9040409@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@netfilter.org
In-Reply-To: <43FBD887.9040409@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 22 Feb 2006 04:20:39 +0100

> > The problem is that currently the expectation mask is not dumped.
> > find_l3proto returns the generic protocol handler for 0xFF, and that
> > doesn't dump any layer 3 information.

Yes, I want this bug to go away before 2.6.16 is shipped.

> >                                        Moreover, the expectation mask has
> > l3num value that is different from the l3num in the nfnetlink header,
> > that's why I introduced this field.

Yes, but in the current code l3num in expectation mask is always 0xff.
And even if we port all helpers of ip_conntrack to nf_conntrack,
they will set 0xff to l3num.

Which situation kernel wants to set the value except of 0xff to l3num
in expectation mask ?

> > I can send a patch to remove the expectation mask dumping but I'm not
> > sure if this information could be useful for userspace helpers. Harald?
>
> I think I can answer myself after some thinking: in order to create an
> expectation from userspace we will need to set the value of l3num of the
> expectation mask. Such value will be different from the value in the
> nfnetlink header, so I still think that we need that new CTA_L3NUM
> attribute.

The similar question can arise. Which situation userspace wants to set
the value except of 0xff in l3num in expectation mask ?

-- Yasuyuki Kozakai
