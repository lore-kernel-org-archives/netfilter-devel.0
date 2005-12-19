From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] pptp conntrack broken when non-modular
Date: Mon, 19 Dec 2005 11:18:00 +0100
Message-ID: <43A688D8.4050200@trash.net>
References: <20051218194848.GA1038@linuxace.com> <43A67D33.70005@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060206020709000503080607"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <43A67D33.70005@trash.net>
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

This is a multi-part message in MIME format.
--------------060206020709000503080607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Phil Oester wrote:
> 
>> The GRE protocol helper of PPTP does not get properly registered
>> when it is built in, because ip_nat_proto_gre_init runs prior to
>> ip_nat_init, so ip_nat_protos is unitialized when ip_nat_proto_gre_init
>> tries to register protocol 47.
>>
>> Changing ip_nat_protocol_register to unconditionally register solves
>> half the problem.  But then when ip_nat_init does run, it overwrites
>> the registration with ip_nat_unknown_protocol.  So the second
>> part of the fix is to change ip_nat_init not to overwrite previously
>> registered protos.
> 
> 
> I think the correct fix is to change the initialisation order so
> the NAT core comes before protocol helpers. I'm going to look into
> this.

This patch fixes the problem by changing the init order.
I'll try to get it in 2.6.15.

--------------060206020709000503080607
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Fix NAT init order

As noticed by Phil Oester, the GRE NAT protocol helper is initialized
before the NAT core, which makes registration fail.

Change the linking order to make NAT be initialized first.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 87704c86b3406255a2b68b1d1a68ff72baa6177e
tree 349f73319574ccb3a02acaefab7cec8edaa798f6
parent afe1ec2b866d310f47db2f368f1f4a7b4961ffed
author Patrick McHardy <kaber@trash.net> Mon, 19 Dec 2005 11:17:20 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 19 Dec 2005 11:17:20 +0100

 net/ipv4/netfilter/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 058c48e..d0a447e 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -12,6 +12,7 @@ ip_nat_pptp-objs	:= ip_nat_helper_pptp.o
 
 # connection tracking
 obj-$(CONFIG_IP_NF_CONNTRACK) += ip_conntrack.o
+obj-$(CONFIG_IP_NF_NAT) += ip_nat.o
 
 # conntrack netlink interface
 obj-$(CONFIG_IP_NF_CONNTRACK_NETLINK) += ip_conntrack_netlink.o
@@ -41,7 +42,7 @@ obj-$(CONFIG_IP_NF_IPTABLES) += ip_table
 # the three instances of ip_tables
 obj-$(CONFIG_IP_NF_FILTER) += iptable_filter.o
 obj-$(CONFIG_IP_NF_MANGLE) += iptable_mangle.o
-obj-$(CONFIG_IP_NF_NAT) += iptable_nat.o ip_nat.o
+obj-$(CONFIG_IP_NF_NAT) += iptable_nat.o
 obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
 
 # matches

--------------060206020709000503080607--
