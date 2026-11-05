Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793854523;
	b=ft4y2jybYt9uaw5MTdhJFZDc6dDM7uqFo50jmIoJfP9oo+3uvcAsInWxLMOZgypawbp7
	 WumQUPZAvrd0uCHgNQDFBZApnXWMghav4NxHo7sAQYFnHg5Opfw5fmmeJ/5jThK5YrKAg
	 n+lAonU/21XW70+LL3wpK9y956OsNBGCICG+r0/Y4jj3NEPiG8i67QkgGzR61/XxtmbnK
	 by4ZKjWcPJMx4CwRAbsms0C28rw4p9yjmw33QBOBoOl2ha3sQOP+OtwY0jIKrtNlSK2Te
	 jjQpD24Gcszsj6Ly3qLEip5r03GUwBY2Nzj9ySUHjHnkeWGiV7xiF0V+5bpBC/uzSZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793854523;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0K/OpJSJDyeiHFgRi2dD4j6fShhHweBIMHEcvs+4Jvc=;
	b=c9pPBsGw5/WdxzEWDxGyTssCp9TczJpz4/z1IV8dATIWrDBZQ78xwenZItQfNnoIF7Lk
	 zUnuMZdq1a9q6U0OH7mj9mJGKuy89bq/6Qdhi5yxfBMIuLwIjT6PJd6YroNejEySAlzO0
	 /xq+ZeVkzxlWHDfwWtOOuxNOPo866YLJpvPJIhSjWW5ipDVJRmTy/4N4XIY3CVNvO16ZZ
	 Xp2bW98VlrKFXpm3IcDx2anFKtrRtxlQSmEA+lOOiJXbdXdtp+zLjfwA2ODE1mfpuhdjS
	 giiftfQTnkKvmIpHO018CwF8nA1uHzJCI0khxzF95+udu5jN69mGmALLlDBya7SfYWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mTKYyYeV;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3A7606A328
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2026 04:55:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D3A7606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mTKYyYeV
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ad0c2e71ebso217396a91.2
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Nov 2026 20:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793854522; x=1794459322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0K/OpJSJDyeiHFgRi2dD4j6fShhHweBIMHEcvs+4Jvc=;
        b=mTKYyYeVr7uxttrPBh/zbgdicB4GtUsAEPY7xWdW42ONQLpFWniKAVmHzgolRVnz1R
         7cGjdcpTCPUuQy/A64lwRFiyY3CHLGj3nlqbK6AEQwT2zG7biKPOWYGbyqYZoXfGRvF9
         VMNjEFP/372eFVw5FbTuSsi8X8vRwpvlmPjZMD5VyyudE8jzRBB7z6J5DpdMGoY7Hq5p
         KRhkUg8+WaJVVEcdue/XWCVzhYJgAPz+7SROTuyUkDUJZGvY0euOB/3t+nKtd4g2liXU
         30ygp2YrQxS3ncCjh2vsNdYieq6M3aMH+1rBdw0W/ieO4AuFjVJakOI9Kr5nAz8+hS5n
         ycYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854522; x=1794459322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0K/OpJSJDyeiHFgRi2dD4j6fShhHweBIMHEcvs+4Jvc=;
        b=cE0/OwzjyuYN/O4oDfGdDltY37ub4FnUv6y40o+vTOL0sRuy2Hh7qV3jXCqSo676Bw
         iu4sKtJu4q0ugVNq5ZKK1iKik+DHZUQ9k+Y4wjM9xmmiPWFm78SmS3ulf9Dc+I5P0A9y
         +Z1loF0QuzfXlZo85vZNCzVCYN4I5S6bVDHC/ZT7NlkY1TRsX2nAkL+0Es5FMi2Ppvl4
         VGyuUrSdlikNBd6vuls+jUGeSnHHDhyD9ktUkl++Gwjp8jHC3xsOnCCvjIkjKxhdzdeU
         UP+1ryzL0zav0xyDjz2z4EPpirOrQb0mMWC3+rGx1+jqU/9Yn1rSySKN9MFA/UU2ai8m
         sSew==
X-Forwarded-Encrypted: i=1; AKwUvBx8wv7+VhQu/+ofWEVkJaAL//MQsMrHmmqANXE6822djgKHS8MJi7KAAadN8oJzT6aMCC99dZVrU8cZBpkbG1Q=@vger.kernel.org
X-Gm-Message-State: APuU4Z8L2ZqGKu7seLtsy4IVOlV5M0XShNlSFj8UcpNJM/V1PyXMrLDe
	KnVtwLQRB+8+3u0K5CLPbMJtOWx9jsaMBYTMWd3u/NkeuQ7ky9WiFF0D
X-Gm-Gg: AYBFou1jPLH+eCoU30XzKBCgYmUYcJu+2qJgezHZooWuYcZLI7/PG75deihpjbJcOQd
	hdvLgYogw4DG1C8Gin2sLTScSADHwXvp8idZXoSw4aaCLFDOawiWScCpoSAAJtPqJRbO2I/SlGe
	4iUm+0FbxVTvcMKqyK4EbuOzxFFfIAv46YPYn09G9DtmVfbFxHF489hai52evtFnW7Fz713iXnz
	2FYxdmdfLnWzKWAKzX1O3z3fLXEi5yGYjP56D1gNMRli8nIFLf8BgAoURX/cP1KJ6BQievT/vRT
	an8DfF9P0n9NtVWFLlyAtHKf7BwtEI4Nwc0y5MkNWaCTQDhUxRhmeQ2iRpX5hwyZ/PklyvLLQSQ
	A3xYsiysCmq7qp9Ig3cghgMaGs+GURSX6swkrhIbTyYPlSOiUzcMt7VIqwjzip1gnn0nX0jJMne
	uwfX2nbOwNuZ7K5aEF6ELcNRymAE3Pae+mfGvEux81r6z/a5hyLvy/fTcKfS7Ld+ZGcaGLCIkc1
	DaujihQsZYAvqZI6uFGA1fh/2moVgqi+8evMXFkQL62a0va/uLWt2ExQ7x4OemAqqgTZW1hX/ys
	JxvmMY0iws1xEhvtwOMvMQyWKD62V3aXV/LgrcmCTWx89sGrnDTTdR3A7EGt
X-Received: by 2002:a17:90b:4487:b0:3ac:9c37:9422 with SMTP id 98e67ed59e1d1-3ae89626108mr25602011a91.2.1793854521680;
        Wed, 04 Nov 2026 20:55:21 -0800 (PST)
Received: from localhost.localdomain ([189.1.242.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0944eb1d1sm3726000a91.0.2026.11.04.20.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 20:55:20 -0800 (PST)
From: Yiqi Sun <sunyiqixm@gmail.com>
To: fuchen.dust@gmail.com
Cc: coreteam@netfilter.org,
	fw@strlen.de,
	kadlec@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pablo@netfilter.org,
	phil@nwl.cc,
	stable@vger.kernel.org
Subject: Re: [PATCH nf v3] netfilter: ipset: fix double free on kernel-side delete during resize
Date: Thu,  5 Nov 2026 12:52:10 +0800
Message-Id: <20261105045210.1179991-1-sunyiqixm@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261026102957.5530-1-fuchen.dust@gmail.com>
References: <20261025090609.v2reply.4093.fuchen.dust@gmail.com> <20261026102957.5530-1-fuchen.dust@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I discovered the same double-free during ipset hash resize
and confirmed its exploitability by successfully exploiting it
in my test environment.

While reviewing this fix, I noticed two remaining issues with the
deferred operations in net/netfilter/ipset/ip_set_hash_gen.h:

1. Failure-path replay can resurrect a deleted element.

In mtype_resize(), cleanup clears orig->resizing before reaching the new
drain path. Packet-path operations can then modify the original table
directly, while earlier operations are still waiting in the backlog.

For example, starting with A absent:

  - During resize, a packet-path ADD inserts A into the original table
    and also queues an ADD in orig->ad.
  - A bucket allocation in the resize copy loop fails. cleanup clears
    orig->resizing and waits for an RCU grace period.
  - Before drain replays the backlog, a later packet-path DEL removes A
    from the original table and returns success without queuing a DEL.
  - drain replays the earlier ADD, inserting A again.

The final state therefore contradicts the later successful DEL. Before
this change, the failure path discarded the queued ADD, so this sequence
left A absent.

The set->lock around list_splice_init() protects the list, but does not
serialize replay with packet-path updates under the region locks. The
RCU grace period does not prevent new updates either. Could failure-path
replay preserve ordering with those updates as well as within the backlog?

2. The new deferred-ADD branch can return success without queuing the ADD.

In mtype_add(), the new branch for an existing element sets ret = 0 and
jumps to resize. If allocation of struct mtype_resize_ad fails there,
the existing "Don't bother" path goes to out with ret still zero.

For example, starting with A present:

  - During resize, a packet-path DEL queues a deletion of A, leaving A
    in the original table.
  - A subsequent packet-path ADD of A, without IPSET_FLAG_EXIST, takes
    the new branch.
  - Backlog allocation fails, but the ADD returns success.
  - Replaying the queued DEL leaves A absent because no ADD was queued.

This branch relies entirely on the backlog to preserve the ADD after
the pending DEL. Allocation failure should at least return -ENOMEM for
this deferred-only case, consistent with the deferred-DEL path.

Validation of the two review findings above used a userspace harness
containing the extracted add/delete functions and failure-path replay
code, with lock/RCU stubs. Both sequences produced the incorrect final
state with v3; the corresponding unpatched baseline cases did not.
The baseline was mainline commit 05441d697f7f ("Merge tag 'cocci-7.4-rc1'
of git://git.kernel.org/pub/scm/linux/kernel/git/jlawall/linux"). These
are deterministic control-flow checks, not reproductions on a running
kernel.

This review and the harness were prepared with AI assistance.

Thanks.
