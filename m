From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: to solve the performance problem of netfilter
Date: Wed, 17 Dec 2003 18:09:46 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312171753560.18408-100000@filer.marasystems.com>
References: <1071676553.1058.48.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Roberto Nibali <ratz@tac.ch>, <tady@gmx.net>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1071676553.1058.48.camel@nienna.balabit>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 17 Dec 2003, KOVACS Krisztian wrote:

>   It contains tuning tips also, and is very interesting indeed. However,
> I'd like to see NAT benchmarks as well. Jozsef mentioned that NAT
> performance is horrible compared to conntrack, and it would be really
> useful if bottlenecks could be identified.

The bottlenecks of NAT is pretty much known I think.. the NAT operation is 
very complex as it needs to support a wide variety of different traffic 
patterns. Because of this there is some hefty locking going on on each new 
session and several "conntrack" hash entries to be able to keep track of 
the various packet variants seen for the session.

But still having benchmarks showing how much of a penalty NAT really is
would inedeed be interesting. To give interesting results wrt where the 
bottlenecks of NAT are the following set of benchmarks would be good I 
thinkg:

  - No netfilter
  - Just iptable_filter loaded (no rules)
  - Just ip_conntrack loaded
  - Just ip_conntrack + iptable_nat loaded
  - Some simple NAT rules added

Using each of the following profiles  

  * Lots of small TCP sessions such as a syn flood to a closed port always 
responding with RST (and no RST rate filtering on the targeted host)

  * A few sessions (TCP or UDP) pushing large packets

  * A few sessions (TCP or UDP) pushing small packets

  * Lots of concurrent sessions forcing the NAT to resolve addressing
overlaps, for example testing with a fixed source port from a wide range
of source IP address and using SNAT to a single fixed address.


The above will/should give a pretty clear picture of what of NAT is 
causing the performance drop.

and then ofcouse a benchmark using a "typical" pattern is also interesting 
to get a feeling of how much of an impact NAT is in the typical case not 
caring why.


Regards
Henrik
