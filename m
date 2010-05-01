From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] nfnetlink_queue: use hash table to speed up entry lookup
Date: Sat, 1 May 2010 08:14:43 +0800
Message-ID: <v2w412e6f7f1004301714wfc3a4e4aoacebb8e609de2d5d@mail.gmail.com>
References: <1271773896-28246-1-git-send-email-xiaosuo@gmail.com>
	<20100421202357.GK2563@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:57866 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab0EAAPE convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Apr 2010 20:15:04 -0400
Received: by pzk42 with SMTP id 42so435028pzk.4
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2010 17:15:03 -0700 (PDT)
In-Reply-To: <20100421202357.GK2563@linux.vnet.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 22, 2010 at 4:23 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Apr 20, 2010 at 10:31:36PM +0800, Changli Gao wrote:
>> use hash table to speed up entry lookup
>>
>> A hash table is used to speed up entry lookup when the verdicts aren=
't received
>> in order. The size of hash table can be specified by NFQA_CFG_QUEUE_=
HTBLSIZ.
>> Its default value is 1. Reciprocal division is used to lower the cos=
t of
>> division, and the entry IDs are generated carefully to get fair entr=
y
>> distribution in the buckets of the hash table.
>
> A few questions interspersed below.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Thanx, Paul
>
>> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
>> ----
>> =C2=A0include/linux/netfilter/nfnetlink_queue.h | =C2=A0 =C2=A01
>> =C2=A0init/Kconfig =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A01
>> =C2=A0lib/Kconfig =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A03
>> =C2=A0lib/Makefile =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A04
>> =C2=A0lib/reciprocal_div.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A02
>> =C2=A0net/netfilter/Kconfig =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A01
>> =C2=A0net/netfilter/nfnetlink_queue.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 | =C2=A0252 +++++++++++++++++++++++++-----
>> =C2=A07 files changed, 227 insertions(+), 37 deletions(-)
>> diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/lin=
ux/netfilter/nfnetlink_queue.h
>> index 2455fe5..77b1566 100644
>> --- a/include/linux/netfilter/nfnetlink_queue.h
>> +++ b/include/linux/netfilter/nfnetlink_queue.h
>> @@ -83,6 +83,7 @@ enum nfqnl_attr_config {
>> =C2=A0 =C2=A0 =C2=A0 NFQA_CFG_CMD, =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* nfqnl_msg_config_cmd */
>> =C2=A0 =C2=A0 =C2=A0 NFQA_CFG_PARAMS, =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0/* nfqnl_msg_config_params */
>> =C2=A0 =C2=A0 =C2=A0 NFQA_CFG_QUEUE_MAXLEN, =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0/* __u32 */
>> + =C2=A0 =C2=A0 NFQA_CFG_QUEUE_HTBLSIZ, =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
/* __u32 */
>> =C2=A0 =C2=A0 =C2=A0 __NFQA_CFG_MAX
>> =C2=A0};
>> =C2=A0#define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
>> diff --git a/init/Kconfig b/init/Kconfig
>> index cb6069e..4b4266f 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -1059,6 +1059,7 @@ choice
>>
>> =C2=A0config SLAB
>> =C2=A0 =C2=A0 =C2=A0 bool "SLAB"
>> + =C2=A0 =C2=A0 select RECIPROCAL_DIV
>> =C2=A0 =C2=A0 =C2=A0 help
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 The regular slab allocator that is estab=
lished and known to work
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 well in all environments. It organizes c=
ache hot objects in
>> diff --git a/lib/Kconfig b/lib/Kconfig
>> index af12831..0c4b5ec 100644
>> --- a/lib/Kconfig
>> +++ b/lib/Kconfig
>> @@ -231,4 +231,7 @@ config IOQ
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0If unsure, say N
>>
>> +config RECIPROCAL_DIV
>> + =C2=A0 =C2=A0 =C2=A0 bool
>> +
>> =C2=A0endmenu
>> diff --git a/lib/Makefile b/lib/Makefile
>> index 0a6ab6f..c3555bd 100644
>> --- a/lib/Makefile
>> +++ b/lib/Makefile
>> @@ -10,7 +10,7 @@ endif
>> =C2=A0lib-y :=3D ctype.o string.o vsprintf.o cmdline.o \
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0rbtree.o radix-tree.o dump_stack.o \
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0idr.o int_sqrt.o extable.o prio_tree.o \
>> - =C2=A0 =C2=A0 =C2=A0sha1.o irq_regs.o reciprocal_div.o argv_split.=
o \
>> + =C2=A0 =C2=A0 =C2=A0sha1.o irq_regs.o argv_split.o \
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0proportions.o prio_heap.o ratelimit.o sho=
w_mem.o \
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0is_single_threaded.o plist.o decompress.o=
 flex_array.o
>>
>> @@ -103,6 +103,8 @@ obj-$(CONFIG_GENERIC_CSUM) +=3D checksum.o
>>
>> =C2=A0obj-$(CONFIG_GENERIC_ATOMIC64) +=3D atomic64.o
>>
>> +obj-$(CONFIG_RECIPROCAL_DIV) +=3D reciprocal_div.o
>> +
>> =C2=A0hostprogs-y =C2=A0:=3D gen_crc32table
>> =C2=A0clean-files =C2=A0:=3D crc32table.h
>>
>> diff --git a/lib/reciprocal_div.c b/lib/reciprocal_div.c
>> index 6a3bd48..39f2e5e 100644
>> --- a/lib/reciprocal_div.c
>> +++ b/lib/reciprocal_div.c
>> @@ -1,5 +1,6 @@
>> =C2=A0#include <asm/div64.h>
>> =C2=A0#include <linux/reciprocal_div.h>
>> +#include <linux/module.h>
>>
>> =C2=A0u32 reciprocal_value(u32 k)
>> =C2=A0{
>> @@ -7,3 +8,4 @@ u32 reciprocal_value(u32 k)
>> =C2=A0 =C2=A0 =C2=A0 do_div(val, k);
>> =C2=A0 =C2=A0 =C2=A0 return (u32)val;
>> =C2=A0}
>> +EXPORT_SYMBOL(reciprocal_value);
>> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
>> index 18d77b5..40b34d5 100644
>> --- a/net/netfilter/Kconfig
>> +++ b/net/netfilter/Kconfig
>> @@ -8,6 +8,7 @@ config NETFILTER_NETLINK_QUEUE
>> =C2=A0 =C2=A0 =C2=A0 tristate "Netfilter NFQUEUE over NFNETLINK inte=
rface"
>> =C2=A0 =C2=A0 =C2=A0 depends on NETFILTER_ADVANCED
>> =C2=A0 =C2=A0 =C2=A0 select NETFILTER_NETLINK
>> + =C2=A0 =C2=A0 select RECIPROCAL_DIV
>> =C2=A0 =C2=A0 =C2=A0 help
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 If this option is enabled, the kernel wi=
ll include support
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 for queueing packets via NFNETLINK.
>> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetli=
nk_queue.c
>> index e70a6ef..d3d02b7 100644
>> --- a/net/netfilter/nfnetlink_queue.c
>> +++ b/net/netfilter/nfnetlink_queue.c
>> @@ -28,6 +28,8 @@
>> =C2=A0#include <linux/netfilter/nfnetlink.h>
>> =C2=A0#include <linux/netfilter/nfnetlink_queue.h>
>> =C2=A0#include <linux/list.h>
>> +#include <linux/vmalloc.h>
>> +#include <linux/reciprocal_div.h>
>> =C2=A0#include <net/sock.h>
>> =C2=A0#include <net/netfilter/nf_queue.h>
>>
>> @@ -37,11 +39,13 @@
>> =C2=A0#include "../bridge/br_private.h"
>> =C2=A0#endif
>>
>> -#define NFQNL_QMAX_DEFAULT 1024
>> +#define NFQNL_QMAX_DEFAULT =C2=A0 1024
>> +#define NFQNL_QHTBLSIZ_DEFAULT =C2=A0 =C2=A0 =C2=A0 1
>>
>> =C2=A0struct nfqnl_instance {
>> =C2=A0 =C2=A0 =C2=A0 struct hlist_node hlist; =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* global list of queues */
>> =C2=A0 =C2=A0 =C2=A0 struct rcu_head rcu;
>> + =C2=A0 =C2=A0 struct work_struct work;
>>
>> =C2=A0 =C2=A0 =C2=A0 int peer_pid;
>> =C2=A0 =C2=A0 =C2=A0 unsigned int queue_maxlen;
>> @@ -49,15 +53,21 @@ struct nfqnl_instance {
>> =C2=A0 =C2=A0 =C2=A0 unsigned int queue_total;
>> =C2=A0 =C2=A0 =C2=A0 unsigned int queue_dropped;
>> =C2=A0 =C2=A0 =C2=A0 unsigned int queue_user_dropped;
>> + =C2=A0 =C2=A0 unsigned int queue_htblsiz;
>> + =C2=A0 =C2=A0 u32 reciprocal_value;
>>
>> =C2=A0 =C2=A0 =C2=A0 unsigned int id_sequence; =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* 'sequence' of pkt ids */
>> + =C2=A0 =C2=A0 unsigned int id_increment;
>> + =C2=A0 =C2=A0 unsigned int id_offset;
>> + =C2=A0 =C2=A0 unsigned int id_limit;
>>
>> =C2=A0 =C2=A0 =C2=A0 u_int16_t queue_num; =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* number of this queue */
>> =C2=A0 =C2=A0 =C2=A0 u_int8_t copy_mode;
>>
>> =C2=A0 =C2=A0 =C2=A0 spinlock_t lock;
>>
>> - =C2=A0 =C2=A0 struct list_head queue_list; =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0/* packets in queue */
>> + =C2=A0 =C2=A0 struct list_head *queue_htbl; =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /* packets in queue */
>> + =C2=A0 =C2=A0 bool vmalloc;
>> =C2=A0};
>>
>> =C2=A0typedef int (*nfqnl_cmpfn)(struct nf_queue_entry *, unsigned l=
ong);
>> @@ -87,49 +97,87 @@ instance_lookup(u_int16_t queue_num)
>> =C2=A0 =C2=A0 =C2=A0 return NULL;
>> =C2=A0}
>>
>> +static void instance_destroy_work(struct work_struct *work)
>> +{
>> + =C2=A0 =C2=A0 struct nfqnl_instance *inst;
>> +
>> + =C2=A0 =C2=A0 inst =3D container_of(work, struct nfqnl_instance, w=
ork);
>> + =C2=A0 =C2=A0 if (inst->vmalloc)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vfree(inst->queue_htbl);
>> + =C2=A0 =C2=A0 else
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(inst->queue_htbl);
>> + =C2=A0 =C2=A0 kfree(inst);
>> + =C2=A0 =C2=A0 module_put(THIS_MODULE);
>> +}
>> +
>> =C2=A0static struct nfqnl_instance *
>> =C2=A0instance_create(u_int16_t queue_num, int pid)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 struct nfqnl_instance *inst;
>> - =C2=A0 =C2=A0 unsigned int h;
>> + =C2=A0 =C2=A0 unsigned int h, i;
>> =C2=A0 =C2=A0 =C2=A0 int err;
>>
>> - =C2=A0 =C2=A0 spin_lock(&instances_lock);
>> - =C2=A0 =C2=A0 if (instance_lookup(queue_num)) {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EEXIST;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_unlock;
>> - =C2=A0 =C2=A0 }
>> -
>> + =C2=A0 =C2=A0 rcu_read_unlock();
>
> This seems strange -- are all the callers aware that instance_create(=
)
> temporarily exits the RCU read-side critical section?

There is only one caller, so it is awares. But it seems that I should
add suffix "_rcu_read_locked()" to instrance_create().

>
>> =C2=A0 =C2=A0 =C2=A0 inst =3D kzalloc(sizeof(*inst), GFP_ATOMIC);
>> =C2=A0 =C2=A0 =C2=A0 if (!inst) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -ENOMEM;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_unlock;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_lock;
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> + =C2=A0 =C2=A0 INIT_WORK(&inst->work, instance_destroy_work);
>> =C2=A0 =C2=A0 =C2=A0 inst->queue_num =3D queue_num;
>> =C2=A0 =C2=A0 =C2=A0 inst->peer_pid =3D pid;
>> =C2=A0 =C2=A0 =C2=A0 inst->queue_maxlen =3D NFQNL_QMAX_DEFAULT;
>> =C2=A0 =C2=A0 =C2=A0 inst->copy_range =3D 0xfffff;
>> =C2=A0 =C2=A0 =C2=A0 inst->copy_mode =3D NFQNL_COPY_NONE;
>> =C2=A0 =C2=A0 =C2=A0 spin_lock_init(&inst->lock);
>> - =C2=A0 =C2=A0 INIT_LIST_HEAD(&inst->queue_list);
>> + =C2=A0 =C2=A0 inst->queue_htblsiz =3D NFQNL_QHTBLSIZ_DEFAULT;
>> + =C2=A0 =C2=A0 inst->id_increment =3D INT_MAX / inst->queue_htblsiz=
;
>> + =C2=A0 =C2=A0 inst->id_limit =3D inst->id_increment * inst->queue_=
htblsiz;
>> + =C2=A0 =C2=A0 inst->reciprocal_value =3D reciprocal_value(inst->id=
_increment);
>> + =C2=A0 =C2=A0 inst->queue_htbl =3D kmalloc(sizeof(struct list_head=
) *
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inst->queue_htblsiz, GFP_K=
ERNEL);
>> + =C2=A0 =C2=A0 if (inst->queue_htbl =3D=3D NULL) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inst->queue_htbl =3D vma=
lloc(sizeof(struct list_head) *
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
inst->queue_htblsiz);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (inst->queue_htbl =3D=
=3D NULL) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 err =3D -ENOMEM;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 goto out_free;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inst->vmalloc =3D true;
>> + =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 for (i =3D 0; i < inst->queue_htblsiz; i++)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 INIT_LIST_HEAD(&inst->qu=
eue_htbl[i]);
>>
>> =C2=A0 =C2=A0 =C2=A0 if (!try_module_get(THIS_MODULE)) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EAGAIN;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_free;
>> =C2=A0 =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 rcu_read_lock();
>>
>> + =C2=A0 =C2=A0 spin_lock(&instances_lock);
>> + =C2=A0 =C2=A0 if (instance_lookup(queue_num)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EEXIST;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(&instances_l=
ock);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rcu_read_unlock();
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_free;
>> + =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 h =3D instance_hashfn(queue_num);
>> =C2=A0 =C2=A0 =C2=A0 hlist_add_head_rcu(&inst->hlist, &instance_tabl=
e[h]);
>> -
>> =C2=A0 =C2=A0 =C2=A0 spin_unlock(&instances_lock);
>>
>> =C2=A0 =C2=A0 =C2=A0 return inst;
>>
>> =C2=A0out_free:
>> + =C2=A0 =C2=A0 if (inst->queue_htbl) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (inst->vmalloc)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 vfree(inst->queue_htbl);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 kfree(inst->queue_htbl);
>> + =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 kfree(inst);
>> -out_unlock:
>> - =C2=A0 =C2=A0 spin_unlock(&instances_lock);
>> +out_lock:
>> + =C2=A0 =C2=A0 rcu_read_lock();
>> =C2=A0 =C2=A0 =C2=A0 return ERR_PTR(err);
>> =C2=A0}
>>
>> @@ -143,8 +191,7 @@ instance_destroy_rcu(struct rcu_head *head)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rcu);
>>
>> =C2=A0 =C2=A0 =C2=A0 nfqnl_flush(inst, NULL, 0);
>> - =C2=A0 =C2=A0 kfree(inst);
>> - =C2=A0 =C2=A0 module_put(THIS_MODULE);
>> + =C2=A0 =C2=A0 schedule_work(&inst->work);
>> =C2=A0}
>>
>> =C2=A0static void
>> @@ -162,32 +209,67 @@ instance_destroy(struct nfqnl_instance *inst)
>> =C2=A0 =C2=A0 =C2=A0 spin_unlock(&instances_lock);
>> =C2=A0}
>>
>> +static inline struct list_head *nfqnl_head_get(struct nfqnl_instanc=
e *queue,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0unsigned int id)
>> +{
>> + =C2=A0 =C2=A0 return &queue->queue_htbl[reciprocal_divide(id,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 queue->reciprocal_value)];
>> +}
>> +
>> +static struct nf_queue_entry *__find_entry(struct nfqnl_instance *q=
ueue,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
u32 id)
>> +{
>> + =C2=A0 =C2=A0 struct nf_queue_entry *entry;
>> + =C2=A0 =C2=A0 struct list_head *head;
>> +
>> + =C2=A0 =C2=A0 head =3D nfqnl_head_get(queue, id);
>> + =C2=A0 =C2=A0 list_for_each_entry(entry, head, list) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (entry->id =3D=3D id)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return entry;
>> + =C2=A0 =C2=A0 }
>> +
>> + =C2=A0 =C2=A0 return NULL;
>> +}
>> +
>> +static u32 __get_uniq_id(struct nfqnl_instance *queue)
>> +{
>> + =C2=A0 =C2=A0 u32 i;
>> +
>> + =C2=A0 =C2=A0 for (i =3D 0; i < INT_MAX; i++) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 queue->id_sequence +=3D =
queue->id_increment;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (queue->id_sequence >=
=3D queue->id_limit) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (++queue->id_offset >=3D queue->id_increment)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 queue->id_offset =3D 0;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 queue->id_sequence =3D queue->id_offset;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (__find_entry(queue, =
queue->id_sequence) =3D=3D NULL)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return queue->id_sequence;
>> + =C2=A0 =C2=A0 }
>> +
>> + =C2=A0 =C2=A0 return INT_MAX;
>> +}
>> +
>> =C2=A0static inline void
>> =C2=A0__enqueue_entry(struct nfqnl_instance *queue, struct nf_queue_=
entry *entry)
>> =C2=A0{
>> - =C2=A0 =C2=A0 =C2=A0 list_add_tail(&entry->list, &queue->queue_lis=
t);
>> - =C2=A0 =C2=A0 =C2=A0 queue->queue_total++;
>> + =C2=A0 =C2=A0 struct list_head *head;
>> +
>> + =C2=A0 =C2=A0 head =3D nfqnl_head_get(queue, entry->id);
>> + =C2=A0 =C2=A0 list_add_tail(&entry->list, head);
>> + =C2=A0 =C2=A0 queue->queue_total++;
>> =C2=A0}
>>
>> =C2=A0static struct nf_queue_entry *
>> =C2=A0find_dequeue_entry(struct nfqnl_instance *queue, unsigned int =
id)
>> =C2=A0{
>> - =C2=A0 =C2=A0 struct nf_queue_entry *entry =3D NULL, *i;
>> + =C2=A0 =C2=A0 struct nf_queue_entry *entry;
>>
>> =C2=A0 =C2=A0 =C2=A0 spin_lock_bh(&queue->lock);
>> -
>> - =C2=A0 =C2=A0 list_for_each_entry(i, &queue->queue_list, list) {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (i->id =3D=3D id) {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 entry =3D i;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 break;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> - =C2=A0 =C2=A0 }
>> -
>> + =C2=A0 =C2=A0 entry =3D __find_entry(queue, id);
>> =C2=A0 =C2=A0 =C2=A0 if (entry) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_del(&entry->li=
st);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 queue->queue_total-=
-;
>> =C2=A0 =C2=A0 =C2=A0 }
>> -
>> =C2=A0 =C2=A0 =C2=A0 spin_unlock_bh(&queue->lock);
>>
>> =C2=A0 =C2=A0 =C2=A0 return entry;
>> @@ -197,13 +279,22 @@ static void
>> =C2=A0nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, u=
nsigned long data)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 struct nf_queue_entry *entry, *next;
>> + =C2=A0 =C2=A0 unsigned int i, total;
>> + =C2=A0 =C2=A0 struct list_head *head;
>>
>> =C2=A0 =C2=A0 =C2=A0 spin_lock_bh(&queue->lock);
>> - =C2=A0 =C2=A0 list_for_each_entry_safe(entry, next, &queue->queue_=
list, list) {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!cmpfn || cmpfn(entr=
y, data)) {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 list_del(&entry->list);
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 queue->queue_total--;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 nf_reinject(entry, NF_DROP);
>> + =C2=A0 =C2=A0 total =3D queue->queue_total;
>> + =C2=A0 =C2=A0 for (i =3D 0; i < queue->queue_htblsiz; i++) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (total < 1)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 break;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 head =3D &queue->queue_h=
tbl[i];
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_entry_safe=
(entry, next, head, list) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (!cmpfn || cmpfn(entry, data)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_del(&entry->list);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 queue->queue_total--;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 nf_reinject(entry, NF_DROP);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 }
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 --total;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 spin_unlock_bh(&queue->lock);
>> @@ -262,7 +353,12 @@ nfqnl_build_packet_message(struct nfqnl_instanc=
e *queue,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> - =C2=A0 =C2=A0 entry->id =3D queue->id_sequence++;
>> + =C2=A0 =C2=A0 entry->id =3D __get_uniq_id(queue);
>> + =C2=A0 =C2=A0 if (entry->id =3D=3D INT_MAX) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_bh(&queue->l=
ock);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
>> + =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 __enqueue_entry(queue, entry);
>>
>> =C2=A0 =C2=A0 =C2=A0 spin_unlock_bh(&queue->lock);
>>
>> @@ -379,6 +475,7 @@ nfqnl_build_packet_message(struct nfqnl_instance=
 *queue,
>>
>> =C2=A0nlmsg_failure:
>> =C2=A0nla_put_failure:
>> + =C2=A0 =C2=A0 find_dequeue_entry(queue, entry->id);
>> =C2=A0 =C2=A0 =C2=A0 if (skb)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree_skb(skb);
>> =C2=A0 =C2=A0 =C2=A0 if (net_ratelimit())
>> @@ -426,14 +523,14 @@ nfqnl_enqueue_packet(struct nf_queue_entry *en=
try, unsigned int queuenum)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto err_out_unlock=
;
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> - =C2=A0 =C2=A0 __enqueue_entry(queue, entry);
>> -
>> =C2=A0 =C2=A0 =C2=A0 spin_unlock_bh(&queue->lock);
>> =C2=A0 =C2=A0 =C2=A0 return 0;
>>
>> =C2=A0err_out_free_nskb:
>> =C2=A0 =C2=A0 =C2=A0 kfree_skb(nskb);
>> =C2=A0err_out_unlock:
>> + =C2=A0 =C2=A0 list_del(&entry->list);
>> + =C2=A0 =C2=A0 queue->queue_total--;
>> =C2=A0 =C2=A0 =C2=A0 spin_unlock_bh(&queue->lock);
>> =C2=A0err_out:
>> =C2=A0 =C2=A0 =C2=A0 return -1;
>> @@ -686,6 +783,77 @@ static const struct nf_queue_handler nfqh =3D {
>> =C2=A0 =C2=A0 =C2=A0 .outfn =C2=A0=3D &nfqnl_enqueue_packet,
>> =C2=A0};
>>
>> +static int nfqnl_htbl_resize(u16 queue_num, int pid, unsigned int s=
ize)
>> +{
>> + =C2=A0 =C2=A0 struct nfqnl_instance *queue;
>> + =C2=A0 =C2=A0 unsigned int i, total;
>> + =C2=A0 =C2=A0 struct list_head *h, *htbl;
>> + =C2=A0 =C2=A0 bool is_vmalloc;
>> + =C2=A0 =C2=A0 int err;
>> +
>> + =C2=A0 =C2=A0 if (size < 1 || size > INT_MAX)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
>> +
>> + =C2=A0 =C2=A0 rcu_read_unlock();
>
> Again, this seems strange. =C2=A0As near as I can tell, the caller im=
mediately
> exits the RCU read-side critical section, so why not have the caller =
do
> the exit immediately before calling nfqnl_htbl_resize()?
>

It sounds reasonable. Thanks.


--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
