From: Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 1/5] netfilter: fix general protection fault when unregister sysctl table
Date: Wed,  5 Dec 2018 20:56:26 +0800
Message-ID: <1544014590-14429-1-git-send-email-laoar.shao@gmail.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, adobriyan@gmail.com, akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On my server, I found a general protection fault in kernel message.
Bellow is the detailed information.

[   34.234846] general protection fault: 0000 [#1] SMP PTI
[   34.235498] CPU: 0 PID: 147 Comm: kworker/u2:3 Not tainted
4.20.0-rc3-next-20181120 #23
[   34.236461] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org 04/01/2014
[   34.238216] Workqueue: netns cleanup_net
[   34.238623] RIP: 0010:unregister_sysctl_table+0x13/0x80
[   34.239202] Code: 6d ff ff ff 48 c7 c7 60 b1 07 83 bd f4 ff ff ff e8 22 1d a7
00 eb c5 0f 1f 44 00 00 41 55 48 85 ff 41 54 55 53 48 89 fb 74 30 <48> 8b 7f 20
e8 04 f1 ff ff 83 f8 01 7f 29 48 c7 c7 60 b1 07 83 e8
[   34.241920] RSP: 0018:ffffc9000022fda8 EFLAGS: 00010206
[   34.242496] RAX: 0000000000000000 RBX: 0000d2f000002328 RCX: 0000000000000000
[   34.243480] RDX: 000000000000001c RSI: ffffffff82999d00 RDI: 0000d2f000002328
[   34.244311] RBP: ffffc9000022fe30 R08: 000000000000000a R09: 0000000000002800
[   34.245274] R10: 000000000000024a R11: ffffea0000f64a40 R12: ffffffff8294a658
[   34.246191] R13: ffffffff8294a660 R14: ffffffff82941e00 R15: ffffc9000022fe30
[   34.247217] FS:  0000000000000000(0000) GS:ffff88803ea00000(0000)
knlGS:0000000000000000
[   34.248230] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   34.248984] CR2: 00007faa1819b2a8 CR3: 0000000002828005 CR4: 00000000003606f0
[   34.249845] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   34.250695] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   34.251535] Call Trace:
[   34.251848]  nf_ct_l4proto_pernet_unregister_one+0x45/0x60
[   34.252479]  proto_gre_net_exit+0x18/0x90
[   34.252888]  ops_exit_list.isra.8+0x33/0x60
[   34.253332]  cleanup_net+0x195/0x2a0
[   34.253698]  process_one_work+0x15f/0x360
[   34.254190]  worker_thread+0x49/0x3e0
[   34.254544]  kthread+0xf5/0x130
[   34.254966]  ? process_one_work+0x360/0x360
[   34.255401]  ? kthread_park+0x80/0x80
[   34.255916]  ret_from_fork+0x35/0x40
[   34.256269] Modules linked in:
[   34.256582] ---[ end trace be3904a1ee0bddf8 ]---
[   34.257080] RIP: 0010:unregister_sysctl_table+0x13/0x80
[   34.257697] Code: 6d ff ff ff 48 c7 c7 60 b1 07 83 bd f4 ff ff ff e8 22 1d a7
00 eb c5 0f 1f 44 00 00 41 55 48 85 ff 41 54 55 53 48 89 fb 74 30 <48> 8b 7f 20
e8 04 f1 ff ff 83 f8 01 7f 29 48 c7 c7 60 b1 07 83 e8
[   34.260268] RSP: 0018:ffffc9000022fda8 EFLAGS: 00010206
[   34.260864] RAX: 0000000000000000 RBX: 0000d2f000002328 RCX: 0000000000000000
[   34.261717] RDX: 000000000000001c RSI: ffffffff82999d00 RDI: 0000d2f000002328
[   34.262569] RBP: ffffc9000022fe30 R08: 000000000000000a R09: 0000000000002800
[   34.263592] R10: 000000000000024a R11: ffffea0000f64a40 R12: ffffffff8294a658
[   34.264449] R13: ffffffff8294a660 R14: ffffffff82941e00 R15: ffffc9000022fe30
[   34.265295] FS:  0000000000000000(0000) GS:ffff88803ea00000(0000)
knlGS:0000000000000000
[   34.266395] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   34.267044] CR2: 00007faa1819b2a8 CR3: 0000000002828005 CR4: 00000000003606f0
[   34.267936] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   34.268881] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

This general protection fault is in function unregister_sysctl_table(),
because 'header' is a pointer that isn't kmalloced.

If some modules(in this case, it is GRE) forget to kmemdup sysctl table,
'pn->ctl_table' will be NULL in function nf_ct_l4proto_register_sysctl(),
and then register_net_sysctl() can't be executed, so the 'header' in
__register_sysctl_table() will never be assigned,
	header = kzalloc(sizeof(struct ctl_table_header) +
			 sizeof(struct ctl_node)*nr_entries, GFP_KERNEL);

But pn->users will be incremented as the return value of
nf_ct_l4proto_register_sysctl() is 0.

As a result of that behavior, when doing unregister,
unregister_net_sysctl_table() will be executed. Then we will access a
pointer that isn't assigned. That's why general protection fault occurs.

This patch is to fix this general protection fault issue.
After this patch, an error message will be printed to indicate some error
happens, for example, in this case bellow message will be printed,
	"nf_conntrack_gre4: pernet registration failed."

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 net/netfilter/nf_conntrack_proto.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 40643af..154e8c0 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -192,8 +192,12 @@ int nf_ct_l4proto_register_sysctl(struct net *net,
 				pn->ctl_table = NULL;
 			}
 		}
+	} else {
+		/* in case any module doesn't kmemdup sysctl table */
+		err = -ENOENT;
 	}
 #endif /* CONFIG_SYSCTL */
+
 	return err;
 }
 
-- 
1.8.3.1
