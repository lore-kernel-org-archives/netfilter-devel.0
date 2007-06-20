From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: xt_connlimit kernel 20070620
Date: Wed, 20 Jun 2007 14:01:08 +0200
Message-ID: <46791704.4090609@netfilter.org>
References: <Pine.LNX.4.64.0706200039290.5731@fbirervta.pbzchgretzou.qr>
	<4678F7A2.6090203@netfilter.org>
	<Pine.LNX.4.64.0706201224490.5731@fbirervta.pbzchgretzou.qr>
	<46790A58.9050106@netfilter.org>
	<Pine.LNX.4.64.0706201328260.5731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706201328260.5731@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> On Jun 20 2007 13:07, Pablo Neira Ayuso wrote:
>>> But it works with UDP too. This if() block looks merely like a
>>> watch-out-for-TCP exception. (And obviously, lacks SCTP/DCCP checking.)
>> I see, still I think that it would be worth to make it completely independent
>> of it.
> 
> UDP does not have a transition from ESTABLISHED -> TIME_WAIT, to begin with.

But the event API has the DESTROY transition. There are three kind of 
events: NEW, UPDATE and DESTROY. Just wait for DESTROY events to release 
the entry from the hashtable.

>>>> I think that it would be worth a
>>>> rework. Luke, use the connection tracking event API :)
>>> Where may I find examples?
>> Have a look at nf_conntrack_netlink.c look for the x_events() function. If
>> you have more questions on it. Let me know.
> 
> I think netlink is an overkill here. Well, at least I could not find
> something usable right away.

No, I didn't mean to use netlink. Just the connection tracking event 
API. See the example below.

> Something like
> 
> myfunction( ??? )
> {
> 	/* kill connlimit entry */
> }
> 
> __init init_module()
> {
> 	nf_register_whatever(ON_TCP_TRANSITION, myfunction);
> }
> 
> I just don't see any modules (matches, targets) that use events yet.
> Could you cook it up?

Does this give you a clue?

static int event(struct notifier_block *this, unsigned long events, void 
*ptr)
{
	struct nf_conn *ct = (struct nf_conn *)ptr;

	if (ct == &nf_conntrack_untracked)
		return NOTIFY_DONE;

	if (events & IPCT_NEW)
		printk("ct %p has been created\n", ct);
	if (events & IPCT_DESTROY)
		printk("ct %p has been destroy\n", ct);

	return NOTIFY_DONE;
}

static struct notifier_block ctnl_notifier = {
         .notifier_call  = event,
};

static int __init init(void)
{
	ret = nf_conntrack_register_notifier(&ctnl_notifier);
	...
}

...

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
