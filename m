From: linux lover <linux_lover2004@yahoo.com>
Subject: Is my program is correct to print packet data part at IP layer?
Date: Fri, 31 Dec 2004 04:13:03 -0800 (PST)
Message-ID: <20041231121303.59844.qmail@web52204.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: rusty@rustcorp.com.au
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

Respected sir,
            I request you to please check my program
and reply me whether it is the correct way of getting
packets data part at IP layer? I am using netfilter
and dumping its output to unsigned string. I just want
to know the results return by following program is
correct or wrong?
regards,
linux_lover.

#define MODULE
#define __KERNEL__

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/skbuff.h>
#include <linux/ip.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>

#include <linux/string.h>

static struct nf_hook_ops nfho1;

unsigned int hook_func1(unsigned int hooknum,struct
sk_buff **skb,
                                 const struct
net_device *in,
                                 const struct
net_device *out,
                                 int (*okfn)(struct
sk_buff *))
{
  struct sk_buff *sb = *skb;
  printk(KERN_DEBUG "calling hook_func at
NF_IP_LOCAL_OUT\n");
      unsigned char *packet;
      unsigned int buflen;
      int  i=0;
      buflen=sb->len;
      packet=kmalloc(buflen,GFP_USER);
      memset(packet,'\0',buflen);
      printk(KERN_DEBUG "Length of skb->data in hook
function = %d\n", buflen);
      strncpy(packet,sb->data,buflen);
      printk(KERN_DEBUG "packet contents of sb->data
in hook function = %02x\n", packet);

     return NF_ACCEPT;
}

static int __init init(void)   
  {
              nfho1.hook     = hook_func1;
              nfho1.hooknum  = NF_IP_LOCAL_OUT;
              nfho1.pf       = PF_INET;
              nfho1.priority = NF_IP_PRI_FIRST;
              nf_register_hook(&nfho1);
              return 0;
          }

static void __exit fini(void)
          {
              nf_unregister_hook(&nfho1);
          }
module_init(init);
module_exit(fini);
MODULE_LICENSE("GPL");




		
__________________________________ 
Do you Yahoo!? 
The all-new My Yahoo! - What will yours do?
http://my.yahoo.com 
