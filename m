Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.6.0.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795163294;
	b=yBv317M/WTG+iRlf2brNIuRnDauA+/5mJU2Zz32bbRlfHvbQgQh9k6/8TSOItUujWD09
	 pvI6ZGfi1rsV0fvSEzyW5wYM8os3UE1PiIG0pKLh40MPl/263AWXW6xwRyIZsvMY6RBux
	 NwwXb6EB1vNcKp6AXpQtG6/nxoiRwHjBaft8e2VNXLlEfvA5ooeHBCyFcolt5bv7xVbU3
	 XBaQdpleAzogSXDRCLKO3RaYVlIg9yaZ4ZMZVJEb0JoXO9RcqyHCRfOPGhSiyy5s3F/1h
	 Of3o5gIhRGVwQmr3SQCJQx8rvuuc8bueRpakyMvLhhVzGhNPxhH3WOvGw8d06LoL4KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795163294;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Received:Received:Date:From:To:cc:Subject:In-Reply-To:
	 Message-ID:References:MIME-Version:Content-Type;
	bh=w1NBOfFgAQPG5zy7sPw/S7Tffv2N+YgwkyeadfXG7Og=;
	b=B2UUvvS9yWfpR35xXY4+eYPqukwowYY3j7Sk/BbMbKc5UPL24q6w2G9hQ+GGopacswvQ
	 tiX8Zi/MKbWDz+SeRXlNNmC2yKQQG+iR4JC1nOPd2Dmk5+pcWjEUkP+Q+9ZvglCBKcBqr
	 gJsfEsj2oxvSb6dZzSHtz2Fp/g8n7kz6JtPgU6FdzAbxbyzAk+Lw4E1FXJkiCurQJdDcM
	 Dj17ZVaNoyCCrMEcgmvcQ8LxfVfO9E96ZdhbwZgXlzxln0F5sPUvgRAuPzXVSR56WzTlR
	 1NgjPyH+jSt3c1XDBupItQMWK7/WudFzPJm0xSK4+Z0TO4RwQKoELczAvjA5suc0XhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=blackhole.kfki.hu;
	spf=pass smtp.mailfrom=blackhole.kfki.hu;
	dkim=pass header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.a=rsa-sha256 header.s=20151130 header.b=JIRfFghO;
	arc=none smtp.remote-ip=148.6.0.51
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E090606A320;
	Fri, 20 Nov 2026 08:28:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E090606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.a=rsa-sha256 header.s=20151130 header.b=JIRfFghO
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4jW7ks22b6z7s7wl;
	Fri, 20 Nov 2026 09:28:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1795163283; x=1796977684; bh=w1NBOfFgAQ
	PG5zy7sPw/S7Tffv2N+YgwkyeadfXG7Og=; b=JIRfFghOwDK+N3vff3fkg2Cbz0
	GzZti7EfaDB3Jh0YVCmCKA5BsiiNn4fPJRZIocHNvHqdcAOmSm/9YD/ffyBxTYup
	zynU2Bq9pd8/eBcu2EFydNBY14i9y+A0o0jmLow/PR9qR0svH5kSSiORKvfDYnM9
	zKeG2CcD8+D4fuCqE=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id eH7u2McxOSrm; Fri, 20 Nov 2026 09:28:03 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4jW7kp6kRdz7s7wc;
	Fri, 20 Nov 2026 09:28:02 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id D7112340D0D; Fri, 20 Nov 2026 09:28:02 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id D55C7340CFB;
	Fri, 20 Nov 2026 09:28:02 +0100 (CET)
Date: Fri, 20 Nov 2026 09:28:02 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Willy Tarreau <w@1wt.eu>
cc: n3rd <18670333770@163.com>, 
    "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, 
    "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
    Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
    "security@kernel.org" <security@kernel.org>
Subject: Re: [SECURITY] netfilter: ipset: double free in hash resize vs inline
 gc
In-Reply-To: <av_cqPmvrh5iT8Tw@1wt.eu>
Message-ID: <3a321704-59ad-7756-102c-a5c6ae77be88@blackhole.kfki.hu>
References: <3a7a0984.dc22e.1a1f6bb0630.Coremail.18670333770@163.com> <av_cqPmvrh5iT8Tw@1wt.eu>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-192711993-1795163282=:2836"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-192711993-1795163282=:2836
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 20 Nov 2026, Willy Tarreau wrote:

> On Fri, Nov 20, 2026 at 10:13:34AM +0800, n3rd wrote:
>>
>> I am reporting a security bug in the Linux kernel.
>>
>>
>> 1. Affected kernel versions
>> Linux v7.3-rc7 (mainline, tested as 7.3.0-rc7) is affected and was rep=
roduced twice on fresh QEMU guests. The same unguarded call site is prese=
nt unchanged in v7.2.9 (stable) and in the v7.3-rc series; those were che=
cked at source level only and were not re-run dynamically. No bisection w=
as performed, so the affected range is stated from the source of the call=
 site rather than from a tested lower bound.
>>
>>
>> 2. Problem description
>> ipset hash sets are generated from one template, net/netfilter/ipset/i=
p_set_hash_gen.h. mtype_gc_do() has two callers. The workqueue caller mty=
pe_gc() takes gc.lock and checks t->resizing before the sweep. The second=
 caller is at the top of mtype_add(), which is the insertion routine shar=
ed by the control plane (hash_ip4_uadt) and the packet path (xt_set SET t=
arget, then hash_ip4_kadt), and it neither takes gc.lock nor reads t->res=
izing. On the other side, mtype_resize() copies every element of the old =
table into a new doubled table while holding only rcu_read_lock_bh(); it =
never takes t->hregion[r].lock, which is the one lock the inline sweep ta=
kes. The copy is a memcpy of the element extension area, and the comment =
extension in that area is only an 8-byte pointer to a separately allocate=
d struct ip_set_comment_rcu that has no reference count. So when an eleme=
nt X expires while the copy loop is still running, the packet path can sw=
eep X as expired, free X's comment on the old tab
 le via ip_set_comment_free() and clear the pointer there, while the new =
table already holds the same pointer. When the set is destroyed later, th=
e new table walks the same element and frees that comment a second time. =
Observed on a KASAN kernel: BUG: KASAN: double-free in rcu_free_sheaf, Fr=
ee of addr ffff8881069f1900 by task ips03v2, and the Allocated-by stack i=
s the kasan kmalloc helper, then ip_set_init_comment, hash_ip4_add, hash_=
ip4_uadt, call_ad, ip_set_ad, ip_set_uadd, nfnetlink_rcv_msg. The object =
is in cache kmalloc-32. The same object is also read after it was freed: =
BUG: KASAN: slab-use-after-free in strlen, Read of size 1, with strlen, i=
p_set_comment_free, hash_ip4_ext_cleanup, hash_ip4_ahash_destroy, hash_ip=
4_destroy, ip_set_destroy_set_work. Two fresh runs produced 16 plus 14 an=
d 30 plus 14 of those reports; a control run with the packet path disable=
d produced zero reports while performing exactly the same 15 resizes.
>>
>>
>> 3. Reproducer
>> A static x86-64 trigger program speaks the ipset nfnetlink protocol di=
rectly. It creates a hash:ip set with the timeout and comment extensions,=
 installs an iptables OUTPUT rule with the SET target and --add-set, send=
s UDP packets to 127.0.0.1 from a bound source address so that the packet=
 path enters mtype_add on every packet, and arranges the timeouts of 1500=
 filler elements so that their deadlines fall inside a table resize. The =
complete reproducer, the guest initramfs scripts and the full console log=
s are available on request; I did not post them publicly.
>>
>>
>> 4. Conditions
>> Local attacker with CAP_NET_ADMIN inside a user namespace. No init-nam=
espace capability, no CAP_NET_RAW (the packets are UDP to 127.0.0.1) and =
no special filesystem are needed. The kernel must have CONFIG_IP_SET, CON=
FIG_IP_SET_HASH_IP and CONFIG_NETFILTER_XT_SET, and the set must use the =
timeout and comment extensions. This is a race, so the trigger runs sever=
al attempts per boot; on TCG it hit within the first one to three of five=
 attempts. KASAN with kasan_multi_shot is required to see it, because sto=
ck KASAN stops reporting after the first finding.
>>
>>
>> 5. Suspected location
>> net/netfilter/ipset/ip_set_hash_gen.h: the inline mtype_gc_do() call a=
t the top of mtype_add(), versus the guarded call inside mtype_gc(). Also=
 mtype_resize() and the memcpy of the element extension area that carries=
 the comment pointer. net/netfilter/ipset/ip_set_core.c: ip_set_comment_f=
ree() and ip_set_init_comment().
>>
>>
>> 6. Suggested fix
>> Give the inline sweep the same exclusion the workqueue sweep already h=
as: take h->gc.lock and skip the sweep when t->resizing is set. A more co=
mplete variant is to take t->hregion[r].lock around the per-region copy i=
n mtype_resize(), so both sweep entry points are serialized with the resi=
ze. For context, cffcf57bf03c only fixed the workqueue caller, and f30415=
929be8 and a442c8a89fb9 fixed other sites.
>>
>>
>> 7. Mitigation
>> Do not create ipset sets that use the comment extension on affected ke=
rnels, or leave CONFIG_NETFILTER_XT_SET off so the packet path cannot ent=
er mtype_add. Restricting unprivileged user namespaces removes the unpriv=
ileged reachability but does not fix the bug.
>>
>>
>> 8. Disclosure
>> Public. This report is being sent to the public netfilter list; no emb=
argo is requested. The reproducer is not posted publicly; it is available=
 on request.
>>
>>
>> 9. AI-assistance note
>> This report was prepared with an AI coding assistant. Per the kernel s=
ecurity process I treat the issue as public and am not posting the reprod=
ucer publicly.
>
> If you used AI assistance, your LLM ought to have told you that our doc
> requests that:
>  - a tested fix is always provided, and in a format that can be applied
>  - the security list isn't CCed when the message is posted to public li=
sts
>
> Can you please propose patches for your different reports ? This is gen=
erally
> trivial to do for LLMs after they find a bug because they have a comple=
te
> view of the problem.

The current custom hash implementation backend suffers major internal=20
issues which cannot properly be solved without a complete redesign.

Florian worked really hard and rewroted the custom hash implementation=20
with an rhashtable based one which fixes the issue in question and other=20
issues lurking in the current ipset code as well, without loosing any=20
functionality.

It is heading into nf-next and at the end going to be backported to the=20
stable branches too. Thus all known/reported ipset related issues will be=
=20
fixed in "one step".

Best regards,
Jozsef

--110363376-192711993-1795163282=:2836--
