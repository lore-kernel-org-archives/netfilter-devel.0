Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.176
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793962496;
	b=W46Hi4oE7DaKvrtwPJwSjITs9wZoZildXODASSYroahOzajNszXWqpk8iziubYqZCogv
	 KkkwWupWdWt1SwLE3HxrwkwtCs0MNn9IslHq9ZDCzV0iAtn94Yc6QZEKKvP4lEzIHK2ds
	 wGUXjMnonUOWkG+tyAUeRDcw0yUCFEY5a4xComzsRZpmM0m6t9l/SShwleUUpEuevqBun
	 yzc9rhn+inqNmHROO8PCLZ+0GPe+L+e8jQ9kuhqm6uULEqZ9uDk2abJC23ls2IOh6Z7YE
	 aevffLVvR7JG8i7a0pSDrZqSmNbsRFRBtnHo8bx9Krr4E2UccfkXlwjE3Usx3giabvA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793962496;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=TsxoI0LwfZFtwDpacdYtMtcxh6fkh2y3fKgq3Q8Ft54=;
	b=nR/bNwK6eD/TGRstb2D5wMtmvrVxyAyPhoaYp88ehLWRMCUtXDssSZr6MxWesnw1jLJU
	 0tXMTcb10fmW++cfZx+qZeACH1hOe/HWsyBArjGwySJpyC5DQBjTfEsMo+DJdkbd9IQlH
	 xQbZTxopW/TzcmQNb+NXShNSkMZpmL5FSc0GVRBQLel65aPUW5eKc56ro9grBTHhbgCFM
	 +4xM0ZOkQ/YHJ4RRL6MpMPZr0mKXcto6GcD2AV1dHfmDh/0B1f1R7XqTc436VG49ZIc0a
	 kqEgYd7slo4VJHGSxuanqN1I9XBLNhgsjVmjWemG1Hw18DOCVXXA9Ff86jEkdB3i4ig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CdI1hiHG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D62606A336
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 10:54:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69D62606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CdI1hiHG
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-36ff9c9da34so471522eec.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Nov 2026 02:54:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793962495; cv=none;
        d=google.com; s=arc-20260327;
        b=VuBtGbixYREbWtmnhWhEKhdD+JNmcpbPo739aMMuFVzZr+gPSVYZu+FnQM+5cSOB0T
         GJaJxDLpFnaR01EpFn+igYq/A/W5DahyBnBCjYf2hKmsfvD8D99YlUiGhZnZYeUzLL4l
         c5GrF9HoNqT4So8a3PuzBGa/w3Mix7Yf3w4KRwkQ1ig9lM5JLd7wu3sTU2nGDwT6IAce
         p78BudSnqq3vu3mvEvETzqf06idx+wDNEP95J5YN8ngUUuy5SD4xhDjGEj7wG8IQs3Dl
         K8r53tptDVB8dwVYnTw9HEYLFZV1vNqjZjuDKqn51mE3sZx0wuRCDY94vIGSqZERS2JC
         FRzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TsxoI0LwfZFtwDpacdYtMtcxh6fkh2y3fKgq3Q8Ft54=;
        fh=rKPHD65xw4fm8Eah2U6YCeRi9s/ZGxNrLF3JfAYUdVg=;
        b=CYtbO9n0eBoCICxFyJc5+X9qVxiLsBoOaThViMWNCVZVKSfbbkJDQqSKoZ0f33Lj2h
         DAtt0Nk0Uu/p31xDUSJKQGUh1JU3+atv+VQMbbNTvvE1TPslqzgG/Re/WkmCfTJZ/6SA
         nWaMDBLYQqzm6SqyhfOzsE39+u3H7oOSJRXqB5V4T1fWmVGFf7yDTN8ICDd6KdX4gKvE
         NijxP143rVlvPOPNSPk3pCTdpYKFlH1pg9P/3Vsiw2DRJ+FHLEigX0lkj1lP7CMwYzPd
         17SN3GM/KgGanzjqOa5S2iI7G2ZkCJacVTqcrwLEzwR6v5x5XMiIax1PsFgVDAsZM23Q
         mfCw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793962495; x=1794567295; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TsxoI0LwfZFtwDpacdYtMtcxh6fkh2y3fKgq3Q8Ft54=;
        b=CdI1hiHGP6qYMIXTiOP+DOU6zz3wk8+fZTtTKoxKPdPRqRGTci9HnG1pTu4TYchOb2
         8z1HDg8JIs2qV8s0BFWqiF+7AYyvTTZ31I3BRwzLkijidt8TmbCUkeVu53xJLyLXP1y+
         iXCom6pK7niZbH52vQqDFj5dG0smAZJ2koYOmavpDO9XCgxlmTq4J8cEr/kbSEnkgqBi
         /X6fcVh3N9F+elWZoy8p8tpJiVBAXGbx2qXj0JdD7tZNkHnRjqdTthH/tVcAKhw+qFdf
         e7VEIJsJJh9BaxiLn5JFGzBPXuR75alXt38XYmtmJw9QbumLtG24juSa2ckAFdA2uN2N
         CnNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793962495; x=1794567295;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TsxoI0LwfZFtwDpacdYtMtcxh6fkh2y3fKgq3Q8Ft54=;
        b=C3jXEr7L+jfItYH7b93/CtN18XyCYVV68Rew50VWgoH4PIc3WYoYFyk6pXCGLnlC3R
         UbRq756FPGcAyiF6LczhclwHTZRyi8/7avRzQxCik9/HZtVvVIgO+EnlWBzXFHcPpvP0
         ypBijbFuJLpl8exv/onXQTiVxjqkacp+xzoXtfyV6NhLZKrFsbNQO4RJwmpRJJa9WIsK
         gC811UI9ODbZAiGS8w35DaroyuF0OlZ9Lu6Ns8AcmW8vM2PSSaZaiD2S46uyTOs0woWg
         T70zAyvDyTIW/3HF9VrS7WDB4wJa9NNcoTAUjctn1iCxRbqcytsOFilyvn6cV1DmJgnZ
         Ip8Q==
X-Gm-Message-State: APuU4Z82Ans81WT2vwKH05RTjVGpwsdcO344+L/ohnGgqbCmmHWixtPo
	wDdgEHroqct92ZObmoDxj+2DHxOvrgG45ASSkav5oEtMHdr4rpNmdCI7JzM7AP9ScoymX74eHwm
	w5s8gww76wAdnLkL/gHBqmNbg6RwnC4hBOaevlQ==
X-Gm-Gg: AYBFou1yNu4RyiNDDTfFUlkjVj0ljLI8vVRX8MDSxIx21H8kM5ssgIWk/WUZ6ULgv/L
	Q7330zfhXgmzLq0i4KpsLYEsWF5sffUOIPHVKVCpDtZwxyrw9W+8Fae+Seooa5kcvTbcT67lJ1x
	JfTsu1R2QzZHYqEM7jmugUcnLQfkNFcPtCflEEMrg5woGXR1jp9zddd5HcXZOvrDJfg6BzOOzDt
	+YzOTgXTlvTVK9EgDSFWDDjeIOQWibYq51nD36i+KYmDGYaSTQgwXRN6PLrZjDPE++ffUf+Saqy
	x9c7MkeOJ16V+xbNwM2HhnWWs1g1ohcdaY35OCYAyi4Jt1gUfoI5W035riOdCZGtYZ3k5BBsVlL
	AbDXjrxgoIREolyHDpHrKXFeYcPfkTrPne/80vl+ZBtm1oSfxhO8LN5yBx19UHE+2icarFyY1yr
	hc2TWQI5+ZazcmHYpFY9tn7sXy1vLNZYevzU3s2zx2x1X3ZVrEBoHV2KMIq8u6E3B9gbepkjFoe
	iIi2o2o2azPL+fx2M3LGC1ZXCvZl2WYIq1vasFTliGSb10vLCnVdXKh37kCNY7F+6nHAQpVPKE6
	PFv/dpHO6ZLtDtQ=
X-Received: by 2002:a05:693c:26c6:b0:369:fa21:ba0b with SMTP id
 5a478bee46e88-36f7691f2f6mr2947794eec.33.1793962495226; Fri, 06 Nov 2026
 02:54:55 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAPGrzGkjouOeqOcy4pXbBgx58DWvZpqK8ppuChPsDsXKvxp4RA@mail.gmail.com>
In-Reply-To: <CAPGrzGkjouOeqOcy4pXbBgx58DWvZpqK8ppuChPsDsXKvxp4RA@mail.gmail.com>
From: "S.S.Vikash" <arisivikash@gmail.com>
Date: Fri, 6 Nov 2026 16:24:44 +0530
X-Gm-Features: AclHuK8te_N1-j7Yu7yM63ZycwFL0yMmLPB3kYJpOuJpfoUGzhFJLCMWOrhhUlc
Message-ID: <CAPGrzGmWbQL1gNDoUEDoMoOaGfr9SU9Yd=dbRGokGFR468L5eA@mail.gmail.com>
Subject: Re: [RFC] netfilter: conntrack: early_drop eviction limitation under
 sparse table configurations (max << buckets)
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de, pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Correction: The results table was mangled by Gmail
formatting. Reposting the results below.

nf_conntrack_max=3D4096
nf_conntrack_buckets=3D262144
SSH: Failed (drops)

nf_conntrack_max=3D4096
nf_conntrack_buckets=3D4096
SSH: Established

nf_conntrack_max=3D65536
nf_conntrack_buckets=3D262144
SSH: Established

nf_conntrack_max=3D262144
nf_conntrack_buckets=3D262144
SSH: Established

On Fri, Nov 6, 2026 at 4:23=E2=80=AFPM S.S.Vikash <arisivikash@gmail.com> w=
rote:
>
> Hi,
>
> While investigating connection tracking exhaustion behavior under a spoof=
ed
> SYN flood, I observed that the effectiveness of early eviction in
> net/netfilter/nf_conntrack_core.c:early_drop() degrades significantly whe=
n
> nf_conntrack_max is configured to be substantially smaller than
> nf_conntrack_buckets.
>
> Setup & Reproduction:
> - Host kernel: Linux 6.14 (Proxmox host)
> - Workload: Conntrack table saturated with non-ASSURED, unreplied TCP
>   connections generated by spoofed SYN traffic.
> - Test: Verifying whether an inbound, legitimate SSH connection can be
>   established while the table is at capacity.
>
> Results observed:
>
> nf_conntrack_max       |   nf_conntrack_buckets     |     New SSH Connect=
ion
> ------------------------------+-----------------------------------+------=
----------------------------
>               4096              |              262144
> |         Failed (drops)
>               4096              |              4096
>   |         Established
>               65536            |              262144
> |         Established
>               262144          |              262144                  |
>         Established
>
> Root Cause Analysis:
> In early_drop(), the kernel examines at most NF_CT_EVICTION_RANGE (8)
> consecutive hash buckets starting from the calculated hash index.
>
> With nf_conntrack_max=3D4096 and nf_conntrack_buckets=3D262144, the hash =
table
> is sparsely populated. Since early_drop() examines only eight consecutive
> buckets, it can fail to locate an eligible entry even when many non-ASSUR=
ED
> connections remain in the table. This appears consistent with the connect=
ion
> failures observed during testing.
>
> When the bucket count is reduced or when the table density is increased,
> early eviction succeeds reliably and permits legitimate inbound connectio=
ns.
>
> Proposed Improvements:
> I am interested in addressing this behavior upstream and would appreciate
> feedback on which direction would be most useful:
>
> 1. Diagnostic:
>    Warn (e.g., via pr_warn_once()) when nf_conntrack_max is configured to=
 be
>    significantly lower than nf_conntrack_buckets via sysctl, notifying th=
e
>    operator that early_drop() heuristics may become ineffective under loa=
d.
>
> 2. Documentation:
>    Update Documentation/networking/nf_conntrack-sysctl.rst to document th=
e
>    tuning implications of sparse hash tables on early eviction.
>
> 3. Algorithmic:
>    Investigate a bounded improvement to candidate selection in sparse tab=
les
>    without introducing unacceptable CPU overhead on the drop path.
>
> I'm happy to prepare a patch or provide additional test measurements base=
d
> on the discussion.
>
> Thanks,
> Vikash SS
