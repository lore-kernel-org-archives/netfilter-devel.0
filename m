Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AFA470429;
	Mon, 28 Sep 2026 23:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790639702; cv=none; b=AQBj5P6B886GUZ/j1hNxpx99Q6QvZ145q27N5dgWfdTjIlSZ0mSi8ObdzsvEqdcsvFFeeUWnvIRVCiW8jQQFvzCGC+7AiuuHrC/Pqacv5GJHl+5gPK9uMDRhQPDlG0zVWa49GtZLaqKxhOx0dkPIV1Oc9Vi3tSz2x/0PqOamblA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790639702; c=relaxed/simple;
	bh=GMYLWElEPaDNYpuF7kcK/VGOjMVakxVkFK1sPX0Ak/s=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SAqlURlLeoi21nj8P0dgrGOO1D7HMv7NvpuhrG8OClyHCc9+0ZMlBnqGXyg87XJrSkxzTCODl7SJ0zqyhJeLR6Sj10KBSFYkv/DT+HeJU6bWfU9SVFgehw6kr0lJUVR87H94tAOv7E9aE3A2VkTpJj8fwsC3B86VyVBWE6eobm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=muxbDkVm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="muxbDkVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9843A1F000FF;
	Mon, 28 Sep 2026 23:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790639701;
	bh=JF0EuAvkoeFjqrzcUGARKPUfjOv5fyAiOQr0rrazrGs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=muxbDkVmCxWq2gzqHqxSYWxToQBz1WkYphkiZThPbj20fNDLE01U4O6rJae1AttQJ
	 VjQpGixE0gtHWM/qOSE2LUuK6pAyRc3RO7tU7SARcvKiSDV4/1TDxHN+alkLJdVq/B
	 2FSKQxgoStKx7Z8Tl+vuZm1TJNk8Uw3URBcXQ+lqC2wdzF4LMupXRZQGFFhsX/vhtr
	 nFsZ1ka2IK/YxTboQFnnDtzLhizrlC+pgn+xiorZBfSZ6GHlfiBr65zTbdVSQyXf5Z
	 4LC52avARIIhSPQ2iRgnrUCkYwMAB11YqL2WauEN/498zfqJhLEhaqaS2xHNx0WJhU
	 Bvgn9HyNPB2YQ==
Subject:
 Re: [PATCH net 02/11] ipvs: fix buffer overflow when sending sync messages
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Mon, 28 Sep 2026 23:55:00 +0000
Message-ID: <179063970014.3145.11099245705422825051@kernel.org>
In-Reply-To: <20260927220816.268206-3-pablo@netfilter.org>
References: <20260927220816.268206-3-pablo@netfilter.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 (1) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message for "ipvs: fix buffer overflow when sending
  sync messages" says the SEQ_MASK race "should not be reproducible",…

Pre-existing issues:
- [Medium] After the patch, the flags are a consistent snapshot, but the
  sequence data is still read without locking and without ordering…

--

ipvs: fix buffer overflow when sending sync messages

This commit changes ip_vs_sync_conn_v0() and ip_vs_sync_conn() to read
cp->flags once with READ_ONCE(). The same value is then used to size the
sync entry and to decide whether to emit the sequence options. This
prevents a heap overflow when another CPU sets IP_VS_CONN_F_SEQ_MASK
between the two reads.

Link: https://sashiko.dev/#/patchset/20260903004149.1037028-1-pablo%40netfilter.org
Link: https://sashiko.dev/#/patchset/20260909111338.44357-1-ja%40ssi.bg

> Note that IPVS does not set the SEQ_MASK anymore for the
> ip_vs_ftp.c helper starting from commit 7f1c40757951
> ("IPVS: make FTP work with full NAT support") (2.6.36+),
> so the problem should not be reproducible.

[Severity: Medium]
Is the "should not be reproducible" part accurate?

The ip_vs_ftp part is true. ip_vs_ftp_out() and ip_vs_ftp_in() always set
*diff = 0, so vs_seq_update() is never reached. However, the SEQ bits
still seem to have another writer, and received sync messages drive it.

In ip_vs_proc_conn(), an existing connection has its flags updated under
cp->lock:

net/netfilter/ipvs/ip_vs_sync.c:ip_vs_proc_conn() {
    ...
		flags &= IP_VS_CONN_F_BACKUP_UPD_MASK;
		flags |= cp->flags & ~IP_VS_CONN_F_BACKUP_UPD_MASK;
		cp->flags = flags;
    ...
}

IP_VS_CONN_F_BACKUP_UPD_MASK includes the SEQ bits:

#define IP_VS_CONN_F_BACKUP_UPD_MASK (IP_VS_CONN_F_INACTIVE | \
				      IP_VS_CONN_F_SEQ_MASK)

ip_vs_proc_sync_conn() masks the wire flags with IP_VS_CONN_F_BACKUP_MASK,
which also keeps the SEQ bits. It does not require an IPVS_OPT_SEQ_DATA
option to be present. So a peer's sync message can set or clear the SEQ
bits on an existing connection.

start_sync_thread() checks the master and backup roles separately and then
does ipvs->sync_state |= state, so one node can run both daemons. On such
a node:

CPU1 (backup kthread)
ip_vs_process_message()
  ip_vs_proc_sync_conn()
    ip_vs_proc_conn()
      cp->flags = flags;    /* SEQ bits toggled */

CPU2 (packet path, or ip_vs_conn_expire())
ip_vs_in()
  ip_vs_sync_conn()
    reads cp->flags to compute len, then again for IPVS_OPT_SEQ_DATA

Before this patch, that double read could size len without the options.
It could then write struct ip_vs_sync_conn_options past buff->end.

Sync traffic is unauthenticated; a later patch in this series calls it
not secure by design. Also, "ipvs: filter some flags received in the
backup server" does not filter the SEQ bits, so this writer is still
live at the end of the series.

Could the commit message drop the "should not be reproducible" claim and
mention the backup update path? The code change itself does look like it
closes the overflow.

> diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> index 5383aeafb0aed..dfa8487ec0c20 100644
> --- a/net/netfilter/ipvs/ip_vs_sync.c
> +++ b/net/netfilter/ipvs/ip_vs_sync.c

[ ... ]

> @@ -647,6 +650,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
>  sloop:
>  	if (!ip_vs_sync_conn_needed(ipvs, cp, pkts))
>  		goto control;
> +	flags = READ_ONCE(cp->flags);
>  
>  	/* Sanity checks */
>  	pe_name_len = 0;

[ ... ]

> @@ -744,7 +749,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
>  		s->v4.vaddr = cp->vaddr.ip;
>  		s->v4.daddr = cp->daddr.ip;
>  	}
> -	if (cp->flags & IP_VS_CONN_F_SEQ_MASK) {
> +	if (seq_mask) {
>  		*(p++) = IPVS_OPT_SEQ_DATA;
>  		*(p++) = sizeof(struct ip_vs_sync_conn_options);
>  		hton_seq(&cp->in_seq, (struct ip_vs_seq *)p);

[Severity: Medium]
This is a pre-existing issue, not one introduced by this patch. The flags
are now a consistent snapshot, but the sequence data is still read
without cp->lock. Nothing orders that read against READ_ONCE(cp->flags).
Can the master send stale or half-updated ip_vs_seq values here?

ip_vs_sync_conn() here only holds ipvs->sync_buff_lock. The same applies
to the memcpy() of cp->sync_conn_opt in ip_vs_sync_conn_v0().

On the backup side, ip_vs_proc_conn() sets the SEQ bits in cp->flags under
cp->lock and drops the lock. Only after that does it copy the sequence
data, with no lock held:

net/netfilter/ipvs/ip_vs_sync.c:ip_vs_proc_conn() {
    ...
		cp->flags = flags;
		spin_unlock_bh(&cp->lock);
    ...
	if (opt) {
		cp->in_seq = opt->in_seq;
		cp->out_seq = opt->out_seq;
	}
    ...
}

On a node running both the master and backup daemons, ip_vs_sync_conn()
could see seq_mask set and then send old or torn init_seq, delta and
previous_delta values. A peer with an app bound to that connection would
then apply the wrong TCP seq/ack adjustment after failover.

vs_seq_update() in ip_vs_app.c is another writer. It updates the sequence
data and flags under cp->lock, but the sync reader never takes that lock.
In-tree it is only reached with diff != 0, which ip_vs_ftp never
produces.

This does not corrupt memory, because the buffer size and the option
emission now both come from the same snapshot.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927220816.268206-2-pablo%40netfilter.org
