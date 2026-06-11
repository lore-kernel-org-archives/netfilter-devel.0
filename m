Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E88A2D1916
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jun 2026 15:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781191505; cv=none; b=Q09qDzYCRdykR3MjZqHesDUPMtQY9jSl9N/EdUqoDtNN9CHbM5sY+UvUjlci0zr0cbw/PSfCUJ8wTHnyvxwLncFlNEAnCNSTO/aI0JJPVrngsgLh8dyrsRbsomZ7iv+701zrCmr+8b2P5VsvNbCZBX1dYjF9jguuvIqHksE5Fw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781191505; c=relaxed/simple;
	bh=gvXzqy2NA1tHVCSzLIb4TUeN51Im/CiBk4h6cxh5g10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ke+fTOysSIgr0fYc7jLEqvCOT29BA0TfR8vIdgDIAbt83SRUOfTonIxJno6l3hukvXumtlAmXxJZvpJQ2C50DFfEqkP5Yk/PmN8qKXC2D0u4XfYDBiBh4TboNbW+aT2mwL4Ebg8BntV8HAJ4ron/+28IbGbOeFZKgR5VHNGc25o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=WM9NmDDo; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="WM9NmDDo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1781191491; bh=jFJ5EPaSEySdFno2T/3VQDq7AByWi1UG8/s1dRtQfU4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WM9NmDDoFjDcYH6ALhesF5Dk6tTAb/7mwlMGwP8xtReLiT8Sy4yEcsK37MBIuPVYY
	 +F7CVQt+pKsmFWHUP9Is1KdOY4iuny7guQAjwCwjof5/rBJEWXzmfmoz9/diCA6VtU
	 SCm/U51RT2tCm15lq1aF8FrxKkoYxcCc91rlywFA=
Received: from [198.18.0.1] ([115.156.144.140])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 6313DE88; Thu, 11 Jun 2026 23:24:49 +0800
X-QQ-mid: xmsmtpt1781191489teykkmyfq
Message-ID: <tencent_C9F91B790E910F8EACB10405AF2C9B173205@qq.com>
X-QQ-XMAILINFO: MRMtjO3A6C9XY3wnlhEXAk6K+CHn2i5pddbfeFUNfX32W504njFh+t7cZWcdga
	 ywB7PD4mW2BjM9Nf/UN9zKTBR2EauRNeAOuRxBwL7ZHjaj0/yICfL/tD53iWzARF2AxR1vAR2Id7
	 80/XPqrzMdCihiqlEt/Dc18mAo7Fm+ZSAKjaCDt/MKGo5JQ2IlR/tngxevA9QK4Hp/pvExZTLGoE
	 zNoByx2NGl5Nv1b8BP8pSNIkAKuQYAssvdtrPIPrU004zg6vZtzfXvuDXDX/S/FLPObsgcZUPAaE
	 gYTnidjwywTzjvnxnp2vPj2/qC3qC5K1KziYdnfZih9/3F5haGsRiI0OqRi9pa0bQJiVW3nbg/o/
	 Xqzp4eYWiB27ExKqF4VmCIsp4syz/RdkrxafiIaMSMhe5aWyjpsHki8NeuNleX+KQqS1tYkaMkev
	 EzqxIkS/npx2NpIeHIx60G4fZUMKPasvt2Khx+Gd9dH4iGaypkzEooIZAWzmKzPMIMvO9h+nF8Yu
	 JUqFyZnAgakSb2jRC9miNssnWnhyXkpEAW2jJG8zryChmlsys/ZH7vdoW9iMz/RH71MlPnp2JIso
	 MK3pId3c+PiRp0tJfS09ij+Rgwpqk+6W9Luxtz0wZt/Dy00PH8veLOrosZCk+1dG1V/G3yY9LwV5
	 h8UY6H6B8jn+8SSw3O89FxSW76PWb0oFLfPWuRaD9YtaqgfmxvD4+w4XXIeY/7+z4Aryd2A6+16v
	 MuYhxO9O14RKp6WXMiC+iEfTaWyDn0DrFAa5aMlDGl04dRqrnksZqtaplVronwz7itC7Mr4owqT/
	 yiRTZN04AqY8dO0/sLfnlr5tInAaR/jsuVremdWsGTpSKhIj/0ZaxcZtRpFD/L/tPgtICtZrGN7H
	 mhlGo6E39gYYdrVRmZ0e1OHHwaC//Y7jittfy4ANP9liIhu0qJ6aWS2QIQXLufFWH0qUdSZnL/Tx
	 6IjQUHaYWidOjemi8/fGhBez24Vovqtd8prWnju0M7AvY0eDgVlh7mFDFooUkSG8NNX7hliCf2ew
	 Mh0i2SNdyRYXNaJoVKregYF5kkYhebfbVm/XYdvCVuJERy0n3ACgYiIOrPOO7CpHxgJ/TLCb0IrX
	 Xp8Ixl
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-OQ-MSGID: <998cac6f-25c4-433e-b258-d3db107a90d7@qq.com>
Date: Thu, 11 Jun 2026 23:24:49 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/9] netfilter: ipset: exlude gc when resize is in
 progress
To: Jozsef Kadlecsik <kadlec@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
References: <20260609072750.318774-1-kadlec@netfilter.org>
 <20260609072750.318774-6-kadlec@netfilter.org>
From: XIAO WU <xiaowu.417@qq.com>
In-Reply-To: <20260609072750.318774-6-kadlec@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Jozsef,

While reviewing this patch on Sashiko [1], I found it introduces a
"scheduling while atomic" bug in mtype_resize().  Sashiko's automated
review flagged the issue, and I was able to confirm it with a PoC that
reliably triggers the kernel splat.

[1] 
https://sashiko.dev/#/patchset/20260609072750.318774-1-kadlec%40netfilter.org

 > diff --git a/net/netfilter/ipset/ip_set_hash_gen.h 
b/net/netfilter/ipset/ip_set_hash_gen.h
 > index 20678116a..a41f6cdee 100644
 > --- a/net/netfilter/ipset/ip_set_hash_gen.h
 > +++ b/net/netfilter/ipset/ip_set_hash_gen.h
 > @@ -84,6 +84,7 @@ struct htable {
 >      atomic_t uref;        /* References for dumping and gc */
 >      u8 htable_bits;        /* size of hash table == 2^htable_bits */
 >      u32 maxelem;        /* Maxelem per region */
 > +    spinlock_t gc_lock;    /* Lock to exclude gc and resize */
 >      struct ip_set_region *hregion;    /* Region locks and ext sizes */
 >      struct hbucket __rcu *bucket[]; /* hashtable buckets */
 >  };

The new gc_lock is added to struct htable but correctly initialized in
_create() via spin_lock_init(), so this part is fine.

 > @@ -581,7 +582,9 @@ mtype_gc(struct work_struct *work)
 >      if (next_run < HZ/10)
 >          next_run = HZ/10;
 >
 > +    spin_lock_bh(&t->gc_lock);
 >      mtype_gc_do(set, h, t, r);
 > +    spin_unlock_bh(&t->gc_lock);
 >
 >      if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
 >          pr_debug("Table destroy after resize by expire: %p\n", t);

mtype_gc() is fine — it does not allocate memory under the lock.

 > @@ -646,6 +649,7 @@ mtype_resize(struct ip_set *set, bool retried)
 >  #endif
 >      orig = ipset_dereference_bh_nfnl(h->table);
 >      htable_bits = orig->htable_bits;
 > +    spin_lock_bh(&orig->gc_lock);
 >
 >  retry:
 >      ret = 0;

The problem is here.  spin_lock_bh() disables preemption and bottom
halves, putting us in atomic context.  Shortly after this, the function
calls:

     t = ip_set_alloc(hsize);

which eventually does kvzalloc(size, GFP_KERNEL_ACCOUNT). GFP_KERNEL
allocations are sleepable — they can trigger direct reclaim or wait for
memory to become available.  Calling a sleepable function while holding a
spinlock triggers:

   BUG: sleeping function called from invalid context

This is reliably reproducible with the PoC below.  spin_lock_bh() and
GFP_KERNEL allocations are fundamentally incompatible.

 > @@ -759,6 +763,8 @@ mtype_resize(struct ip_set *set, bool retried)
 >      /* There can't be any other writer. */
 >      rcu_assign_pointer(h->table, t);
 >
 > +    spin_unlock_bh(&orig->gc_lock);
 > +
 >      /* Give time to other readers of the set */
 >      synchronize_rcu();
 >
 > @@ -797,6 +803,7 @@ mtype_resize(struct ip_set *set, bool retried)
 >      mtype_ahash_destroy(set, t, false);
 >      if (ret == -EAGAIN)
 >          goto retry;
 > +    spin_unlock_bh(&orig->gc_lock);
 >      goto out;
 >
 >  hbwarn:

Note that the hbwarn error path bypasses the newly added
spin_unlock_bh(), leaving the lock held on return.  That's a separate
issue, but worth fixing too.

 > @@ -1617,6 +1624,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, 
struct ip_set *set,
 >      }
 >      t->htable_bits = hbits;
 >      t->maxelem = h->maxelem / ahash_numof_locks(hbits);
 > +    spin_lock_init(&t->gc_lock);
 >      RCU_INIT_POINTER(h->table, t);
 >
 >      INIT_LIST_HEAD(&h->ad);

## Reproducer

The PoC below creates a hash:ip set with a small hashsize, then adds
enough IPs to overflow buckets and force a resize, hitting the
sleep-in-atomic path.  Generated and verified via Sashiko's kernel
testing framework.

Build:  gcc -static -o poc poc.c
Run:    ./poc   (as root or with CAP_NET_ADMIN)
Check:  dmesg | grep "sleeping function called from invalid context"

/* PoC: trigger scheduling while atomic in mtype_resize()
  *
  * Commit be2a510ec367 ("netfilter: ipset: exlude gc when resize is in
  * progress") adds spin_lock_bh(&orig->gc_lock) in mtype_resize(), then
  * calls ip_set_alloc() which uses kvzalloc(GFP_KERNEL).  Since
  * spin_lock_bh disables preemption, the sleepable GFP_KERNEL allocation
  * triggers "BUG: sleeping function called from invalid context".
  *
  * Build: gcc -static -o poc poc.c
  * Run:   ./poc   (as root or with CAP_NET_ADMIN)
  */
#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <linux/netlink.h>
#include <linux/netfilter/nfnetlink.h>
#include <linux/netfilter/ipset/ip_set.h>

#define A4(x) (((x) + 3) & ~3)

int main(void)
{
     struct sockaddr_nl sa = { .nl_family = AF_NETLINK };
     int fd = socket(AF_NETLINK, SOCK_RAW | SOCK_CLOEXEC, 
NETLINK_NETFILTER);

     if (fd < 0) { perror("socket"); return 1; }
     bind(fd, (struct sockaddr *)&sa, sizeof(sa));

     char msg[4096];
     unsigned char *b = (unsigned char *)msg;
     char rsp[8192];
     int o, ds, ips, r, i;

     /* ---- IPSET_CMD_CREATE: hash:ip set 'h' ---- */
     memset(msg, 0, sizeof(msg));
     b[0] = 2; b[1] = 0; b[2] = 0; b[3] = 0; o = 4;

     o = A4(o);
     b[o] = 5; b[o + 1] = 0; b[o + 2] = 1; b[o + 3] = 0; b[o + 4] = 7; o 
+= 5;

     o = A4(o);
     b[o] = 6; b[o + 1] = 0; b[o + 2] = 2; b[o + 3] = 0;
     b[o + 4] = 'h'; b[o + 5] = 0; o += 6;

     o = A4(o);
     b[o] = 12; b[o + 1] = 0; b[o + 2] = 3; b[o + 3] = 0;
     memcpy(b + o + 4, "hash:ip", 8); o += 12;

     o = A4(o);
     b[o] = 5; b[o + 1] = 0; b[o + 2] = 4; b[o + 3] = 0; b[o + 4] = 0; o 
+= 5;

     o = A4(o);
     b[o] = 5; b[o + 1] = 0; b[o + 2] = 5; b[o + 3] = 0;
     b[o + 4] = 2; o += 5;

     o = A4(o); ds = o; o += 4;

     /* hashsize = 8 (small, so buckets overflow quickly -> resize) */
     o = A4(o); {
         __be32 v = htonl(8);
         b[o] = 8; b[o + 1] = 0; b[o + 2] = 18; b[o + 3] = 0;
         memcpy(b + o + 4, &v, 4); o += 8;
     }
     /* maxelem = 1000000 */
     o = A4(o); {
         __be32 v = htonl(1000000);
         b[o] = 8; b[o + 1] = 0; b[o + 2] = 19; b[o + 3] = 0;
         memcpy(b + o + 4, &v, 4); o += 8;
     }

     o = A4(o); b[ds] = o - ds; b[ds + 1] = 0;
     b[ds + 2] = 7 | 0x80; b[ds + 3] = 0;

     struct nlmsghdr nlh = {0};
     int al = A4(o);

     nlh.nlmsg_len   = A4((int)sizeof(nlh)) + al;
     nlh.nlmsg_type  = (NFNL_SUBSYS_IPSET << 8) | IPSET_CMD_CREATE;
     nlh.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK | NLM_F_CREATE;
     nlh.nlmsg_seq   = 1;

     struct iovec iov[2];
     struct msghdr mh = {0};
     iov[0].iov_base = &nlh;
     iov[0].iov_len  = A4((int)sizeof(nlh));
     iov[1].iov_base = msg;
     iov[1].iov_len  = al;
     mh.msg_name     = &sa;
     mh.msg_namelen  = sizeof(sa);
     mh.msg_iov      = iov;
     mh.msg_iovlen   = 2;

     sendmsg(fd, &mh, 0);
     r = recv(fd, rsp, sizeof(rsp), 0);
     if (r > 0) {
         struct nlmsghdr *hdr = (struct nlmsghdr *)rsp;
         if (hdr->nlmsg_type == NLMSG_ERROR) {
             struct nlmsgerr *e = (struct nlmsgerr *)NLMSG_DATA(hdr);
             if (e->error) {
                 printf("ERR %d\n", e->error);
                 close(fd);
                 return 1;
             }
         }
     }
     printf("[*] Hash:ip set 'h' created (hashsize=8).\n");

     /* ---- Add 25000 IPs to trigger bucket overflow -> resize ---- */
     printf("[*] Adding 25000 IPs to trigger resize...\n");
     for (i = 0; i < 25000; i++) {
         /* Cycle through 10000 unique IPs: 11.0.0.1 .. 11.0.39.16 */
         __be32 ip = htonl(0x0b000000 + (i % 10000) + 1);

         memset(msg, 0, sizeof(msg));
         b[0] = 2; b[1] = 0; b[2] = 0; b[3] = 0; o = 4;

         o = A4(o);
         b[o] = 5; b[o + 1] = 0; b[o + 2] = 1; b[o + 3] = 0;
         b[o + 4] = 7; o += 5;

         o = A4(o);
         b[o] = 6; b[o + 1] = 0; b[o + 2] = 2; b[o + 3] = 0;
         b[o + 4] = 'h'; b[o + 5] = 0; o += 6;

         o = A4(o); ds = o;
         b[ds + 2] = 7; b[ds + 3] = 0x80; o += 4;

         o = A4(o); ips = o;
         b[ips + 2] = 1; b[ips + 3] = 0x80; o += 4;

         o = A4(o);
         b[o] = 8; b[o + 1] = 0; b[o + 2] = 1; b[o + 3] = 0x40;
         memcpy(b + o + 4, &ip, 4); o += 8;

         o = A4(o);
         b[ips] = o - ips; b[ips + 1] = 0;
         b[ds]  = o - ds;  b[ds + 1]  = 0;

         int a2 = A4(o);
         nlh.nlmsg_len   = A4((int)sizeof(nlh)) + a2;
         nlh.nlmsg_type  = (NFNL_SUBSYS_IPSET << 8) | IPSET_CMD_ADD;
         nlh.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
         nlh.nlmsg_seq   = i + 2;
         iov[1].iov_len  = a2;

         sendmsg(fd, &mh, 0);
         r = recv(fd, rsp, sizeof(rsp), 0);
         if (r > 0) {
             struct nlmsghdr *hdr = (struct nlmsghdr *)rsp;
             if (hdr->nlmsg_type == NLMSG_ERROR) {
                 struct nlmsgerr *e = (struct nlmsgerr *)NLMSG_DATA(hdr);
                 if (e->error) {
                     printf("[!] %d err %d\n", i, e->error);
                     if (e->error == -EAGAIN)
                         printf("*** EAGAIN - check dmesg ***\n");
                     break;
                 }
             }
         }
         if (i % 2000 == 1999)
             printf("  %d/25000\n", i + 1);
     }

     printf("[*] Done. Check dmesg.\n");
     close(fd);
     return 0;
}

## Kernel Splat

Running the PoC on 7.1.0-rc5 with this patch applied:

[ 4605.426526][T10324] BUG: sleeping function called from invalid 
context at include/linux/sched/mm.h:323
[ 4605.429032][T10324] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, 
pid: 10324, name: poc
[ 4605.430595][T10324] preempt_count: 201, expected: 0
[ 4605.432432][T10324] 2 locks held by poc/10324:
[ 4605.433263][T10324]  #0: ffffffff9bc4e600 
(nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0x8ba/0x11f0
[ 4605.435525][T10324]  #1: ffff888115560028 (&t->gc_lock){+...}-{3:3}, 
at: hash_ip4_resize+0x1a4/0x1c60
[ 4605.438773][T10324] CPU: 1 UID: 0 PID: 10324 Comm: poc Not tainted 
7.1.0-rc5-gd81b843c2589 #1 PREEMPT(full)
[ 4605.438802][T10324] Call Trace:
[ 4605.438808][T10324]  <TASK>
[ 4605.438814][T10324]  dump_stack_lvl+0x16c/0x1f0
[ 4605.439190][T10324]  __might_resched+0x3c5/0x5e0
[ 4605.439606][T10324]  __kvmalloc_node_noprof+0x63f/0x920
[ 4605.439653][T10324]  hash_ip4_resize+0x103a/0x1c60
[ 4605.439771][T10324]  call_ad.constprop.0+0x372/0x950
[ 4605.439917][T10324]  ip_set_ad.constprop.0.isra.0+0x3d3/0x880
[ 4605.440032][T10324]  nfnetlink_rcv_msg+0x9e2/0x11f0
[ 4605.440164][T10324]  netlink_rcv_skb+0x15d/0x430
[ 4605.440261][T10324]  nfnetlink_rcv+0x1b8/0x430
[ 4605.440325][T10324]  netlink_unicast+0x592/0x860
[ 4605.440385][T10324]  netlink_sendmsg+0x8cd/0xdd0
[ 4605.440449][T10324]  ____sys_sendmsg+0x9ec/0xb80
[ 4605.440595][T10324]  ___sys_sendmsg+0x139/0x1e0
[ 4605.440682][T10324]  __sys_sendmsg+0x172/0x220
[ 4605.440753][T10324]  do_syscall_64+0x129/0x850
[ 4605.440770][T10324]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[ 4605.440888][T10324]  </TASK>

The call chain is: hash_ip4_resize (holds &t->gc_lock) ->
__kvmalloc_node_noprof (GFP_KERNEL) -> __might_resched -> BUG.

## Suggested Fix

Move the memory allocations before acquiring gc_lock, so the lock only
protects the section where pointers are copied:

--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -657,12 +657,11 @@ mtype_resize(struct ip_set *set, bool retried)
      orig = ipset_dereference_bh_nfnl(h->table);
      htable_bits = orig->htable_bits;
-    spin_lock_bh(&orig->gc_lock);

  retry:
      ret = 0;

      t = ip_set_alloc(hsize);
      if (!t) {
          ret = -ENOMEM;
          goto out;
      }

      t->hregion = ip_set_alloc(ahash_sizeof_regions(htable_bits));
      if (!t->hregion) {
          kvfree(t);
          ret = -ENOMEM;
          goto out;
      }
+
+    spin_lock_bh(&orig->gc_lock);

      /* ... copy elements from orig to t under gc_lock ... */

+    spin_unlock_bh(&orig->gc_lock);
      mtype_ahash_destroy(set, orig, false);

Alternatively, if the allocations must remain under the lock, use
GFP_ATOMIC and handle the NULL return gracefully.

Thanks,
Xiao

---
[1] Sashiko found this issue during automated patch review.  Full
     results, including the PoC, kernel config, and raw serial log:
https://sashiko.dev/#/patchset/20260609072750.318774-1-kadlec%40netfilter.org 

