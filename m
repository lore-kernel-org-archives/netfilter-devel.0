From: Peter Osterlund <petero2@telia.com>
Subject: Re: [PATCH-2.4.26] ip6tables cleanup
Date: 28 Mar 2004 21:27:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <m2d66wsrg2.fsf@p4.localdomain>
References: <20040328042608.GA17969@logos.cnet>
	<20040328115439.GA24421@pcw.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>,
	linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Willy TARREAU <willy@w.ods.org>
In-Reply-To: <20040328115439.GA24421@pcw.home.local>
List-Id: netfilter-devel.vger.kernel.org

Willy TARREAU <willy@w.ods.org> writes:

> 2.4.26-rc1 returned this warning compiling ip6_tables :
> 
> ip6_tables.c: In function `tcp_match':
> ip6_tables.c:1596: warning: implicit declaration of function `ipv6_skip_exthdr'
> 
> I had to add a cast because ipv6_skip_exthdr() expects a 'struct sk_buff*' while
> its caller uses a 'const struct sk_buff*'. Here is a cleanup patch.

I think it would be better to change the ipv6_skip_exthdr() function
to take a const struct sk_buff* instead. Unnecessary casts are evil.

-- 
Peter Osterlund - petero2@telia.com
http://w1.894.telia.com/~u89404340
