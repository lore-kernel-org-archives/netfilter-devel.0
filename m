From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH] Nexthop match
Date: Sun, 23 Nov 2003 09:29:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031123082906.GB23141@alpha.home.local>
References: <18729960090.20031123024241@alarit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Igor Fuks <fuks@alarit.com>
Content-Disposition: inline
In-Reply-To: <18729960090.20031123024241@alarit.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

this is interesting, but I have a few questions :

On Sun, Nov 23, 2003 at 02:42:41AM +0200, Igor Fuks wrote:
> Example #1:
> 
> iptables -A OUTPUT -m nexthop --nexthop 10.1.1.5 -s 10.1.10.0/24 -j DROP
> 
> Means stations in 10.1.10.0/24 net will have not connectivity via 10.1.1.5
> neighbour.

It should have been in POSTROUTING or FORWARD for this, isn't it ?

Does it also match packets going TO the gateway, or only packets routed
THROUGH the gateway ?

Cheers,
Willy
