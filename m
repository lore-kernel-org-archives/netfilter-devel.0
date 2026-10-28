Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793177864;
	b=fSRVlxU9uj3xulq1K//4OY6saE04y39EEHlWoqMLdzY76QGlhtBevoJryzXsPod7pquo
	 f02iBaJ5qVUgDBk7aslZS3B2ClgLdFFj4RVoZ/nrv9z+tWPftrRUTRVYCUOJGL6sD5REw
	 c0ubU3xrDt52O7Yeq7dScUGgaMuzmBbOXqZGV6yeBh2wopho9MlH8e+E4d9w/IZPi5Qoa
	 fhIKOic9F9IgYyrjsHLFVD1vUsPcDfE9ziiryyaCzbG0vhJ2ICnggQxDbayWF8ZRoqscp
	 SeB2IagyrGcquNinbGZ5TvUTLfjkEIS9NaJ8w66kqhaDaLVjKKUz3tG8qYz2atQ4Q7Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793177864;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=08u/naPLoGSWQfRVtBDJmWzl/kLcQQnEOKD0pTU57IQ=;
	b=g7maTxjfsOlIQyLJj9vZLjSEQjz6brsbrX7l+6VK2KNcaq0tAnsP/MjC9ABAAtLPVsFL
	 gKIin4OLzbjgeKnKwrLxZeleHRXqvc9R18qy3DNf3cQ+2gYhYDBVsn+IuM1/rxk4u/X3s
	 RavUQ2VeISHi9/X2ZSj8gwPUs6vUIMFYnEqvW8QqAReNABmp0VjuzpPTfYc0vEXLfpL9B
	 0KCVnrmT+kymQrP2ZkONRHpfYUMgtzBj99e332pnfIpjVrcIiOon4tuGpjppeOPCcGYHj
	 bp5at0C4QpGMqSakFdz7qbargIQzo6TWg+u2AM4+Trzgy6yk7QemcrVsH7NN/hxyNdw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Dgk4796U;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AF4606A320
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 08:57:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74AF4606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Dgk4796U
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48b060ec084so398757f8f.0
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 01:57:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793177863; cv=none;
        d=google.com; s=arc-20260327;
        b=TYtInc4E5SlkiTFbPsyNnUkDW/8emS4PCw40gW7SgcXzC54ftoKR9V98MIDfor+3C5
         oPXFJc9cs9KtHrInxYCoQPS2UWSm5138Top/1X/eF6McMFAImX3QiWdml2SWpbBTmeKD
         1gGFc7XO7rXqGUAZo/tpGDyPB2QC+l+AJiDLp/aiuyj6G2vgCiPtGBZ7tLXPkfKnXU71
         kUCQDjDAvNOt9OXLBTwTNI6iEFNP8bXMD88ruZYoaSuoGC/VfTnuT3p69kV+AMaDCKgo
         z0l0wY21EezZkh+fkbg3FZPB6bRqlDsyClJZNjgtfYFKFEMrEGinfcWgt8bVV2wtE5mk
         GcrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=08u/naPLoGSWQfRVtBDJmWzl/kLcQQnEOKD0pTU57IQ=;
        fh=DOgUi1oejN42IITs1qwLYelF14IInP1MaKQTj/R9W7w=;
        b=EYuwYtMbQ6rytFdoUVh+HR5gFV8cnbkh+BTG3hKPxDulp3NT9xMVbc1KA+fqyFLGx9
         bdSlaBBfJwh9+FZJorZ0bst3JxREGTbREanAQTGFeXA+JbhmMlM8ElxgPs18gi2ayQ6E
         SEBdieXETRu4ZWO2fGuf1ily1HGSodm8I/Ks0Ffki3js0gFMSdoPupCOdfVADpeOdeHB
         HivBEcqxZOfAXoafZvfLnZkc+JilQbsuW2TMnUdTH1ClGGBOYd0K7WfUjC4kh5pZurSs
         euiWzwQHhB2hdzGTYT2M40w+QPl/yF4Yv9FQ5xZrZ+xytXnbuABkzWvIiIua1MO5SUnb
         n73Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793177863; x=1793782663; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=08u/naPLoGSWQfRVtBDJmWzl/kLcQQnEOKD0pTU57IQ=;
        b=Dgk4796UjzbIKnvQkPtIisiTc0U//ggCtY3On+v5ygPSZ4VS6GK8J7r/X+FqtO67y2
         eeLllTrl1E2Dri8lqrakM6fN0McF9uA0fVYw0yHflEYj5Ru5wGcEXm3a9BOb63NeMqqM
         5X5IgorCn1m8sRKE43u0udgW1tnJM+Kdk5Pzu1cRmJf3Tx1yptNZp2Y1nZI31M218l4Q
         4mQZYsSx6VDL+GbV9fS6e6qMsaW8CyjJSI55qktKIC5gCpbmc6VESbxypSXOu2CFFBkW
         s+zgDiOvZjnhq8PtIa017Z2ot+WQoY9GLus7mU575TXcrT8vvAPlMwqA/s7Eg0bsBsk0
         Fgrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793177863; x=1793782663;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=08u/naPLoGSWQfRVtBDJmWzl/kLcQQnEOKD0pTU57IQ=;
        b=mPB9r1khiARcZSXUq4SpUpy708qRqYw7QKUVb5dfW4NXg9Ol8T8dCFC7T2Ca+8UdZ9
         Z9UMIOEDRr6dGxjCJYJugWpbmUcxvIa9d/yJG7s73na8fMuNGk81D3f5rs1k2zQPWYwp
         ZsacWJA9H+AZ3Rt4T/dLgZ3ZPcdReOMcp6jSQb3gvz1Xfq2Qc9JvIXyBtsmyrLW+JVDu
         UDxZPIfhiAJkVA/aszkK7TNhWYDKcAd9hPIDMMHF+sbFL6Ts3J310WJqwlRLVZ+ziqEE
         s0A4VytcTBeKdEoAbcuSJwhJ4V4PszkRYVS0iCZ2C1cn3UCCJEKlkbv4FXaGtRkpkp6h
         Xv+A==
X-Forwarded-Encrypted: i=1; AKwUvBz27iYq8ARg9gJLLq1QJZMLv6hjXrprE4rhvt/fSo7HK0RhBy6o9ak5+f0FKPXi90a2Tm8STzB9tehI18x6Ing=@vger.kernel.org
X-Gm-Message-State: AFq9FYKnroxMVWwUIIw+qxAb2aKtHEmc+2QtTKU8VbNl1MgnuqObDMeR
	We2oaLE+ayk7HUzLxlKaCMZ31XXi3Cp4FGpwZlA5WHzQXz5BMhlHQhlIb9dnXFg4ZByKFX/Ma10
	WtW3icRpmFwhFR14ptTcTJfSHCCNQipI=
X-Gm-Gg: AYBFou0rR0l0LUg2otqQ5nY2RQQOsIeJLDoMAGYuwTF/p2VJwpTlWVO8Nf+ehAQJQxG
	MdqxQBRO7ie5gSLh4iqCJ3l7tWZtJQYukC203mNmrAFG2pbuCXyfgE7rNgXOYJ0bPvn7Y/cFkfA
	5ldTt0gqW4ZKi94r5AhP6X9a/ugtidL9uq9Tph2gWJg20ZtCbOR3LYQtTkObl9QlsitKO+5VxUF
	TGMBpxOyUwa2HPYnQk+YQ50lMoTELQYiLiCADv4+nGHe7i2TJjOZSOEIqCHcJeQHmSkoO0rlAnf
	dGt3X0yRtzXNTyyDgjU+Ewxb7S3gxCPnklgiDy+fkYQIx7rSVA1doNwU8JRzEeUm+P6XDnNDb/h
	3If8o63jRkO/yJcvjg8Zdr4G/2A4VqivuXx7e
X-Received: by 2002:a05:6000:220a:b0:48e:2371:3835 with SMTP id
 ffacd0b85a97d-48e5d5b3d3fmr4159196f8f.51.1793177862485; Wed, 28 Oct 2026
 01:57:42 -0700 (PDT)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <9fc5fe14207146a4a9d12c12cf17e652@yinwang.com>
In-Reply-To: <9fc5fe14207146a4a9d12c12cf17e652@yinwang.com>
From: "Avinash H. Duduskar" <avinash.duduskar@gmail.com>
Date: Wed, 28 Oct 2026 14:27:30 +0530
X-Gm-Features: AclHuK9ozOQ3KOrEItVzcMw36iA_w0IxIYWqOLRoXcd4OJQt1BipmcX362wbxVg
Message-ID: <CAEDmbkEWNz_sDF9hPN3WNrxX8VLnnDOJio=xtFjXVAq_xmLJfQ@mail.gmail.com>
Subject: Re: [BUG Report] UAF in ipt_do_table() on table replace (v5.10/v6.6)
To: "huangwenqing (A)" <huangwenqing@yinwang.com>
Cc: "pablo@netfilter.org" <pablo@netfilter.org>, "kadlec@netfilter.org" <kadlec@netfilter.org>, 
	"fw@strlen.de" <fw@strlen.de>, "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>, 
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, Phil Sutter <phil@nwl.cc>, 
	"wangli (D)" <wangli2@yinwang.com>, guxizhi <guxizhi@yinwang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Can you post the OEM kernel's diff against
v5.10.43 for net/netfilter/x_tables.c, net/ipv4/netfilter/
ip_tables.c and any vendor module that touches struct
xt_table_info?

-Avi

On Wed, Oct 28, 2026 at 8:06=E2=80=AFAM huangwenqing (A)
<huangwenqing@yinwang.com> wrote:
>
> Hello,
>
> We hit a field panic in ipt_do_table() on an OEM kernel based on
> v5.10.43 (arm64), several times per fleet per week, sometimes as
> reboot storms on the same device; in most logs netd /
> iptables-restore had run 0.7 to 2.2 seconds before the crash.  It
> looks similar to the ip6t_do_table() use-after-free that motivated
> cc00bcaa5899.  Field logs are customer-confidential; a sanitized
> representative stack is at [2].
>
> Root cause we suspect is as follows:
>
> xt_replace_table (setsockopt IPT_SO_SET_REPLACE)
>   table->private =3D newinfo
>   /* ... wait for even xt_recseq on all cpus ... */
>   for_each_possible_cpu(cpu)
>     raw_read_seqcount(&per_cpu(xt_recseq, cpu))   // scan misses a walker
>   return private
>     xt_free_table_info
>       cleanup_entry -> string_mt_destroy -> textsearch_destroy
>         kfree(pattern)                            // old table + matches =
freed
>
> ipt_do_table (reader, packet path, e.g. INPUT softirq)
>   addend =3D xt_write_recseq_begin()          // seq -> odd
>   private =3D READ_ONCE(table->private)       // still the old table
>   ... walk the whole table ...              // reads freed memory
>   xt_write_recseq_end(addend)               // seq -> even
>
> A reader that fetched the old ->private but is missed by this
> single-pass per-CPU scan keeps walking the old table while the
> caller frees it.  Note xt_recseq is a seqcount_t used with
> inverted roles: the entity marking the count (ipt_do_table) is the
> *reader* of the protected data, the data writer (the replacer)
> only polls the count, and nothing anywhere does
> read_seqcount_begin()/retry on it -- it is a hand-rolled per-CPU
> quiescence wait.
>
> We reproduced this on vanilla v6.6.160 + KASAN: forcing the miss
> once -- a single debugger write making the scan read "even" for
> CPUs whose readers are still walking -- reproduces the
> use-after-free with high probability, and the other in-flight
> walkers then fault concurrently, ending in the same panic form as
> the field (setup and method in [1]).  Without the flip we only see
> long-tail wedges (replacers never returning from setsockopt()).
> The flip does not prove the scan misses readers by itself; the
> field crash is our natural occurrence.
>
> History we may be misreading: cc00bcaa5899 (Dec 2020) converted
> this scheme to RCU to fix a reported ip6t_do_table() UAF, was
> reverted in March 2021 (d3d40f237480) because synchronize_rcu()
> slowed table replaces by an order of magnitude (200 iptables
> invocations: 1.16 s -> 11.59 s), and 175e476b8cdf then upgraded two
> of the smp_wmb()s to smp_mb().  Our OEM kernel and current mainline
> are both in that post-revert shape, so the field crash happens on
> a kernel that already carries 175e476b8cdf.  One gap it did not
> touch: xt_write_recseq_end() still only issues smp_wmb() before
> the even store, leaving the walk's loads unordered against it.
>
> Maybe the destruction of the old table could be deferred with
> call_rcu() (as nftables does for replaced rules), which would keep
> the replace latency as it is today while removing this whole class
> of ordering subtleties.
>
> Does anyone have a good idea to solve this problem?  Also, is the
> single-pass scan believed to be correct on all architectures with
> the 175e476b8cdf barriers, and is the end-side smp_wmb()-only
> ordering known or considered harmless?
>
> Best Regards,
> Wenqing Huang
>
> [1] Reproduction on vanilla v6.6.160 + KASAN (QEMU virt-aarch64,
> 16 vCPU):
>
>     Kernel: kernel.org linux-6.6.160, arm64 defconfig +
>     CONFIG_KASAN=3Dy (generic) + CONFIG_KASAN_VMALLOC=3Dy, booted with
>     nokaslr.
>
>     Load: per-CPU UDP senders crossing a filter table with ~45
>     xt_string rules, plus processes looping
>     setsockopt(IPT_SO_SET_REPLACE).
>
>     Trigger: the window is narrow, so we forced exactly one event
>     with a debugger.  On entry to xt_replace_table(), flip the
>     per-CPU xt_recseq of the in-flight walkers odd -> even --
>     i.e. make the scan read "even" for CPUs whose readers are
>     still inside the table, the event the scan exists to rule out.
>     This is the single debugger write (no memory poisoning, no
>     page recycling); everything after it was natural: the scan
>     passed, the old table and its xt_string/textsearch allocations
>     were freed, and the walkers still walking were caught by KASAN.
>
>     Full report:
>
>     BUG: KASAN: slab-use-after-free in kmp_find+0x188/0x294
>     Read of size 1 at addr ffff0000c81b8934 by task init/146
>     CPU: 4 PID: 146 Comm: init Not tainted 6.6.160
>
>     Call Trace (access -- an in-flight walker, softirq INPUT path,
>     entered from sendto -> ip_output -> loopback delivery):
>      kmp_find+0x188/0x294
>      skb_find_text+0x130/0x198
>      string_mt+0x6c/0x94
>      ipt_do_table+0x494/0x7e4
>      nf_hook_slow+0xa4/0x148
>      ip_local_deliver+0x264/0x29c
>      ip_rcv+0xb0/0x188
>      __netif_receive_skb+0xac/0x1cc
>      ... process_backlog -> net_rx_action
>
>     Allocated by task 151 (the table install):
>      __kmalloc+0xb8/0x10c
>      kmp_init+0x54/0x2bc
>      textsearch_prepare+0x128/0x18c
>      string_mt_check+0xac/0xcc
>      xt_check_match+0x3c8/0x42c
>      translate_table+0x824/0xb40
>      do_ipt_set_ctl (setsockopt IPT_SO_SET_REPLACE)
>
>     Freed by task 150 (the next replace, tearing down the old
>     table):
>      kfree+0x58/0x78
>      textsearch_destroy+0x5c/0x6c
>      string_mt_destroy+0x30/0x40
>      cleanup_entry+0x124/0x1f0
>      do_ipt_set_ctl+0x800/0x8f4
>      ... __arm64_sys_setsockopt (setsockopt IPT_SO_SET_REPLACE)
>
>     The buggy address belongs to the object at ffff0000c81b8900, 52
>     bytes inside it: the kmp pattern configuration of the old
>     table's xt_string match -- the same object class whose bytes
>     appear as wild match pointers in the field logs.
>
> [2] Sanitized representative field stack (OEM v5.10.43):
>
>     WARNING: CPU: 1 PID: 0 at net/ipv4/netfilter/ip_tables.c:305
>               ipt_do_table+0x48c/0x6c4
>     x8 : 0000000000000000            <- t->u.kernel.target
>     Call trace:
>      ipt_do_table+0x48c/0x6c4
>      iptable_filter_hook+0x30/0x40
>      nf_hook_slow+0xa8/0x1e8
>      ip_local_deliver+0xa8/0x17c
>      ip_rcv+0xfc/0x15c
>      __netif_receive_skb_core+0xe58/0x114c
>     [1.3 ms later]
>     Unable to handle kernel NULL pointer dereference at virtual
>     address 0000000000000030
>     pc : ipt_do_table+0x2d8/0x6c4
>     Kernel panic - not syncing: Oops: Fatal exception in interrupt
>
>     Eleven captured occurrences all fault inside ipt_do_table(), at
>     neighboring instructions of the same 0x6c4-byte function
>     (+0xfc/+0x2ac/+0x2d8/+0x338/+0x48c), always from packet
>     processing.  In other logs the faulting addresses are wild
>     non-canonical (e.g. 0xffffff9c71769000), and in the clearest
>     ones the in-register match pointer contains bytes of xt_string
>     pattern data while the entry pointer is tens of KB past the end
>     of the table blob.  Six product software versions from 2024 to
>     2026 share the same kernel image (same faulting offsets, only
>     the KASLR base differs), so this is a long-standing defect.
>
