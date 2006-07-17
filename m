From: zhongyu <zhongyu@18mail.cn>
Subject: [MATCH] a match for qq
Date: Tue, 18 Jul 2006 06:51:44 +0800
Message-ID: <1153176704.15818.1.camel@localhost.localdomain>
Reply-To: zhongyu@18mail.cn
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter dev <netfilter-devel@lists.netfilter.org>
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

QQ is a very popular IM tool in Chinese. Some people may need this
match :-)

###########This is the begin of ipt_qq.c########
/***************************************************
 * ipt_qq : a iptables match for qq 
 *
 * Author : Triplex Chung <xxx.phy@gmail.com>
 *
***************************************************/
#include <linux/config.h>
#include <linux/skbuff.h> 
#include <linux/kmod.h>
#include <linux/vmalloc.h>
#include <linux/netdevice.h>
#include <linux/module.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <linux/udp.h> 
#include <linux/icmp.h>
#include <linux/types.h>
#include <linux/spinlock.h>
#include <linux/sched.h>
#include <linux/sysctl.h>
#include <linux/timer.h>
#include <net/ip.h> 
#include <asm/uaccess.h>
#include <asm/semaphore.h>

MODULE_LICENSE("GPL");

static int mach_qq_bin(unsigned char *data, int dlen)
{
        if(dlen < 6)
                return 0; 
        if(data[0] != 0x2)
                return 0;
        if(data[3] != 0x0)
                return 0;
        if(data[4] != 0x16 || data[4] != 0x62)
                return 0;
        if(data[dlen - 1] != 0x3) 
                return 0;
        return 1;
}

static int
match(const struct sk_buff *skb,
      const struct net_device *in,
      const struct net_device *out,
      const void *matchinfo,
      int offset,
      const void *hdr,
      u_int16_t datalen,
      int *hotdrop)
{
        int dlen;
        unsigned char *data;
        struct iphdr *iph;

         /* Must not be a fragment. */ 
        if(offset)
                return 0;

        /*make sure that skb is linear*/
        if(skb_is_nonlinear(skb)){
                printk("QQ.match: nonlinear skb found\n");
                return 0; 
        }

        iph = skb->nh.iph;
        if(iph->protocol == IPPROTO_TCP) {
                struct tcphdr *th = (void *)iph + iph->ihl * 4;
                if (th->fin)
                        return 0; 
                if (th->syn)
                        return 0;
                if (th->rst)
                        return 0;
                /*if(ntohs(th->dest) != 80) {
                        return 0; 
                }*/
                dlen = ntohs(iph->tot_len) - (iph->ihl * 4) - th->doff *
4;
                data = (void *)th + th->doff * 4;
                return mach_qq_bin(data, dlen);
        } else if (iph->protocol == IPPROTO_UDP) {
                struct udphdr *uh = (void *)iph + iph->ihl * 4;
                dlen = ntohs(iph->tot_len) - (iph->ihl * 4) -
sizeof(struct udphdr);
                data = (void *)uh + sizeof(struct udphdr);
                return mach_qq_bin(data, dlen);
        }

        return 0;
}

static int
checkentry(const char *tablename,
         const struct ipt_ip *ip, 
         void *matchinfo,
         unsigned int matchsize,
         unsigned int hook_mask)
{
        return 1;
}

static struct ipt_match qq_match = {
        .name           = "qq", 
        .match          = &match,
        .checkentry     = &checkentry,
        .me             = THIS_MODULE
};

static int __init init(void)
{
        return ipt_register_match(&qq_match); 
}

static void __exit fini(void)
{
}

MODULE_AUTHOR("TripleX Chung <xxx.phy@gmail.com>");
MODULE_DESCRIPTION("An extension to iptables to identify QQ."); 
MODULE_LICENSE("GPL");

module_init(init);
module_exit(fini);

##############this is the end of ipt_qq.c########

#############this is the begin of libipt_qq.c########

#include <stdio.h >
#include <netdb.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>
#include <getopt.h>
#include <iptables.h>

/* Function which prints out usage message. */ 
static void
help(void)
{
        printf("no options %s", IPTABLES_VERSION);
}

static struct option opts[] = {
        {0}
};

/* Initialize the target. */
static void
init(struct ipt_entry_match *m, unsigned int *nfcache) 
{
}

/* Function which parses command options; returns true if it
   ate an option */
static int
parse(int c, char **argv, int invert, unsigned int *flags,
      const struct ipt_entry *entry,
      unsigned int *nfcache,
      struct ipt_entry_match **match)
{
        return 1;
}

/* Final check; don't care. */
static void final_check(unsigned int flags)
{
}

/* Saves the targinfo in parsable form to stdout. */ 
static void
save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
{
}

static
struct iptables_match qq
= { NULL,
    "qq",
    IPTABLES_VERSION,
    IPT_ALIGN(0), 
    IPT_ALIGN(0),
    &help,
    &init,
    &parse,
    &final_check,
    NULL, /* print */
    &save,
    opts
};

void _init(void)
{
        register_match(&qq); 
}

###########this is the end of libipt_qq.c########
