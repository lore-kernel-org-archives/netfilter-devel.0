From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Working on a match extension (ipt_gateway)
Date: Mon, 19 Jul 2004 08:56:05 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407190832190.27199-100000@filer.marasystems.com>
References: <33169.207.236.167.154.1090066493.squirrel@207.236.167.154>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Samuel Jean <sjean@cookinglinux.org>
In-Reply-To: <33169.207.236.167.154.1090066493.squirrel@207.236.167.154>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 17 Jul 2004, Samuel Jean wrote:

> Forget about the MASQUERADE example, it's not a good one at all !
> I'm sorry for such a poor example which I've quickly writen whithout
> thinking.

It is a reasonable example except that SNAT is probably more suited for 
the job...

> (The netfilter box doesn't have to MASQUERADE packets since he's not
> attached to a public network.)

Doesn't really matter. There is situations on private networks where SNAT 
is equally needed/wanted to hide "internal" addressing details or 
otherwise simplify networking.

What can be said about using routing information in this manner (for any
result, being it SNAT or accounting) is that it is only needed in
situations where it is unfeasible to replicate the needed destination
classifications in iptables. It should also be noted that the information 
needs to be trusted for this to be done in any meaningful manner.

The example discussed can be solved equally well using vlans with one
router per vlan. The question is, should this be required by iptables in
order to be able to access information about which route was selected by
routing or is having a "gateway/route" match suitable?  Also, not all such
situations can be solved by using vlans.

Personally I would not mind having a POSTROUTING "route" match available
in patch-o-matic-ng to match details about the selected route (next hop,
metric, dynamic/static, whatelse is available).

Regards
Henrik
