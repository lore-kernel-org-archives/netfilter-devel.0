From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's
 brain broke!)
Date: Sun, 11 Jan 2004 22:11:43 +0100 (CET)
Sender: linux-net-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0401112203250.24615-100000@filer.marasystems.com>
References: <Pine.LNX.4.58.0401111517550.1161@u.domain.uli>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>, <kuznet@ms2.inr.ac.ru>,
	Rusty Russell <rusty@rustcorp.com.au>, <fenio@o2.pl>,
	<davem@redhat.com>, <linux-net@vger.kernel.org>, <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>, <boris@boris.ca>,
	<email@cs-ware.de>, <Jan.Schubert@GMX.li>
Return-path: <linux-net-owner@vger.kernel.org>
To: Julian Anastasov <ja@ssi.bg>
In-Reply-To: <Pine.LNX.4.58.0401111517550.1161@u.domain.uli>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 11 Jan 2004, Julian Anastasov wrote:

> - use CONNMARK or similar functionality to keep the connection
> bound to its path. As long as CONNMARK is not a standard feature
> there is no safe way to use multipath routes with MASQUERADE and
> SNAT in the latest kernels. Even before this change it was risky
> to rely on the routing cache to keep NAT connections bound to
> its path in the multipath route - the cache entries expire.

As the aurhor of CONNMARK I certainly do not mind having this progress 
beyond path-o-matic extras..

While it was invented to solve a special-case issue, it has over the years 
found many additional and more general uses. Today it is in use for

a) Multihomed setups of a shared network with limited routing tables

b) Reliable and easy to understand multipath+NAT routing.

c) Interception routing without NAT, routing specific TCP sessions
(including RELATED and ICMP messages) a special path, usually for 
interception caching outside of the router without loss of addressing 
information.

and probably several other applications I do not know about or simply 
forgotten.

Regards
Henrik

