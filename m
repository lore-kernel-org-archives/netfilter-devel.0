Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793973395;
	b=kToxSLC74GgZPZ7GtKJCrm08y3y8IXBnKvg0m4AJudW3uBgRb/LPbc5gYRihPbRgHO/I
	 mpJlUTuTCDhn7sxbmcbyPr5+1Vi6V3Qt7p+uLMqKL6d9TFTXFd/Y7OuBpDVcFZdd15WJl
	 xswMxYH0f7RBYwUa/q6AUm873c1/6rhdX4FHWmxPIR6zoZnLF8nq6l18M2WMVkUQKU52M
	 wmojG1STX6b9UhZ7dLj0W6VDGIYWJ2dxLACNSaTNmop/98TOfFln0mNZsfX9Phnty0trZ
	 eqgREDkhESLrRfrqbtxXMZSwwHVOWS8wyD9PUJIUTT1ly55xvNYYHumWh5Kt4V03QWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793973395;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=VFdz8QnGNNiqxHgreT1S2XWtlfzdjAGTXGsHdh8zCGs=;
	b=4kQ9CXbOIuA8EtOBZ/hI9lJwfTpzJl9JdualnnVP7AfldDMxMt51VvNa6nkf7a1/YSOu
	 meRCTHlBfCWCulqIu2v8JcEzB+Vt0H8mAiqNWiKxBaMupd1Wub5N2Yh0NwREzpA0zdLcN
	 rmjfcKhDbkz5cOYmA8EEkWzksIaAw5BzYvSb4dGp3JMUTFbZ7Tln7X6RZHGG64dbqVfAa
	 cwGwRHZFzRfHJjDXhIFfDTDyTfaSbfCdGJsdvynUgoCvFMs/4AaV+Wqsn6vsWJhjtE6Qe
	 GB7aM4rV0Ixh8QjHuK6cVbvEaISNYQJ1ok/lS3K9oHY7EKH0LfjdH+lRB4FgbomynVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=E8nzqOS5;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 4297B606D83B
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 13:56:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4297B606D83B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=E8nzqOS5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793973391;
	bh=VFdz8QnGNNiqxHgreT1S2XWtlfzdjAGTXGsHdh8zCGs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E8nzqOS5nMUFA/48WhjrnD7peO60kAatS0Y0iarNyqGwqezXPfYrDcXHsL2Q0T7Q6
	 kaFcmtVOKkZaSIlN/4GIP7sROVaTfp1iHR+iAD05MttjwEwTZHs74XiDI6sued789m
	 e7NjrZKGrUUQ77hc2eexvzKZO93frjnfvHG2LL8wSEN/suZ4KSr6zQIqWLmt7QYrPc
	 datg0m6SBZe5nIl5prP7A4ivPwqP0ZMWTVg6L6aQwm5SrRpINLKOk49aa5wdO0Og6z
	 ple0iViPugxpy8edy9OjRqz1XG4XW1su6kGntf284zjekzrPNJ8+Rs+GGun2TPzKld
	 ++NiDL1w8kzEA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CB58A60056;
	Fri,  6 Nov 2026 14:56:31 +0100 (CET)
Date: Fri, 6 Nov 2026 14:56:29 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: "S.S.Vikash" <arisivikash@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [RFC] netfilter: conntrack: early_drop eviction limitation under
 sparse table configurations (max << buckets)
Message-ID: <au3cjRvFU0Iks-WW@chamomile>
References: <CAPGrzGkjouOeqOcy4pXbBgx58DWvZpqK8ppuChPsDsXKvxp4RA@mail.gmail.com>
 <au28uheXr_lsEhzY@chamomile>
 <CAPGrzGmyVKDYsQV1vyN-K5Y6FJ9U+T_DvkDXnR6Ju0W-5Bk=dQ@mail.gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPGrzGmyVKDYsQV1vyN-K5Y6FJ9U+T_DvkDXnR6Ju0W-5Bk=dQ@mail.gmail.com>

On Fri, Nov 06, 2026 at 11:52:47AM +0000, S.S.Vikash wrote:
> Hi Pablo,
> 
> I understand your point about the suboptimal configuration.
> 
> I came across this behavior while experimenting with conntrack and
> investigated the source to understand why it was happening.

OK, looks like a LLM finding then.

> I'm relatively new to kernel development, so I appreciate the guidance
> on what would be useful upstream.
> 
> I'll start with the documentation improvement.

Yes, thats sufficient. I don't see the need to improve the situation
for a suboptiomal configuration like the one described in this
scenario.

Thanks.

> Thanks for your time!
> 
> On Fri, Nov 6, 2026 at 11:40 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Fri, Nov 06, 2026 at 04:23:08PM +0530, S.S.Vikash wrote:
> > > Hi,
> > >
> > > While investigating connection tracking exhaustion behavior under a spoofed
> > > SYN flood, I observed that the effectiveness of early eviction in
> > > net/netfilter/nf_conntrack_core.c:early_drop() degrades significantly when
> > > nf_conntrack_max is configured to be substantially smaller than
> > > nf_conntrack_buckets.
> > >
> > > Setup & Reproduction:
> > > - Host kernel: Linux 6.14 (Proxmox host)
> > > - Workload: Conntrack table saturated with non-ASSURED, unreplied TCP
> > >   connections generated by spoofed SYN traffic.
> > > - Test: Verifying whether an inbound, legitimate SSH connection can be
> > >   established while the table is at capacity.
> > >
> > > Results observed:
> > >
> > > nf_conntrack_max       |   nf_conntrack_buckets     |     New SSH Connection
> > > ------------------------------+-----------------------------------+----------------------------------
> > >               4096              |              262144
> > > |         Failed (drops)
> > >               4096              |              4096
> > >   |         Established
> > >               65536            |              262144
> > > |         Established
> > >               262144          |              262144                  |
> > >         Established
> > >
> > > Root Cause Analysis:
> > > In early_drop(), the kernel examines at most NF_CT_EVICTION_RANGE (8)
> > > consecutive hash buckets starting from the calculated hash index.
> > >
> > > With nf_conntrack_max=4096 and nf_conntrack_buckets=262144,
> >
> > makes no sense to make to configure it in this way, there are well
> > define rules aiming at maintaining O(1) in hashtables and this
> > configuration is clearly suboptimal.
> >
> > > the hash table
> > > is sparsely populated. Since early_drop() examines only eight consecutive
> > > buckets, it can fail to locate an eligible entry even when many non-ASSURED
> > > connections remain in the table. This appears consistent with the connection
> > > failures observed during testing.
> > >
> > > When the bucket count is reduced or when the table density is increased,
> > > early eviction succeeds reliably and permits legitimate inbound connections.
> > >
> > > Proposed Improvements:
> > > I am interested in addressing this behavior upstream and would appreciate
> > > feedback on which direction would be most useful:
> > >
> > > 1. Diagnostic:
> > >    Warn (e.g., via pr_warn_once()) when nf_conntrack_max is configured to be
> > >    significantly lower than nf_conntrack_buckets via sysctl, notifying the
> > >    operator that early_drop() heuristics may become ineffective under load.
> > >
> > > 2. Documentation:
> > >    Update Documentation/networking/nf_conntrack-sysctl.rst to document the
> > >    tuning implications of sparse hash tables on early eviction.
> >
> > Documentation is good to have, I would suggest you start with this.
> >
> > > 3. Algorithmic:
> > >    Investigate a bounded improvement to candidate selection in sparse tables
> > >    without introducing unacceptable CPU overhead on the drop path.
> >
> > You mean, to improve the situation for this suboptimal configuration?
> >
> > > I'm happy to prepare a patch or provide additional test measurements based
> > > on the discussion.
> > >
> > > Thanks,
> > > Vikash SS
