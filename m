Return-Path: <SRS0=D3nJ=YM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA12CA9EAC
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Oct 2019 15:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37D522082C
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Oct 2019 15:35:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="deD77b4v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfJSPe7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Oct 2019 11:34:59 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25769 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725912AbfJSPe7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Oct 2019 11:34:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571499297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=OoPMqKURXI3gJDQqs+D/pjKyg/AFijSy0gzptzetWaU=;
        b=deD77b4vWeinakgBcSCJfD8bY3eFuOIT8Bx8FY0B5TnMT6YZ7Cg1md4MtJeqTWjXDdlWug
        HmsBNKms1GFImHIG4uxn31wpg99wMJJ/VQ6bPC1Ab/6AVV+Mc+wUReDLjG0d1/A263Q0wx
        m9Nw0U5xB2RniYB1TBZCiXkzT5DzqqA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-rHaxag5FPzW3bTWqdlQwxg-1; Sat, 19 Oct 2019 11:34:54 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3723107AD32;
        Sat, 19 Oct 2019 15:34:52 +0000 (UTC)
Received: from new-host.redhat.com (ovpn-204-59.brq.redhat.com [10.40.204.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41F3160BEC;
        Sat, 19 Oct 2019 15:34:49 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     ja@ssi.bg
Cc:     dcaratti@redhat.com, horms@verge.net.au, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        wensong@linux-vs.org
Subject: [PATCH nf v2] ipvs: don't ignore errors in case refcounting ip_vs module fails
Date:   Sat, 19 Oct 2019 17:34:35 +0200
Message-Id: <d89e2de1473417d204fa7474506d92fc640366f3.1571498634.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: rHaxag5FPzW3bTWqdlQwxg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

if the IPVS module is removed while the sync daemon is starting, there is
a small gap where try_module_get() might fail getting the refcount inside
ip_vs_use_count_inc(). Then, the refcounts of IPVS module are unbalanced,
and the subsequent call to stop_sync_thread() causes the following splat:

 WARNING: CPU: 0 PID: 4013 at kernel/module.c:1146 module_put.part.44+0x15b=
/0x290
  Modules linked in: ip_vs(-) nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ve=
th ip6table_filter ip6_tables iptable_filter binfmt_misc intel_rapl_msr int=
el_rapl_common crct10dif_pclmul crc32_pclmul ext4 mbcache jbd2 ghash_clmuln=
i_intel snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_intel_nhlt sn=
d_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm aesni_int=
el crypto_simd cryptd glue_helper joydev pcspkr snd_timer virtio_balloon sn=
d soundcore i2c_piix4 nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables=
 xfs libcrc32c ata_generic pata_acpi virtio_net net_failover virtio_blk fai=
lover virtio_console qxl drm_kms_helper syscopyarea sysfillrect sysimgblt f=
b_sys_fops ata_piix ttm crc32c_intel serio_raw drm virtio_pci libata virtio=
_ring virtio floppy dm_mirror dm_region_hash dm_log dm_mod [last unloaded: =
nf_defrag_ipv6]
  CPU: 0 PID: 4013 Comm: modprobe Tainted: G        W         5.4.0-rc1.ups=
tream+ #741
  Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
  RIP: 0010:module_put.part.44+0x15b/0x290
  Code: 04 25 28 00 00 00 0f 85 18 01 00 00 48 83 c4 68 5b 5d 41 5c 41 5d 4=
1 5e 41 5f c3 89 44 24 28 83 e8 01 89 c5 0f 89 57 ff ff ff <0f> 0b e9 78 ff=
 ff ff 65 8b 1d 67 83 26 4a 89 db be 08 00 00 00 48
  RSP: 0018:ffff888050607c78 EFLAGS: 00010297
  RAX: 0000000000000003 RBX: ffffffffc1420590 RCX: ffffffffb5db0ef9
  RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffffffc1420590
  RBP: 00000000ffffffff R08: fffffbfff82840b3 R09: fffffbfff82840b3
  R10: 0000000000000001 R11: fffffbfff82840b2 R12: 1ffff1100a0c0f90
  R13: ffffffffc1420200 R14: ffff88804f533300 R15: ffff88804f533ca0
  FS:  00007f8ea9720740(0000) GS:ffff888053800000(0000) knlGS:0000000000000=
000
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
  Code: 73 01 c3 48 8b 0d b9 80 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0=
f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 8b 0d 89 80 2c 00 f7 d8 64 89 01 48
  RSP: 002b:00007ffcd38d2fe8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
  RAX: ffffffffffffffda RBX: 0000000002436240 RCX: 00007f8ea8bf0db7
  RDX: 0000000000000000 RSI: 0000000000000800 RDI: 00000000024362a8
  RBP: 0000000000000000 R08: 00007f8ea8eba060 R09: 00007f8ea8c658a0
  R10: 00007ffcd38d2a60 R11: 0000000000000206 R12: 0000000000000000
  R13: 0000000000000001 R14: 00000000024362a8 R15: 0000000000000000
  irq event stamp: 4538
  hardirqs last  enabled at (4537): [<ffffffffb6193dde>] quarantine_put+0x9=
e/0x170
  hardirqs last disabled at (4538): [<ffffffffb5a0556a>] trace_hardirqs_off=
_thunk+0x1a/0x20
  softirqs last  enabled at (4522): [<ffffffffb6f8ebe9>] sk_common_release+=
0x169/0x2d0
  softirqs last disabled at (4520): [<ffffffffb6f8eb3e>] sk_common_release+=
0xbe/0x2d0

Check the return value of ip_vs_use_count_inc() and let its caller return
proper error. Inside do_ip_vs_set_ctl() the module is already refcounted,
we don't need refcount/derefcount there. Finally, in register_ip_vs_app()
and start_sync_thread(), take the module refcount earlier and ensure it's
released in the error path.

Change since v1:
 - better return values in case of failure of ip_vs_use_count_inc(),
   thanks to Julian Anastasov
 - no need to increase/decrease the module refcount in ip_vs_set_ctl(),
   thanks to Julian Anastasov

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/netfilter/ipvs/ip_vs_app.c   | 12 ++++++++++--
 net/netfilter/ipvs/ip_vs_ctl.c   | 14 ++++----------
 net/netfilter/ipvs/ip_vs_pe.c    |  3 ++-
 net/netfilter/ipvs/ip_vs_sched.c |  3 ++-
 net/netfilter/ipvs/ip_vs_sync.c  | 13 ++++++++++---
 5 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.=
c
index 4515056ef1c2..f9b16f2b2219 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -193,21 +193,29 @@ struct ip_vs_app *register_ip_vs_app(struct netns_ipv=
s *ipvs, struct ip_vs_app *
=20
 =09mutex_lock(&__ip_vs_app_mutex);
=20
+=09/* increase the module use count */
+=09if (!ip_vs_use_count_inc()) {
+=09=09err =3D -ENOENT;
+=09=09goto out_unlock;
+=09}
+
 =09list_for_each_entry(a, &ipvs->app_list, a_list) {
 =09=09if (!strcmp(app->name, a->name)) {
 =09=09=09err =3D -EEXIST;
+=09=09=09/* decrease the module use count */
+=09=09=09ip_vs_use_count_dec();
 =09=09=09goto out_unlock;
 =09=09}
 =09}
 =09a =3D kmemdup(app, sizeof(*app), GFP_KERNEL);
 =09if (!a) {
 =09=09err =3D -ENOMEM;
+=09=09/* decrease the module use count */
+=09=09ip_vs_use_count_dec();
 =09=09goto out_unlock;
 =09}
 =09INIT_LIST_HEAD(&a->incs_list);
 =09list_add(&a->a_list, &ipvs->app_list);
-=09/* increase the module use count */
-=09ip_vs_use_count_inc();
=20
 out_unlock:
 =09mutex_unlock(&__ip_vs_app_mutex);
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.=
c
index 8b48e7ce1c2c..c8f81dd15c83 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1275,7 +1275,8 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_=
vs_service_user_kern *u,
 =09struct ip_vs_service *svc =3D NULL;
=20
 =09/* increase the module use count */
-=09ip_vs_use_count_inc();
+=09if (!ip_vs_use_count_inc())
+=09=09return -ENOPROTOOPT;
=20
 =09/* Lookup the scheduler by 'u->sched_name' */
 =09if (strcmp(u->sched_name, "none")) {
@@ -2435,9 +2436,6 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __use=
r *user, unsigned int len)
 =09if (copy_from_user(arg, user, len) !=3D 0)
 =09=09return -EFAULT;
=20
-=09/* increase the module use count */
-=09ip_vs_use_count_inc();
-
 =09/* Handle daemons since they have another lock */
 =09if (cmd =3D=3D IP_VS_SO_SET_STARTDAEMON ||
 =09    cmd =3D=3D IP_VS_SO_SET_STOPDAEMON) {
@@ -2450,13 +2448,13 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __u=
ser *user, unsigned int len)
 =09=09=09ret =3D -EINVAL;
 =09=09=09if (strscpy(cfg.mcast_ifn, dm->mcast_ifn,
 =09=09=09=09    sizeof(cfg.mcast_ifn)) <=3D 0)
-=09=09=09=09goto out_dec;
+=09=09=09=09return ret;
 =09=09=09cfg.syncid =3D dm->syncid;
 =09=09=09ret =3D start_sync_thread(ipvs, &cfg, dm->state);
 =09=09} else {
 =09=09=09ret =3D stop_sync_thread(ipvs, dm->state);
 =09=09}
-=09=09goto out_dec;
+=09=09return ret;
 =09}
=20
 =09mutex_lock(&__ip_vs_mutex);
@@ -2551,10 +2549,6 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __us=
er *user, unsigned int len)
=20
   out_unlock:
 =09mutex_unlock(&__ip_vs_mutex);
-  out_dec:
-=09/* decrease the module use count */
-=09ip_vs_use_count_dec();
-
 =09return ret;
 }
=20
diff --git a/net/netfilter/ipvs/ip_vs_pe.c b/net/netfilter/ipvs/ip_vs_pe.c
index 8e104dff7abc..166c669f0763 100644
--- a/net/netfilter/ipvs/ip_vs_pe.c
+++ b/net/netfilter/ipvs/ip_vs_pe.c
@@ -68,7 +68,8 @@ int register_ip_vs_pe(struct ip_vs_pe *pe)
 =09struct ip_vs_pe *tmp;
=20
 =09/* increase the module use count */
-=09ip_vs_use_count_inc();
+=09if (!ip_vs_use_count_inc())
+=09=09return -ENOENT;
=20
 =09mutex_lock(&ip_vs_pe_mutex);
 =09/* Make sure that the pe with this name doesn't exist
diff --git a/net/netfilter/ipvs/ip_vs_sched.c b/net/netfilter/ipvs/ip_vs_sc=
hed.c
index 2f9d5cd5daee..d4903723be7e 100644
--- a/net/netfilter/ipvs/ip_vs_sched.c
+++ b/net/netfilter/ipvs/ip_vs_sched.c
@@ -179,7 +179,8 @@ int register_ip_vs_scheduler(struct ip_vs_scheduler *sc=
heduler)
 =09}
=20
 =09/* increase the module use count */
-=09ip_vs_use_count_inc();
+=09if (!ip_vs_use_count_inc())
+=09=09return -ENOENT;
=20
 =09mutex_lock(&ip_vs_sched_mutex);
=20
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_syn=
c.c
index a4a78c4b06de..8dc892a9dc91 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1762,6 +1762,10 @@ int start_sync_thread(struct netns_ipvs *ipvs, struc=
t ipvs_sync_daemon_cfg *c,
 =09IP_VS_DBG(7, "Each ip_vs_sync_conn entry needs %zd bytes\n",
 =09=09  sizeof(struct ip_vs_sync_conn_v0));
=20
+=09/* increase the module use count */
+=09if (!ip_vs_use_count_inc())
+=09=09return -ENOPROTOOPT;
+
 =09/* Do not hold one mutex and then to block on another */
 =09for (;;) {
 =09=09rtnl_lock();
@@ -1892,9 +1896,6 @@ int start_sync_thread(struct netns_ipvs *ipvs, struct=
 ipvs_sync_daemon_cfg *c,
 =09mutex_unlock(&ipvs->sync_mutex);
 =09rtnl_unlock();
=20
-=09/* increase the module use count */
-=09ip_vs_use_count_inc();
-
 =09return 0;
=20
 out:
@@ -1924,11 +1925,17 @@ int start_sync_thread(struct netns_ipvs *ipvs, stru=
ct ipvs_sync_daemon_cfg *c,
 =09=09}
 =09=09kfree(ti);
 =09}
+
+=09/* decrease the module use count */
+=09ip_vs_use_count_dec();
 =09return result;
=20
 out_early:
 =09mutex_unlock(&ipvs->sync_mutex);
 =09rtnl_unlock();
+
+=09/* decrease the module use count */
+=09ip_vs_use_count_dec();
 =09return result;
 }
=20
--=20
2.21.0

