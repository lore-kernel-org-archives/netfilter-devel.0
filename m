From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]Re: NAT before IPsec with 2.6
Date: Wed, 28 Jan 2004 10:37:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <401782C9.6070609@trash.net>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com> <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040128000938.GH11761@sunbeam.de.gnumonks.org> <401777B4.9020000@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
 Willy Tarreau <willy@w.ods.org>,
 Tom Eastep <teastep@shorewall.net>, Michal Ludvig <mludvig@suse.cz>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <401777B4.9020000@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:

>I see two problems with this approach. The dummy devices don't have
>  
>
>any ip config, so f.e. REDIRECT will fail. The bigger problem is
>  
>
>hooking in output routines that return NET_XMIT_BYPASS. dst_output
>  
>
>loops until the return code of skb->dst->output != NET_XMIT_BYPASS.
>  
>
>These output routines replace skb->dst when finished by calling dst_pop.
>  
>
>If we pass the packet through netfilter in between, the dst_entry
>  
>
>might get replaced in ip_route_me_harder or elsewhere and not all
>  
>
>transformations will be applied. If NAT is used,
>  
>
>ip_route_{input,output} might even return a different policy bundle.
>

Bad news, I've tested the hook part (using skb->dev instead of ah4/esp4
devices), this is how the traces look:

IN= OUT=eth0 SRC=172.20.0.3 DST=192.168.0.1 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=ICMP TYPE=8 CODE=0 ID=28443 SEQ=1
IN= OUT= SRC=172.20.0.3 DST=192.168.0.1 LEN=152 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=ESP SPI=0xb9f7900
IN= OUT= SRC=172.20.0.3 DST=192.168.0.1 LEN=176 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=AH SPI=0xc46e27

After applying a MARK rule to the first packet (causing rerouting):

IN= OUT=eth0 SRC=172.20.0.3 DST=192.168.0.1 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=ICMP TYPE=8 CODE=0 ID=51484 SEQ=1

Sniffing in between shows the unencrypted packet.

>Regards,
>  
>
>Patrick
>  
>
>  
>
>
