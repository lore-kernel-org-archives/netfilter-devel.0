From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Removal of ROUTE target - what now?
Date: Sat, 4 Aug 2007 10:41:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708041040030.11760@fbirervta.pbzchgretzou.qr>
References: <BAY137-F26BDAB7CC7FE589BFB7F4DA3EB0@phx.gbl>
	<46B3D859.8090906@davidcoulson.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, John Lumby <johnlumby@hotmail.com>
To: David Coulson <david@davidcoulson.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46B3D859.8090906@davidcoulson.net>
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


On Aug 3 2007 21:37, David Coulson wrote:
>
> ip ru add from a.b.c.d table 20
> ip ro add table 20 default via p.q.r.s
>
> you can of course use 'ip ru add fwmark 8 table 20' to use a mark from iptables
> rather than an IP address
>
> Make sure you have reverse path filtering disabled on the interface too.

Since the routing layer now knows about a.b.c.d->p.q.r.s (it does not
when you use ipt_ROUTE), things could work even if RPF are on.
Of course that I what I believe or what I believe should be happening;
if it is not, feel free to correct me :)


	Jan
-- 
