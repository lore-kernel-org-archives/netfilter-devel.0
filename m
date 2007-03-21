From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: NFNL_NFA_NEST
Date: Wed, 21 Mar 2007 11:39:43 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0703211137170.4799@blackhole.kfki.hu>
References: <4600BDBB.8020205@trash.net>
	<Pine.LNX.4.64.0703211014200.4799@blackhole.kfki.hu>
	<46010555.3010300@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46010555.3010300@trash.net>
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

On Wed, 21 Mar 2007, Patrick McHardy wrote:

> I don't want to remove the ability to nest attributes, just the
> NFNL_NFA_NEST bit on nested attributes (ORed in nfa_type):
>
> #define NFA_NEST(skb, type) \
>
>
> ({      struct nfattr *__start = (struct nfattr *) (skb)->tail; \
>        NFA_PUT(skb, (NFNL_NFA_NEST | type), 0, NULL); \
>        __start;  })
>
> Or did I misunderstand you and you actually use this for something?

No, the other way around, I misunderstood you :-). I don't use/plan to use 
the NFNL_NFA_NEST bit for anything.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
