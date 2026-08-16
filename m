Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950C73A8737
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 14:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786888856; cv=pass; b=DHOHFEhY2ABXiAPC4R/+gLewG5tBcQngXfhlrHFg+WDxulgkgKSXwz95JmYra9Tn15pV7cR00LtPpcy+AAt/yAXs+nWzli9mM5ejEGWAdx9C7RzgWOu0QgUdS4GeSS79uyKL1LdCHms+3SqmVshsTrMHiGKLOyQQtH/tNqbPXZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786888856; c=relaxed/simple;
	bh=HLatxlkjdQ7JRipWH3h0dHpuBRR9IjHD83Tci937/4c=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=B+x/0v7xRizvR7fmj0ar74RASzZ9SZKJFK83NgH6OOEmhzsonfdTIn3pLBvp2725F7Pqqq7f0Xw94UzTlR1g4OXdJbKY5kuByoVd5VuJyW/gDMw7fmz9TkNWwiWdCQGQtft+1peKTTSMaD7qihMRMA3FWqKOUkVryVqx8iacizg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MFtyLBQI; arc=pass smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MFtyLBQI"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5bfc54558d5so2301589e0c.0
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 07:00:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786888853; cv=none;
        d=google.com; s=arc-20260327;
        b=VNU1xZ/vLPLKKULK53LKBIpSWdAV20WBFgBbts4Ea7DFOqykM2/tBHWeTGE/XbL7Of
         tCeyCJCQhth/o7/BpiWnSYuXZBgTwSV+NBomRfl+5u2aaAlMED02hv5faX8VPcehyONr
         YMMmbvq7V+vzW98JLMAUoEXVOMM3sSZAGSF6EyEbgTO9PBcOB3mP22/Mf2Nqv1hhkOYm
         nLbVzOT53Ohu0rx34lFmd6wqLdhU97woOi1+Ogscvin8SNF53ayJBgrY3IUQID+UlqH+
         aAPTZp/RgSma05dF4yabKT1vjlYuEhyhNCuIJCTgHiKJrzPFz1/c19jU4TZGAwi3y0yl
         6AWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=cbmxHwyupCv7gWWvclNtRFF9jxMMnu+SHa7B7ordqGU=;
        fh=oDPQ0SkZkvEoQxKum5hUSidi0arWjhyBncbZeRKpIVQ=;
        b=hQ/KqmbQxuNZtiVAQKibAsSSu99DYBlOrJkt2WIz8V33GX8HOLM8+JNPJ96rp60lLl
         NxBMIj08wKr2LNzjKrfbA+G3byZbNKcPhnKOVM834uYfqvBddOBeNKtcZIxXyirPQu7E
         DxT/k3ETmYQwKvcCgLHO7lofivzMk0gmqR9gLXqZO1kb8CL20gPhj2h4i2lxCg5TkFqV
         fPgMxb63Q2DNdn0RAcpjoD+35DziKkUgWqKHGjRRP7P7ESGA0NCg3hv95th6wE4WK8y2
         iHfmaANhkRb2eYsTsXOJO7cKzV9keh+HQP6vBsRl6JYVBYRUEmcEn/LIMi3Kd7gI9084
         yBzg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786888853; x=1787493653; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cbmxHwyupCv7gWWvclNtRFF9jxMMnu+SHa7B7ordqGU=;
        b=MFtyLBQIv4So5Nuys8JEFfjR0owPcOnLU93z8tgzHFQ/1ppxG93vfcOOek7iMNQqPB
         hkpBMqtfdWEDHMKQtEGAQvl4WfzqjQMsFmn+NoniRCTm/kfIoOed0vWOmOdAcO1Qnzrs
         hcJX+EQ8C+5j/YHA4mdieAhjeUZVLMBIz8OZ3rHCieBJloAlN/OqhekxIpR3gufvJCeC
         TTzv0Rv4Yf6gj/yWLmiYWd5PbL6FTF48qreoOlKplS9uFcBiPEp1L6TX+hrgTiC6jkis
         kJIRD5ROPqHPskYipay34Qochu15H04GbWqoB5XlUtXpStiC9GhQ2OXtEt1sXF4ofYFT
         Pwzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786888853; x=1787493653;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cbmxHwyupCv7gWWvclNtRFF9jxMMnu+SHa7B7ordqGU=;
        b=LFQk2AGwu4RGE3NfV8b5O1w0P78/AAEK/7pzOkTUTs0SQIRT1sbxyYrpvR2k0oYsuf
         3AkKN8FbKnMjjb5dZCBuaG3BBzn/8bh7Ddexy4N0Mv5vspIveRGD8/KLd9pafRtizAzO
         S7E6A8dclPz4Zt2eEGn/6oOoxKRepENV1tDwfV2K4d0v0Qh06QnkWF5V9nv7oUrO8kZL
         fxB1OYIVqBW87Kzs0FYbiXB4yOAiD4E3spgRlo0KmtLkiVhWHswWTiQkWVlHyxZPzsxj
         xi7fy6vpLHTyJQn7uooENLMk9GivPPR3qK1p3NbtOadgDcbtHK7y37vpBk62IUKuVE7B
         OAeQ==
X-Gm-Message-State: AOJu0Yw8G3Ka4WURdptpmxA79GK3dwpuecD4T3PPf7Eu/2fbuM1YRfbv
	NOXKjRniemTnWEqD9AEoNcjlg/wDwKllWM7lLjby0cBoVKezrd1vvEvTccOIWXpjK5dWXadtJt5
	Z5UfKlg51CbU+TH+gfLOw1W82uTqTrtWQSkNy2KA=
X-Gm-Gg: AR+sD13ze6tJNzPlPmUOjkJA9Wjgoca1irKeAaie+33ymrahVn7TrxSyoi6Cp3YPpIi
	uNLBKoJGG4Gf5/c7tA/Qs92UBln/+hi8mOmEGt752JmTIJ7wewlt0Lqm5f3bM4OD7ymLspYaIgd
	xb6lEyU1cK6mKMm2QslPC/OSFE5kk70YBt+wDhMr4/mrLZOO1PW1nhezGfT/TPoGcqz/A7dR8au
	XNiKFUXgRfonJKjYftKm3sh8f0ekoIwtbElOmlH129D8a5hpOZQhCrHExjJe0X6tu7bCnT+Kkge
	IxHbKr2pk8J4snWJJBLi0c984OBT4X8z2Plf/Q6Ybi9juyvQV8z5bX6KMXnxkqU3xeXkzz/xUmz
	z
X-Received: by 2002:a05:6122:881:b0:5a1:b296:78fc with SMTP id
 71dfb90a1353d-5c5926c88e0mr2660905e0c.1.1786888853350; Sun, 16 Aug 2026
 07:00:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Vimal Agrawal <avimalin@gmail.com>
Date: Sun, 16 Aug 2026 19:30:42 +0530
X-Gm-Features: AcwNN1XRNhk8_sbCcFWIBod856y7YR5HbWUdg45iYh-6KfBC4RzaWaM36OVzDXI
Message-ID: <CALkUMdRXAB1nGsBhg77zg2VGZyh-D+rL8kxqDDiEs6qmcXev=g@mail.gmail.com>
Subject: netfilter: nf_nat: race in nf_nat_setup_info() corrupts nat_bysource
 list (GPF / soft lockup)
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, coreteam@netfilter.org, 
	Vimal Agrawal <vimal.agrawal@sophos.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Our custom module can decide to send the first packet of a conntrack
to userspace via NFQUEUE while the rest of the packets for that
conntrack follow the standard kernel forward path.
In the case of a bridge, br_flood() clones skbs, and those clones
share one unconfirmed conntrack for the initial packet(s) (via
skb_clone()'s __nf_copy(), which just bumps the refcount and copies
the same ct pointer).

br_flood() clones the skb; Skb1 and Skb2 share one unconfirmed ct:
  Skb1 (cpu1): -> nfqueue -> [userspace verdict] -> reinject -> SNAT
-> confirm (cpu2)
  Skb2 (cpu1): -> SNAT -> confirm (cpu1)
Skb1's reinject-triggered SNAT (cpu2) races Skb2's synchronous SNAT
(cpu1) on the same, still-unconfirmed ct.

Because of this, SNAT for the two skbs sharing the unconfirmed
conntrack races across two different CPUs. nf_nat_setup_info() sees on
both CPUs that the conntrack isn't yet SNAT-initialized, and both try
to initialize it =E2=80=94 pushing the same conntrack node onto the
nat_bysource hash chain twice, corrupting the list.
We've seen two instances of this in production: a soft lockup and a
crash due to an illegal address, both while traversing the
nat_bysource chain. Backtrace from the GPF instance:
[321916.534145] [   T6617] general protection fault, probably for
non-canonical address 0x15000bffffffb6: 0000 [#1] SMP NOPTI
[321916.567351] [   T6617] CPU: 0 PID: 6617 Comm: snort Kdump: loaded
Tainted: P        W  O       6.6.49 #1
[321916.595688] [   T6617] Hardware name: Sophos XGS/XGS, BIOS V112 02/09/2=
022
[321916.615439] [   T6617] RIP: 0010:nf_nat_setup_info+0x8b6/0xba0 [nf_nat]
[321916.634338] [   T6617] Code: ed 75 15 e9 f2 fb ff ff 4d 8b ad 90
00 00 00 4d 85 ed 0f 84 e2 fb ff ff 49 81 ed 90 00 00 00 0f 84 d5 fb
ff ff 0f b6 44 24 56 <41> 38 45 46 75 d8 49 8b 45 20 49 8b 55 28 48 33
44 24 30 48 33 54
...
[321917.017416] [   T6617]  nf_nat_masquerade_ipv4+0x11d/0x200 [nf_nat]
[321917.035180] [   T6617]  ? do_accept6+0x150/0x150 [xt_SFOS_SNAT]
[321917.051796] [   T6617]  do_masq4+0x49/0x70 [xt_SFOS_SNAT]
[321917.066699] [   T6617]  ? do_accept6+0x150/0x150 [xt_SFOS_SNAT]
[321917.083312] [   T6617]  rule_lookup+0xc9/0x130 [sfos_rules_framework]
[321917.101646] [   T6617]  snat_tg+0x235/0x300 [xt_SFOS_SNAT]
[321917.116827] [   T6617]  ipt_do_table+0x2b9/0x410 [ip_tables]
[321917.132578] [   T6617]  nf_nat_inet_fn+0x14f/0x260 [nf_nat]
[321917.148044] [   T6617]  nf_nat_ipv4_out+0x4d/0xe0 [nf_nat]
[321917.163221] [   T6617]  nf_reinject+0x177/0x1d0
Disassembly of the faulting/looping instruction shows it's inside
find_appropriate_src()'s inlined hlist_for_each_entry_rcu() walk of
nf_nat_bysource[h] (called from get_unique_tuple(), itself called from
nf_nat_setup_info() before the vulnerable insert). Both are static,
single-call-site functions, so they're fully inlined and never appear
as separate symbols =E2=80=94 which is why the crash attributes entirely to
nf_nat_setup_info:
373    hlist_for_each_entry_rcu(ct, &nf_nat_bysource[h], nat_bysource) {
   0x0000000000000daa <+2170>:  48 8b 15 00 00 00 00  mov    0x0(%rip),%rdx
   0x0000000000000db1 <+2177>:  89 c0                mov    %eax,%eax
   ...
357    return (t->dst.protonum =3D=3D tuple->dst.protonum &&
   0x0000000000000de1 <+2225>:  0f b6 44 24 56        movzbl 0x56(%rsp),%ea=
x
   0x0000000000000de6 <+2230>:  41 38 45 46           cmp    %al,0x46(%r13)
Basically, nf_nat_setup_info() is not CPU-race-safe against two
callers concurrently operating on the same, still-unconfirmed ct.

This kernel (6.6) already carries the fix for the analogous race at
confirm time =E2=80=94 commit 3a1ce9793855935a2d2b4d9dc5003d42f797f6fc
("netfilter: conntrack: fix cloned unconfirmed skb->_nfct race in
__nf_conntrack_confirm"), which detects this exact
shared-unconfirmed-ct-via-clone precondition and drops the losing skb.
But nf_nat_setup_info() runs before confirm, on the same shared ct,
and has no equivalent guard =E2=80=94 so the identical precondition
(bridge-flood/broadcast clones sharing one unconfirmed ct across CPUs)
is still exploitable earlier in the pipeline, at the NAT-setup stage.

We have not been able to catch the nf_nat_setup_info() double-insert
directly via kprobe so far =E2=80=94 the window there is narrow. We do,
however, see the __nf_conntrack_confirm() WARN_ON_ONCE ("Another skb
with the same unconfirmed conntrack may win the race...") fire live in
production whenever there's a race for confirmation, which confirms
the underlying precondition =E2=80=94 clones sharing one unconfirmed ct rac=
ing
across CPUs =E2=80=94 is genuinely occurring on this box, not just inferred
from the crash dumps. We just haven't yet been able to force the
earlier, nf_nat_setup_info()-stage race into a controlled
reproduction.

I think this needs a fix in nf_nat_setup_info(). Wanted to get initial
feedback before I start working on a patch.

Thanks,
Vimal
