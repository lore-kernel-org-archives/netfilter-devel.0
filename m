From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]Re: NAT before IPsec with 2.6
Date: Wed, 28 Jan 2004 09:49:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <401777B4.9020000@trash.net>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com> <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040128000938.GH11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
 Willy Tarreau <willy@w.ods.org>,
 Tom Eastep <teastep@shorewall.net>, Michal Ludvig <mludvig@suse.cz>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040128000938.GH11761@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>Hi!
>
>[please ignore the last message, I mistakenly sent an outdated, incomplete 
> patch]
>
>I've now hacked a preliminary patch.  Be warned, I didn't even test if
>it compiles.  Maybe someone who actually has a running 2.6.x ipsec setup
>can give it a try.
>
>What it should be doing
>- traverse the additional chains as described in the last email
>- have connection tracking recognize two seperate connections, one
>  for the decapsulated traffic, one for the encapsulated
>- thus, even SNAT/DNAT should be working.
>- locally-encapsulated traffic shows up with input device "ah4" or
>  "esp4" in POSTROUTING.
>- locally-encapsulated traffic shows up with output device "ah4" or
>  "esp4" in OUTPUT.
>
>What is missing (TODO):
>- no dummy device names in INPUT/PREROUTING for locally-decapsulated
>  packets.  This is somewhat harder
>- no real output device shown in OUTPUT for locally-encapsulated
>  packets.  I'm not sure if it is legal to typecast the just-popped
>  dst_entry to 'struct rtable' and derive the output interface from
>  there.
>
>Please give feedback.
>  
>
I see two problems with this approach. The dummy devices don't have
any ip config, so f.e. REDIRECT will fail. The bigger problem is
hooking in output routines that return NET_XMIT_BYPASS. dst_output
loops until the return code of skb->dst->output != NET_XMIT_BYPASS.
These output routines replace skb->dst when finished by calling dst_pop.
If we pass the packet through netfilter in between, the dst_entry
might get replaced in ip_route_me_harder or elsewhere and not all
transformations will be applied. If NAT is used,
ip_route_{input,output} might even return a different policy bundle.

Anyways, I'm testing it (slightly hacked) as soon as the compile finishes ;)

Regards,
Patrick
