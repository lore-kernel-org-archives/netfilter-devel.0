Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2227137A494
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 12:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790600121; cv=pass; b=PUdG6ELtWPWfUMEg6/k1xRZLsazs9JDLrCNEsSRTjs0PGoz96AR1dcBSK67rnS9p3OY21A4aUjUAWrXxYZt4ih4bN4YjW+7+Pa4AG374JTlH1VWTA/he+VyTk69JeVb21AUz+0zeNuET5S1dl9dzekVBwb6rDTHFoGL2YQqo6mY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790600121; c=relaxed/simple;
	bh=HGdJ8P7pSskXwI6y7NBpLAw0+M7RovjnFsZII77q+BI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BXyfqUtRjFEspCg4maYgAHmWuTCR1e84Ju4m04C2tqhEVoStfNGSKRJLS6dSl8XdIV50PuGHeRvknpiDTtc6TCjqIZS8vAq3ugcuIK4dqfEsfaswVoeW+zxX8pQ8+Igv960arf0VrmVVEZYV7T3Ox608o8JligMmgv3JoZSt0HE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uAwoQ9Ef; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uAwoQ9Ef"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-53334ea7b5cso14171031cf.0
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 05:55:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790600118; cv=none;
        d=google.com; s=arc-20260327;
        b=TelJsO9lqPrV80BFVg+i6NQq7rlJJj382SIH93i9p/CY9+FCjYhxIFRSGXe4aMm8n2
         QWXHKhyjhgTCh6Bk+v0kKbNuTlXIxvzwnYOwW6qsGrSve4uhQ3hYoZwXOHJ/bahtOl70
         QUjWlFzojcTrBJSKEatWFbmDEazohQAw7b7NT8o/s2YWAuynVN7VXmQipU/JrpGFAabJ
         BzY6sPxsB5lUtXZT3QBxJLoPnWROD5dRLRsMqhveG1y4WazmRYJVNmj4A5qJkCl8fGR7
         JnvLQ7j1W+WksBBj+tDsr6PhhOzJxXpFMJZDG+FFxLn+XpsHyEg75OFoljQ5W5HVHcO9
         ntVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HGdJ8P7pSskXwI6y7NBpLAw0+M7RovjnFsZII77q+BI=;
        fh=TFJwFHdo1211dOajtuFgT6Pkvbo4LVxDgw96dOCPVQc=;
        b=gyeuPKxfRifqVWYslLNSL1x0TW2cy9HSZvMUkRM6y5Go71KRuDGVxWkIrR3yHhvrD0
         sGOAFqUUTIvI7N0yFZj2BmDwwp5tVZH588EryFBirqSVOuEMZ1wkZr5ll8T0q1G18mW9
         /U1eIdC8BX3+yjlrwhP93x72QaRyBmFWjC545JH8es0v46wiYjgBohFluFN8oRxRWOo2
         GmZDotGDYOsPBEx/p0q6CnKm6w8Q/Q+acW1NJr/OoEnE/DFYRtBcfYOszCJ5KKKRPphB
         4wpPkAcbBTWDWsJfh8CWIsXuloHTPnCsqEsT12BHBJ8vgt3NxVqZs7Qt8UCSZGe3rw/U
         BJ/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790600118; x=1791204918; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HGdJ8P7pSskXwI6y7NBpLAw0+M7RovjnFsZII77q+BI=;
        b=uAwoQ9EfMdXQoiQ6qvH15VDek8pr8DbNk+OhZ54MTIwwKW4/iYIEui8xLF4DrFKR1d
         GnBSgljApr53qr1IIdgAjhnyOaz2bJT9GLEu+hZ5RcuLlcFtReUFJYZAhJQ4ax25/Qcf
         ilJt4bj0A/nXzO+ymRRHwDbLhitrfqCod+c8JAzluzD7rDhLlQhycYAB2T5RaQvuziid
         KM5U3Svz8RzzKvsgfGOBGMLU4kO/CF5ptsP5ea/iOObnmSqUCAMghJCq+VMgXwaOYj0G
         o20qtjt10BKLoHKVjk4p9IcV+cfa3Yh7dEN2P0Vwn8PhL3+ExaoDFdPRoKhcK1QpBS/J
         HSIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790600118; x=1791204918;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HGdJ8P7pSskXwI6y7NBpLAw0+M7RovjnFsZII77q+BI=;
        b=oKUOyZp1Es1jqbBhX4Bg8K4TeHznH9S8o3qZwZmAIGUsuO6HlRY8IK3xsed6COfRJJ
         EmzdRdr1cmpRyqcDDlJvgv9nKnMtg134/DR12mNSJ8Ld7vgKNPxVVa4r8Qw+1Sk+i0Vt
         iWMf/cqaWy7ro3ETl6ZBuexz2jhjnO+kZjn++aE8z+Kkmv9RWs8U1XZ+XFHWjXSJmhjz
         X3fT31bI8AlOaGQyG7vJ7lD0Jco+tTwV2zfhJ1wGu4TxMvZA00Pw/S8IHOJAOxfwiZic
         Rj6RsHz2K/Hm3Ahq8iUuM5uoy7ChXjEDVDn87a4KiyoS+IQwVdjFFA6UL29Y2Vv3C7ns
         avjg==
X-Forwarded-Encrypted: i=1; AKwUvBxlNzBO55xLMNCvXJO7JRw2RC3Fytqr3c2TzQi3YA4+8KPnHw2ZdiBd0B2JLt3Few+BRcIK/2wP4TNyDTeLcR8=@vger.kernel.org
X-Gm-Message-State: AFuF++l6NXvl1+e/8OeE+bNVHp991PpXc56NlkItrEsSDGf1J5BKmxjp
	naTfshtmJtTLCjUDUjVHIHHTMouXf1Na997W5fRu6TGUPpeJhDBLrfYFHXr4ScOR8K8qS6Fg9Is
	OZwUbFJi0bKZKVlR95913hlEjoPPSbY2exSwchVXl
X-Gm-Gg: AYBFou1UJiZSBDcId/Az7Ci0aimEWmg+nocHezws0l8wOjjqFn088pxHW622ie/Jzys
	9jQSbNgMhg6geo4rnXUlIm7FWE54hGkspl+fjlq9ZMF2+tSJHCKhFdTb+G3LjapJSg7qGFp8+EB
	GpTYAoVtzbBw6JnUQqn0VYT12CDR5bt13Dix1/zGEnekb3yhuKcVqdtfEkl6Kus/Y07ceGImKSd
	gWpBkxx66eb98j6etkbqANKzNdrbIxeMtILFdTqO97dlzxZBtNBpBl92Xlv/TiHp3naxQ21CID7
	a6YVeVuE08MEWkjiFOlnUrruWwEhSnhEoZxQGRzp6bFlfnUGq7oCAhqMm/moyoDfqR/NiCoXEVA
	RHoYKOgjxi1CncLs6f3DAu/2F4MTCcj3Ua5HlG9WOWs/E2/dkwRxzVlilisjRRuMGIFc0
X-Received: by 2002:a05:622a:355:b0:533:3a42:aeaa with SMTP id
 d75a77b69052e-5333a42b791mr77615191cf.4.1790600117206; Mon, 28 Sep 2026
 05:55:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <QDISC-9R8V.v4.20260928081529@mojatatu.com>
In-Reply-To: <QDISC-9R8V.v4.20260928081529@mojatatu.com>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 28 Sep 2026 14:55:06 +0200
X-Gm-Features: AclHuK9FtNEUEXpn14JvRmZ6b0QftR4i5sPaslooh9w1KzgEgklcCh1WUjgZQjg
Message-ID: <CANn89iL0baGdqnKof1FtQyQwbb8qiLwTwHB2U+HCMFsBm4wsnQ@mail.gmail.com>
Subject: Re: [PATCH net v4] net: cap skb->queue_mapping when the tx queue is picked
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Jiri Pirko <jiri@resnulli.us>, Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
	Simon Horman <horms@kernel.org>, Tonghao Zhang <xiangxia.m.yue@gmail.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Victor Nogueira <victor@mojatatu.com>, 
	Zero Day Initiative <zdi-disclosures@trendmicro.com>, hybris <hybris@mojatatu.ai>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	linux-rt-devel@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2026 at 2:46=E2=80=AFPM Jamal Hadi Salim <jhs@mojatatu.com>=
 wrote:
>
> skbedit can set skb->queue_mapping and raise the per-CPU skip_txqueue
> flag so __dev_queue_xmit() honours the mapping. __dev_queue_xmit()
> cleared the flag before sch_handle_egress() and only read it afterwards,
> so the flag was not confined to the xmit that set it: a nested xmit
> (mirred redirect or mirror, or a drop after skbedit) could set the flag
> and the outer xmit would consume it for an skb that never went through
> skbedit.
>
> A forwarded packet still carries the ingress NIC's rx_queue + 1 in
> skb->queue_mapping, so the outer device then indexes its tx queue state
> with that stale value. Taprio's child array q->qdiscs[] is sized to the
> device's queue count, so taprio_enqueue() indexes past its allocation
> and dereferences the result as a struct Qdisc *.
>
> We (ab)use the skb->nf_skip_egress which means "skip netfilter egress
> for this packet" to tag to "am I in tc egress?". Despite the overload
> I dont see it as a conflict since the marker is set only around the
> single sch_handle_egress() call and ingress path is guarded by
> tc_at_ingress.
> I will send a followup(net-next) patch once this hits net-next to
> rename the skb->nf_skip_egress bit/flag to skb->skip_egress
>
> Arm the flag only from the egress classifier that can use it: raise
> skip_txqueue from tcf_skbedit_act() only when it runs inside
> sch_handle_egress(), thanks to skb->nf_skip_egress. An egress qdisc
> classifier runs in q->enqueue(), after the tx queue has been picked,
> so a mapping it sets cannot affect the current packet; arming the flag
> there only pollutes it for a later xmit. Then own the flag for the xmit
> frame the egress hook runs in: save the incoming value and clear it just
> before sch_handle_egress(), and restore it after the hook - on the
> consumed (drop) path, or, in the same call that reads it, on the
> surviving path. The save and the restores stay inside the
> egress_needed_key static branch, so a packet pays for them only when
> egress hooks are active (2f1e85b1aee4).
>
> Store the value netdev_cap_txqueue() selected back into skb->queue_mappin=
g
> in netdev_tx_queue_mapping(), as netdev_core_pick_tx() already does, so
> the skip_txqueue path never hands a later reader on the xmit path a
> mapping the device cannot serve. A store made still later in the same
> frame, by a tc BPF program attached to a transmit qdisc, is outside this
> path and is not re-capped; a separate followup will resolve that path.
>
> netdev_xmit_skip_txqueue() returns the previous flag value so the
> save-and-clear is one call, and a no-op stub is provided when
> CONFIG_NET_EGRESS is disabled. skb->nf_skip_egress is compiled under
> CONFIG_NET_EGRESS rather than CONFIG_NETFILTER_SKIP_EGRESS, so
> skb_at_tc_egress() is valid whenever the egress path is built.
>
> A local user in a network namespace can redirect a packet from a device
> with more TX queues to one with fewer after setting a mapping valid only
> on the larger device. That reaches these reads and, under KASAN, faults
> with "slab-out-of-bounds in taprio_enqueue".
>
> Conditions to recreate the bug: the report's own trigger is a local user
> with CAP_NET_ADMIN in a network namespace, so no eBPF program is needed.
> With CONFIG_NET_SCH_TAPRIO=3Dy, CONFIG_NET_ACT_SKBEDIT=3Dy,
> CONFIG_NET_ACT_MIRRED=3Dy, CONFIG_NET_CLS_MATCHALL=3Dy,
> CONFIG_NET_SCH_PRIO=3Dy and KASAN enabled, create qa (3 queues), qb
> (2 queues) and qc (1 queue) as dummy devices; put a taprio root on qb
> (num_tc 1, queues 2@0) and clsact on all three; then add an egress
> matchall filter on every device. On qa: "action skbedit queue_mapping 2
> pipe action mirred egress redirect dev qb". On qb: "action mirred egress
> mirror dev qc". On qc: "action skbedit queue_mapping 0 pipe". Send one
> packet out qa. qc's skbedit sets the flag while qb's outer xmit is in
> flight; without the fix qb consumes it and reads its two-entry taprio
> child array with the forwarded packet's stale mapping. A qc whose
> skbedit is instead installed in a transmit-qdisc classifier (a matchall
> filter on the qc root qdisc) reaches the same code path the same way
> without the fix.
>
> Testing: on a KASAN build with panic_on_warn=3D1 the unfixed kernel panic=
s
> with "BUG: KASAN: slab-out-of-bounds in taprio_enqueue", a read 0 bytes
> past a 16-byte taprio_init() allocation, for the clsact-setter and the
> transmit-qdisc-classifier reproducers and for a clsact skbedit-then-tc-BP=
F
> store; the fixed kernel runs all three with no report, and the BPF store
> variant additionally shows the expected "selects TX queue" clamp notice
> from the write-back.
>
> Fixes: 2f1e85b1aee4 ("net: sched: use queue_mapping to pick tx queue")
> Reported-by: Zero Day Initiative <zdi-disclosures@trendmicro.com>
> Link: https://lore.kernel.org/netdev/CANn89iLwYx8nCVf0pCEk_MmEiyC6kQaMwCQ=
T9WkQVeeNzNQHqQ@mail.gmail.com/
> Link: https://lore.kernel.org/netdev/179008581937.2160803.711781429057426=
2942@kernel.org/
> Link: https://lore.kernel.org/netdev/179033713973.2160803.491457069399439=
8206@kernel.org/
> Link: https://lore.kernel.org/netdev/20260925180407.63647514@kernel.org/
> Link: https://lore.kernel.org/netdev/CANn89i+k-mZKDQVtvws_MEXeuMTAdaCcOXF=
ZE-RfhcGTu90sjA@mail.gmail.com/
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Tested-by: hybris <hybris@mojatatu.ai>
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>

SGTM, thanks Jamal!

Reviewed-by: Eric Dumazet <edumazet@google.com>
