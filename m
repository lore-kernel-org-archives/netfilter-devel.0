From: John Williams Floroiu <floroiu@fokus.fraunhofer.de>
Subject: Re: problems with netlink_broadcast
Date: Tue, 13 Jan 2004 19:16:23 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <400435F7.7070309@fokus.fraunhofer.de>
References: <4003DCD7.6040602@fokus.fraunhofer.de> <400424F7.9040508@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi Patrick,

> Are you using GFP_ATOMIC for netlink_broadcast and alloc_skb ?

Yes, here is the code of the tasklet and timer handler in the version of my "user-kernel" module that apparently works.

I also attached at the end the dump I got with the versions that calls alloc_skb from the tasklet.

Regards,
John.

----

void uk_task(void *arg) {

         local_bh_disable();
         printk(KERN_INFO "--- calling netlink_broadcast ---\n");
         netlink_broadcast(uknl, (struct sk_buff *)arg, 0, UKGRP_TEST, GFP_ATOMIC);
         local_bh_enable();
         printk(KERN_INFO "### uk_task terminates ###\n");
}

void uk_timer_handler(unsigned long arg){

         struct nlmsghdr *nl;
         struct sk_buff *skb;

         uktimer.expires = jiffies + HZ/2;
         add_timer(&uktimer);

         skb = alloc_skb(NLMSG_SPACE(256), GFP_ATOMIC);
         if (!skb) {
                 printk(KERN_INFO "### uk_task skb allocation failure ###\n");
                 return;
         }
         NLMSG_PUT(skb, 0, 0, UK_NOTIF_TEST, 0);
         NETLINK_CB(skb).dst_groups = UKGRP_TEST;
         printk(KERN_INFO "### skb->len = %d ###\n", skb->len);

         uk_work.data = skb;
         schedule_work(&uk_work);
         printk(KERN_INFO "### uk_timer_handler terminates ###\n");

         return;

nlmsg_failure:
         skb_trim(skb, skb->tail - skb->data);
         printk(KERN_INFO "### uk_task NLMSG_PUT failure ###\n");
}

----------------------------------------------------------------

Unable to handle kernel paging request at virtual address f6a34fb0
   printing eip:
  f88233ca
  *pde = 00488067
  *pte = 36a34000
  Oops: 0000 [#1]
  CPU:    1
  EIP:    0060:[__crc_utf8_wctomb+5448385/6417782]    Not tainted
  EFLAGS: 00010246
  EIP is at uk_task+0xda/0x160 [uk]
  eax: 00000000   ebx: f6a34f4c   ecx: 00000000   edx: fffffffd
  esi: f2f1fbf8   edi: f8824460   ebp: c1a95f64   esp: c1a95f48
  ds: 007b   es: 007b   ss: 0068
  Process events/1 (pid: 7, threadinfo=c1a94000 task=c1a619b0)
  Stack: f2fa7e94 f6a34f4c 00000000 00000159 00000020 c1a94000 f8824464 c1a95fec
         c01370f6 00000000 c1a95fa0 00000000 c1a64f90 c1a64fa0 00000000 f88232f0
         00000212 c1a64f88 c1a64f78 5a5a5a5a 5a5a5a5a 5a5a5a5a 00000001 00000000
  Call Trace:
   [worker_thread+534/960] worker_thread+0x216/0x3c0
   [__crc_utf8_wctomb+5448167/6417782] uk_task+0x0/0x160 [uk]
   [default_wake_function+0/32] default_wake_function+0x0/0x20
   [ret_from_fork+6/20] ret_from_fork+0x6/0x14
   [default_wake_function+0/32] default_wake_function+0x0/0x20
   [worker_thread+0/960] worker_thread+0x0/0x3c0
   [kernel_thread_helper+5/24] kernel_thread_helper+0x5/0x18

  Code: 8b 43 64 c7 04 24 a0 36 82 f8 89 44 24 04 e8 73 10 90 c7 83
