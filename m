Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D0F2EC0B0;
	Tue, 29 Sep 2026 04:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.238.174.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790654789; cv=none; b=bpDkecOxhwjGtnof6wLbS5gA67Hw516q4EiEdP5mTiq1ChXPNwjwmxuQxsJjiGVGwhTGaiLq05re0S593Hj8eePjXlvjPHR39TUN2QjZ+zitxxFy86ZCiMbDJZC4fg9lPknJQ32di083Cz+r6f/Gy92uLudjHVzhIcewCM9qLV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790654789; c=relaxed/simple;
	bh=n1BdDTBfv+TLiE0roTDNFgi7rg6e1pyYG9OSfB4zyz0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=HalbfM6tHOsvCgYadRySwoJrcZChou/cp8QDEIH6gyUbs1j4M57Kiiay/N5YCA+UmXd7p+z20o8o8z6p3NelIgE+lZjjzmJoC/DhYbxPrWIoPKM1STN4HD+1nVAt/6ZaZa1L3tcPMMoYg9icgdbzV7sjVTdWF5Fu29m3l9VBR8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg; spf=pass smtp.mailfrom=ssi.bg; dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b=7ioAko3B; arc=none smtp.client-ip=193.238.174.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b="7ioAko3B"
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id 9CD4A20F96;
	Tue, 29 Sep 2026 07:06:18 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=hDCQEdSK2zaXTb+hNlds7CAFd4ipcl+xGL27RHyx/f0=; b=7ioAko3BrpK7
	sHnHS9w3OhKNc4S3bSQkARosiC5CznWwdpKqheNC2buOjtBpUcsOQ3tyHWaZPAB5
	HKDRM8r2XKDRHc/rdL6YCAro7zFV0cHAM9IMRowTrp3TAadZGK3xd6uPYKZh3hMa
	McIGMO8nfj7yYTFZ7rsv8kaHlDd70EPTux3LGSox4HSMqvyfekAgmu2tEFsvI9Ws
	q0Ro/J9yzg/981gS9IdMz2Zf4ReF+WqjnqxjFZziprRD+xGbuDZXmF0tTZK9RV8H
	b5O3b+EgoSRiHWCBzE4j5cfnjaz+JYS7f2ojTpzPIxkZDV6Py3F6Rwo/ghSOkbvy
	Or1pFvbNCsgjymoduEVwaDl8AMPjPZPW/CVp/QMBx0fg/LSzHMSnh4cAhcD8zVfT
	f8tI49ez0aPE9rMijbOGpQEMournN4k9UXUeLOerWHPc/FxKgxtG27c1wkdEbwio
	aHNFOYULF5ZgoNHEqKgVCqdsrj107xBgENmzLi5wYT3gZ440DAeatezPH7N1WPe5
	miCihgJ2JaYv1LZeyMou/zkmgt6Sz4uSq8NCCJtTqtlkX7y1arP9/GteVf1jJrBz
	Ta5NeH5asKKRj5arNo+2MaTHpuoeAA8rsz4M5VKAb41cU9Iow2xNLpz5+pSALHbg
	KiJSq1Q7q+7baS0OMTeRtAP2SP2CbVs=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Tue, 29 Sep 2026 07:06:18 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id C2291603B4;
	Tue, 29 Sep 2026 07:06:20 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 68T46C30007496;
	Tue, 29 Sep 2026 07:06:12 +0300
Date: Tue, 29 Sep 2026 07:06:12 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: netdev-bot+sashiko@kernel.org
cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, horms@kernel.org, fw@strlen.de
Subject: Re: [PATCH net 02/11] ipvs: fix buffer overflow when sending sync
 messages
In-Reply-To: <179063970014.3145.11099245705422825051@kernel.org>
Message-ID: <2aa8af69-3843-3ffd-cfa4-2daf3c949127@ssi.bg>
References: <20260927220816.268206-3-pablo@netfilter.org> <179063970014.3145.11099245705422825051@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811672-531094360-1790654772=:5433"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-531094360-1790654772=:5433
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

On Mon, 28 Sep 2026, netdev-bot+sashiko@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 (1) · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The commit message for "ipvs: fix buffer overflow when sending
>   sync messages" says the SEQ_MASK race "should not be reproducible",…
> 
> Pre-existing issues:
> - [Medium] After the patch, the flags are a consistent snapshot, but the
>   sequence data is still read without locking and without ordering…
> 
> --
> 
> ipvs: fix buffer overflow when sending sync messages
> 
> This commit changes ip_vs_sync_conn_v0() and ip_vs_sync_conn() to read
> cp->flags once with READ_ONCE(). The same value is then used to size the
> sync entry and to decide whether to emit the sequence options. This
> prevents a heap overflow when another CPU sets IP_VS_CONN_F_SEQ_MASK
> between the two reads.
> 
> Link: https://sashiko.dev/#/patchset/20260903004149.1037028-1-pablo%40netfilter.org
> Link: https://sashiko.dev/#/patchset/20260909111338.44357-1-ja%40ssi.bg
> 
> > Note that IPVS does not set the SEQ_MASK anymore for the
> > ip_vs_ftp.c helper starting from commit 7f1c40757951
> > ("IPVS: make FTP work with full NAT support") (2.6.36+),
> > so the problem should not be reproducible.
> 
> [Severity: Medium]
> Is the "should not be reproducible" part accurate?
> 
> The ip_vs_ftp part is true. ip_vs_ftp_out() and ip_vs_ftp_in() always set
> *diff = 0, so vs_seq_update() is never reached. However, the SEQ bits
> still seem to have another writer, and received sync messages drive it.
> 
> In ip_vs_proc_conn(), an existing connection has its flags updated under
> cp->lock:
> 
> net/netfilter/ipvs/ip_vs_sync.c:ip_vs_proc_conn() {
>     ...
> 		flags &= IP_VS_CONN_F_BACKUP_UPD_MASK;
> 		flags |= cp->flags & ~IP_VS_CONN_F_BACKUP_UPD_MASK;
> 		cp->flags = flags;
>     ...
> }
> 
> IP_VS_CONN_F_BACKUP_UPD_MASK includes the SEQ bits:
> 
> #define IP_VS_CONN_F_BACKUP_UPD_MASK (IP_VS_CONN_F_INACTIVE | \
> 				      IP_VS_CONN_F_SEQ_MASK)
> 
> ip_vs_proc_sync_conn() masks the wire flags with IP_VS_CONN_F_BACKUP_MASK,
> which also keeps the SEQ bits. It does not require an IPVS_OPT_SEQ_DATA
> option to be present. So a peer's sync message can set or clear the SEQ
> bits on an existing connection.
> 
> start_sync_thread() checks the master and backup roles separately and then
> does ipvs->sync_state |= state, so one node can run both daemons. On such
> a node:
> 
> CPU1 (backup kthread)
> ip_vs_process_message()
>   ip_vs_proc_sync_conn()
>     ip_vs_proc_conn()
>       cp->flags = flags;    /* SEQ bits toggled */
> 
> CPU2 (packet path, or ip_vs_conn_expire())
> ip_vs_in()
>   ip_vs_sync_conn()
>     reads cp->flags to compute len, then again for IPVS_OPT_SEQ_DATA
> 
> Before this patch, that double read could size len without the options.
> It could then write struct ip_vs_sync_conn_options past buff->end.
> 
> Sync traffic is unauthenticated; a later patch in this series calls it
> not secure by design. Also, "ipvs: filter some flags received in the
> backup server" does not filter the SEQ bits, so this writer is still
> live at the end of the series.
> 
> Could the commit message drop the "should not be reproducible" claim and
> mention the backup update path? The code change itself does look like it
> closes the overflow.
> 
> > diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> > index 5383aeafb0aed..dfa8487ec0c20 100644
> > --- a/net/netfilter/ipvs/ip_vs_sync.c
> > +++ b/net/netfilter/ipvs/ip_vs_sync.c
> 
> [ ... ]
> 
> > @@ -647,6 +650,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
> >  sloop:
> >  	if (!ip_vs_sync_conn_needed(ipvs, cp, pkts))
> >  		goto control;
> > +	flags = READ_ONCE(cp->flags);
> >  
> >  	/* Sanity checks */
> >  	pe_name_len = 0;
> 
> [ ... ]
> 
> > @@ -744,7 +749,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
> >  		s->v4.vaddr = cp->vaddr.ip;
> >  		s->v4.daddr = cp->daddr.ip;
> >  	}
> > -	if (cp->flags & IP_VS_CONN_F_SEQ_MASK) {
> > +	if (seq_mask) {
> >  		*(p++) = IPVS_OPT_SEQ_DATA;
> >  		*(p++) = sizeof(struct ip_vs_sync_conn_options);
> >  		hton_seq(&cp->in_seq, (struct ip_vs_seq *)p);
> 
> [Severity: Medium]
> This is a pre-existing issue, not one introduced by this patch. The flags
> are now a consistent snapshot, but the sequence data is still read
> without cp->lock. Nothing orders that read against READ_ONCE(cp->flags).
> Can the master send stale or half-updated ip_vs_seq values here?
> 
> ip_vs_sync_conn() here only holds ipvs->sync_buff_lock. The same applies
> to the memcpy() of cp->sync_conn_opt in ip_vs_sync_conn_v0().
> 
> On the backup side, ip_vs_proc_conn() sets the SEQ bits in cp->flags under
> cp->lock and drops the lock. Only after that does it copy the sequence
> data, with no lock held:
> 
> net/netfilter/ipvs/ip_vs_sync.c:ip_vs_proc_conn() {
>     ...
> 		cp->flags = flags;
> 		spin_unlock_bh(&cp->lock);
>     ...
> 	if (opt) {
> 		cp->in_seq = opt->in_seq;
> 		cp->out_seq = opt->out_seq;
> 	}
>     ...
> }
> 
> On a node running both the master and backup daemons, ip_vs_sync_conn()
> could see seq_mask set and then send old or torn init_seq, delta and
> previous_delta values. A peer with an app bound to that connection would
> then apply the wrong TCP seq/ack adjustment after failover.

	Agreed, this can be improved to take a snapshot of
flags and seqs together under lock. I'll request to drop
this version, it is not urgent to apply it.

> vs_seq_update() in ip_vs_app.c is another writer. It updates the sequence
> data and flags under cp->lock, but the sync reader never takes that lock.
> In-tree it is only reached with diff != 0, which ip_vs_ftp never
> produces.
> 
> This does not corrupt memory, because the buffer size and the option
> emission now both come from the same snapshot.
> 
> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927220816.268206-2-pablo%40netfilter.org

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-531094360-1790654772=:5433--

