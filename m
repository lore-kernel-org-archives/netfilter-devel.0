From: Rafael Dreher <dreher@interage.com.br>
Subject: Unable to add rule on Chain with 30 characters.
Date: Fri, 08 Jul 2005 17:10:05 -0300
Message-ID: <42CEDD9D.5020808@interage.com.br>
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

Hi,

I'm trying do add a rule on a user-defined chain, on the NAT table, with exactly 30 characters.

The chain have bee added without any problem, but when I add the rule, iptables says that it's unable do find the chain.

See bellow:

-----------------------------------------------------------------------
[root@ward] [16:55:58]
[~]#iptables -t nat -N ecommerce-internet@POSTROUTING

[root@ward] [16:56:01]
[~]#iptables -t nat -A POSTROUTING -j ecommerce-internet@POSTROUTING
iptables: No chain/target/match by that name

[root@ward] [16:56:19]
[~]#iptables -t nat -N 123456789012345678901234567890

[root@ward] [17:04:15]
[~]#iptables -t nat -A POSTROUTING -j 123456789012345678901234567890
iptables: No chain/target/match by that name

[root@ward] [17:04:23]
[~]#

-------------------------------------------------------------------------

If I reduce the chain to 28 characters, it works. I'm trying to migrate a set of rules form iptables-1.2.11 to 1.3.1,
and I don't want to rewrite the rules.

Someone can help me?

My iptables version: 1.3.1
My kernel version: 2.4.31

POM-Patches:

CLASSIFY
SAME
comment
NETMAP
iprange
quota
time
IPMARK
ROUTE
account
h323-conntrack-nat
ipp2p
l7-filter-pom-1.4
mms-conntrack-nat
msnp-conntrack-nat
pptp-conntrack-nat
quake3-conntrack-nat
string
mport

Thanks in advance.
-- 
Rafael Dreher

-:: Red Hat Certified Engineer ::-
-:: Nr: 807303498507617 ::-
http://www.redhat.com/training/certification/verify
