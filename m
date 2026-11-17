Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794879632;
	b=PEb17Lm8eZozOs6ha645tZlpMBIHloJ3TC367+tSl7dxf9tyzQYBlDp4wwyRo+fATLLW
	 wJ7VvPOpQcaVDexsBZJXMNdT7jGZrCwa1fxsfHI+sRdd5gYwDCHQgCRq5YJzN6/wFxXTC
	 9ZO3lCeHArnJaVD4ZPhz38PMvJyEuSzRxKEyU+WdDk7I6+TtVu4HBQpjpdm7WyQzqL7/i
	 0KkJ6xh6P2IojKy080ql8T592zpAw0qZJ7WP+4sFo4xq+YPFe06D6WmfwaH+2JzHLXimY
	 FCLjw4qOan6vs4Y0Bk0iuu35linzrVlJv/3ZFGuFp6gEEw31GtSPyfr2H7ZdRJYAmtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794879632;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=DfqA+cxvT1tg7nY7uX4m+b8n5bqFDqQUVLlQWc1FIrA=;
	b=J+PWQF48DJWSPg2QTgJmUdlGn+HOv1isxrQxjoHcOcPMdoWHuZNFDo4sJNpOI6u2tqya
	 ID0koWSPEeQZQSY5nfEM9+68S9s2wvVpnkQ8eWyJZZK9KYQS5G6eZErQZUh316ZsyemxP
	 4/ZvYRZJkI8xJ5meDZo2Y8FL1F7J6ZNs76ewNVrm3t77NyZEQneMsKHMlW1+g2lmOs44P
	 Gny7Fy8I2bmgCjC/6Nq4Q+FSOqqAyvdmqhfx2u91FvoTr/TO7QSjujn6YSecYun9qPdPp
	 3ucA7y8ibF99Nju2H4JV8RS/KyVWJ7Nc3MOxKzx/Q9THH9MdDefx4m635yG1w2X6yYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="aerOq3/D";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F10606A337;
	Tue, 17 Nov 2026 01:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aerOq3/D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738A71F000C4;
	Tue, 17 Nov 2026 01:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794879632;
	bh=DfqA+cxvT1tg7nY7uX4m+b8n5bqFDqQUVLlQWc1FIrA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=aerOq3/DfQDk5X/MLEdOrfQyTfnGzfmGX7P9rAHGJKiTmHJGe/BvRI5yKMwHhZnPN
	 An03gQGDCpPyeilryv1dwe2P9W+0NxmX43VMYDHz5bOuIgIFbgXbmpmBBehS6c1wby
	 dpGWhX+wu4hS5soUl2LQg4z56V6pudqOhNHfXwmWVbQnD5G44c/yfAlc/uxUNmvjMl
	 /jc3MyLPcMqADib0TYs5lQIakdMqBHFtpeUL86gtoYkjkOyuKbQJuIxnRl+28MYBqd
	 WlwL2/m7jOh9zyIsEVmOxJ59MB7gNo2lS4Y3ukjhOF2k1hG+x8jR/8BH3v0N7j2tcH
	 xIBRi6tPJINPw==
Subject:
 Re: [PATCH net 05/11] ipvs: update flags and seqs in backup server under lock
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 17 Nov 2026 01:40:31 +0000
Message-ID: <179487963105.3136.8669444891088576096@kernel.org>
In-Reply-To: <20261116004404.2821183-6-pablo@netfilter.org>
References: <20261116004404.2821183-6-pablo@netfilter.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete.

--

ipvs: update flags and seqs in backup server under lock

This commit extends the cp->lock region in ip_vs_proc_conn() so that the
backup server updates the conn flags, seqs, state, old_state and timeout
under the lock. Newly created conns now also take cp->lock before these
updates. ip_vs_try_bind_dest() is now called after the unlock.

Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927220816.268206-1-pablo%40netfilter.org

> diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> index 1caacf419af99..ba2fa1f9d08ed 100644
> --- a/net/netfilter/ipvs/ip_vs_sync.c
> +++ b/net/netfilter/ipvs/ip_vs_sync.c

[ ... ]

> @@ -891,9 +892,6 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
>  		flags &= IP_VS_CONN_F_BACKUP_UPD_MASK;
>  		flags |= cp->flags & ~IP_VS_CONN_F_BACKUP_UPD_MASK;
>  		cp->flags = flags;
> -		spin_unlock_bh(&cp->lock);
> -		if (!dest)
> -			ip_vs_try_bind_dest(cp);
>  	} else {
>  		/*
>  		 * Find the appropriate destination for the connection.

[ ... ]

> @@ -951,6 +951,9 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
>  		else
>  			cp->timeout = (3*60*HZ);
>  	}
> +	spin_unlock_bh(&cp->lock);
> +	if (!dest && !cp_new)
> +		ip_vs_try_bind_dest(cp);

[Severity: High]
Can the backup server still write cp->flags without cp->lock through this
ip_vs_try_bind_dest() call?

ip_vs_try_bind_dest() holds cp->lock only around ip_vs_unbind_app() and
ip_vs_bind_dest(). It drops the lock before it rebinds the transmitter and
the app:

net/netfilter/ipvs/ip_vs_conn.c:ip_vs_try_bind_dest() {
    ...
		ip_vs_bind_dest(cp, dest);
		spin_unlock_bh(&cp->lock);

		/* Update its packet transmitter */
		cp->packet_xmit = NULL;
    ...
		pd = ip_vs_proto_data_get(cp->ipvs, cp->protocol);
		if (pd && atomic_read(&pd->appcnt))
			ip_vs_bind_app(cp, pd->pp);
    ...
}

For a MASQ conn, ip_vs_bind_app() reaches tcp_app_conn_bind(), which sets
cp->app and calls inc->init_conn(). For the FTP helper, that is:

net/netfilter/ipvs/ip_vs_ftp.c:ip_vs_ftp_init_conn() {
	/* We use connection tracking for the command connection */
	cp->flags |= IP_VS_CONN_F_NFCT;
	return 0;
}

This is a non-atomic read-modify-write of cp->flags on a conn that is
already hashed. The other runtime writers of cp->flags hold cp->lock:

- set_tcp_state() and set_sctp_state() toggle IP_VS_CONN_F_INACTIVE and
  adjust the dest counters.
- vs_seq_update() sets IN_SEQ/OUT_SEQ.
- ip_vs_in_hook() clears NFCT.

The path is:

ip_vs_process_message()
  ip_vs_proc_conn()            /* existing conn, cp->dest == NULL */
    spin_unlock_bh(&cp->lock)
    ip_vs_try_bind_dest()
      spin_unlock_bh(&cp->lock)
      ip_vs_bind_app()
        tcp_app_conn_bind()
          ip_vs_ftp_init_conn()   /* unlocked cp->flags |= ... */

This can happen when all of the following are true:

- A synced MASQ conn for an FTP virtual service was created unbound,
  because the real server was not yet configured on the backup.
- The dest is added later.
- The next sync message for that conn arrives while the backup is also
  forwarding its traffic.

Suppose tcp_state_transition() on another CPU sets IP_VS_CONN_F_INACTIVE
under cp->lock and moves activeconns/inactconns at the same time. Would
the unlocked write here put back the stale flags?

The flags and the dest counters would then disagree, and the wrong counter
would be decremented when the conn is unbound. IN_SEQ/OUT_SEQ bits could
be lost the same way. This code path also looks unchanged by the rest of
the series.

The commit message says:

  "Sashiko reports that we modify the conn flags and seq values in
  the backup server without holding cp->lock."

Should this path be covered as well?

>  	ip_vs_conn_put(cp);
>  }
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116004404.2821183-2-pablo%40netfilter.org
