From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Mon, 21 Jun 2004 14:46:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40D6D8A7.4040809@eurodev.net>
References: <Pine.LNX.4.33.0406211033420.31871-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Patrick McHardy <kaber@trash.net>,
 Martin Josefsson <gandalf@wlug.westbo.se>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Willy Tarreau <willy@w.ods.org>
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

Hi Jozsef,

Jozsef Kadlecsik wrote:

>>Would you be willing to apply the patch attached to pom-ng? It applies
>>to linux-2.6.patch_02-udp-icmp and it adds more checkings for invalid
>>icmp combinations.
>>    
>>
>
>Let us be very careful here and not add half of the unclean match to
>conntrack.
>  
>

thanks, it's always ok having someone who has the feet on the ground :-)

>We always have to remind ourselves that the sole task of the connection
>tracking subsystem is to keep track of connections as good as possible.
>We drop packets directly only when letting trough the packet would render
>connection tracking useless (therefore it's so rare). We *advice* the
>admin to drop packets by flagging it as INVALID when we can surely say
>that the packet in question is invalid in the context of the connection
>where it seems to belong to. But it's practically as strong a decision
>as dropping the packet directly, so we have to be careful there as well.
>
>I had already hesitated over the implications of the code
>
>++      /* 15 is the highest 'known' ICMP code. See RFC 1812 */
>++      if (icmph.code > 15) {
>++              if (LOG_INVALID(IPPROTO_ICMP))
>++                      nf_log_packet(PF_INET, 0, skb, NULL, NULL,
>++                                    "ip_ct_icmp: invalid ICMP code ");
>++              return -NF_ACCEPT;ç
>++      }
>
>because it means that if a new ICMP code is introduced, even if we modify
>the source code, all previously installed systems runnin netfilter
>(estimate that number) would refuse to handle the new ICMP code: we
>created a forward-incompatibility.
>  
>

that's true but, if that day comes, we can provide different ways to 
work around the problem:

- The admin could disable dropping invalid ICMP.
- We could use some some /proc stuff or implement custom options in 
iptables like:
iptables setting strong-icmp-tracking on
iptables setting strong-tcp-tracking off
and so on. This way the admin could choose to use your current 
tcp-window-tracking or the old one which is softer.
- We could use that NOTRACK target to untrack icmp packets which have 
those new codes, actually I don't love that target but it could be ok.

And of course, document these issues: Let everyone know what conntrack 
is setting as INVALID. I'll be please to do that, even your 
tcp-window-tracking patch.

If you still consider that we can't provide any methods to work around 
to possible problem, I'll drop checkings and we could leave them in a 
patch in pom-ng as something optional.

The reason why I like adding those pieces of codes is that I like the 
idea of having a strong and smart conntrack system that we could be 
proud of, but always letting the administrator to decide what he wants 
to drop or not.

regards,
Pablo
