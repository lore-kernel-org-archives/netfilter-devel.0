Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355244F7CBB
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 16:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167165; cv=pass; b=fTP/4sy8rgHJ0A8yXjxYlxpcbflwnpC+hJmmu+hPn1ATbo8xmHvNLmZHr+3FYjzgynYH6ZBuJMpCSZAdw0obyl6ia1lDZ6fOsU77t2ox/pBJCFXenrbtLVMsCkmSFLopc50VJr7FO4mxzNOfUCJ2gcJ08bKw2jTwaF7JQKjL0iM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167165; c=relaxed/simple;
	bh=zBk/WWunbgjQ1PnhejDQFmkv3G3u9bY8Wo8DwzlmXqg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r+jj6mKjzMTHWQj3yAs28elyChf+ktIC5JCX04Nq2V2CxY7q5YdjI6obq/bZqsSMfkNbkb9uPtOpLAbSj+t9ZqEfnBfQuVTb/l/mgk4F6aqiBaa1krlA2i/EfH/xbhtpyXKvqOnb/4dYn/kPVgkL0UrNVgsKHbNdmnTOjjyE+Vg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=VKucz2sm; arc=pass smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="VKucz2sm"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3ab27b4924aso183171fa.2
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 09:12:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792167161; cv=none;
        d=google.com; s=arc-20260327;
        b=h+xSDrhI4WLv02gKw5BWvQNi6rrG0vqY6uG3rDgdk6kwpCBKBF6028cn6KvjDPuV61
         mOW4SIUE0s52N27HHI4D5FJEFtRBXd1wwO2ajrkVefT+/getz6umtTF2RWpuOIFXIUko
         TbdySR+cIJ0ca0Wi6qGgacil/tncrDxm6bkeMSUOPnspfnGA9kAmuOvZjOImbihjF8yc
         /e4hcKEZwQjdKY3uJ3iKg+hWvhiRpCWPDgZzHI17VH7EA90geKrDvxVpHW5P7HdN6I4a
         uMHUOU9I39c9vgoFTXUaIum2mNmzkINYVZMnXGKd9qm2okM2BF1Plz2Xx1Kofi/+aod+
         8Q1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1DBXJxHvquUaLKJ+tkdkfcHBt7XZVv/oRHXlHwD+SAo=;
        fh=qcRMXbPFR3mI2ttQMVVaKelBUA0wi5y3tnZ340qn92g=;
        b=klCQYpu0/TaggHpOzbiN3ogj0br6ZiHxR6XjtUdFPoktEoIAgHo2XZ4tu3YfSqs/UD
         QQif9lNeQyzspiupwCq/evt2I9YaBAVwczMar9kDBwHAJySMLjBRsgChuCvui/1aAnhx
         U0OnwMtgn60pOiLIILQc74+E227j1E+hpeLkQwfQbACTj0TFlbJ57cYJyfpzPX4DqIK5
         VdO8PEuWSzrm5HmMdIFfStmKHJV79Q9cGVlnf/lPGG9MxCSdEne+kOKyG/VSV1uUsyXM
         kAnMhKiBgFvi8POceZ44X5SeplXk1lqaChfvHtus3Bywk6mEQD/HTpbq8YBKVwbnONA1
         +UNA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1792167161; x=1792771961; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1DBXJxHvquUaLKJ+tkdkfcHBt7XZVv/oRHXlHwD+SAo=;
        b=VKucz2smIC8VhKndOqTkTpEQsySepSdlJpFzfZluXj78ZBSnrV25g2OTSGN1TsquKO
         rWSeULc51d/TxTMaNo3gKW6eIdSBLMsmNOcSk/vZLDFEoz4UVBZWOFV2QG/YQ1hPkdb4
         6MdNUEY+6jHK1xptQ3OKYl+YmHIeTviMQz/g2yx2XvgwSGnLkMBzS9Qt5KoISmsXGy5s
         n4Kb9UBrFGDh9tQzClgauJs37IDjDoaaDexxj+gm6CX+ODirLf0WTwkd27NaFyCnRl0k
         hTWjtFYGh7tmv+7lg3ojIdi2a3PPqwlJZ12wwwb+DROkXpIWNSYPfjU84yDJE351tI/S
         GHzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792167161; x=1792771961;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1DBXJxHvquUaLKJ+tkdkfcHBt7XZVv/oRHXlHwD+SAo=;
        b=EBLtZwIb11Yy/jsZm3qMj42wDX4A9prosGACFj+J+uy9ZpJ19iDXv4ww4iY36p6Q7o
         gFjgvYfmJF567rqDnI0g4CmA1wbUXweTsxsdyjvwufNDb7QCiCqCZYiotE3uSPo1dSZ7
         gC5EKVNVaZjVV5+wkcUx7UkRIEqkASPszWTdk33hjX5WTJATFQYB88dNVZ0ncuUL3ca8
         3Ez/AMlHfL5kViqrYYqQsgECosfSz/s0S9PHaTKjHi/hvCDLqIYpB/Lcdn2Mn3sOuue9
         WoWSbvtW9A00qkb6vLVr7CzL2FiMzq8JEJqnTYMugmbedwGoFBH6NX9fdv05ddIas3Gw
         IGAQ==
X-Gm-Message-State: AFq9FYI7CnnSE+fReOjMQzGcY8Q+9xDn9MRHgn9ejhev1UBTNKmbUoBk
	xmUEz6b0o8WPWmfJ3Z9h2osqgIIULkWLTLa74aqcrllFXnlABME1DYMwe7V1lUCzEERIvnETsc/
	SLFFqA9GYV+mfkCpik2dkfN60g4J9KAu38sKVX3jxEYk=
X-Gm-Gg: AYBFou3wWoAc6PhMXdYlsh7bHyNtY4h4lBX7sOnR2fiXD5XU+zHcFQ2wW8+Tgy/T/8l
	7SduyxMUO3EEkIDpbXA6GS4tntm+ISRWlOEPFlYzl9+KBI8l8Sqo5SkOW39Ij/X67IdsPvCQ3j5
	xtBWo9bSLXumVhU8HitW9hl2/ZCPmWMGdCXywa+zM0LHM1DVR+mvuDx2n5R80TK1iBl6g/XBzv0
	WMSsvW/Wwy/PRvGItC4SR6s6hCBTuwfluq8q9CcMwVLsb3YdyYzCbrd1ezRMugW90OrqKYU6d+X
	H1wZfOhZG0HwhI+Y/bK7XZh1TXxKFB4dceahSKzU4f+Rox7v3B7C82WOWAZuccrHC5yDHEi49nF
	UKtom07SduA==
X-Received: by 2002:a2e:9a10:0:b0:3a9:c840:10ee with SMTP id
 38308e7fff4ca-3ab2927a909mr511431fa.5.1792167160733; Fri, 16 Oct 2026
 09:12:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1792048855.git.zihanx@nebusec.ai> <atCtUFcG9b4ykXY3@strlen.de>
In-Reply-To: <atCtUFcG9b4ykXY3@strlen.de>
From: zihan xi <zihanx@nebusec.ai>
Date: Sat, 17 Oct 2026 00:12:27 +0800
X-Gm-Features: AclHuK9WXLPZ_WQaM633BzwfDjRGTUWRZmkMt1BFBbMb-E1VSzEd_hb2wxJXXZk
Message-ID: <CAANe3eTSz3-EE0=9JNFBMFDqZ9NUfScHdi8EN30UVaTiRq0vcg@mail.gmail.com>
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

Following up on my earlier note, I reviewed the NFQUEUE and netdev
paths and narrowed the proposed fix.

For IPv4/IPv6 duplication through NFQUEUE, the queue entry can preserve
current->in_nf_duplicate from the task that queued the packet. Reinjection
can restore that value while hook traversal resumes, then restore the
verdict task's previous value on exit. The reinjection path also needs
bottom halves disabled across that traversal so the task-local state
cannot be changed by BH processing during reinjection. The fail-open
case is synchronous: the queue entry carries the set state, so the
diagnostic must not warn merely because current->in_nf_duplicate is set
on entry.

The netdev duplication path is separate. It uses
nf_dev_xmit_recursion(), and the current counter does not follow the skb
through asynchronous software receive paths. My earlier patch 2 tried
to cover skb/XDP state propagation across those paths, but I agree that
it was too broad and complex. I have dropped it from this series rather
than present it as a complete or sufficiently small design. I have also
dropped the unrelated TTL/hop-limit change.

I will send a one-patch v9 series for the NFQUEUE guard preservation
only. It does not address netdev duplication or claim to provide a
general facility for bounding every asynchronous duplication path.

Best regards,
Zihan
