Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.238.174.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794891504;
	b=a4uMvXD6vwHzWq1Zkx5c0x+Zdw3pF9CLTPMiony7OwI0wnOdrYnuUgxyOCp1NUWCoJzT
	 XRqRisKlP6Y+o3o1xfTSIEppVYoEg4plFPd2UxkrKRxJbmqc+UEXPaKGJPS0pj+w4m5z3
	 8sJoZ2/uuxvYpDjv+mHY3Wc1/Um8kv5iaKEZRcxVpADBKFMeszrC3DLEprZ7b4L1ZrRCg
	 GhFgZD/oHDB9Arl3DQ3+kJT0qt8zrDgNYy2Hbg9FpziiHpi4yH56pG4VzPQZM3+jLVI5O
	 vO/MahZZMiyWjTw+1eQrsuWunjYVfAjlIaUqS/ZtVUC0+Nf9ONiA+67yFVA287qNlKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794891504;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:Date:
	 From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:
	 Content-Type;
	bh=NtvNavLhdF5VqzN3U/lxKGZTbJ2uLaBHlsvnWRO5TGY=;
	b=wTbV2X/rks+Y+6hYb3FLq6iT/IMyLt92dX9bnRMlACm3JEWaXJH0wZV7JxWB12yz2TOk
	 irzEj5+YVwk7seqgJCBXeLWQ06qqagfmYbHmfcuTxKDrzoesYGVAANP8ZZAkPmdMM61Zg
	 FDVEWd5XrN7w87SXiRnFWhTq4yjJuQSVLStigUB/aB4JHDbeuaMzIocCxyBqyXogPzbQa
	 ZEqwdxnhHlqC9Fr9JY8TsXARzgFkiphg/44BXkWOeK1D1e0GgWcvzyUWBCGypZ3AZTrOh
	 wMNOO2asI9y28sNlQIBoxgOm0wxym7DFqGmgurCjB15F+n+0pooqx4gz00ksC8yxIaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ssi.bg;
	spf=pass smtp.mailfrom=ssi.bg;
	dkim=pass header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b="i/Tm38Ud";
	arc=none smtp.remote-ip=193.238.174.39
Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A18606A329;
	Tue, 17 Nov 2026 04:58:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4A18606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b=i/Tm38Ud
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id 9BD7C21FD1;
	Tue, 17 Nov 2026 06:58:19 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=NtvNavLhdF5VqzN3U/lxKGZTbJ2uLaBHlsvnWRO5TGY=; b=i/Tm38Ud2Lx5
	U5CCydP9ThSlQ9sdIn4/XPOWBBdyJsKDg6emeez3NmLlUAnBPBYaM5URKEEgn9ow
	NI7uw+tO5lERAVZuo/aqGXqXbLmvM01vx1gVwPLbl7AZRM4qB3M3FEBfOMlRCqU3
	20gJwwLQ4jUnsA7FaEFVFBaLEFBVgu4ZMERA6ccWcWqTh6JtgzAjT+Yhc6w2MDRm
	QrPk5LCJ1Q0rDYWGfj9vnY+ZXd3ZFIOu/KFsVhHSqhfQ8aHwhP32LlVCfKVJI+nu
	YOjdXocmfvWF2/jgE3VIE++HeuJG71yGH0bGQ5e3Nkn7rCFvNXB3AfhKkslRFITQ
	8aHf93HnvlsOvN9R9YW+VU1rhgNcLVthyS6RKBsEp4iXWCorBt33P6dbfccFNOxd
	YASxWA/galH3tHShJOXPWehF5AKfr/JKZt4XVSCYLXtE1FbYILc4Oey6ZYcCR1fa
	8QcxjaHV9RqV77IHBhNI6MyQr9vb1q70IKEqDYAyRj0aIxGuBdO37B1/kH/9mH3V
	y36uKYQfOeCj/t16zSZ13f7uyMsmfXym0nBcjB1K9tgFkeQkOCiw7EoSl78gSLs3
	gkvZPaJNDxJIR/SG3KepGXBc2n0S/AQ/Zdy1ZxEAL2zWnPQejtPgsw/CpgvIIAMq
	3BLNb++zvqbJ3d38flctK8q5cG1vOrY=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Tue, 17 Nov 2026 06:58:19 +0200 (EET)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 0718160572;
	Tue, 17 Nov 2026 06:58:19 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 6AH4wGOk008059;
	Tue, 17 Nov 2026 06:58:16 +0200
Date: Tue, 17 Nov 2026 06:58:16 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: netdev-bot+sashiko@kernel.org
cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@kernel.org, horms@kernel.org, fw@strlen.de
Subject: Re: [PATCH net 05/11] ipvs: update flags and seqs in backup server
 under lock
In-Reply-To: <179487963105.3136.8669444891088576096@kernel.org>
Message-ID: <6f59fbeb-d5cb-afef-1731-a272418ee6ff@ssi.bg>
References: <20261116004404.2821183-6-pablo@netfilter.org> <179487963105.3136.8669444891088576096@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811672-183751456-1794891497=:5807"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-183751456-1794891497=:5807
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

On Tue, 17 Nov 2026, netdev-bot+sashiko@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 0 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The fix is incomplete.
> 
> --
> 
> ipvs: update flags and seqs in backup server under lock
> 
> This commit extends the cp->lock region in ip_vs_proc_conn() so that the
> backup server updates the conn flags, seqs, state, old_state and timeout
> under the lock. Newly created conns now also take cp->lock before these
> updates. ip_vs_try_bind_dest() is now called after the unlock.
> 
> Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927220816.268206-1-pablo%40netfilter.org
> 
> > diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> > index 1caacf419af99..ba2fa1f9d08ed 100644
> > --- a/net/netfilter/ipvs/ip_vs_sync.c
> > +++ b/net/netfilter/ipvs/ip_vs_sync.c
> 
> [ ... ]
> 
> > @@ -891,9 +892,6 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
> >  		flags &= IP_VS_CONN_F_BACKUP_UPD_MASK;
> >  		flags |= cp->flags & ~IP_VS_CONN_F_BACKUP_UPD_MASK;
> >  		cp->flags = flags;
> > -		spin_unlock_bh(&cp->lock);
> > -		if (!dest)
> > -			ip_vs_try_bind_dest(cp);
> >  	} else {
> >  		/*
> >  		 * Find the appropriate destination for the connection.
> 
> [ ... ]
> 
> > @@ -951,6 +951,9 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
> >  		else
> >  			cp->timeout = (3*60*HZ);
> >  	}
> > +	spin_unlock_bh(&cp->lock);
> > +	if (!dest && !cp_new)
> > +		ip_vs_try_bind_dest(cp);
> 
> [Severity: High]
> Can the backup server still write cp->flags without cp->lock through this
> ip_vs_try_bind_dest() call?
> 
> ip_vs_try_bind_dest() holds cp->lock only around ip_vs_unbind_app() and
> ip_vs_bind_dest(). It drops the lock before it rebinds the transmitter and
> the app:
> 
> net/netfilter/ipvs/ip_vs_conn.c:ip_vs_try_bind_dest() {
>     ...
> 		ip_vs_bind_dest(cp, dest);
> 		spin_unlock_bh(&cp->lock);
> 
> 		/* Update its packet transmitter */
> 		cp->packet_xmit = NULL;
>     ...
> 		pd = ip_vs_proto_data_get(cp->ipvs, cp->protocol);
> 		if (pd && atomic_read(&pd->appcnt))
> 			ip_vs_bind_app(cp, pd->pp);
>     ...
> }
> 
> For a MASQ conn, ip_vs_bind_app() reaches tcp_app_conn_bind(), which sets
> cp->app and calls inc->init_conn(). For the FTP helper, that is:
> 
> net/netfilter/ipvs/ip_vs_ftp.c:ip_vs_ftp_init_conn() {
> 	/* We use connection tracking for the command connection */
> 	cp->flags |= IP_VS_CONN_F_NFCT;

	This problem is deep in my TODO list. It is not locked only
for the backup context, not for the normal packet context, so it
needs a proper separate fix.

> 	return 0;
> }
> 
> This is a non-atomic read-modify-write of cp->flags on a conn that is
> already hashed. The other runtime writers of cp->flags hold cp->lock:
> 
> - set_tcp_state() and set_sctp_state() toggle IP_VS_CONN_F_INACTIVE and
>   adjust the dest counters.
> - vs_seq_update() sets IN_SEQ/OUT_SEQ.
> - ip_vs_in_hook() clears NFCT.
> 
> The path is:
> 
> ip_vs_process_message()
>   ip_vs_proc_conn()            /* existing conn, cp->dest == NULL */
>     spin_unlock_bh(&cp->lock)
>     ip_vs_try_bind_dest()
>       spin_unlock_bh(&cp->lock)
>       ip_vs_bind_app()
>         tcp_app_conn_bind()
>           ip_vs_ftp_init_conn()   /* unlocked cp->flags |= ... */
> 
> This can happen when all of the following are true:
> 
> - A synced MASQ conn for an FTP virtual service was created unbound,
>   because the real server was not yet configured on the backup.
> - The dest is added later.
> - The next sync message for that conn arrives while the backup is also
>   forwarding its traffic.
> 
> Suppose tcp_state_transition() on another CPU sets IP_VS_CONN_F_INACTIVE
> under cp->lock and moves activeconns/inactconns at the same time. Would
> the unlocked write here put back the stale flags?
> 
> The flags and the dest counters would then disagree, and the wrong counter
> would be decremented when the conn is unbound. IN_SEQ/OUT_SEQ bits could
> be lost the same way. This code path also looks unchanged by the rest of
> the series.
> 
> The commit message says:
> 
>   "Sashiko reports that we modify the conn flags and seq values in
>   the backup server without holding cp->lock."
> 
> Should this path be covered as well?
> 
> >  	ip_vs_conn_put(cp);
> >  }
> >
> 
> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116004404.2821183-2-pablo%40netfilter.org

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-183751456-1794891497=:5807--

