From: Adam Guyot <aguyot@speakeasy.net>
Subject: match code question
Date: Tue, 17 Sep 2002 11:27:41 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020917112741.A52590@speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,
I'm attempting to write a 'match' module that will do something like the
limit module; so I am following that as a core. Unfortunately when the
module is loaded up it doesn't appear to see any packets, so I stripped it
down to a test match and that doesn't work either.  Any help as to where
I have gone wrong in the whole scheme would be appreciated. :)

File: ipt_test.c


#include <linux/module.h>
#include <linux/skbuff.h>
#include <linux/list.h>
#include <linux/time.h>
#include <linux/ip.h>
#include <net/tcp.h>

#include <linux/netfilter_ipv4/ip_conntrack.h>
#include <linux/netfilter_ipv4/ip_conntrack_core.h>
#include <linux/netfilter_ipv4/ip_conntrack_tcp.h>
#include <linux/netfilter_ipv4/ip_tables.h>

#define DEBUG 1

MODULE_AUTHOR("Adam Guyot <adamg@sdcsncnsdkjn");
MODULE_DESCRIPTION("Test Match Connections");
MODULE_LICENSE("GPL");


static int
tmatch( const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
       int offset,
       const void *hdr,
       u_int16_t datalen,
       int *hotdrop)
{

  printk("ipt_test: in tmatch\n");
  /* do nothing, we're a test */
  return 1;
}

static int tcheck(const char *tablename,
        const struct ipt_ip *ip,
        void *matchinfo,
        unsigned int matchsize,
        unsigned int hook_mask)
{
  printk("ipt_test: in checkentry\n");
  return 0;

}

static struct ipt_match ipt_test_reg = {
  { NULL, NULL },
  "test",
  &tmatch,
  &tcheck,
  NULL,
  THIS_MODULE };

static int __init init(void)
{
  printk("ipt_test  loading\n");
  ipt_register_match(&ipt_test_reg);
  return 0;
}

static void __exit fini(void)
{
  ipt_unregister_match(&ipt_test_reg);
  printk("ipt_test unloaded\n");
}
module_init(init);
module_exit(fini);


--------snip----------
The code compiles, I am able to insmod it:

[adamg@whoville netfilter]$ sudo insmod ipt_test
Password:
Using /lib/modules/2.4.19/kernel/net/ipv4/netfilter/ipt_test.o
[adamg@whoville netfilter]$ lsmod
Module                  Size  Used by    Not tainted
ipt_test                1280   0 (unused)
ipt_REJECT              3488   0 (autoclean)
ipt_state               1088  11 (autoclean)
ipt_limit               1664   1 (autoclean)
ipt_LOG                 4224   6 (autoclean)
iptable_mangle          2688   0 (autoclean) (unused)
iptable_nat            26324   1 (autoclean)
ip_conntrack           29932   2 (autoclean) [ipt_state iptable_nat]
iptable_filter          2368   1 (autoclean)
ip_tables              16704  10 [ipt_test ipt_REJECT ipt_state ipt_limit ipt_LOG iptable_mangle iptable_nat iptable_filter]
ext3                   64320   1 (autoclean)
jbd                    49496   1 (autoclean) [ext3]
[adamg@whoville netfilter]$

Now, when a new connection is initiated, the printk msgs don't show
up in /var/log/messages or anywhere that I can tell :P.

thanks,

--adam
                                                                                      
                                                                                     
                                                                                      
