From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Mon, 21 Jun 2004 12:14:05 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406211102000.23953-100000@filer.marasystems.com>
References: <Pine.LNX.4.33.0406211033420.31871-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira <pablo@eurodev.net>, Martin Josefsson <gandalf@wlug.westbo.se>,
   Patrick McHardy <kaber@trash.net>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0406211033420.31871-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 21 Jun 2004, Jozsef Kadlecsik wrote:

> We always have to remind ourselves that the sole task of the connection
> tracking subsystem is to keep track of connections as good as possible.
> We drop packets directly only when letting trough the packet would render
> connection tracking useless (therefore it's so rare). We *advice* the
> admin to drop packets by flagging it as INVALID when we can surely say
> that the packet in question is invalid in the context of the connection
> where it seems to belong to. But it's practically as strong a decision
> as dropping the packet directly, so we have to be careful there as well.

I stronly agree with the above.

conntrack MUST NOT drop packets only because the meaning of the packet is 
undefined today.

conntrack MAY drop packets if the packet is in conflict with already 
tracked sessions, but I prefer not unless there is no other way to solve 
it (for example in MASQUERADE if there is no free tuple).

The only case I know of where it may be considered OK for conntrack to 
drop packets is the hack in various protocol helpers if a command is 
fragmented and in the packet reassembly. The helpers need to temporarily 
drop packets to cause TCP stream reassembly, and packet reassembly needs 
to drop packets to avoid DoS.

In all other situations involving packets which could not be 
properly tracked INVALID should be returned unless there is very 
strong reasons in terms of other tracked connections to do otherwise.

> I had already hesitated over the implications of the code
> 
> ++      /* 15 is the highest 'known' ICMP code. See RFC 1812 */
> ++      if (icmph.code > 15) {
> ++              if (LOG_INVALID(IPPROTO_ICMP))
> ++                      nf_log_packet(PF_INET, 0, skb, NULL, NULL,
> ++                                    "ip_ct_icmp: invalid ICMP code ");
> ++              return -NF_ACCEPT;
> ++      }

This is a good case where INVALID is the appropriate response. As the code
is not defined today it can not be defined how/if it should be tracked,
but this alone is not a reason to drop the packet.

This principle is also strongly advocated in RFC 1812 as "MUST NOT drop
(receive or forward) a packet merely becasue one or more of these reserved
bits has a non-zero value". This specific quote is from the IP header
section, but just empazises the golden rule of Internet networking: "be
strict in what you send, liberal in what you accept/forward".

Unless I have misunderstood the prior discussion regarding return values
the above code is actaully correct save for the confusing use of negative
NF_ACCEPT..  These ICMP codes is undefined and it can not be defined how
these should be tracked so these packets needs to be marked as INVALID in
terms of conntrack status. Logging them as "invalid ICMP code" is perhaps
a little harsh and should maybe read "unknown ICMP code" and the return
value should be fixed to return CONNTRACK_INVALID or similar instead of
overloading NF_ACCEPT as per the prior discussion regarding return 
values..

Regards
Henrik
