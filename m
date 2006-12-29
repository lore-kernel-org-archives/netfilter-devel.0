From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: New libnetfilter_conntrack API: why two values of layer 3/4?
Date: Fri, 29 Dec 2006 22:15:38 +0100
Message-ID: <4595857A.7030004@netfilter.org>
References: <200612291806.57788.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Victor Stinner <victor.stinner@inl.fr>
In-Reply-To: <200612291806.57788.victor.stinner@inl.fr>
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

Victor Stinner wrote:
> In new libnetfilter_conntrack API, I see:
> 
> ATTR_ORIG_L3PROTO = 15
> ATTR_REPL_L3PROTO = 16
> ATTR_ORIG_L4PROTO = 17
> ATTR_REPL_L4PROTO = 18
> 
> Is it possible to change layer 3 protocol with NAT? or layer4? If not, one 
> constant will be enough ;-)

Indeed, there is no real usefulness currently, but if the connection
tracking ever supports tunneling ipv4-to-ipv6, I'll have to take them
back, so I prefer leaving this issue open.

> And for counters, are they 32 or 64 bits?
> 
> ATTR_ORIG_COUNTER_PACKETS = 26
> ATTR_REPL_COUNTER_PACKETS = 27
> ATTR_ORIG_COUNTER_BYTES = 28
> ATTR_REPL_COUNTER_BYTES = 29
> 
> 32 bits (2 GB) sounds small with a gigabyte interface or long uptime (old 
> connection).

We've been discussing about this issue lately and there is a patch on
the table for the connection tracking to go back 64 bits counters. In
any case, the library will be able to support both counter sizes.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
