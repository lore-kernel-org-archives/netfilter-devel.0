From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: remove connections notification by conntrack?
Date: Sun, 24 Sep 2006 05:10:18 +0200
Message-ID: <4515F71A.8070409@netfilter.org>
References: <200609221359.22676.thezema@gmail.com>
	<200609221519.52127.thezema@gmail.com>
	<4513FA76.1010304@netfilter.org>
	<200609231123.09148.thezema@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Mader <thezema@gmail.com>
In-Reply-To: <200609231123.09148.thezema@gmail.com>
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

Thomas Mader wrote:
>> Use the event API, do not forget to enable it (it's still marked as
>> experimental): have a look at ctnetlink_conntrack_event inside
>> ip_conntrack_netlink.c, that will help I think.
>>
>> Use the unsigned long parameter of your notify function above and wait
>> for the event IPCT_DESTROY.
> 
> Now it looks like this:
> 
> int ipaddr_conntrack_event(struct notifier_block *this, unsigned long events, 
> void *ptr) {
> 	struct ip_conntrack *ct = (struct ip_conntrack *)ptr;
> 	
> 	if (events == IPCT_DESTROY) {

events & IPCT_DESTROY

> 		printk("We have been notified that connection %d was deleted!\n", ct->id);
> 	}
> 	
> 	return 0;
> }
> 
> 
> static struct notifier_block ctnl_notifier = { 
> 	.notifier_call = ipaddr_conntrack_event,
> }; 
> 
> 
> static int __init init(void)
> {
> 	int ret;
> 	need_conntrack();
> 	ret = ip_conntrack_register_notifier(&ctnl_notifier);
> 	if (ret < 0) {
> 		printk("ipaddr_init: cannot register notifier.\n");
> 		goto err_unreg_notifier;
> 	}
> 	//ip_conntrack_destroyed = destroyed_connect;
>      
> 	printk(KERN_CRIT "init!\n");
>    	return ipt_register_match(&ipaddr_match);
> 	
> err_unreg_notifier:
> 		ip_conntrack_unregister_notifier(&ctnl_notifier);
> 		return 1;
> }
> 
> But the problem remains the same. It works for TCP and I get properly notified 
> about those but not about UDP.

Try with what I told you above and let me know if it works

>> BTW, some tips about the code that I hope that you can find useful:
>>
>> Don't nest the code like that, it is hard to read and really ugly, I
>> always tell that to my students: invert the logic, check for errors not
>> for sucess, I don't blame I used to do that time ago.
>>
>> Don't forget that a foo_get(...) operation usually requires a
>> foo_put(...) afterwards.
> 
> Thanks for your comments we are hacking kernel stuff for the first time.

;)

>> There is no floating point in kernel (double) because of portability issues
> 
> We need to save the arriving time of the packets and we need a bit of 
> precision.
> It would work also when we would save sec and usec separately but this would 
> make everything more complicated and for now we are just trying things out.
> 
>> And, out of curiosity, what do you want to do? Can't you do it with
>> ctnetlink and in userspace?
> 
> We thought about that when we started but than it happend that we started 
> implementing  as kernel space only. ;)
> Our main focus was performance but maybe we need to go into userspace fully 
> because we need to save a lot of data.
> 
> We try to write a module which detects bursts and if a burst was detected a 
> package will be injected at the end of the burst.
> We will make a kernel space module first which saves just one time stamp and 
> id per connection. (The list I posted earlier makes somthing different but I 
> get the idea mentioned right now some time later)
> Then we implement a second algorithm for detecting bursts which is much more 
> complicated than that and relies on a special container structer which could 
> be implemented with lists afair.
> The thing is that we will need much memory for this and therefore should be 
> placed in userspace maybe.
> 
> Is there a general rule when to write something for user/kernel space?

Probably this is a good idea, have a look a libnetfilter_queue, there is
some unnofficial docs available on the web to start with.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
