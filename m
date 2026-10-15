Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC3750AC29
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 11:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792064032; cv=pass; b=c3XMvHz9Mz8mfofu2HXYFBkFmxDyAvhgoi2jWJICDx7MZcKIUso3v00E06Sq02pOLuTbgXcEKSCruhlqnrO5BP+U4Zsal+CsHM1jYGpK8MO7saeAGAEataDNRAVwTai7/3fSb7Ad9+YLT0JFW82zazHXlYMEQzH3bPd3jlWDRSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792064032; c=relaxed/simple;
	bh=78wXkLFw/SMfWWA5rRLBi3jwnfNyUqDFiIvYEtDeyqc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vt0+tdm/Gmowf0CNoym4K0RNl1AgJBeOY5Zs/tM6CNzpLsHfkM763K5fRi+722tK8jePyC1Kppqf3W5qLGzTAAtNxKhJkhO4olGxvYfXQ1rLS8Ij/UEOM3rRdzDQxD3bZi/x8yZG4QCa+s8auk4yHS/ZYfgh/MRkG5mQC4DL4kA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=Glpm5tgr; arc=pass smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="Glpm5tgr"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-3a9761758adso42542251fa.0
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 04:33:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792064024; cv=none;
        d=google.com; s=arc-20260327;
        b=iHugijsUeAYj+D0EYi+xOmzXC44f8bvj9KbAsALhMmK493TlsFw65J64xcNeRR9uCN
         cvHdphjbuCdLhVAQLQB/h235tSI9BhH6g4GcGmiPNagfVUGZg73PJofaYerJPRPaIj4T
         GXSYtMZyqqSfBbmQZKoDVR3OSFhv6vVLGlYpXNdrJF00HnZijYQ3LWDY1FAFfQP+RGqb
         FfytDOfFpK6KJU1PPDN84HOgTT0BYycszsXAvlnaXfhQopOO6P1KDD9Vyj2nHQlX5HHt
         yttrj23isXPxiF3ExUpE6HkpXd2WBYufYOLwU7P6y4N9lw3KpQ9+JxcchZJ0r5ktBisY
         bA8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kVkAPVeV3U3Z1r6vn3DHdC0uUky7cOD11NYVy4jKyNM=;
        fh=qcRMXbPFR3mI2ttQMVVaKelBUA0wi5y3tnZ340qn92g=;
        b=l4HXRr6dVaseN3Vg3xiJE3GTgNH7FdmyGuK3oSReM7l1I1np/tQZFs1UhujUwuPhRc
         si1gmSc3FsMSRbxRtXa/qz4jU98uN+bOsYPGkLmjTwrxzfKkj/iTyAKIbWhYldEJKx8z
         Km8O8kDGUdTSSjMeYetX7mxnyjRDRs3l8ixYKxNPTWeoGtmE+VTHykTBCLJK+O5dp3Fq
         1n1B/pnUv6cBkWiUdBP8VY7cwoFiuR0AwUxnW/aoti3WmXW1dllezZQhpMGMIX8FK7YG
         MdZc/ttP3M1vNCdDQk2iL2aMWtJ8jnnTDCR0OAOzGUYqS31uAmb/dLiqotSmX9cgHfxG
         jW2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1792064024; x=1792668824; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kVkAPVeV3U3Z1r6vn3DHdC0uUky7cOD11NYVy4jKyNM=;
        b=Glpm5tgr46F+Rj5ss+W90tvAuLdiTGjE5ceFkHuKOuxQ3ZBSb4EyZ5ekwzDBlrWRoV
         eHsQpKEz54jPTEV2rUXiSaWEu70hAIuSNJ/HOfIUXw0EsQEhFX5g5mxzIOAr/GyrwTfW
         DWPZGz6ftTdWTnDgKquz9mm+UycxnxNPPLvlOQrDlMZFZaJoAhNOES8SLzFxEdMLBDFs
         dsRUuzpKHV9gFwccCp0mJ80/llf5L+11PwBpbsjgNGtKou2lZfRquydC9yBcAUQ8in3q
         xUDYOzcZTKidnEFEZt7RJtvURtwPNURjGjH/+RKCin9ckKfoub27WEBtBxp89FcDLGnh
         SzZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792064024; x=1792668824;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kVkAPVeV3U3Z1r6vn3DHdC0uUky7cOD11NYVy4jKyNM=;
        b=knbq+k2V/GKNaSFcB9xyyL4C8BqT74m43vUuFK7f5rEwJ1UwkEfEsxHN/PLTs+c3DM
         qBPqySgbZn08nZAtVqGQwThphgZgtdDuACi0BCfc8XNJ1pMhxij6vZOiv0iEVJV2WIFe
         t8laYDxLmA2xyHalbmntNcvOZlH+fMkuzvmkCDZyELaMbMHKLkC/z7zdqHb5SkTgU755
         NCTrJjhBkpSr5+OSlJBTvJNaG8ZuI2J84EGS1s674BpSQNbnQDkhSVbS9F41mensSLbT
         +HYEGc7FpymTTeJXnVKRCxT0+351BiUlA/+CRZJJRciPeLNTplwjCQ2kxbvhn4lpy/9k
         Hglw==
X-Gm-Message-State: AFq9FYJTq5jOwNKfuQSrbJh1SXkj+qi5JEmntEKat1N5k5J1kmoc4/o8
	VgY9HjE4yclNuuu0hjaYva5FZeJUGEMl29tjkz2nlyIPrQVOD1VZBqt3Zcek6oR42ID0udj1H4b
	AOgN180Eud6n1mSZKpxfomLilDKMrkatDj5U56S1IHUU=
X-Gm-Gg: AYBFou2egJCPHeEHzhpV/JN7m3cI4oFavIMUBcy5o1gbY71BDIBMoJw3knQumF2/yBo
	8zbldjL2Qd/jzswqyomKsr4YQts3lEPdlJs4oRHdAWd2Rjw/PgY809CEd3EHbcEOkhYGVML6nIr
	GmDXcJzrqjEROyu4N12yjsJcOnQGf5F986f77wj/6XoduTv3ymD3NXcli/oIbw4IfePaDrDwq+o
	8V8TYqhfHiitjKL1AVBXhqAcerlObQtJSiqXVRN1rFKgsXDSlRLijdqvDXGgNVVzr/JNSIGBQ7u
	ND144E8lhnOlvENQgsOf4MSZmvBFQokfSe+QHF1uzzNwNV8p9pf39DaBDX86Tq5O23aOZezpoqI
	ZbStHMVSHcg==
X-Received: by 2002:a2e:b019:0:b0:3a6:53b7:65f with SMTP id
 38308e7fff4ca-3a9c56e2e18mr32007541fa.24.1792064023930; Thu, 15 Oct 2026
 04:33:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1792048855.git.zihanx@nebusec.ai> <atCtUFcG9b4ykXY3@strlen.de>
In-Reply-To: <atCtUFcG9b4ykXY3@strlen.de>
From: zihan xi <zihanx@nebusec.ai>
Date: Thu, 15 Oct 2026 19:33:31 +0800
X-Gm-Features: AclHuK_8_Kk2IIVBq5gfnontRtGKaffdTFvzSUc3-5H_TGMTs9I-jfqzlZDWd3I
Message-ID: <CAANe3eS=72iEkSwLGToMZmv_Drk3Naky2OL8oM_11GZztR3s4g@mail.gmail.com>
Subject: Re: [PATCH nf v8 0/3] netfilter: bound asynchronous packet duplication
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, virtualization@lists.linux.dev, 
	intel-wired-lan@lists.osuosl.org, bpf@vger.kernel.org, pablo@netfilter.org, 
	phil@nwl.cc, davem@davemloft.net, edumazet@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, kaber@trash.net, jengelh@medozas.de, andrew+netdev@lunn.ch, 
	mst@redhat.com, jasowangio@gmail.com, eperezma@redhat.com, 
	xuanzhuo@linux.alibaba.com, aleksander.lobakin@intel.com, ast@kernel.org, 
	daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com, 
	sdf@fomichev.me, magnus.karlsson@intel.com, maciej.fijalkowski@intel.com, 
	willemb@google.com, alice.kernel@fastmail.im, eilaimemedsnaimel@gmail.com, 
	imv4bel@gmail.com, shiming.cheng@mediatek.com, sd@queasysnail.net, 
	vega@nebusec.ai, root@tr0jan.top
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 6:39=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Zihan Xi <zihanx@nebusec.ai> wrote:
> > Hi Linux kernel maintainers,
> >
> > We found and validated an issue in netfilter packet duplication. The bu=
g
> > is reachable by an unprivileged user in user and network namespaces.
> > Bounded tests exercised the fixes. Non-duplication packet semantics are
> > intended to remain unchanged. MIRRED flow offload for affected netdev d=
up
> > rules is rejected because it cannot enforce the duplication-depth limit=
.
> >
> > We will provide detailed information about the bug
> > in this email, along with a PoC to trigger it.
>
> Series makes no sense to me, sorry.  I dislike the 2nd patch, I see no
> reason why we need to make changes all over the place for this...?
>
> Also, if we go with 2nd patch, why do we still need the first?
>
> > The IPv4 and IPv6 duplication helpers use a task-local guard while a cl=
oned
> > packet traverses output hooks. If NFQUEUE suspends that traversal, the
> > output call can return and clear the guard before a later verdict resum=
es
> > the remaining hooks. The resumed packet can reach another duplication
> > consumer without the original guard. This can cause repeated packet
> > processing and consume CPU and network resources.
>
> "Don't do that, then"?
>
> I think the kernel should not crash when misused, but I don't think
> kernel should have to do extreme stunts to detect such loops.
>
> There are probably many other ways to make kernel allocate lots of
> memory or waste cpu cycles.
>
> E.g. via create use of veth and bridges, sched plug, teql, ...
>
> > Patch 1 records the
> > guard in the queue entry and restores it during reinjection. It keeps
> > bottom halves disabled during the reinjection traversal, restoring the
> > verdict task state before reenabling them.
>
> Its small enough, so I have no objections to this patch.
>
> > The netdev nft dup path has a separate synchronous transmit recursion
> > counter. It does not accompany a duplicated skb through asynchronous
> > software receive paths. Patch 2 carries a bounded duplication depth thr=
ough
> > skb and supported XDP conversions, resets it on reused buffers, and rej=
ects
> > MIRRED flow offload where the software depth cannot be enforced. This s=
cope
> > covers software skb/XDP continuity, not packet loops through physical
> > hardware or userspace device round trips.
>
> I think it would be better to first go to the drawing board and make ONE
> facility that governs the recursion part.
>
> From a quick glance, the difference is historical from time when
> per-module pcpu counters were used, so nf_dup netdev could not see the st=
ate
> of nft_dup toggle.  Now that its in task struct anyway, maybe its time to
> just zap the egress recursion counter and first make a patch that
> uses the bool toggle for both egress and normal dup?
>
> I would like to remove code, not add more.
>
> > At PRE_ROUTING and LOCAL_IN, the IPv4 and IPv6 helpers decrement TTL or
> > hop limit on the copy. Patch 3 stops creating copies when the value is
> > <=3D 1, so the decrement cannot reach zero or wrap a zero value to the
> > maximum.
>
> Thats unrelated problem.  There are other places that do TTL/HL
> decrements.  I think it makes sense to clean this up in -next and
> add common helpers and then use those.

Hi Florian,

Thanks for taking the time to review this series. Your comments make
clear that I have not yet presented a sufficiently simple, coherent
design, particularly why both patches 1 and 2 are needed.

I will go back to the recursion-guard design and first evaluate
whether the existing current->in_nf_duplicate flag can be used by both
the IPv4/IPv6 and netdev duplication paths, replacing the separate
egress recursion counter. I will check the effects on the counter=E2=80=99s
other users and verify the relevant egress, bottom-half, and
asynchronous receive paths before deciding whether a task-local flag
is sufficient. I will not assume that it covers asynchronous paths
without evidence.

I understand that you have no objection to patch 1 on its own. I will
nevertheless check whether the unified design makes its NFQUEUE
queue-entry state redundant; if not, I will keep that change limited
to the NFQUEUE state-lifetimeissue.

I agree that the TTL/hop-limit change is separate from this series. I
will leave it out and consider it independently alongside the
common-helper work in -next.

I also take your point about scope: the goal should be a simple,
coherent recursion guard for this duplication behavior, not a general
mechanism for detecting every possible source of CPU or memory
consumption. I will return with the path analysis and a smaller design
before sending another series.

Best regards,
Zihan
