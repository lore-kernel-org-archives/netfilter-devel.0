From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Fri, 21 May 2004 03:40:35 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405210317470.14542-100000@filer.marasystems.com>
References: <40AD3CB7.1070107@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40AD3CB7.1070107@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 21 May 2004, Pablo Neira wrote:

> b) We don't need to set assured bit all the time, I think that I told 
> you, well if so, sorry for repeating me.

>          } else if ((old_state == TCP_CONNTRACK_SYN_RECV
>                     || old_state == TCP_CONNTRACK_ESTABLISHED)
> -                   && new_state == TCP_CONNTRACK_ESTABLISHED)
> +                 && new_state == TCP_CONNTRACK_ESTABLISHED
> +                 && !test_bit(IPS_ASSURED_BIT, &conntrack->status)) {

Are you sure this really is an optimization in the current code? Is 
test_bit really faster than set_bit when the bit is already set?

But still I second this change. If ctnetlink is used then there is 
additional actions taken when the bit is set and this should only be done 
once.

Also, is it really the case that this operation needs to be atomic?

> c) In the TCP_CONNTRACK_SYN_SENT case, we saw a SYN packet while staying 
> in state TIME_WAIT, so there's a reopened connection. Why do we destroy 
> the conntrack and don't recycle /reuse this conntrack? I mean, 
> reinitilize all the fields and let it continue its travel through the 
> tcp tracking of instead of returning NF_REPEAT.

Simplicity?

It is not a very common operation.

> e) I'm not sure if it's worthy optimizing this case. In tcp_new, we are 
> checking if a packet is clean as well as size of tcp header, then in 
> tcp_packet we will do the same, so we are doing twice the same checking. 
> If we consider that general case is that packets are clean, will be this 
> double check worthy?

The old conntrack code did not verify anything in tcp_new..  but it is 
wise to check that there is a tcp header before trying to access field 
members in the header and with tcp_new being called before tcp_packet on 
new connections but only tcp_packet on already known connections...

But there is one obvious way to optimize this.. move the check for a valid 
TCP header to the pkt_to_tuple function. But I think ICMP error processing 
may complicate this a bit so maybe it is not so easy.

Regards
Henrik
