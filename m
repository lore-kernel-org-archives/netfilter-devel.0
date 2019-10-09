Return-Path: <SRS0=M1Ox=YC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A66ECE58D
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Oct 2019 15:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DE0220B7C
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Oct 2019 15:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731493AbfJIPB3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Oct 2019 11:01:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49720 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729644AbfJIPB2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Oct 2019 11:01:28 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3D5152A09AD;
        Wed,  9 Oct 2019 15:01:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FCA9F6FB;
        Wed,  9 Oct 2019 15:01:25 +0000 (UTC)
Message-ID: <d61ec28f8e8a5f623d25ae29545523be21ea363d.camel@redhat.com>
Subject: Re: [PATCH nf] ipvs: more robust refcounting when sync thread
 starts
From:   Davide Caratti <dcaratti@redhat.com>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.21.1910032111170.3862@ja.home.ssi.bg>
References: <2bac83f117771cc5c5a59c2bf816039b0efa8239.1570010302.git.dcaratti@redhat.com>
         <alpine.LFD.2.21.1910032111170.3862@ja.home.ssi.bg>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Wed, 09 Oct 2019 17:01:24 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 09 Oct 2019 15:01:28 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2019-10-03 at 22:28 +0300, Julian Anastasov wrote:
> 	Hello,

hello Julian,

thanks a lot for reviewing this code.

> On Wed, 2 Oct 2019, Davide Caratti wrote:
> 
> > if the IPVS module is removed while the sync daemon is starting, there is
> > a small possibility for stop_sync_thread() to end successfully just after
> > start_sync_thread() released sync_mutex, but before increasing the module
> > refcount. When this race happens, the following warning is seen in dmesg:
> > 
> >  IPVS: stopping master sync thread 14134 ...
> >  ------------[ cut here ]------------
> >  WARNING: CPU: 0 PID: 14133 at kernel/module.c:1137 module_put.part.44+0x167/0x2a0

[...]

> 	May be this is not early enough. When control hooks 
> are the first thing to disconnect with ip_vs_unregister_nl_ioctl()
> how start_sync_thread() is called concurrently?

Initially I believed that __ip_vs_dev_cleanup() was called when
start_sync_thread() was already running (but it already released the RTNL
lock). But then, after your comments:

>  ip_vs_sockopts is 
> protected with .owner field and ip_vs_genl_family with .module field
> or more correctly with cb_lock rwsem in net/netlink/genetlink.c
> which avoids doit() handlers after genl_unregister_family() is called.
> So, both interfaces do not allow start_sync_thread() during module
> removal and it is interesting how your fix works actually.

I think that probably my patch just changes the timing of events in my
test setup (see script below), making the problem more difficult to
observe.

> 	Which interface calls start_sync_thread (sockopt/genl)? Note that
> do_ip_vs_set_ctl() already has ip_vs_use_count_inc() before the
> start_sync_thread() call. Also, the WARN in module_put warns
> about refcnt underflow, so there is an extra ip_vs_use_count_dec() ?

it's genl in my case, see call traces below.

> 	Another possibility is the missing checks for 
> ip_vs_use_count_inc() result to cause underflow on ip_vs_use_count_dec().

thanks for the advice, the unbalance is probably the cause of the splat
I'm seeing. On a clean/unpatched kernel, I modified ip_vs_use_count() to
do this:

WARN_ON(!try_module_get(THIS_MODULE))

using the reproducer below, I still see the splat in module_put(), but
it's preceded by a failure in ip_vs_use_count_inc(), which accidentally is
the same one I moved in my patch).

IPVS: Registered protocols (TCP, UDP, SCTP, AH, ESP)
 IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
 IPVS: ipvs loaded.
 IPVS: sync thread started: state = MASTER, mcast_ifn = veth_syncd, syncid = 0, id = 0
 IPVS: stopping master sync thread 4005 ...
 IPVS: sync thread started: state = MASTER, mcast_ifn = veth_syncd, syncid = 0, id = 0
 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 4014 at net/netfilter/ipvs/ip_vs_ctl.c:235 ip_vs_use_count_inc+0x19/0x20 [ip_vs]
 Modules linked in: ip_vs(-) nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 veth ip6table_filter ip6_tables iptable_filter binfmt_misc intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul ext4 mbcache jbd2 ghash_clmulni_intel snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_intel_nhlt snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm aesni_intel crypto_simd cryptd glue_helper joydev pcspkr snd_timer virtio_balloon snd soundcore i2c_piix4 nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c ata_generic pata_acpi virtio_net net_failover virtio_blk failover virtio_console qxl drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ata_piix ttm crc32c_intel serio_raw drm virtio_pci libata virtio_ring virtio floppy dm_mirror dm_region_hash dm_log dm_mod [last unloaded: nf_defrag_ipv6]
 CPU: 0 PID: 4014 Comm: ipvsadm Not tainted 5.4.0-rc1.upstream+ #741
 Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
 RIP: 0010:ip_vs_use_count_inc+0x19/0x20 [ip_vs]
 Code: e8 bc 5e dc f4 4c 8b 44 24 08 e9 db fd ff ff 66 90 0f 1f 44 00 00 48 c7 c7 00 02 42 c1 e8 5f 3c 9e f4 84 c0 74 04 0f b6 c0 c3 <0f> 0b 0f b6 c0 c3 90 0f 1f 44 00 00 55 48 89 e5 41 57 49 89 f7 41
 RSP: 0018:ffff88804ba5f2c8 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffff88804f533ca8 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 1ffff1100974be3f RDI: ffffffffc1420200
 RBP: ffff88804ba5f500 R08: fffffbfff71129d1 R09: fffffbfff71129d1
 R10: 0000000000000001 R11: fffffbfff71129d0 R12: ffff88804f533300
 R13: 0000000000000000 R14: 0000000000000001 R15: ffff888079442d00
 FS:  00007fd42ff9c740(0000) GS:ffff888053800000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000fc91d8 CR3: 000000004fe2c002 CR4: 00000000001606f0
 Call Trace:
  start_sync_thread+0x1c17/0x23a0 [ip_vs]
  ip_vs_genl_new_daemon+0x3b0/0x550 [ip_vs]
  ip_vs_genl_set_daemon+0x295/0x360 [ip_vs]
  genl_rcv_msg+0x588/0x11e0
  netlink_rcv_skb+0x121/0x350
  genl_rcv+0x24/0x40
  netlink_unicast+0x416/0x5d0
  netlink_sendmsg+0x67f/0xb50
  sock_sendmsg+0xe2/0x110
  ___sys_sendmsg+0x640/0x940
  __sys_sendmsg+0xd2/0x170
  do_syscall_64+0xa5/0x4e0
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 RIP: 0033:0x7fd42f48f930
 Code: c3 48 8b 05 42 75 2c 00 f7 db 64 89 18 48 83 cb ff eb dd 0f 1f 80 00 00 00 00 83 3d 6d d6 2c 00 00 75 10 b8 2e 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 ae cc 00 00 48 89 04 24
 RSP: 002b:00007ffcf69ecaa8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
 RAX: ffffffffffffffda RBX: 0000000000fc2100 RCX: 00007fd42f48f930
 RDX: 0000000000000000 RSI: 00007ffcf69ecb50 RDI: 0000000000000003
 RBP: 0000000000fc2010 R08: 0000000000000001 R09: 0000000000fc2150
 R10: 00007fd42f7577b8 R11: 0000000000000246 R12: 0000000000fc3160
 R13: 00007ffcf69ecb50 R14: 0000000000000000 R15: 0000000000000000
 irq event stamp: 3288
 hardirqs last  enabled at (3287): [<ffffffffb5bb276f>] __local_bh_enable_ip+0xef/0x1b0
 hardirqs last disabled at (3288): [<ffffffffb5a0556a>] trace_hardirqs_off_thunk+0x1a/0x20
 softirqs last  enabled at (3286): [<ffffffffc13f3365>] start_sync_thread+0x1c05/0x23a0 [ip_vs]
 softirqs last disabled at (3284): [<ffffffffc13f32e1>] start_sync_thread+0x1b81/0x23a0 [ip_vs]
 ---[ end trace 7b4e216440e510e6 ]---
 IPVS: stopping master sync thread 4016 ...
 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 4013 at kernel/module.c:1146 module_put.part.44+0x15b/0x290
 Modules linked in: ip_vs(-) nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 veth ip6table_filter ip6_tables iptable_filter binfmt_misc intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul ext4 mbcache jbd2 ghash_clmulni_intel snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_intel_nhlt snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm aesni_intel crypto_simd cryptd glue_helper joydev pcspkr snd_timer virtio_balloon snd soundcore i2c_piix4 nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c ata_generic pata_acpi virtio_net net_failover virtio_blk failover virtio_console qxl drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ata_piix ttm crc32c_intel serio_raw drm virtio_pci libata virtio_ring virtio floppy dm_mirror dm_region_hash dm_log dm_mod [last unloaded: nf_defrag_ipv6]
 CPU: 0 PID: 4013 Comm: modprobe Tainted: G        W         5.4.0-rc1.upstream+ #741
 Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
 RIP: 0010:module_put.part.44+0x15b/0x290
 Code: 04 25 28 00 00 00 0f 85 18 01 00 00 48 83 c4 68 5b 5d 41 5c 41 5d 41 5e 41 5f c3 89 44 24 28 83 e8 01 89 c5 0f 89 57 ff ff ff <0f> 0b e9 78 ff ff ff 65 8b 1d 67 83 26 4a 89 db be 08 00 00 00 48
 RSP: 0018:ffff888050607c78 EFLAGS: 00010297
 RAX: 0000000000000003 RBX: ffffffffc1420590 RCX: ffffffffb5db0ef9
 RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffffffc1420590
 RBP: 00000000ffffffff R08: fffffbfff82840b3 R09: fffffbfff82840b3
 R10: 0000000000000001 R11: fffffbfff82840b2 R12: 1ffff1100a0c0f90
 R13: ffffffffc1420200 R14: ffff88804f533300 R15: ffff88804f533ca0
 FS:  00007f8ea9720740(0000) GS:ffff888053800000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f3245abe000 CR3: 000000004c28a006 CR4: 00000000001606f0
 Call Trace:
  stop_sync_thread+0x3a3/0x7c0 [ip_vs]
  ip_vs_sync_net_cleanup+0x13/0x50 [ip_vs]
  ops_exit_list.isra.5+0x94/0x140
  unregister_pernet_operations+0x29d/0x460
  unregister_pernet_device+0x26/0x60
  ip_vs_cleanup+0x11/0x38 [ip_vs]
  __x64_sys_delete_module+0x2d5/0x400
  do_syscall_64+0xa5/0x4e0
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 RIP: 0033:0x7f8ea8bf0db7
 Code: 73 01 c3 48 8b 0d b9 80 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 89 80 2c 00 f7 d8 64 89 01 48
 RSP: 002b:00007ffcd38d2fe8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
 RAX: ffffffffffffffda RBX: 0000000002436240 RCX: 00007f8ea8bf0db7
 RDX: 0000000000000000 RSI: 0000000000000800 RDI: 00000000024362a8
 RBP: 0000000000000000 R08: 00007f8ea8eba060 R09: 00007f8ea8c658a0
 R10: 00007ffcd38d2a60 R11: 0000000000000206 R12: 0000000000000000
 R13: 0000000000000001 R14: 00000000024362a8 R15: 0000000000000000
 irq event stamp: 4538
 hardirqs last  enabled at (4537): [<ffffffffb6193dde>] quarantine_put+0x9e/0x170
 hardirqs last disabled at (4538): [<ffffffffb5a0556a>] trace_hardirqs_off_thunk+0x1a/0x20
 softirqs last  enabled at (4522): [<ffffffffb6f8ebe9>] sk_common_release+0x169/0x2d0
 softirqs last disabled at (4520): [<ffffffffb6f8eb3e>] sk_common_release+0xbe/0x2d0
 ---[ end trace 7b4e216440e510e7 ]---
 IPVS: ipvs unloaded.

so, this is try_module_get() in ip_vs_start_sync_thread() failing to refcount ip_vs.
When the module is unloaded and stop_sync_thread() is called, the refcounts are
unbalanced and then we see the splat when the last module_put() is called.

> 	Are there any steps to reproduce?

yes, a script that does the following:

        while true; do
                if modprobe -r ip_vs; then
                        sleep 0.5
                fi
        done >/dev/null 2>&1 &

        while true; do
                ipvsadm --start-daemon master --mcast-interface veth_syncd
        done >/dev/null 2>&1 &

        while true; do
                ipvsadm --stop-daemon master
        done >/dev/null 2>&1


I'm about to send a v2 patch where I test the return value of each call to
ip_vs_use_count_inc(), and jump to the error path of caller functions
(returning -EAGAIN) on failure of try_module_get(). For
ip_vs_start_sync_thread(), the resulting code is very similar to what I
did in the first post, with the only addition of an additional 'goto
out_unlock;' in case the attempt to refcount the module failed.

thank you in advance for any further feedback!
-- 
davide


