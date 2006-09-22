From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: remove connections notification by conntrack?
Date: Fri, 22 Sep 2006 17:00:06 +0200
Message-ID: <4513FA76.1010304@netfilter.org>
References: <200609221359.22676.thezema@gmail.com>
	<4513DE12.4020305@netfilter.org>
	<200609221519.52127.thezema@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Mader <thezema@gmail.com>
In-Reply-To: <200609221519.52127.thezema@gmail.com>
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

Thomas,

Thomas Mader wrote:
>> Could you post the code?
> 
> struct conn_id {
> 	int id;
> 	struct list_head elem;
> 	struct list_head tstamps;
> };
> 
> struct conn_stamp {
> 	double stamp;
> 	struct list_head elem;
> };
> 
> static LIST_HEAD(list);
> 
> void destroyed_connect(struct ip_conntrack *conntrack) {
> 	printk("destroy id %u\n", conntrack->id);
> }
> 
> static int match(const struct sk_buff *skb,
>                  const struct net_device *in,
>                  const struct net_device *out,
> 		 const struct xt_match *match,
>                  const void *matchinfo,
>                  int offset,
> 		 unsigned int protoff,
>                  int *hotdrop)
> {
> .....
> 	proto = ip_conntrack_proto_find_get(skb->nh.iph->protocol);
> 
> 
> 	if (ip_ct_get_tuple(skb->nh.iph, skb, skb->nh.iph->ihl*4, &tuple,proto)) {
> 
> 		h = ip_conntrack_find_get(&tuple, NULL);
> 		if (h) {
> 			//printk("dstp: %u\n", ntohs(h->tuple.dst.u.udp.port) );
> 			ipct = tuplehash_to_ctrack(h);
> 			if (ipct) {
> 				int found_id = 0;
> 				struct conn_stamp *new_stamp;
> 				connection_id = ipct->id;
> 
> 				if(!list_empty(&list)) {
> 					struct conn_id *p;
> 					
> 					list_for_each_entry(p, &list, elem) {
> 						if (connection_id == p->id) {
> 							found_id = 1;
> 							new_stamp = (struct conn_stamp*)kmalloc(sizeof(struct conn_stamp), 
> GFP_KERNEL);
> 							if(!new_stamp) {
> 								printk("new_stamp not allocated!\n");
> 								return 1;
> 							}
> 							
> 							new_stamp->stamp = sec;
> 							list_add_tail(&new_stamp->elem, &p->tstamps);
> 							printk("new tstamp added to already existing id %d\n", p->id);
> 							break;
> 						}
> 					}
> 				}
> 				if(!found_id) {
> 					struct conn_id* new_id = (struct conn_id*)kmalloc(sizeof(struct conn_id), 
> GFP_KERNEL);
> 					if(!new_id) {
> 						printk("new_id not allocated!\n");
> 						return 1;
> 					}
> 					
> 					new_id->id = connection_id;
> 					INIT_LIST_HEAD(&new_id->elem);
> 					list_add_tail(&new_id->elem, &list);
> 					
> 					new_stamp = (struct conn_stamp*)kmalloc(sizeof(struct conn_stamp), 
> GFP_KERNEL);
> 					if(!new_stamp) {
> 						printk("new_stamp not allocated!\n");
> 						return 1;
> 					}
> 							
> 					new_stamp->stamp = sec;
> 					INIT_LIST_HEAD(&new_id->tstamps);
> 					list_add_tail(&new_stamp->elem, &new_id->tstamps);
> 					printk("new tstamp added to new created id %d\n", new_id->id);
> 				}
> 			}
> 		}
> 	}
> .....
>    return 1;
> }
> 
> int notify(struct notifier_block *nb, unsigned long ul, void *v) {

Use the event API, do not forget to enable it (it's still marked as
experimental): have a look at ctnetlink_conntrack_event inside
ip_conntrack_netlink.c, that will help I think.

Use the unsigned long parameter of your notify function above and wait
for the event IPCT_DESTROY.

BTW, some tips about the code that I hope that you can find useful:

Don't nest the code like that, it is hard to read and really ugly, I
always tell that to my students: invert the logic, check for errors not
for sucess, I don't blame I used to do that time ago.

Don't forget that a foo_get(...) operation usually requires a
foo_put(...) afterwards.

There is no floating point in kernel (double) because of portability issues

And, out of curiosity, what do you want to do? Can't you do it with
ctnetlink and in userspace?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
