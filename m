From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Fri, 21 May 2004 10:11:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040521081115.GA4605@alpha.home.local>
References: <Pine.LNX.4.33.0405201307440.5246-100000@blackhole.kfki.hu> <40AD3CB7.1070107@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
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

On Fri, May 21, 2004 at 01:18:15AM +0200, Pablo Neira wrote:
 
> c) In the TCP_CONNTRACK_SYN_SENT case, we saw a SYN packet while staying 
> in state TIME_WAIT, so there's a reopened connection. Why do we destroy 
> the conntrack and don't recycle /reuse this conntrack? I mean, 
> reinitilize all the fields and let it continue its travel through the 
> tcp tracking of instead of returning NF_REPEAT.

I seem to recall that it was the only way to mark it NEW again. Otherwise,
it would still match the ESTABLISHED state and not necessarily be logged
or whatever, depending on the rules.

> e) I'm not sure if it's worthy optimizing this case. In tcp_new, we are 
> checking if a packet is clean as well as size of tcp header, then in 
> tcp_packet we will do the same, so we are doing twice the same checking. 
> If we consider that general case is that packets are clean, will be this 
> double check worthy?

I remember that we already discussed this once with Jozsef, and it ended up
that we didn't want to create a new session on invalid packets, so the check
in tcp_new was necessary, and that of course we wanted to do the check in
tcp_packet for all subsequent packets. One alternative would be to call
tcp_unclean() from tcp_packet() only if the packet has not passed through
tcp_new previously. Something based on the conntrack state might be OK IMHO.

Regards,
Willy
