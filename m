From: "Shen Qiyu" <shenqiyu@hotmail.com>
Subject: For netfilter ipt_ops, init() and nf_register_hook()
Date: Wed, 23 Oct 2002 15:15:44 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <F225AtxXuGSkXlVg2R20000850c@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312; format=flowed
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

Hi, guys,
 
When I read the source of netfilter(withe kernel 2.4.18), something pullzed 
me.
 
net/ipv4/netfilter/Iptable_filter.c
....
static struct nf_hook_ops ipt_ops[]
= { { { NULL, NULL }, ipt_hook, PF_INET, NF_IP_LOCAL_IN, NF_IP_PRI_FILTER 
},
    { { NULL, NULL }, ipt_hook, PF_INET, NF_IP_FORWARD, NF_IP_PRI_FILTER },
    { { NULL, NULL }, ipt_local_out_hook, PF_INET, NF_IP_LOCAL_OUT,
  NF_IP_PRI_FILTER }
};
...
static int __init init(void)
{
 ...
 ret = nf_register_hook(&ipt_ops[0]);
...
}
 
net\core\Netfilter.c
 
int nf_register_hook(struct nf_hook_ops *reg)
{
 struct list_head *i;
 
 br_write_lock_bh(BR_NETPROTO_LOCK);
 for (i = nf_hooks[reg->pf][reg->hooknum].next; 
      i != &nf_hooks[reg->pf][reg->hooknum]; 
      i = i->next) {
  if (reg->priority < ((struct nf_hook_ops *)i)->priority)
   break;
 }
 list_add(&reg->list, i->prev);
 br_write_unlock_bh(BR_NETPROTO_LOCK);
 return 0;
}
 
It seems that in list_add(&reg->list, i->prev), only a {NULL, NULL} list 
head is added, so how it run?
 
Regards.
 
Paul.
2002.10.23







_________________________________________________________________
与联机的朋友进行交流，请使用 MSN Messenger: http://messenger.msn.com/lccn/ 
