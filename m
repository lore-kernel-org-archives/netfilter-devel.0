From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] nf_conntrack: optimize hash calculation of tuple
Date: Sat, 27 May 2006 00:04:17 +0900 (JST)
Message-ID: <200605261504.k4QF4Iph003626@toshiba.co.jp>
References: <447703F2.90401@trash.net>
	<20060526.224556.19965528.yoshfuji@linux-ipv6.org>
	<447707EB.7000401@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <447707EB.7000401@trash.net>
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


Hi, Patrick,

> >>That still looks pretty expensive. Is there a reason why you didn't
> >>just add/xor/or/... the individual values until you get down to
> >>three and then use jhash_3words? We could also get rid of the modula
> >>operation by making sure the hash-size is always a power of 2.
> >
> >
> > I disagree.  Suhc oprations are not good for randomness.
> > And, gcc is cleaver enough to convert it to shift operation.
> 
> 
> Assuming you're talking the modula operation: gcc can't do that,
> a modula operation can only be represented by a shift for a small
> subset of the possible values. The randomness is provided by
> jhash + the initial random value. If we rely on randomness by
> some assumption about the hash size our code is already broken.
> But anyway, this is just a possible micro-optimization, the
> real question is why we need three invocations of jhash_mix.

That patch is just the result of extracting jhash() and jhash_2words().
I'm not familiar with hash algorithms. Does the degree of distribution
become bad if we replaces 3 jhash_mix with something like XOR ?

-- kozakai
