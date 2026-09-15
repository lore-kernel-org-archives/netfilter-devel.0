Received: from mail-oa2-f9.google.com (mail-oa2-f9.google.com [74.125.231.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA033DDB09
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Sep 2026 15:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789485029; cv=none; b=AsMOSn/chfa4C8H9vQqI8rHv20Ay50JJq9p4/JKM535+Ljp4C18+sIGuEewVbWKLXcJKZeRYGqP78iwjDeoowlZDOPo7XTDNCBvbd5B6U8ItQZizug0filyDZMxCs6MQlferyrCb9FOkt1n6KibCdXWfuCakLd9F6a7FWlaBF/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789485029; c=relaxed/simple;
	bh=0aTTYo9AKNOwLZZPnxtNfMcg3pXYDD2KHdOQfimOf+M=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=knwIp2LVHYtPbDOwYgcPIJqUgJAWIdNjZ4HO/1zf9d0THAOmO2/loWqsDvEteGpBPm4aMJ3OzaBXGMcbLvGiiG9ENxTaTyW3QtQILIuvx+6eV4ISMDVPZXrMAb4ysSNDF9G13K0DcnBHahbIw99cxa5bi6xW6oQAqBGQWXwv0ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa2-f9.google.com with SMTP id 586e51a60fabf-4840f0c24bbso59340fac.1
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Sep 2026 08:10:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789485025; x=1790089825;
        h=content-transfer-encoding:content-type:to:from:subject:message-id
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=05eRWcQkmVyuTeeo7bWsa4qmhk3vLgVesCvvW4mcNyc=;
        b=rpNUbkwGaBIg72mKM9Q7qAWnXmw5PGXyS2yoDbFtpV46Axhb14LxiL+wuQowlEcG0a
         GyQyQ7tuHVVK7p4GicJpgZ7GbMWG664b2PbQ2vXZOg89NBQc6h1JaXsVsAuLAJ9BhWTX
         LcuGq5KuQd20JkPRTj9uQTRJaZgsB2lZpPrVwOCUaV/RuTvurtG2lqIyjSQD1JoVEdUW
         1OapweKK9t/XWl+I5FS1G32x6BAxoUJRNyyH8VWP+QgtCU/k6dvyEi9viqLXBidQRgeL
         ajN2lRHwuzEhNWARrI5ADakqByO0kUVWM8G+WvvOHQO/ZSMD3bX9TIbESF3/g3u2tWPQ
         039A==
X-Forwarded-Encrypted: i=1; AKwUvBw/MbDTUe+4544e1gNbbuyaGrUBSHX/cd8eCGOxxw9EqUo/hXHoTuVJ3INaWrbDcvcHm6ws+MYbpGF8nXqaL1o=@vger.kernel.org
X-Gm-Message-State: AFuF++mJB9GoWtHdiJ0tEjYVrFJvtzP/W92CxiWQR/YkG4aj5jNDWFTQ
	rLQyZcNRuBS64Tx5m8xDkKkbcdJqJOpjhGLUfXwE2QseT/NcbBbVb3+zcl+0GKArQzTmNfalpJe
	oF0Z5euumXODo1HxWYmf1DkGlgRVaHqbd1uu2n/R6V11U+ahnBFzPIK+X1QM=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:625:b0:6be:354a:1ced with SMTP id
 006d021491bc7-6c54292a60emr5300757eaf.64.1789485025298; Tue, 15 Sep 2026
 08:10:25 -0700 (PDT)
Date: Tue, 15 Sep 2026 08:10:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa95fe1.a211d2ce.1a5198.02af.GAE@google.com>
Subject: [syzbot] [netfilter?] BUG: workqueue lockup in batadv_tt_purge
From: syzbot <syzbot+61b202fdc410840f0198@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, fw@strlen.de, 
	herbert@gondor.apana.org.au, horms@kernel.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    5445d6419962 arm64: Don't read GMID_EL1 when MTE is disable=
d
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.g=
it for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=3D1514428e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D56ed23170c168d4=
c
dashboard link: https://syzkaller.appspot.com/bug?extid=3D61b202fdc410840f0=
198
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-=
1~exp1~20260613092250.77), Debian LLD 22.1.8
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e8b70e3bd109/disk-=
5445d641.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e5227e56ac93/vmlinux-=
5445d641.xz
kernel image: https://storage.googleapis.com/syzbot-assets/54905f78be59/Ima=
ge-5445d641.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+61b202fdc410840f0198@syzkaller.appspotmail.com

BUG: workqueue lockup - pool cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 stuck f=
or 37s!
Showing busy workqueues and worker pools:
workqueue events: flags=3D0x100
  pwq 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 active=3D8 refcnt=3D9
    in-flight: 6264:reg_todo for 27s
    pending: 6*nsim_dev_hwstats_traffic_work, psi_avgs_work
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D11 refcnt=3D12
    pending: 4*nsim_dev_hwstats_traffic_work, 2*psi_avgs_work, 2*ovs_dp_mas=
ks_rebalance, free_obj_work, 2*psi_avgs_work
workqueue events_unbound: flags=3D0x2
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D20 refcnt=3D21
    in-flight: 56:cfg80211_wiphy_work for 64s cfg80211_wiphy_work ,4950:cfg=
80211_wiphy_work for 68s cfg80211_wiphy_work ,7165:nsim_dev_trap_report_wor=
k for 9s ,12:cfg80211_wiphy_work for 69s cfg80211_wiphy_work ,1457:cfg80211=
_wiphy_work for 63s cfg80211_wiphy_work
    pending: nsim_dev_trap_report_work, toggle_allocation_gate, 5*nsim_dev_=
trap_report_work, flush_memcg_stats_dwork, 3*nsim_dev_trap_report_work
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D8 refcnt=3D9
    in-flight: 52:cfg80211_wiphy_work for 67s cfg80211_wiphy_work ,13:cfg80=
211_wiphy_work for 67s cfg80211_wiphy_work ,40:cfg80211_wiphy_work for 62s =
cfg80211_wiphy_work ,264:cfg80211_wiphy_work for 34s cfg80211_wiphy_work
workqueue events_power_efficient: flags=3D0x82
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D8 refcnt=3D9
    in-flight: 1188:neigh_periodic_work for 41s ,7164:gc_worker for 2s
    pending: crda_timeout_work, neigh_periodic_work, wg_ratelimiter_gc_entr=
ies, reg_check_chans_work, 2*neigh_managed_work
workqueue events_dfl_long: flags=3D0x2
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D6 refcnt=3D7
    pending: 6*defense_work_handler
workqueue mm_percpu_wq: flags=3D0x108
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D1 refcnt=3D2
    pending: vmstat_update
workqueue bat_events: flags=3D0x6000a
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D1 refcnt=3D45 MAYDAY
    in-flight: 2852(RESCUER):batadv_tt_purge for 11s
    pending: mayday_cursor_func
    inactive: 2*batadv_tt_purge, batadv_dat_purge, 2*batadv_bla_periodic_wo=
rk, batadv_dat_purge, batadv_bla_periodic_work, batadv_dat_purge, batadv_bl=
a_periodic_work, batadv_dat_purge, 4*batadv_mcast_mla_update, 2*batadv_iv_s=
end_outstanding_bat_ogm_packet, 2*batadv_purge_orig, 6*batadv_iv_send_outst=
anding_bat_ogm_packet, 2*batadv_purge_orig, batadv_dat_purge, batadv_bla_pe=
riodic_work, 4*batadv_iv_send_outstanding_bat_ogm_packet, batadv_purge_orig=
, batadv_tt_purge, batadv_mcast_mla_update, 3*batadv_iv_send_outstanding_ba=
t_ogm_packet, batadv_tt_purge
workqueue wg-kex-wg0: flags=3D0x6
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_send_worker
workqueue wg-crypt-wg0: flags=3D0x128
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker
workqueue wg-kex-wg1: flags=3D0x6
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_send_worker
workqueue wg-crypt-wg1: flags=3D0x128
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker, wg_packet_decry=
pt_worker
workqueue wg-kex-wg2: flags=3D0x6
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_send_worker
workqueue wg-crypt-wg2: flags=3D0x128
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_encrypt_worker, wg_packet_decrypt_worker, wg_packet_=
tx_worker
workqueue wg-crypt-wg0: flags=3D0x128
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker
workqueue wg-kex-wg1: flags=3D0x6
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_send_worker
workqueue wg-crypt-wg1: flags=3D0x128
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker, wg_packet_decry=
pt_worker
workqueue wg-crypt-wg2: flags=3D0x128
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_encrypt_worker, wg_packet_decrypt_worker, wg_packet_=
tx_worker
workqueue wg-kex-wg0: flags=3D0x6
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_send_worker
workqueue wg-crypt-wg0: flags=3D0x128
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker
workqueue wg-crypt-wg1: flags=3D0x128
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D3 refcnt=3D4
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker, wg_packet_decry=
pt_worker
workqueue wg-kex-wg2: flags=3D0x6
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_send_worker
workqueue wg-crypt-wg2: flags=3D0x128
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker
workqueue wg-kex-wg0: flags=3D0x6
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_send_worker
workqueue wg-crypt-wg0: flags=3D0x128
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker
workqueue wg-kex-wg1: flags=3D0x6
  pwq 8: cpus=3D0-1 flags=3D0x6 nice=3D0 active=3D1 refcnt=3D2
    pending: wg_packet_handshake_send_worker
workqueue wg-crypt-wg1: flags=3D0x128
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker
workqueue wg-crypt-wg2: flags=3D0x128
  pwq 6: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D2 refcnt=3D3
    pending: wg_packet_encrypt_worker, wg_packet_tx_worker
pool 2: cpus=3D0 node=3D0 flags=3D0x0 nice=3D0 hung=3D0s workers=3D10 idle:=
 4833 9 4790 6306 5581 4834 6772 10 1009
pool 8: cpus=3D0-1 flags=3D0x6 nice=3D0 hung=3D2s workers=3D12 manager: 716=
6
Showing backtraces of busy workers in stalled worker pools:
pool 6: no worker in running state, cpu=3D1 is busy (nr_workers=3D11 nr_idl=
e=3D11)
The pool might have trouble waking an idle worker.
Backtrace of last woken worker:
task:kworker/1:1     state:R  running task     stack:0     pid:26    tgid:2=
6    ppid:2      task_flags:0x4208060 flags:0x00000010
Workqueue:  0x0 (wg-crypt-wg0)
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:775 (T)
 context_switch kernel/sched/core.c:5520 [inline]
 __schedule+0x1370/0x2d80 kernel/sched/core.c:7270
 __schedule_loop kernel/sched/core.c:7347 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7362
 worker_thread+0x924/0xbd0 kernel/workqueue.c:3566
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:838
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 2852 Comm: kworker/R-bat_e Not tainted syzkaller #0 PREE=
MPT=20
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 08/14/2026
Workqueue: bat_events batadv_tt_purge
pstate: 03400005 (nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=3D--)
pc : in_softirq_really kernel/kcov.c:167 [inline]
pc : check_kcov_mode+0x18/0x54 kernel/kcov.c:179
lr : write_comp_data+0x38/0x84 kernel/kcov.c:242
sp : ffff80008ec46dd0
x29: ffff80008ec46dd0 x28: dfff800000000000 x27: 000000000000224e
x26: dfff800000000000 x25: ffff700011d88dc8 x24: 1ffff00011d88dfa
x23: ffff0000c8e9d880 x22: 0000000000000007 x21: 0000000000000002
x20: ffff000023a0f400 x19: ffff800085709eb4 x18: 0000000011264820
x17: 0000000001320140 x16: 0140000800000000 x15: 0000000000000000
x14: 00000000850ade10 x13: 0000000000000007 x12: 0000000000000000
x11: 0000000000000000 x10: 000000000000000f x9 : 0000000000000101
x8 : ffff0000c8e9d880 x7 : 0000000000000000 x6 : 000000000000003f
x5 : 0000000000000040 x4 : 0000000000000000 x3 : ffff800085709eb4
x2 : ffff000023a0f400 x1 : ffff0000c8e9d880 x0 : 0000000000000003
Call trace:
 preempt_count arch/arm64/include/asm/preempt.h:12 [inline] (P)
 in_softirq_really kernel/kcov.c:167 [inline] (P)
 check_kcov_mode+0x18/0x54 kernel/kcov.c:179 (P)
 __sanitizer_cov_trace_const_cmp8+0x24/0x30 kernel/kcov.c:317
 __xfrm_decode_session+0x484/0x8a8 net/xfrm/xfrm_policy.c:3524
 xfrm_decode_session include/net/xfrm.h:1357 [inline]
 ip_route_me_harder+0x7c4/0xd80 net/ipv4/netfilter.c:67
 synproxy_send_tcp+0x2d4/0x5a4 net/netfilter/nf_synproxy_core.c:434
 synproxy_send_client_synack+0x3b0/0x640 net/netfilter/nf_synproxy_core.c:4=
87
 nft_synproxy_eval_v4+0x16c/0x278 net/netfilter/nft_synproxy.c:59
 nft_synproxy_do_eval+0x2d8/0x4a4 net/netfilter/nft_synproxy.c:141
 nft_synproxy_eval+0x34/0x48 net/netfilter/nft_synproxy.c:247
 expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
 nft_do_chain+0x418/0x13c8 net/netfilter/nf_tables_core.c:285
 nft_do_chain_inet+0x284/0x3d4 net/netfilter/nft_chain_filter.c:162
 nf_hook_entry_hookfn include/linux/netfilter.h:165 [inline]
 nf_hook_slow+0xc8/0x224 net/netfilter/core.c:619
 nf_hook include/linux/netfilter.h:280 [inline]
 NF_HOOK+0x1f0/0x398 include/linux/netfilter.h:323
 ip_local_deliver+0x128/0x188 net/ipv4/ip_input.c:262
 dst_input include/net/dst.h:480 [inline]
 ip_rcv_finish+0x20c/0x230 net/ipv4/ip_input.c:492
 NF_HOOK+0x308/0x398 include/linux/netfilter.h:325
 ip_rcv+0x7c/0x9c net/ipv4/ip_input.c:612
 __netif_receive_skb_one_core+0xc8/0x110 net/core/dev.c:6264
 __netif_receive_skb+0x34/0x128 net/core/dev.c:6377
 process_backlog+0x5f4/0x16f8 net/core/dev.c:6728
 __napi_poll+0xb4/0x328 net/core/dev.c:7787
 napi_poll net/core/dev.c:7850 [inline]
 net_rx_action+0x5b0/0xc14 net/core/dev.c:8007
 handle_softirqs+0x2ec/0xd98 kernel/softirq.c:645
 __do_softirq+0x14/0x20 kernel/softirq.c:679
 ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:78
 call_on_irq_stack+0x30/0x48 arch/arm64/kernel/entry.S:885
 do_softirq_own_stack+0x20/0x2c arch/arm64/kernel/irq.c:83
 do_softirq+0x90/0xf8 kernel/softirq.c:546
 __local_bh_enable_ip+0x240/0x35c kernel/softirq.c:473
 __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:237 [inline]
 _raw_spin_unlock_bh+0x3c/0x4c kernel/locking/spinlock.c:245
 spin_unlock_bh include/linux/spinlock.h:407 [inline]
 batadv_tt_global_purge net/batman-adv/translation-table.c:2390 [inline]
 batadv_tt_purge+0x3e4/0x7b4 net/batman-adv/translation-table.c:3754
 process_one_work kernel/workqueue.c:3387 [inline]
 process_scheduled_works+0x91c/0x1250 kernel/workqueue.c:3470
 rescuer_thread+0x68c/0xd90 kernel/workqueue.c:3694
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:838


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
