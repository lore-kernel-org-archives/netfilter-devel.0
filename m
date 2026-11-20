Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.59.229
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795153069;
	b=ZE2h7oPsnBzjKd1A/ny44S02qarTPtyn2fFAD1Oz6gOUf74ybZIdixqWsvOjKQEcmT78
	 HtKsjpyvqmD9VUj3GA+Fgq/MWg63Q2T4G+rwnNRGCPO9QuEaAX6u/fN9IjAhIJpsPYtrZ
	 f1wapygTI6/Rd0XDUksR52Q1RRBtllBdTyV/27clV8Vhc2TGSF5riIO3fzkQLd+JItZmH
	 RKu9KDgTUFMliI8p5TI0GJ6cwEHLToTRWUM58y0uTT3ymxkMbIlpdPOearQlMHk2DAekR
	 0itO/NINQUteKNZ7u/CR5g8+oeaa5pVZ/JgEaLtacZSuFfLQDlKJpCBMYr9yN3PawEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795153069;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=t/++9kq+HgKKBvu8dsfTWVjPVohzWSlwX7QOayHmTpk=;
	b=282NafvG9S6jotW+tMzJ1btbzfdschmrs8AiPzjc/FyG6NZGPrtc9NXXscufQlrtbKj6
	 /4xflWe6I0Pty0Y7RufVhubdKNH6O6ZI/EzeN4/5cDoy4Sk2ewMN1jBP1HO69LM5BsOP/
	 hr9uOPXPDY1+zSontpeKxLdYLV6HKKVMFsaDJk5+saJhmBpZR2h6zRFBXdN/c5ms9bz+H
	 Ifxw8j1nPFkdQ2/TcHvx3UKVaB62/+xRjgjzKcbGlTxyW1m+g6m/Rws/NoZyh2/P+4Q4C
	 P724eMw0YtgKSmFQp+VXjpzv89/xXeQPHguzHkjf/C0u7v9sYpsfOicIMva1RvTCg0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=1wt.eu;
	spf=pass smtp.mailfrom=1wt.eu;
	dkim=pass header.d=1wt.eu header.i=@1wt.eu header.a=rsa-sha256 header.s=mail header.b=dEdbW+lO;
	arc=none smtp.remote-ip=51.159.59.229
Received: from mta1.formilux.org (mta1.formilux.org [51.159.59.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB81D606A320;
	Fri, 20 Nov 2026 05:37:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB81D606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=1wt.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=1wt.eu header.i=@1wt.eu header.a=rsa-sha256 header.s=mail header.b=dEdbW+lO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1wt.eu; s=mail;
	t=1795153065; bh=t/++9kq+HgKKBvu8dsfTWVjPVohzWSlwX7QOayHmTpk=;
	h=From:Message-ID:From;
	b=dEdbW+lO204v036Omb+vvUs1YY+BCTxSxm9WkJq5baDnIsL7G/zo3ItFguZxUQwO4
	 1W9BbdpK1iEZSJNMJX+TQwjWWbfhXZSKIc0eLTKG9WwvS6Icb/TmWZg9aRGiQpCveP
	 MXMwCGKVB8LevxzTTvt4gy3rDiELZD03gfKAn4W0=
Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by mta1.formilux.org (Postfix) with ESMTP id 19893C094A;
	Fri, 20 Nov 2026 06:37:45 +0100 (CET)
Date: Fri, 20 Nov 2026 06:37:44 +0100
From: Willy Tarreau <w@1wt.eu>
To: n3rd <18670333770@163.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "security@kernel.org" <security@kernel.org>
Subject: Re: [SECURITY] netfilter: ipset: double free in hash resize vs
 inline gc
Message-ID: <av_cqPmvrh5iT8Tw@1wt.eu>
References: <3a7a0984.dc22e.1a1f6bb0630.Coremail.18670333770@163.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <3a7a0984.dc22e.1a1f6bb0630.Coremail.18670333770@163.com>

Hello,

On Fri, Nov 20, 2026 at 10:13:34AM +0800, n3rd wrote:
>=20
>=20
> Hello,
>=20
>=20
> I am reporting a security bug in the Linux kernel.
>=20
>=20
> 1. Affected kernel versions
> Linux v7.3-rc7 (mainline, tested as 7.3.0-rc7) is affected and was reprod=
uced twice on fresh QEMU guests. The same unguarded call site is present un=
changed in v7.2.9 (stable) and in the v7.3-rc series; those were checked at=
 source level only and were not re-run dynamically. No bisection was perfor=
med, so the affected range is stated from the source of the call site rathe=
r than from a tested lower bound.
>=20
>=20
> 2. Problem description
> ipset hash sets are generated from one template, net/netfilter/ipset/ip_s=
et_hash_gen.h. mtype_gc_do() has two callers. The workqueue caller mtype_gc=
() takes gc.lock and checks t->resizing before the sweep. The second caller=
 is at the top of mtype_add(), which is the insertion routine shared by the=
 control plane (hash_ip4_uadt) and the packet path (xt_set SET target, then=
 hash_ip4_kadt), and it neither takes gc.lock nor reads t->resizing. On the=
 other side, mtype_resize() copies every element of the old table into a ne=
w doubled table while holding only rcu_read_lock_bh(); it never takes t->hr=
egion[r].lock, which is the one lock the inline sweep takes. The copy is a =
memcpy of the element extension area, and the comment extension in that are=
a is only an 8-byte pointer to a separately allocated struct ip_set_comment=
_rcu that has no reference count. So when an element X expires while the co=
py loop is still running, the packet path can sweep X as expired, free X's =
comment on the old table via ip_set_comment_free() and clear the pointer th=
ere, while the new table already holds the same pointer. When the set is de=
stroyed later, the new table walks the same element and frees that comment =
a second time. Observed on a KASAN kernel: BUG: KASAN: double-free in rcu_f=
ree_sheaf, Free of addr ffff8881069f1900 by task ips03v2, and the Allocated=
-by stack is the kasan kmalloc helper, then ip_set_init_comment, hash_ip4_a=
dd, hash_ip4_uadt, call_ad, ip_set_ad, ip_set_uadd, nfnetlink_rcv_msg. The =
object is in cache kmalloc-32. The same object is also read after it was fr=
eed: BUG: KASAN: slab-use-after-free in strlen, Read of size 1, with strlen=
, ip_set_comment_free, hash_ip4_ext_cleanup, hash_ip4_ahash_destroy, hash_i=
p4_destroy, ip_set_destroy_set_work. Two fresh runs produced 16 plus 14 and=
 30 plus 14 of those reports; a control run with the packet path disabled p=
roduced zero reports while performing exactly the same 15 resizes.
>=20
>=20
> 3. Reproducer
> A static x86-64 trigger program speaks the ipset nfnetlink protocol direc=
tly. It creates a hash:ip set with the timeout and comment extensions, inst=
alls an iptables OUTPUT rule with the SET target and --add-set, sends UDP p=
ackets to 127.0.0.1 from a bound source address so that the packet path ent=
ers mtype_add on every packet, and arranges the timeouts of 1500 filler ele=
ments so that their deadlines fall inside a table resize. The complete repr=
oducer, the guest initramfs scripts and the full console logs are available=
 on request; I did not post them publicly.
>=20
>=20
> 4. Conditions
> Local attacker with CAP_NET_ADMIN inside a user namespace. No init-namesp=
ace capability, no CAP_NET_RAW (the packets are UDP to 127.0.0.1) and no sp=
ecial filesystem are needed. The kernel must have CONFIG_IP_SET, CONFIG_IP_=
SET_HASH_IP and CONFIG_NETFILTER_XT_SET, and the set must use the timeout a=
nd comment extensions. This is a race, so the trigger runs several attempts=
 per boot; on TCG it hit within the first one to three of five attempts. KA=
SAN with kasan_multi_shot is required to see it, because stock KASAN stops =
reporting after the first finding.
>=20
>=20
> 5. Suspected location
> net/netfilter/ipset/ip_set_hash_gen.h: the inline mtype_gc_do() call at t=
he top of mtype_add(), versus the guarded call inside mtype_gc(). Also mtyp=
e_resize() and the memcpy of the element extension area that carries the co=
mment pointer. net/netfilter/ipset/ip_set_core.c: ip_set_comment_free() and=
 ip_set_init_comment().
>=20
>=20
> 6. Suggested fix
> Give the inline sweep the same exclusion the workqueue sweep already has:=
 take h->gc.lock and skip the sweep when t->resizing is set. A more complet=
e variant is to take t->hregion[r].lock around the per-region copy in mtype=
_resize(), so both sweep entry points are serialized with the resize. For c=
ontext, cffcf57bf03c only fixed the workqueue caller, and f30415929be8 and =
a442c8a89fb9 fixed other sites.
>=20
>=20
> 7. Mitigation
> Do not create ipset sets that use the comment extension on affected kerne=
ls, or leave CONFIG_NETFILTER_XT_SET off so the packet path cannot enter mt=
ype_add. Restricting unprivileged user namespaces removes the unprivileged =
reachability but does not fix the bug.
>=20
>=20
> 8. Disclosure
> Public. This report is being sent to the public netfilter list; no embarg=
o is requested. The reproducer is not posted publicly; it is available on r=
equest.
>=20
>=20
> 9. AI-assistance note
> This report was prepared with an AI coding assistant. Per the kernel secu=
rity process I treat the issue as public and am not posting the reproducer =
publicly.

If you used AI assistance, your LLM ought to have told you that our doc
requests that:
  - a tested fix is always provided, and in a format that can be applied
  - the security list isn't CCed when the message is posted to public lists

Can you please propose patches for your different reports ? This is general=
ly
trivial to do for LLMs after they find a bug because they have a complete
view of the problem.

Thanks,
Willy
