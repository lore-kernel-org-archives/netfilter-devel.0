From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Sun, 25 Jul 2004 11:40:56 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407251135260.25333-100000@filer.marasystems.com>
References: <41005697.9060807@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Stephen Frost <sfrost@snowman.net>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41005697.9060807@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 23 Jul 2004, Patrick McHardy wrote:

> > But seriously speaking I think conntrack may need to be split in two for
> > this to work properly: prerouting to associate packet with connection for
> 
> I've thought about this, but I can't imagine how it would work, you
> have to deal with all kinds of races ..

conntrack should be manageable in this I think, but NAT looks like a
nightmare..  In any event it is a major change of connection tracking and 
most likely outside what is realistic to do during a "stable" kernel 
cycle.

For now I think it is better to make use of the raw table and accept the 
duplicate policy check on ipsec traffic, if of too heavy add a skb flag 
indicating the policy check is already done.

Regards
Henrik
