Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5160336884
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2026 23:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774394890; cv=pass; b=I32AleOKPOobiUNc3PlJZE5g9zAdMOPKiT32Nk3ayuZW+e3sT/pjpLuxUZqiB/s7lPa+/GfjiemgGdP7NlNi5Wg304F2pCNUbe4V4NtC6cMOCPScCGwJQjBBUHTBbOBrcL+iiBY2wJZkjsfzRrR6t1amuxzXaSJSpMzVT/GTh6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774394890; c=relaxed/simple;
	bh=LT2q8PEldt87z3mrWDdYA25Zu4LLlNbQMdEbJVa3TH4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DOgHW6bmgkvPtcNjrhCroRWatfCHkaKG4wP4lPSqeTCkFg3KEw91+PRMkjRmtMDrXFg/6Jd/IofFWlfONdl95cDm7dwyLV2VsLVmrHFbvZkT1wJtSjQxgcTyUDIiarelEsg2yl1d530mRnyXuiMs/j7Qfqzfpw8PTjQ6dviFxFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WxPOYUy0; arc=pass smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WxPOYUy0"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-79a40fb9890so45768307b3.1
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2026 16:28:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774394889; cv=none;
        d=google.com; s=arc-20240605;
        b=A4RMavfwf6+cmj32S0atS4Cd3tZ9mBdH8NlB6SXRSeCnqqY/kRHbX4Fa7otXE7d1vX
         d8yJv72ZK4OcrgIDufElAdOZftefLjW8k+ZfGpEL41DMxe0J7F2f6w83/7rBN/HnjUFe
         DianIaYu/AKMXuii1gq2z5xsad/tKQhF75fiTykvcFnzhhL+jsP4g1+9wvl3RywLQTxg
         +P5G0zoW8Y07u3TLq1KSEmGCMlT0FT5FA3tU8qUJ2XolSHY15i3YnIa9cAUVbQkqDIP5
         9UlEmPZAaD79ErUZViN7Yj4f68ll4fwq9rYm2wBK5UadhPSmrOPPRmV6KRNpIu3o/oqq
         zvzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LT2q8PEldt87z3mrWDdYA25Zu4LLlNbQMdEbJVa3TH4=;
        fh=RfTkRRQ9QGHC7Dv12BG7XbdNp64oE4mrTo9cmMiTN+o=;
        b=aXk1DFYWuE4Zroz+C4FVdb7I6839z67P1ufD65CpW/6QTqIg1kwO9vzJ6/igr012qV
         FjDPxbhkr99FGf4x6Eu2018brYpUd0sWFUlYmjBQjMtlQQ46et4o2teXFiXytWRs2sww
         wpxruHNa2qR5BB3lhFdeICAHVh3c7lZoQX6idKKcwub5lng43WISaZuT0yOhZ3COfHKB
         qkaDq6MKJiolL3pfxKxI/mpxo8QkUXWzWDLpOAhZUNpccRsSzoGQ6lZq7hXu/KR1QQ/4
         zKtwa/dm4IUm+/rns1A833Hrk/4mRylL2GIKZq5vnEa2yaoRUk1fN9hKM6mfRN1mdDWU
         fKYA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774394889; x=1774999689; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LT2q8PEldt87z3mrWDdYA25Zu4LLlNbQMdEbJVa3TH4=;
        b=WxPOYUy082lc2OjwB4xhShORA4QxdFRtI+x6ZZ3ALQYlmgNlgflc0CvwJfY2ZiMWCA
         Pda4hK8u24vnWwuYI/kSIA3qc2f3oDQRS22HgD3blGmLG0pIHFYoVfGESBjQPe3EviDJ
         sPwfWbP4SiO2fsQ6U/Ogv3TFy00c0vMW13EhAc/wWXPXDJpIYtPqlb+HdbSx1f4bHUfl
         h4br/PwT23zhZaBPgrgnGI3cgrCDG5jTxLvakOsPIP79Re619iJvl72QjTLXflRAL+vZ
         2pmBRjiyA6K15DNVWIazxaAlOob38Qv+Heag7N6CQz3Ku7KIsUHwQXhuXn4ybMw9fs29
         WwwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774394889; x=1774999689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LT2q8PEldt87z3mrWDdYA25Zu4LLlNbQMdEbJVa3TH4=;
        b=pVgCuBDaPaVyisKADShA2aD4tY/Pn4zsKqI5wLqBVbL2LpxPRBSdYqQAz87HfgwG1R
         aRstQ57DcRkabEX42VgyjDqRjYj6x4+Bv4+kDTBuWB4skFHr29c6MHnzkfi0BM/KxvcD
         A4BqCTDQMMyahh8ismsZGnAJdTD56l9y2P3ua0ALalMZCPJmKCPt5TixLfYE7Vt+5Q55
         r+RK2+4DrimTI90IABMTqa4sdTcc5SjoWIec90y7u/++le4jCh3yflUowB/HinGZq7Rx
         ZtT4Sn0/tnvfk/HAa6g07I76EmqXdGTU2++/FiWGtuUTMcXXwCz0AuXCUQ6h0X8ctp8V
         qGSQ==
X-Gm-Message-State: AOJu0YzIaicTI4xH0N6s80F6e100NZAVJwrTNhJir66XtgKzls1DUyNu
	EbSZf5A5vA6LED+vCY3EEiUIAO95tsmF04/9l7T7BJF+loulQYDsA6Sh+3L8bSclwHsY+/39nbN
	mTdZA+VSjhE+p9llucs2vXcQnR702hB8=
X-Gm-Gg: ATEYQzyN6vnH58Ofl98+AWFROpqo6fkRvhSfZsHKgcM9OzRuKWqZSAz3vjN6G/ksJoz
	9z5xO7GEs+NGJ7tNLnS1z/y86ApTz8RscghNXGRUGwvS+90203KEHkBDD3cmHM6DktWDhBK1/52
	ZpSTrp9Xnp0bM0hh8FrTrstjtzEubSDhuYBM15Pc0PVVfr2fngI4M7ZJ016XNOhKC4tyBMMpOYe
	8Co5rzlukLotGkkWUtHA/W6aQI4f6YdbVpteP2hYXBP1I2JEAE+wK7tmAJP2DLNkn11QLenY0iA
	SUPU4w5Q5DTUMkXEQWw=
X-Received: by 2002:a05:690c:c0d3:b0:798:36:e110 with SMTP id
 00721157ae682-79acf6f180fmr15427277b3.62.1774394888606; Tue, 24 Mar 2026
 16:28:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260324204016.2089193-1-anzaki@gmail.com> <20260324204016.2089193-2-anzaki@gmail.com>
 <acMB9xSTEmwly8QK@chamomile>
In-Reply-To: <acMB9xSTEmwly8QK@chamomile>
From: Ahmed Zaki <anzaki@gmail.com>
Date: Tue, 24 Mar 2026 17:27:32 -0600
X-Gm-Features: AaiRm51IbJFq0DzIib_tS9CxsVxmnu9xjmu7KIN3YEOt6boriUdcPPCK74Wy5qM
Message-ID: <CANczwAHFy1fp4JU4ANJ2Uf-=B2uDP0GejrWUuELz9yf0wu9H2A@mail.gmail.com>
Subject: Re: [PATCH nf-next v2 1/2] netfilter: flowtable: update netdev stats
 with HW_OFFLOAD flows
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, andrew@lunn.ch, olteanv@gmail.com, 
	fw@strlen.de, kuba@kernel.org, pabeni@redhat.com, edumazet@google.com, 
	coreteam@netfilter.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2026 at 3:28=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> On Tue, Mar 24, 2026 at 02:40:15PM -0600, Ahmed Zaki wrote:
> > Some drivers (notably DSA) delegate the nft flowtable HW_OFFLOAD flows
> > to a parent driver. While the parent driver is able to report the
> > offloaded traffic stats directly from the HW, the delegating driver
> > does not report the stats. This fails SNMP-based monitoring tools that
> > rely on netdev stats to report the network traffic.
> >
> > Add a new struct pcpu_sw_netstats "fstats" to net_device that gets
> > allocated only if the new flag "flow_offload_via_parent" is set by the
> > driver. The new stats are lazily allocated by the nft flow offloading
> > code when the first flow is offloaded. The stats are updated periodical=
ly
> > in flow_offload_work_stats() and also once in flow_offload_work_del()
> > before the flow is deleted. For this, flow_offload_work_del() had to
> > be moved below flow_offload_tuple_stats().
>
> Hm, I think v1 was a simpler approach... except that you innecesarily
> modified a lot of callsites as Jakub pointed out. I don't see why you
> need this new callback for netdev_ops.
>

No new netdev_op, but I added the new stats field (fstats) since having a
separate field and flag guarantees that no other drivers gets broken and
no other drivers (that already count offloaded stats) need to be touched.

Looking at some drivers, tstats seems to be sometimes used by H/W drivers
and sometimes not, which just complicates the code semantics if we also use=
 it
for "H/W flow offloaded" stats. Some of these drivers already read H/W
MIB registers.
So I think there is no way around adding a new flag to not break something.

But more importantly, I am not sure if there is no driver that sets
NETDEV_PCPU_STAT_TSTATS
**and** report its own offloaded flow stats. If we re-use tsats
for these, we will double count the offloaded traffic unless we set some
flag so that nft does not double-count.

Also, any driver that already counts offloaded flow traffic and uses
NETDEV_PCPU_STAT_DSTATS will break if we use tstas (union with dstats).
