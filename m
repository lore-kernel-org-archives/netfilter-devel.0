From: "A Babula" <ababula@novell.com>
Subject: Problem in Plugging into Netfilters Hooks
Date: Thu, 29 Apr 2004 05:52:24 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <s090982c.069@lucius.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hi,


I have a written a small module to hook into NF_IP_LOCAL_IN hook .To
get the packet I initialize the nf_hook_ops structure and passes to the
`nf_register_hook'   and I do the samething for nf_unregister_hook'. 
But when I compile following errors are coming.

error: variable 'nf_hook' has initializer but incomplete type.
error: extra brace group at end of initialzer
error:(near initialization for 'nf_hook')

here is the code


#define MODULE
#define __KERNEL__
#include<linux/config.h>
#include<linux/module.h>
#include<linux/version.h>
#include<linux/netfilter.h>
#include<linux/netfilter_ipv4.h>
#define fw_priority 2

static unsigned int fw_incoming(unsigned int hook, struct
sk_buff **pskb,
const struct net_device *indev, const struct net_device *outdev, int
(*okfn) (struct sk_buff *))
	{
		
		return FW_ACCEPT;
	}



static struct nf_hooks_ops nf_hook =
	{{NULL,NULL},fw_incoming,PF_INET,NF_IP_LOCAL_IN,
		fw_priority};


int init_module(void)
	{

		if(nf_register_hook(&nf_hook) < 0)
		{
			printk("\n\n\tERROR..Main main jinglala ");
			return -1;
		}	
		else
		{		
			printk("\n\n\tSuccessfully registered");

		}	
		return 0;
	}








void cleanup_module(void)
          {

		nf_unregister_hook(&nf_hook);
		printk("\n\n\tFirewall unregistered");

		}

If any body knows how to solve this problem ,please guide me.

thanks
babula
