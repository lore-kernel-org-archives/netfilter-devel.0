From: Stephen Jones <hivemynd@hivemynd.net>
Subject: pom-ng-20040621 - pptp conntrack patch missing argument
Date: Mon, 30 Aug 2004 21:53:23 -0500
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4133E823.4070209@hivemynd.net>
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello Harald and netfilter-devel list!

I have been using iptables 1.2.9 with the pptp/gre conntrack modules 
with a 2.4.26 kernel with great success for several months.  I would 
like to thank you for your hard work in providing support for pptp 
connection tracking through linux NAT'ing firewalls!  It is a great 
service!

With the release of 2.4.27, I thought I would update my iptables to the 
current 1.2.11 release and patch-o-matic-ng-20040621 along with the 
kernel.  I was in the process of patching and recompiling the kernel 
when I ran across this problem:

The complier complains about the missing arguments for the call to 
ip_nat_used_tuple from gre_unique_tuple, in line 108 of the 
ip_nat_proto_gre.c source:

The gre_unique_tuple method, line 108 in the ip_nat_proto_gre.c file 
reads like this:

if (!ip_nat_used_tuple(tuple, conntrack))

The definition of ip_nat_used_tuple from the ip_nat.h file reads like this:

/* Is this tuple already taken? (not by us)*/
extern int ip_nat_used_tuple(const struct ip_conntrack_tuple *tuple,
               const struct ip_conntrack *ignored_conntrack,
               const enum ip_nat_manip_type maniptype,
               const unsigned int flags);

I am no code monster, but a quick glance at the source made me think 
that perhaps the line 108 in the ip_nat_proto_gre.c could read:

if (!ip_nat_used_tuple(tuple, conntrack, maniptype, flags))

The problem is, I don't know what the proper values to send in for the 
"flags" argument should be, and the "maniptype" argument is a guess 
based off of what is passed into the parent gre_unique_tuple function:

/* generate unique tuple ... */
static int
gre_unique_tuple(struct ip_conntrack_tuple *tuple,
       const struct ip_nat_range *range,
       enum ip_nat_manip_type maniptype,
       const struct ip_conntrack *conntrack)

I have been scanning the mailing lists looking to see if someone posted 
a solution to this yet, but I have not run across a solution so far.
A nudge in the right direction would be most helpful!  And thanks again 
for your outstanding work!

Best regards,

Stephen
