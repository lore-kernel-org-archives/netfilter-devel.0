From: "Stephan Jager" <netfilter@medz.org>
Subject: re: nat and conntrack helper howto question
Date: Sat, 02 Aug 2003 22:21:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200308022021.h72KLcVi000813@alpha.medz.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'd made a simple wrapper for my h225ras patch, but somehow something is 
going wrong. When insmodding the module, it does get the init, but when 
sending packages to the 1719/udp port, the helper function is not 
kicking in. Did I make some obvious bug? I looked at cuseeme and 
snmp_basic nat's, which are both doing the same it seems but could not 
find the difference.

Stephan

My code:


#include <linux/module.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>
#include <linux/netfilter_ipv4/ip_nat.h>
#include <linux/netfilter_ipv4/ip_nat_helper.h>
#include <net/udp.h>

#define H225RAS_PORT 1719

static unsigned int nat_help(struct ip_conntrack *ct,
                             struct ip_conntrack_expect *exp,
                             struct ip_nat_info *info,
                             enum ip_conntrack_info ctinfo,
                             unsigned int hooknum,
                             struct sk_buff **pskb)
{
        printk("nat help for h225ras entered"); // but this is not happening
        return NF_ACCEPT;
}

static struct ip_nat_helper h225ras = { 
        { NULL, NULL },
        "h225ras",
        IP_NAT_HELPER_F_STANDALONE,
        THIS_MODULE,
        { { 0, { __constant_htons(H225RAS_PORT) } },
          { 0, { 0 }, IPPROTO_UDP } },
        { { 0, { 0xFFFF } },
          { 0, { 0 }, 0xFFFF } },
        nat_help, NULL };

static int __init init(void)
{
        printk("H225ras: init\n");
        return ip_nat_helper_register(&h225ras);
}

static void __exit fini(void)
{
        ip_nat_helper_unregister(&h225ras);
}

module_init(init);
module_exit(fini);
MODULE_LICENSE("GPL");
