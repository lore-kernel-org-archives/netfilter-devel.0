From: Aaron Grunthal <stardive@gmx.de>
Subject: Proposal: fuzzy range limiter based on a self-trimming binary tree
Date: Fri, 25 Nov 2005 14:19:54 +0100
Message-ID: <43870F7A.7070105@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

My suggestion is another step to generalize the limit/hashlimit filters 
since they don't work properly under certain scenarios:

The limit filter only applies to a rule and thus filters all packets 
that pass through this rule, so a single host can perform a DoS attack 
by saturating the filter and thus block everybody else from using any 
service that might be limited by this filter.

The hashlimit filter applies more fairness since it performs limiting on 
a per-IP basis, but it can be circumvented if an attacker has enough 
ressources at his disposal (large IP-ranges) since every source IP will 
have its own limit and thus will slow down the entire hashlimit filter.

So, here is my proposal:

# A self-trimming binary tree used as a leaf limiter

The first time the filter is created it consists of a empty binary tree 
with 0 leaves. The first packet that arrives will be stored in the 
binary tree based on the binary representation of either its source or 
its destination IP. It doesn't need to obey all bits, the tree could be 
limited to a certain depth ( (== netmask) instead. The leaf for this IP 
represents a conventional limiting filter.

Since ressources are limited and the intention of this filter is to 
ensure fairness based on the IP distribution the number of leaves has to 
be restricted to a certain amount. If this limit is exceeded the filter 
will begin to collapse branches with a high traffic/leaf density into 
new leaves and sum up all their rates into a single limiter. This way a 
limiter will apply to a larger subnet than other filters and thus it is 
able to ensure a largescale fairness at the price of limiting entire 
subnets.

The advantage of this method is that it needs less ressources the more 
traffic a specific range creates.


I'm still pondering how to perform proper uncollapsing to rebalance the 
tree when the rate on a collapsed branch falls under a certain limit 
again. This requires comparisons with other branch-wide traffic stats 
from branches on the equal level...


Generally this filter is inteded to do 2 things:
a) ensure fairness on a large scale
b) allow matching against connection flooding that doesn't come from a 
single host but from several IP ranges instead (note: this does NOT 
include dDoS attacks from botnets since those have a widespread set of 
IPs at their disposal, it's better to block these with a hashlimit or 
recent filter)
