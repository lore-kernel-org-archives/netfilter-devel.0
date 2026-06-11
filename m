Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04CF33D4E8
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jun 2026 19:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781207278; cv=none; b=OOyLC1kr0Mp2Cwbdbdh2rvIEtwS7XkLP87BAHe8WcZ4ozJrZsYfpv3LdT0zThL6lbqKJZcuSdTAVZaYf5Mh6kp1XODH0M4QG8pk2B65s5BDl+aAS30vnavkBKMotSJG45kxsQRy4eQX4TwCJ9fmgjFst5aYoMIiIDAn30LMmWYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781207278; c=relaxed/simple;
	bh=GFV8WbtaMA+m8Tubj+8RfHKK002yaf6n2mZxnfM4D/I=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Ys9BeH9RlcJTCk66a2Jey/b3eVFR82mVKTraaXqCtxeK6mAMC3M2KHYuKOmFh0TYTQ0DWI3EU6SzdgsZryuV/M9XSpOWqBS9238FfU3O/OuqDioXOjP/YwsCl3qxYfIPjaczXIXQMwZX4GQOskZA0NNl5RI7r2WvF3PnxRYbxwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4gbtTt6XBRz7s7wq;
	Thu, 11 Jun 2026 21:47:46 +0200 (CEST)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id Q55gI8gwZCmu; Thu, 11 Jun 2026 21:47:44 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (91-83-11-230.pool.digikabel.hu [91.83.11.230])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4gbtTr1Pslz7s7wc;
	Thu, 11 Jun 2026 21:47:44 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id F1D2A1404D3; Thu, 11 Jun 2026 21:47:43 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id EE458140165;
	Thu, 11 Jun 2026 21:47:43 +0200 (CEST)
Date: Thu, 11 Jun 2026 21:47:43 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: XIAO WU <xiaowu.417@qq.com>
cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 5/9] netfilter: ipset: exlude gc when resize is in
 progress
In-Reply-To: <tencent_C9F91B790E910F8EACB10405AF2C9B173205@qq.com>
Message-ID: <4b2b9778-9e16-eef4-10b5-22b185867925@netfilter.org>
References: <20260609072750.318774-1-kadlec@netfilter.org> <20260609072750.318774-6-kadlec@netfilter.org> <tencent_C9F91B790E910F8EACB10405AF2C9B173205@qq.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-273641086-1781207263=:3413"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-273641086-1781207263=:3413
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 11 Jun 2026, XIAO WU wrote:

> While reviewing this patch on Sashiko [1], I found it introduces a=20
> "scheduling while atomic" bug in mtype_resize().=C2=A0 Sashiko's automa=
ted=20
> review flagged the issue, and I was able to confirm it with a PoC that=20
> reliably triggers the kernel splat.

Yes, a respin of the patches are required. Thanks for the thorough report=
!

Best regards,
Jozsef
=20
> [1]
> https://sashiko.dev/#/patchset/20260609072750.318774-1-kadlec%40netfilt=
er.org
>=20
> > diff --git a/net/netfilter/ipset/ip_set_hash_gen.h
> b/net/netfilter/ipset/ip_set_hash_gen.h
> > index 20678116a..a41f6cdee 100644
> > --- a/net/netfilter/ipset/ip_set_hash_gen.h
> > +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> > @@ -84,6 +84,7 @@ struct htable {
> >=C2=A0 =C2=A0 =C2=A0 atomic_t uref;=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Refe=
rences for dumping and gc */
> >=C2=A0 =C2=A0 =C2=A0 u8 htable_bits;=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* siz=
e of hash table =3D=3D 2^htable_bits */
> >=C2=A0 =C2=A0 =C2=A0 u32 maxelem;=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Maxele=
m per region */
> > +=C2=A0 =C2=A0 spinlock_t gc_lock;=C2=A0 =C2=A0 /* Lock to exclude gc=
 and resize */
> >=C2=A0 =C2=A0 =C2=A0 struct ip_set_region *hregion;=C2=A0 =C2=A0 /* Re=
gion locks and ext sizes */
> >=C2=A0 =C2=A0 =C2=A0 struct hbucket __rcu *bucket[]; /* hashtable buck=
ets */
> >=C2=A0 };
>=20
> The new gc_lock is added to struct htable but correctly initialized in
> _create() via spin_lock_init(), so this part is fine.
>=20
> > @@ -581,7 +582,9 @@ mtype_gc(struct work_struct *work)
> >=C2=A0 =C2=A0 =C2=A0 if (next_run < HZ/10)
> >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 next_run =3D HZ/10;
> >
> > +=C2=A0 =C2=A0 spin_lock_bh(&t->gc_lock);
> >=C2=A0 =C2=A0 =C2=A0 mtype_gc_do(set, h, t, r);
> > +=C2=A0 =C2=A0 spin_unlock_bh(&t->gc_lock);
> >
> >=C2=A0 =C2=A0 =C2=A0 if (atomic_dec_and_test(&t->uref) && atomic_read(=
&t->ref)) {
> >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_debug("Table destroy after resiz=
e by expire: %p\n", t);
>=20
> mtype_gc() is fine =E2=80=94 it does not allocate memory under the lock=
.
>=20
> > @@ -646,6 +649,7 @@ mtype_resize(struct ip_set *set, bool retried)
> >=C2=A0 #endif
> >=C2=A0 =C2=A0 =C2=A0 orig =3D ipset_dereference_bh_nfnl(h->table);
> >=C2=A0 =C2=A0 =C2=A0 htable_bits =3D orig->htable_bits;
> > +=C2=A0 =C2=A0 spin_lock_bh(&orig->gc_lock);
> >
> >=C2=A0 retry:
> >=C2=A0 =C2=A0 =C2=A0 ret =3D 0;
>=20
> The problem is here.=C2=A0 spin_lock_bh() disables preemption and botto=
m
> halves, putting us in atomic context.=C2=A0 Shortly after this, the fun=
ction
> calls:
>=20
> =C2=A0 =C2=A0 t =3D ip_set_alloc(hsize);
>=20
> which eventually does kvzalloc(size, GFP_KERNEL_ACCOUNT). GFP_KERNEL
> allocations are sleepable =E2=80=94 they can trigger direct reclaim or =
wait for
> memory to become available.=C2=A0 Calling a sleepable function while ho=
lding a
> spinlock triggers:
>=20
> =C2=A0 BUG: sleeping function called from invalid context
>=20
> This is reliably reproducible with the PoC below.=C2=A0 spin_lock_bh() =
and
> GFP_KERNEL allocations are fundamentally incompatible.
>=20
> > @@ -759,6 +763,8 @@ mtype_resize(struct ip_set *set, bool retried)
> >=C2=A0 =C2=A0 =C2=A0 /* There can't be any other writer. */
> >=C2=A0 =C2=A0 =C2=A0 rcu_assign_pointer(h->table, t);
> >
> > +=C2=A0 =C2=A0 spin_unlock_bh(&orig->gc_lock);
> > +
> >=C2=A0 =C2=A0 =C2=A0 /* Give time to other readers of the set */
> >=C2=A0 =C2=A0 =C2=A0 synchronize_rcu();
> >
> > @@ -797,6 +803,7 @@ mtype_resize(struct ip_set *set, bool retried)
> >=C2=A0 =C2=A0 =C2=A0 mtype_ahash_destroy(set, t, false);
> >=C2=A0 =C2=A0 =C2=A0 if (ret =3D=3D -EAGAIN)
> >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto retry;
> > +=C2=A0 =C2=A0 spin_unlock_bh(&orig->gc_lock);
> >=C2=A0 =C2=A0 =C2=A0 goto out;
> >
> >=C2=A0 hbwarn:
>=20
> Note that the hbwarn error path bypasses the newly added
> spin_unlock_bh(), leaving the lock held on return.=C2=A0 That's a separ=
ate
> issue, but worth fixing too.
>=20
> > @@ -1617,6 +1624,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, st=
ruct
> ip_set *set,
> >=C2=A0 =C2=A0 =C2=A0 }
> >=C2=A0 =C2=A0 =C2=A0 t->htable_bits =3D hbits;
> >=C2=A0 =C2=A0 =C2=A0 t->maxelem =3D h->maxelem / ahash_numof_locks(hbi=
ts);
> > +=C2=A0 =C2=A0 spin_lock_init(&t->gc_lock);
> >=C2=A0 =C2=A0 =C2=A0 RCU_INIT_POINTER(h->table, t);
> >
> >=C2=A0 =C2=A0 =C2=A0 INIT_LIST_HEAD(&h->ad);
>=20
> ## Reproducer
>=20
> The PoC below creates a hash:ip set with a small hashsize, then adds
> enough IPs to overflow buckets and force a resize, hitting the
> sleep-in-atomic path.=C2=A0 Generated and verified via Sashiko's kernel
> testing framework.
>=20
> Build:=C2=A0 gcc -static -o poc poc.c
> Run:=C2=A0 =C2=A0 ./poc=C2=A0 =C2=A0(as root or with CAP_NET_ADMIN)
> Check:=C2=A0 dmesg | grep "sleeping function called from invalid contex=
t"
>=20
> /* PoC: trigger scheduling while atomic in mtype_resize()
> =C2=A0*
> =C2=A0* Commit be2a510ec367 ("netfilter: ipset: exlude gc when resize i=
s in
> =C2=A0* progress") adds spin_lock_bh(&orig->gc_lock) in mtype_resize(),=
 then
> =C2=A0* calls ip_set_alloc() which uses kvzalloc(GFP_KERNEL).=C2=A0 Sin=
ce
> =C2=A0* spin_lock_bh disables preemption, the sleepable GFP_KERNEL allo=
cation
> =C2=A0* triggers "BUG: sleeping function called from invalid context".
> =C2=A0*
> =C2=A0* Build: gcc -static -o poc poc.c
> =C2=A0* Run:=C2=A0 =C2=A0./poc=C2=A0 =C2=A0(as root or with CAP_NET_ADM=
IN)
> =C2=A0*/
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <string.h>
> #include <unistd.h>
> #include <sys/socket.h>
> #include <netinet/in.h>
> #include <arpa/inet.h>
> #include <linux/netlink.h>
> #include <linux/netfilter/nfnetlink.h>
> #include <linux/netfilter/ipset/ip_set.h>
>=20
> #define A4(x) (((x) + 3) & ~3)
>=20
> int main(void)
> {
> =C2=A0 =C2=A0 struct sockaddr_nl sa =3D { .nl_family =3D AF_NETLINK };
> =C2=A0 =C2=A0 int fd =3D socket(AF_NETLINK, SOCK_RAW | SOCK_CLOEXEC, NE=
TLINK_NETFILTER);
>=20
> =C2=A0 =C2=A0 if (fd < 0) { perror("socket"); return 1; }
> =C2=A0 =C2=A0 bind(fd, (struct sockaddr *)&sa, sizeof(sa));
>=20
> =C2=A0 =C2=A0 char msg[4096];
> =C2=A0 =C2=A0 unsigned char *b =3D (unsigned char *)msg;
> =C2=A0 =C2=A0 char rsp[8192];
> =C2=A0 =C2=A0 int o, ds, ips, r, i;
>=20
> =C2=A0 =C2=A0 /* ---- IPSET_CMD_CREATE: hash:ip set 'h' ---- */
> =C2=A0 =C2=A0 memset(msg, 0, sizeof(msg));
> =C2=A0 =C2=A0 b[0] =3D 2; b[1] =3D 0; b[2] =3D 0; b[3] =3D 0; o =3D 4;
>=20
> =C2=A0 =C2=A0 o =3D A4(o);
> =C2=A0 =C2=A0 b[o] =3D 5; b[o + 1] =3D 0; b[o + 2] =3D 1; b[o + 3] =3D =
0; b[o + 4] =3D 7; o +=3D 5;
>=20
> =C2=A0 =C2=A0 o =3D A4(o);
> =C2=A0 =C2=A0 b[o] =3D 6; b[o + 1] =3D 0; b[o + 2] =3D 2; b[o + 3] =3D =
0;
> =C2=A0 =C2=A0 b[o + 4] =3D 'h'; b[o + 5] =3D 0; o +=3D 6;
>=20
> =C2=A0 =C2=A0 o =3D A4(o);
> =C2=A0 =C2=A0 b[o] =3D 12; b[o + 1] =3D 0; b[o + 2] =3D 3; b[o + 3] =3D=
 0;
> =C2=A0 =C2=A0 memcpy(b + o + 4, "hash:ip", 8); o +=3D 12;
>=20
> =C2=A0 =C2=A0 o =3D A4(o);
> =C2=A0 =C2=A0 b[o] =3D 5; b[o + 1] =3D 0; b[o + 2] =3D 4; b[o + 3] =3D =
0; b[o + 4] =3D 0; o +=3D 5;
>=20
> =C2=A0 =C2=A0 o =3D A4(o);
> =C2=A0 =C2=A0 b[o] =3D 5; b[o + 1] =3D 0; b[o + 2] =3D 5; b[o + 3] =3D =
0;
> =C2=A0 =C2=A0 b[o + 4] =3D 2; o +=3D 5;
>=20
> =C2=A0 =C2=A0 o =3D A4(o); ds =3D o; o +=3D 4;
>=20
> =C2=A0 =C2=A0 /* hashsize =3D 8 (small, so buckets overflow quickly -> =
resize) */
> =C2=A0 =C2=A0 o =3D A4(o); {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 __be32 v =3D htonl(8);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 b[o] =3D 8; b[o + 1] =3D 0; b[o + 2] =3D 18=
; b[o + 3] =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(b + o + 4, &v, 4); o +=3D 8;
> =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 /* maxelem =3D 1000000 */
> =C2=A0 =C2=A0 o =3D A4(o); {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 __be32 v =3D htonl(1000000);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 b[o] =3D 8; b[o + 1] =3D 0; b[o + 2] =3D 19=
; b[o + 3] =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(b + o + 4, &v, 4); o +=3D 8;
> =C2=A0 =C2=A0 }
>=20
> =C2=A0 =C2=A0 o =3D A4(o); b[ds] =3D o - ds; b[ds + 1] =3D 0;
> =C2=A0 =C2=A0 b[ds + 2] =3D 7 | 0x80; b[ds + 3] =3D 0;
>=20
> =C2=A0 =C2=A0 struct nlmsghdr nlh =3D {0};
> =C2=A0 =C2=A0 int al =3D A4(o);
>=20
> =C2=A0 =C2=A0 nlh.nlmsg_len=C2=A0 =C2=A0=3D A4((int)sizeof(nlh)) + al;
> =C2=A0 =C2=A0 nlh.nlmsg_type=C2=A0 =3D (NFNL_SUBSYS_IPSET << 8) | IPSET=
_CMD_CREATE;
> =C2=A0 =C2=A0 nlh.nlmsg_flags =3D NLM_F_REQUEST | NLM_F_ACK | NLM_F_CRE=
ATE;
> =C2=A0 =C2=A0 nlh.nlmsg_seq=C2=A0 =C2=A0=3D 1;
>=20
> =C2=A0 =C2=A0 struct iovec iov[2];
> =C2=A0 =C2=A0 struct msghdr mh =3D {0};
> =C2=A0 =C2=A0 iov[0].iov_base =3D &nlh;
> =C2=A0 =C2=A0 iov[0].iov_len=C2=A0 =3D A4((int)sizeof(nlh));
> =C2=A0 =C2=A0 iov[1].iov_base =3D msg;
> =C2=A0 =C2=A0 iov[1].iov_len=C2=A0 =3D al;
> =C2=A0 =C2=A0 mh.msg_name=C2=A0 =C2=A0 =C2=A0=3D &sa;
> =C2=A0 =C2=A0 mh.msg_namelen=C2=A0 =3D sizeof(sa);
> =C2=A0 =C2=A0 mh.msg_iov=C2=A0 =C2=A0 =C2=A0 =3D iov;
> =C2=A0 =C2=A0 mh.msg_iovlen=C2=A0 =C2=A0=3D 2;
>=20
> =C2=A0 =C2=A0 sendmsg(fd, &mh, 0);
> =C2=A0 =C2=A0 r =3D recv(fd, rsp, sizeof(rsp), 0);
> =C2=A0 =C2=A0 if (r > 0) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct nlmsghdr *hdr =3D (struct nlmsghdr *=
)rsp;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (hdr->nlmsg_type =3D=3D NLMSG_ERROR) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct nlmsgerr *e =3D (struc=
t nlmsgerr *)NLMSG_DATA(hdr);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (e->error) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf("ERR %d\=
n", e->error);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 close(fd);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 printf("[*] Hash:ip set 'h' created (hashsize=3D8).\n");
>=20
> =C2=A0 =C2=A0 /* ---- Add 25000 IPs to trigger bucket overflow -> resiz=
e ---- */
> =C2=A0 =C2=A0 printf("[*] Adding 25000 IPs to trigger resize...\n");
> =C2=A0 =C2=A0 for (i =3D 0; i < 25000; i++) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Cycle through 10000 unique IPs: 11.0.0.1=
 .. 11.0.39.16 */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 __be32 ip =3D htonl(0x0b000000 + (i % 10000=
) + 1);
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(msg, 0, sizeof(msg));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 b[0] =3D 2; b[1] =3D 0; b[2] =3D 0; b[3] =3D=
 0; o =3D 4;
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 o =3D A4(o);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 b[o] =3D 5; b[o + 1] =3D 0; b[o + 2] =3D 1;=
 b[o + 3] =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 b[o + 4] =3D 7; o +=3D 5;
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 o =3D A4(o);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 b[o] =3D 6; b[o + 1] =3D 0; b[o + 2] =3D 2;=
 b[o + 3] =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 b[o + 4] =3D 'h'; b[o + 5] =3D 0; o +=3D 6;
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 o =3D A4(o); ds =3D o;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 b[ds + 2] =3D 7; b[ds + 3] =3D 0x80; o +=3D=
 4;
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 o =3D A4(o); ips =3D o;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 b[ips + 2] =3D 1; b[ips + 3] =3D 0x80; o +=3D=
 4;
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 o =3D A4(o);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 b[o] =3D 8; b[o + 1] =3D 0; b[o + 2] =3D 1;=
 b[o + 3] =3D 0x40;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(b + o + 4, &ip, 4); o +=3D 8;
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 o =3D A4(o);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 b[ips] =3D o - ips; b[ips + 1] =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 b[ds]=C2=A0 =3D o - ds;=C2=A0 b[ds + 1]=C2=A0=
 =3D 0;
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 int a2 =3D A4(o);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 nlh.nlmsg_len=C2=A0 =C2=A0=3D A4((int)sizeo=
f(nlh)) + a2;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 nlh.nlmsg_type=C2=A0 =3D (NFNL_SUBSYS_IPSET=
 << 8) | IPSET_CMD_ADD;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 nlh.nlmsg_flags =3D NLM_F_REQUEST | NLM_F_A=
CK;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 nlh.nlmsg_seq=C2=A0 =C2=A0=3D i + 2;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 iov[1].iov_len=C2=A0 =3D a2;
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 sendmsg(fd, &mh, 0);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D recv(fd, rsp, sizeof(rsp), 0);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (r > 0) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct nlmsghdr *hdr =3D (str=
uct nlmsghdr *)rsp;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (hdr->nlmsg_type =3D=3D NL=
MSG_ERROR) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct nlmsgerr=
 *e =3D (struct nlmsgerr *)NLMSG_DATA(hdr);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (e->error) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p=
rintf("[!] %d err %d\n", i, e->error);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i=
f (e->error =3D=3D -EAGAIN)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 printf("*** EAGAIN - check dmesg ***\n");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b=
reak;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (i % 2000 =3D=3D 1999)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf("=C2=A0 %d/25000\n", i=
 + 1);
> =C2=A0 =C2=A0 }
>=20
> =C2=A0 =C2=A0 printf("[*] Done. Check dmesg.\n");
> =C2=A0 =C2=A0 close(fd);
> =C2=A0 =C2=A0 return 0;
> }
>=20
> ## Kernel Splat
>=20
> Running the PoC on 7.1.0-rc5 with this patch applied:
>=20
> [ 4605.426526][T10324] BUG: sleeping function called from invalid conte=
xt at
> include/linux/sched/mm.h:323
> [ 4605.429032][T10324] in_atomic(): 1, irqs_disabled(): 0, non_block: 0=
, pid:
> 10324, name: poc
> [ 4605.430595][T10324] preempt_count: 201, expected: 0
> [ 4605.432432][T10324] 2 locks held by poc/10324:
> [ 4605.433263][T10324]=C2=A0 #0: ffffffff9bc4e600 (nfnl_subsys_ipset){+=
.+.}-{4:4},
> at: nfnetlink_rcv_msg+0x8ba/0x11f0
> [ 4605.435525][T10324]=C2=A0 #1: ffff888115560028 (&t->gc_lock){+...}-{=
3:3}, at:
> hash_ip4_resize+0x1a4/0x1c60
> [ 4605.438773][T10324] CPU: 1 UID: 0 PID: 10324 Comm: poc Not tainted
> 7.1.0-rc5-gd81b843c2589 #1 PREEMPT(full)
> [ 4605.438802][T10324] Call Trace:
> [ 4605.438808][T10324]=C2=A0 <TASK>
> [ 4605.438814][T10324]=C2=A0 dump_stack_lvl+0x16c/0x1f0
> [ 4605.439190][T10324]=C2=A0 __might_resched+0x3c5/0x5e0
> [ 4605.439606][T10324]=C2=A0 __kvmalloc_node_noprof+0x63f/0x920
> [ 4605.439653][T10324]=C2=A0 hash_ip4_resize+0x103a/0x1c60
> [ 4605.439771][T10324]=C2=A0 call_ad.constprop.0+0x372/0x950
> [ 4605.439917][T10324]=C2=A0 ip_set_ad.constprop.0.isra.0+0x3d3/0x880
> [ 4605.440032][T10324]=C2=A0 nfnetlink_rcv_msg+0x9e2/0x11f0
> [ 4605.440164][T10324]=C2=A0 netlink_rcv_skb+0x15d/0x430
> [ 4605.440261][T10324]=C2=A0 nfnetlink_rcv+0x1b8/0x430
> [ 4605.440325][T10324]=C2=A0 netlink_unicast+0x592/0x860
> [ 4605.440385][T10324]=C2=A0 netlink_sendmsg+0x8cd/0xdd0
> [ 4605.440449][T10324]=C2=A0 ____sys_sendmsg+0x9ec/0xb80
> [ 4605.440595][T10324]=C2=A0 ___sys_sendmsg+0x139/0x1e0
> [ 4605.440682][T10324]=C2=A0 __sys_sendmsg+0x172/0x220
> [ 4605.440753][T10324]=C2=A0 do_syscall_64+0x129/0x850
> [ 4605.440770][T10324]=C2=A0 entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [ 4605.440888][T10324]=C2=A0 </TASK>
>=20
> The call chain is: hash_ip4_resize (holds &t->gc_lock) ->
> __kvmalloc_node_noprof (GFP_KERNEL) -> __might_resched -> BUG.
>=20
> ## Suggested Fix
>=20
> Move the memory allocations before acquiring gc_lock, so the lock only
> protects the section where pointers are copied:
>=20
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -657,12 +657,11 @@ mtype_resize(struct ip_set *set, bool retried)
> =C2=A0 =C2=A0 =C2=A0orig =3D ipset_dereference_bh_nfnl(h->table);
> =C2=A0 =C2=A0 =C2=A0htable_bits =3D orig->htable_bits;
> -=C2=A0 =C2=A0 spin_lock_bh(&orig->gc_lock);
>=20
> =C2=A0retry:
> =C2=A0 =C2=A0 =C2=A0ret =3D 0;
>=20
> =C2=A0 =C2=A0 =C2=A0t =3D ip_set_alloc(hsize);
> =C2=A0 =C2=A0 =C2=A0if (!t) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -ENOMEM;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0}
>=20
> =C2=A0 =C2=A0 =C2=A0t->hregion =3D ip_set_alloc(ahash_sizeof_regions(ht=
able_bits));
> =C2=A0 =C2=A0 =C2=A0if (!t->hregion) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kvfree(t);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -ENOMEM;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0}
> +
> +=C2=A0 =C2=A0 spin_lock_bh(&orig->gc_lock);
>=20
> =C2=A0 =C2=A0 =C2=A0/* ... copy elements from orig to t under gc_lock .=
.. */
>=20
> +=C2=A0 =C2=A0 spin_unlock_bh(&orig->gc_lock);
> =C2=A0 =C2=A0 =C2=A0mtype_ahash_destroy(set, orig, false);
>=20
> Alternatively, if the allocations must remain under the lock, use
> GFP_ATOMIC and handle the NULL return gracefully.
>=20
> Thanks,
> Xiao
>=20
> ---
> [1] Sashiko found this issue during automated patch review.=C2=A0 Full
> =C2=A0 =C2=A0 results, including the PoC, kernel config, and raw serial=
 log:
> https://sashiko.dev/#/patchset/20260609072750.318774-1-kadlec%40netfilt=
er.org=20
>=20
>=20

--=20
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef=
@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
--8323329-273641086-1781207263=:3413--
