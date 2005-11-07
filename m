From: Horms <horms@debian.org>
Subject: Bug#337713: [PATCH] Null pointer access in nf_queue()
Date: Mon, 7 Nov 2005 17:39:53 +0900
Message-ID: <20051107083953.GA8420@verge.net.au>
References: <E1EYW7S-0000uH-00@master.debian.org>
Reply-To: Horms <horms@debian.org>, 337713@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: coreteam@netfilter.org, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@coreworks.de>
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-Message-ID: <handler.337713.B337713.113135348931744@bugs.debian.org>
To: Torok Edwin <edwintorok@gmail.com>, 337713@bugs.debian.org
Content-Disposition: inline
In-Reply-To: <E1EYW7S-0000uH-00@master.debian.org>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Nov 06, 2005 at 12:02:37AM +0200, Torok Edwin wrote:
> Package: linux-image-2.6.14-1-k7
> Version: 2.6.14-1
> Severity: important
> 
> I have got a kernel panic, here it is: (I hand-copied it, since it wasn't saved to disk)
> EIP: 0060: [<c02b2516>]  Not tainted VLI
> EFLAGS: 00010286 (2.6.14-1-k7)
> EIP is at nf_queue+0x16/0x240
> eax: 00000000 ebx: 00000001 ecx: 00000000 edx: 00000002
> esi: dece0920 edi: c03a3aa8 ebp: c0277e70 esp: cf165e78
> ds:  007b     es:  007b     ss: 0068
> 
> Process sh (pid:5278, threadinfo=cf164000 task=dc5b4ab0)
> Stack:   cf165f00 dae29000 00000000 c0277e70 00000001 cf165f00 c03a3aa8 c0277e70
> c02b1f7c cf165f00 dece0920 00000002 00000001 dae29000 00000000 c0277e70 
> 00000000 dece0920 00000000 da641b40 da54bcde cc318abc c0277c10 00000002
> 
> Call Trace:
> [<c0277e70>] ip_local_deliver_finish+0x0/0x230
> [<c0277e70>] ip_local_deliver_finish+0x0/0x230
> [<c02b1f7c>] nf_hook_slow+0x0c/0x110
> [<c0277e70>] ip_local_deliver_finish+0x0/0x230
> [<c0277c10>] ip_local_deliver+0x60/0x2c0
> [<c02783f7>] ip_rcv+0x357/0x540
> [<c0258ed8>] netif_receive_skb+0x238/0x2e0
> [<c0258fec>] process_backlog+0x6e/0xf0
> [<c02590f7>] net_rx_action+0x87/0x140
> [<c0120a33>] __do_softirqq+0x43/0x90
> [<c012caa6>] do_softirq+0x26/0x30
> [<c010528e>] do_IRQ+0x1e/0x30
> [<c0103ada>] common_interrupt+0x1a/0x20
> Code: c0 75 ec e9 bd e5 e6 ff 8d b6 00 00 00 00 8d bc 27 00 00 00 00 55 57 56 53
> 83 ec 10 8b 54 24 2c 8b 74 24 28 8b 04 9b c0 42 3a c0 <8b> 38 85 ff 0f 84 96 01
> 00 00 86 44 24 2c 8b 7c 24 2c c7 44 24
> <0>Kernel panic - not syncing: Fatal exception in interrupt
> 
> Bug reproducible: always.
> Steps to reproduce: Start fireflierd
> Result: kernel panic
> 
> What fireflierd does is try to communicate with the ip_queue module, that isn't loaded.
> If I load the module everything is ok. 
> On kernel version 2.6.12 I got an error message from fireflierd, but the kernel didn't panic.
> If you need further info, tell please tell me how to provide it.
> If you need the program fireflierd, just tell me, I can upload it somewhere (binary/source), it is a GPL program,
> that's going to be released soon.

Thanks,

I did some disasembling fun and games, and I'm pretty sure the patch
below will fix your problem. I'll fire of a build, I'd be greateful if
you could test it.

According to the trace above, pf (%edx) is 2, however, it seems that
queue_handler[pf] is NULL.  I would guess that it has been unbound using
netlink (nfqnl_recv_config(), case NFQNL_CFG_CMD_PF_UNBIND:)

Or in other words, queue_handler[pf] can be set to NULL from userspace,
but it is accessed without checking to see if it is NULL.

I'm taking a few leaps of faith here, so my logic could be out.
Here is the a portion of the disasembled code if anyone cares:

0xc02b2500:     push   %ebp
0xc02b2501:     push   %edi
0xc02b2502:     push   %esi
0xc02b2503:     push   %ebx
0xc02b2504:     sub    $0x10,%esp
0xc02b2507:     mov    0x2c(%esp),%edx
0xc02b250b:     mov    0x28(%esp),%esi
0xc02b250f:     mov    0xc03a42c0(,%edx,4),%eax
0xc02b2516:     mov    (%eax),%edi
0xc02b2518:     test   %edi,%edi
0xc02b251a:     je     0x412b26b6

Signed-off-by: Horms <horms@verge.net.au>


diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index d10d552..d3a4f30 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -117,7 +117,7 @@ int nf_queue(struct sk_buff **skb, 
 
 	/* QUEUE == DROP if noone is waiting, to be safe. */
 	read_lock(&queue_handler_lock);
-	if (!queue_handler[pf]->outfn) {
+	if (!queue_handler[pf] || !queue_handler[pf]->outfn) {
 		read_unlock(&queue_handler_lock);
 		kfree_skb(*skb);
 		return 1;
