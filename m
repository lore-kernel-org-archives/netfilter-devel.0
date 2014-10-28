From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: Re: [PATCH v2 3/3] Make use of pr_fmt where applicable
Date: Tue, 28 Oct 2014 17:56:31 -0200
Message-ID: <544FF4EF.5060509@redhat.com>
References: <12a99ae77aa9969692d847d8d2929deb13485e72.1414175014.git.mleitner@redhat.com> <65a78d556ae1682fdf38f8bdb424204ee72d1ad9.1414175014.git.mleitner@redhat.com> <20141027222353.GC5998@salvia> <544F9347.6020704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbaJ1T4g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:56:36 -0400
In-Reply-To: <544F9347.6020704@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28-10-2014 10:59, Marcelo Ricardo Leitner wrote:
> On 27-10-2014 20:23, Pablo Neira Ayuso wrote:
>> On Fri, Oct 24, 2014 at 04:46:32PM -0200, Marcelo Ricardo Leitner wrote:
>>> And also remove PRINTR macro in favor of net_*_ratelimited().
>>>
>>> Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
>>> ---
>>>
>>> Notes:
>>>      v1-v2:
>>>        make use of net_err_ratelimited()
>>>
>>>   net/netfilter/nfnetlink_log.c | 18 ++++++++----------
>>>   1 file changed, 8 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
>>> index
>>> b1e3a05794169283ed50d1c0fb4f44d9e7753eeb..0eb10bf295e92ad29541f58ca1de67e3380157c0
>>> 100644
>>> --- a/net/netfilter/nfnetlink_log.c
>>> +++ b/net/netfilter/nfnetlink_log.c
>>> @@ -12,6 +12,8 @@
>>>    * it under the terms of the GNU General Public License version 2 as
>>>    * published by the Free Software Foundation.
>>>    */
>>> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>> +
>>>   #include <linux/module.h>
>>>   #include <linux/skbuff.h>
>>>   #include <linux/if_arp.h>
>>> @@ -45,9 +47,6 @@
>>>   #define NFULNL_QTHRESH_DEFAULT     100    /* 100 packets */
>>>   #define NFULNL_COPY_RANGE_MAX    0xFFFF    /* max packet size is limited
>>> by 16-bit struct nfattr nfa_len field */
>>>
>>> -#define PRINTR(x, args...)    do { if (net_ratelimit()) \
>>> -                     printk(x, ## args); } while (0);
>>> -
>>>   struct nfulnl_instance {
>>>       struct hlist_node hlist;    /* global list of instances */
>>>       spinlock_t lock;
>>> @@ -335,8 +334,7 @@ nfulnl_alloc_skb(struct net *net, u32 peer_portid,
>>> unsigned int inst_size,
>>>               skb = nfnetlink_alloc_skb(net, pkt_size,
>>>                             peer_portid, GFP_ATOMIC);
>>>               if (!skb)
>>> -                pr_err("nfnetlink_log: can't even alloc %u bytes\n",
>>> -                       pkt_size);
>>> +                pr_err("can't even alloc %u bytes\n", pkt_size);
>>>           }
>>>       }
>>>
>>> @@ -569,7 +567,7 @@ __build_packet_message(struct nfnl_log_net *log,
>>>           int size = nla_attr_size(data_len);
>>>
>>>           if (skb_tailroom(inst->skb) < nla_total_size(data_len)) {
>>> -            printk(KERN_WARNING "nfnetlink_log: no tailroom!\n");
>>> +            pr_warn("no tailroom!\n");
>>>               return -1;
>>
>> I think we can just goto nla_put_failure and remove this warning.
>
> ok
>
>>>           }
>>>
>>> @@ -585,7 +583,7 @@ __build_packet_message(struct nfnl_log_net *log,
>>>       return 0;
>>>
>>>   nla_put_failure:
>>> -    PRINTR(KERN_ERR "nfnetlink_log: error creating log nlmsg\n");
>>> +    net_err_ratelimited("error creating log nlmsg\n");
>>
>> I'd remove this one too.
>>
>> But before doing any error message cleanup, we should also call
>> nlmsg_cancel() here to leave the nflog netlink batch message in
>> consistent state in case of errors. And we don't check for errors
>> after __build_packet_message() which may result in sending an
>> incomplete message to userspace.
>
> okay
>
>> Would you send us patches to address this? Thanks.
>
> Sure thing. Thanks Pablo.
>

Hi Pablo,

While we are at this, what about this one, does it really have to be a BUG() one?

__build_packet_message()
...
     if (data_len) {
         struct nlattr *nla;
         int size = nla_attr_size(data_len);

         if (skb_tailroom(inst->skb) < nla_total_size(data_len))
             goto nla_put_failure;           <-- already changed

         nla = (struct nlattr *)skb_put(inst->skb, nla_total_size(data_len));
         nla->nla_type = NFULA_PAYLOAD;
         nla->nla_len = size;

         if (skb_copy_bits(skb, 0, nla_data(nla), data_len))
             BUG();         <--
     }

Seems we could just put a goto nla_put_failure there too instead of bringing 
everything down. skb_copy_bits will only fail if we try to copy too much from 
the skb.. We could leave a WARN_ONCE in there if the idea is to catch nasty 
bugs in there. WDYT? I'm thinking in just sticking with a goto in there too.

Marcelo

