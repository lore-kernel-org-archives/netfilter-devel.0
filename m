From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
	<yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] nf_conntrack: optimize hash calculation of tuple
Date: Fri, 26 May 2006 22:45:56 +0900 (JST)
Message-ID: <20060526.224556.19965528.yoshfuji@linux-ipv6.org>
References: <200605260015.k4Q0FpPC024839@toshiba.co.jp>
	<447703F2.90401@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <447703F2.90401@trash.net>
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

In article <447703F2.90401@trash.net> (at Fri, 26 May 2006 15:34:42 +0200), Patrick McHardy <kaber@trash.net> says:


> > +	return c % size;
> >  }
> 
> 
> That still looks pretty expensive. Is there a reason why you didn't
> just add/xor/or/... the individual values until you get down to
> three and then use jhash_3words? We could also get rid of the modula
> operation by making sure the hash-size is always a power of 2.

I disagree.  Suhc oprations are not good for randomness.
And, gcc is cleaver enough to convert it to shift operation.

--yoshfuji
