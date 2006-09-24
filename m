From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: remove connections notification by conntrack?
Date: Sun, 24 Sep 2006 17:34:15 +0200
Message-ID: <4516A577.7080802@netfilter.org>
References: <200609221359.22676.thezema@gmail.com>
	<200609231123.09148.thezema@gmail.com>
	<4515F71A.8070409@netfilter.org>
	<200609241151.31689.thezema@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020202020706040905090100"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Mader <thezema@gmail.com>
In-Reply-To: <200609241151.31689.thezema@gmail.com>
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
--------------020202020706040905090100
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Thomas Mader wrote:
> On Sunday 24 September 2006 05:10, Pablo Neira Ayuso wrote:
>> events & IPCT_DESTROY
>>
>>> 		printk("We have been notified that connection %d was deleted!\n",
>>> ct->id); }
>>>
>>> 	return 0;
>>> }
>>>
>>>
>>> static struct notifier_block ctnl_notifier = {
>>> 	.notifier_call = ipaddr_conntrack_event,
>>> };
>>>
>>>
>>> static int __init init(void)
>>> {
>>> 	int ret;
>>> 	need_conntrack();
>>> 	ret = ip_conntrack_register_notifier(&ctnl_notifier);
>>> 	if (ret < 0) {
>>> 		printk("ipaddr_init: cannot register notifier.\n");
>>> 		goto err_unreg_notifier;
>>> 	}
>>> 	//ip_conntrack_destroyed = destroyed_connect;
>>>
>>> 	printk(KERN_CRIT "init!\n");
>>>    	return ipt_register_match(&ipaddr_match);
>>>
>>> err_unreg_notifier:
>>> 		ip_conntrack_unregister_notifier(&ctnl_notifier);
>>> 		return 1;
>>> }
>>>
>>> But the problem remains the same. It works for TCP and I get properly
>>> notified about those but not about UDP.
>> Try with what I told you above and let me know if it works
> 
> No it doesn't. I tried "events & IPCT_DESTROY" already and it didn't work. Now 
> I tested it once again with same result.

Works fine here with the toy module attached:

Sep 24 17:30:52 Decadence kernel: protonum=17
Sep 24 17:31:26 Decadence last message repeated 2 times
Sep 24 17:31:47 Decadence kernel: protonum=6

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------020202020706040905090100
Content-Type: text/x-csrc;
 name="modulo.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="modulo.c"

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4/ip_conntrack.h>

static int conntrack_event(struct notifier_block *this,
			   unsigned long events, 
			   void *ptr)
{
	struct ip_conntrack *ct = (struct ip_conntrack *)ptr;

	if (events & IPCT_DESTROY)
		printk("protonum=%d\n", ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum);

	return 0;
}

static struct notifier_block ctnl_notifier = { 
	.notifier_call = conntrack_event,
}; 

static int __init hello_init(void)
{
	int ret;

	need_conntrack();
	ret = ip_conntrack_register_notifier(&ctnl_notifier);
	if (ret < 0)
		printk("ipaddr_init: cannot register notifier.\n");

	return ret;
}

module_init(hello_init);

MODULE_LICENSE("GPL");

--------------020202020706040905090100--
