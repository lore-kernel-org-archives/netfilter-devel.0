From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: CONNMARK patch
Date: Fri, 5 Mar 2004 15:04:22 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403051459270.8853-100000@filer.marasystems.com>
References: <40487996.3020901@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40487996.3020901@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


On Fri, 5 Mar 2004, Pablo Neira wrote:

> I was having a look at your CONNMARK target available in pom-ng. I saw 
> that you use the function ip_conntrack_get to get the conntrack 
> structure associated to a skb but you don't need the ctinfo stuff.

Correct, but it needs conntrack.

The official API for getting the conntrack entry is ip_conntrack_get, not 
to dig around in the skb fields manually.

It could make sense to add another API call for this situation, but I
think the difference is rather minimal. Would be more effective to convert
ip_conntrack_get to a inline function and find some other means of having
correct module dependencies.

Regards
Henrik
