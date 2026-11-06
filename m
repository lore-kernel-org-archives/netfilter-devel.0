Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.175
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793965982;
	b=l/JEdSMSLDGAcLctJ0tiarAQMRPRUBsCiTfxG8+whpVvMMW1j0zhhowlQuY07IkyfSPm
	 Zsfnh+9rBIUDY/sidWZSZ4qY1R+2QLRaWqQA2zll7Ep7rWfg9H46eN0Q7nwzsqhH2i/0g
	 kBY57oqU3OAL5mgzcUqmqR1QaAJCoJ/5noPvr7QvXNiFkvOPU68Fv0fr3mvbron3pYpj9
	 vxCIrkUL0jyfi93CluPfZUQ36IUwko/RCfIO4HuOEPXICmOvEt3WgH0Jn5hBXBG4eGwwB
	 1QdkRHCca194cQSFK7h4AaPlUQrX/69mRc8exE4YaFpmS6i+hCCjS++1lFV+q8H626Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793965982;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=1ZhAooC5Nf//Cb11weQtPgcyMRwI8NAZ0TW+ZgmLeOQ=;
	b=XG7vFq2Qdc2YpzJyNcQcgsTh3NVNtMZzIOfD5Q4Sfls/6gI/SGD2mwdSpPDeJBIY8/0v
	 gcxYrse9qFlWfTvC+cSyYHf7i5/XVB0yWQke68GP2w5+VlJIxTtORialEq7TmsLtxYJ2z
	 4e/D43G0Dh64Mln8wR9YcQOs7RIHLFiO6fchDmRtIpKEZNCpSWkoFyJGLRgO7hHGa5Z8Q
	 gdBauc9nvZrltCq3MbC83SpIflg8WavO+V7RVbzS/hY+3KrZfysE8jLx1VA1h2OW6AQUR
	 7ly4pibw2aY6LV36oaL2DUCEAZrwYYxFvOMrQZDYJebUcTZl/8m0vGb/9Atjtvz5nxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qK8soAVW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.175
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E116D606A326
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 11:53:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E116D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qK8soAVW
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3514b90bb89so1093905eec.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Nov 2026 03:53:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793965981; cv=none;
        d=google.com; s=arc-20260327;
        b=l2DY7VLGK94P7QcpTeZeW0/ylR7ud+I0BjOS4VtEGsr8Ij2lMwzIJjKFTuEvCoMMmC
         3+s3KpYczZMdNtqmjDqLHxo7EyOrGdJHgCKPsU2TtRDzXDaFVsGb5CD53eJO5Vo3zr6r
         7/uJjeA5CqBZWoTtna8bYxyUWkQ7uWmFkO11Lb+UKSYKjdXu/Qtu4Gk7syHb7ZQ65B2A
         MDuRCFNCCzFndqx5WZ/k+35LdT1t90+GdGQEUHc1fBSAnZ93Q+0pP6F/KIv1HHOeDNUt
         t4nSEjXRQgLmwh1PpcbvjVJj/CqSgqEoVxOxpaG+TIt3JNw7FyMCgH0Oz4eTZwfCJMRX
         WjWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1ZhAooC5Nf//Cb11weQtPgcyMRwI8NAZ0TW+ZgmLeOQ=;
        fh=iCjVDsbW9GMWkouiosnpqntZ8wkDB0SG4Dkaz0NZRz4=;
        b=bo493ExCBvY4neAVYl7m/LcKGnIZep2YeEzlEM4DfODe/rAXoWEHnbdVPKoI8e1caX
         HlEk89qg6rH2Fxz+v9N4k5UDVzWZ4ao2gsxOliCfKeGFqQyQhdQQMcYcXhVvW5NSkGHL
         UxCRS3hWxTJw9M6xwbn2HbnUb8wZ3CejepEkxg0cqb4HDtp8xbFJaPvMvgs1GrdFMWbP
         bH6hr3Hqai2zSePlI4engEbF8OqcswmJAdAjowMjUECaSLfPahtQ0Pq9tPiRifLOmWAv
         mnz46twfRwDa895Figr4nupqkl+QjTUa8/zB3eLAo9dwO9Hmg9hQ4mmR3+0o8XpYsB3u
         QN7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793965981; x=1794570781; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1ZhAooC5Nf//Cb11weQtPgcyMRwI8NAZ0TW+ZgmLeOQ=;
        b=qK8soAVWGjsCjz2KdY/0n3Ck8AUp0QgCSNfXoDKmCQ3jPtVn5zzKbPhbBuIK3z717R
         jhZFKosfCNV39l7Y6Fu5TF2CM4dIRetd4aSGosQ/vP8zg+fa8PUIlvIBE6//68XtnrEg
         GN7FDbFh1JlQXH1qmzL6V3i8eK2LgedR/tV9gPCGuRs1vH7hnUtSV3k/bOIRzUTX/Dd8
         jaeTrTwqtEGkuBhSNRitBXurZgG691JCLyiZ+VBpNtUJAVZt+S2oLRdkQsNQL9TmeTti
         pJcSj8SYdfT1xTJv0WCpS89O6JCh1iymXmRustKDaizuFzzD1825ds4lPpUbeRKYUicF
         lpQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793965981; x=1794570781;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1ZhAooC5Nf//Cb11weQtPgcyMRwI8NAZ0TW+ZgmLeOQ=;
        b=rQWJeYk0HcHfgAMEqNR3nwooZtep5r8KTqdYWcd3V83gIIYXc2nIAVR+fBrHzkDzfU
         uG0ItnCnlEnUQ/WNDaln2PPFpljctvAT6jUo1UEDuHdDsR22fjk9DN6jZH4negZZo4rV
         S0AbeIA0vHWEfQETtGqLDIaVwBIUtXSSzPzFMnALfRgErSPAbsspXUJ/wlKDNcu9XFcL
         fya6GbmERWZqHXJlyXa8fI8iR068+i68KDA+gVc2vqIucqomJHWUgEkblCsf2AGVXQcL
         jy/qgDrwKotzMoVMQb+sEmv9aEx3a/3nC/KGBX8aV2RiUXWSZoTWWpJa6YpT3tW4DPRd
         ah5Q==
X-Gm-Message-State: APuU4Z878an8P4hIy1zihpl1wBDB6ogEMjIHL+6LTPzIJJ0AG3Z5BDCi
	9dE91aufVKYBKuwBJsbbevv/GEzYeBdKjhQ6XA33RkoLZy8If2fnwfZVYc0ztIMZigVYRs7sPBB
	737CnEyuGM4RAhI0BpRFOhzkG7TXhCQ==
X-Gm-Gg: AYBFou3ak03kR42fi5FuUwcXqXAzkXWAoz5EP1VEoYSFLXoSAlV2t5cSc07KaAAKSiB
	oD/0QHpQzfDrdHQ8sVa9kklRgGQmcr63O6jBP4Kywvfr2edvqymyAmUujUSSGUf/PcXpqbqwuut
	MxJm2iifepvpNBRDCASqhZqSGkXSKQBChH/siBiYFxQxIkJyCj9T+1rKZ0VvD3A4LGZhDqYSO51
	YiD+GWqbqpFG+jHelHo1rLH3pz6+XariHbfQnXsaNvgQvb4278DoG0Q8Bm3Psi+01KtMjCCMrIQ
	yRhvm7Z7kQjgx0fojaPxSdDjlDuARe0297A5UCk6S39LWODxLev/MSsk/tv25wKDbxQzBY7+52g
	IS9vpBH15p1IQTLiUuTe0E6gdWTQ6OG9w9oaCH3P36r0p0zSpBCEqJsWHHikfWlMFI7/ak2jAco
	Bp2f1290hiOIWm4AeViolP7gRL6Nx7E4Q6lknHzAF2rw+rX3xfwj7Mz9DZRiuuVkPvA0iLPGirR
	Cp/wTxP1C/1dmHgQVuj3AKsd+6XbAP1PV39kVEdcuzgOuS12xNdWnw2vgY9gN8vdfUJ4Q==
X-Received: by 2002:a05:7300:f58b:b0:36d:48e:82de with SMTP id
 5a478bee46e88-36f76813819mr3133684eec.12.1793965980836; Fri, 06 Nov 2026
 03:53:00 -0800 (PST)
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
 <au28uheXr_lsEhzY@chamomile>
In-Reply-To: <au28uheXr_lsEhzY@chamomile>
From: "S.S.Vikash" <arisivikash@gmail.com>
Date: Fri, 6 Nov 2026 11:52:47 +0000
X-Gm-Features: AclHuK8U0WVynJ2ir9OIluovQKJ2-hSn_fZ70Ci7hCbSXdnHTeOvZMyiK4_AkoU
Message-ID: <CAPGrzGmyVKDYsQV1vyN-K5Y6FJ9U+T_DvkDXnR6Ju0W-5Bk=dQ@mail.gmail.com>
Subject: Re: [RFC] netfilter: conntrack: early_drop eviction limitation under
 sparse table configurations (max << buckets)
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

I understand your point about the suboptimal configuration.

I came across this behavior while experimenting with conntrack and
investigated the source to understand why it was happening.

I'm relatively new to kernel development, so I appreciate the guidance
on what would be useful upstream.

I'll start with the documentation improvement.

Thanks for your time!

On Fri, Nov 6, 2026 at 11:40=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> On Fri, Nov 06, 2026 at 04:23:08PM +0530, S.S.Vikash wrote:
> > Hi,
> >
> > While investigating connection tracking exhaustion behavior under a spo=
ofed
> > SYN flood, I observed that the effectiveness of early eviction in
> > net/netfilter/nf_conntrack_core.c:early_drop() degrades significantly w=
hen
> > nf_conntrack_max is configured to be substantially smaller than
> > nf_conntrack_buckets.
> >
> > Setup & Reproduction:
> > - Host kernel: Linux 6.14 (Proxmox host)
> > - Workload: Conntrack table saturated with non-ASSURED, unreplied TCP
> >   connections generated by spoofed SYN traffic.
> > - Test: Verifying whether an inbound, legitimate SSH connection can be
> >   established while the table is at capacity.
> >
> > Results observed:
> >
> > nf_conntrack_max       |   nf_conntrack_buckets     |     New SSH Conne=
ction
> > ------------------------------+-----------------------------------+----=
------------------------------
> >               4096              |              262144
> > |         Failed (drops)
> >               4096              |              4096
> >   |         Established
> >               65536            |              262144
> > |         Established
> >               262144          |              262144                  |
> >         Established
> >
> > Root Cause Analysis:
> > In early_drop(), the kernel examines at most NF_CT_EVICTION_RANGE (8)
> > consecutive hash buckets starting from the calculated hash index.
> >
> > With nf_conntrack_max=3D4096 and nf_conntrack_buckets=3D262144,
>
> makes no sense to make to configure it in this way, there are well
> define rules aiming at maintaining O(1) in hashtables and this
> configuration is clearly suboptimal.
>
> > the hash table
> > is sparsely populated. Since early_drop() examines only eight consecuti=
ve
> > buckets, it can fail to locate an eligible entry even when many non-ASS=
URED
> > connections remain in the table. This appears consistent with the conne=
ction
> > failures observed during testing.
> >
> > When the bucket count is reduced or when the table density is increased=
,
> > early eviction succeeds reliably and permits legitimate inbound connect=
ions.
> >
> > Proposed Improvements:
> > I am interested in addressing this behavior upstream and would apprecia=
te
> > feedback on which direction would be most useful:
> >
> > 1. Diagnostic:
> >    Warn (e.g., via pr_warn_once()) when nf_conntrack_max is configured =
to be
> >    significantly lower than nf_conntrack_buckets via sysctl, notifying =
the
> >    operator that early_drop() heuristics may become ineffective under l=
oad.
> >
> > 2. Documentation:
> >    Update Documentation/networking/nf_conntrack-sysctl.rst to document =
the
> >    tuning implications of sparse hash tables on early eviction.
>
> Documentation is good to have, I would suggest you start with this.
>
> > 3. Algorithmic:
> >    Investigate a bounded improvement to candidate selection in sparse t=
ables
> >    without introducing unacceptable CPU overhead on the drop path.
>
> You mean, to improve the situation for this suboptimal configuration?
>
> > I'm happy to prepare a patch or provide additional test measurements ba=
sed
> > on the discussion.
> >
> > Thanks,
> > Vikash SS
