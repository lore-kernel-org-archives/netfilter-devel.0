Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794879631;
	b=CHeSSLlIyQohxfQkxdv6q8+3TF7zLZ4B8oesMuaB4xpDCA41xl4IAaU8Ree8OeImS4Th
	 npV/VoSoNAu39gktNcwdCyQlC52GwKD9hX7N3ValbJoqmbv0vmoE+tfFBKQ/SzMsUFH9i
	 NFKPXlI9X3lDtQGblkFYcAzelHaDBuu3T72z6vF9PjiY4DZfcPVkvAeFg+gdYe4wcSEo+
	 3iINObm0aJAZp6AJRvzT8NeI2/newyg+e41OM/Gye0tCbo5VcrPBzVRQoWbDwRaAqpB5n
	 RopthlibIP3kD7ZCKNwHI+zdkzf0ivvDCtQ3wj2qg933rjoLXhHS65Vib4CRxlshzWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794879631;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=P/78TN4zpBip53jvAVPl/wLOQX6H0z2TVhUcsrZra6E=;
	b=dW48Wp4I2QSjlVaxa8bcPEk7b5SDJ7vC5jtHgD/w0A++CHVtKUyPzdb5A4gDgvi9H5aM
	 kBDyFWgSR4x0FRx8VZSyJ2NBg7y5Um7O4XQmoeMZJmBycSNuuM78X4yTU2Rq2T6R1I+CQ
	 Bh5XFVDf77n/HaT6zfgxCvdsW9ztzyWerLVQnsLA0zscDknHH8YjIyJNPCS4CUahzqges
	 yLfFYqBD4ia1OuPrA0xuoLXixM5YtWkAvzuwvuAbtaXkHd3Zq8hgsRAKUZ+wDbGW1Xi8P
	 hUSt4X2nYgU0T0JARixiG+zJQNjZogToG1nFeB4712Lcu7bIAMnduyIyxgbD6Lf1jkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ToUd9lRc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FD9606A31C;
	Tue, 17 Nov 2026 01:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ToUd9lRc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606E91F000C4;
	Tue, 17 Nov 2026 01:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794879630;
	bh=P/78TN4zpBip53jvAVPl/wLOQX6H0z2TVhUcsrZra6E=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ToUd9lRcul3MhHeYazGHa4iNRWaz415Rkdyk+NVAPcWIinJpkK/7umKiIfWhl8JSs
	 iZYrzx7DSTN7Qm7lH209TLFF1xuI8w08jiq67FMCozYGf26ZM44+1CtZrhn04E8wPD
	 wHJThCDse6mi53Fne/Itw6cAwP7CGNOXK3KDSSgy9ANOnpYiw/olxic2nkWvJT8yz6
	 foGFKsVYT9HVRP96m+9Z6h2K7T60/8AZCICPiLcPLrSEbDz8hm6Bz4pOkRBtra9B8/
	 PvEikZalPq4/nrRPFHrCeTmsnEoMeh3c2Ab6nn+sPFtyT/eBwDyk0JfRO3jMMXAgXW
	 Pmd4ibXYgVyeQ==
Subject: Re: [PATCH net 03/11] ipvs: reject FTP control ports as data ports
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 17 Nov 2026 01:40:29 +0000
Message-ID: <179487962993.3136.14851480745296161932@kernel.org>
In-Reply-To: <20261116004404.2821183-4-pablo@netfilter.org>
References: <20261116004404.2821183-4-pablo@netfilter.org>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The new rejection checks in ip_vs_ftp_out() and ip_vs_ftp_in()
  (net/netfilter/ipvs/ip_vs_ftp.c) return 0.
- [Low] The commit message says that accepting a control port as a data
  port 'leads to recursive expiration and kernel stack exhaustion'.

--

ipvs: reject FTP control ports as data ports

This patch adds is_control_port() to the IPVS FTP helper. Before a data
connection is created, the helper now rejects zero ports and configured
FTP control ports. In passive mode it checks the port from the server's
PASV/EPSV reply; in active mode it checks the client port and the derived
data port (vport - 1).

> The FTP helper must not treat a configured control port as a data port.
> Accepting such a port can leave IPVS connections in a state that leads
> to recursive expiration and kernel stack exhaustion.

[Severity: Low]
Is this rationale still accurate once the previous patch in this series
is applied?

"ipvs: avoid stack overflow from recursive connection expiration" already
rewrote ip_vs_conn_expire() so that it walks the ->control chain
iteratively, in a single stack frame:

net/netfilter/ipvs/ip_vs_conn.c:ip_vs_conn_expire() {
    ...
				next = ip_vs_conn_del_reference(ct);
    ...
		if (next) {
			cp = ct;
			goto repeat;
		}
    ...
}

With that change, the recursive expiration described here should no
longer happen in this tree.

Could the commit message point to the companion commit and say what this
guard still prevents now that expiration is iterative? Two candidates are
long chains of FTP-bound data connections, and NO_CPORT entries on
VIP:control-port capturing the client's new control connections.

Both commits carry Cc: stable, but with different Fixes: tags
(f9200a52eedf and 1da177e4c3f4). A stable backporter can't tell from the
messages whether the two are alternatives or must both be applied.

> diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
> index 9e3e005a82635..4822a1a75212d 100644
> --- a/net/netfilter/ipvs/ip_vs_ftp.c
> +++ b/net/netfilter/ipvs/ip_vs_ftp.c

[ ... ]

> @@ -319,6 +330,10 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
>  		return 1;
>  	}
>  
> +	/* Do not redirect data to control ports */
> +	if (!port || is_control_port(ntohs(port)))
> +		return 0;
> +
>  	/* Now update or create a connection entry for it */
>  	{
>  		struct ip_vs_conn_param p;
> @@ -529,6 +544,9 @@ static int ip_vs_ftp_in(struct ip_vs_app *app, struct ip_vs_conn *cp,
>  		return 1;
>  	}
>  
> +	if (!port || is_control_port(ntohs(cp->vport) - 1))
> +		return 0;
> +
>  	/* Passive mode off */
>  	cp->app_data = (void *) IP_VS_FTP_ACTIVE;
>  

[Severity: Medium]
Should these new checks return 0? In include/net/ip_vs.h, struct
ip_vs_app documents pkt_out/pkt_in as:

	Return: 0=Error, 1=Payload Not Mangled/Mangled but checksum is ok,

The callers drop the packet when they get 0:

ip_vs_ftp_in() returns 0
  tcp_dnat_handler() returns 0
    ip_vs_nat_xmit()
	if (pp->dnat_handler && !pp->dnat_handler(skb, pp, cp, ipvsh))
		goto tx_error;

ip_vs_ftp_out() returns 0
  tcp_snat_handler() returns 0
    handle_response()
	if (pp->snat_handler &&
	    !SNAT_CALL(pp->snat_handler, skb, pp, cp, iph))
		goto drop;

So instead of just skipping the data connection, the FTP control segment
itself seems to be dropped silently.

In ip_vs_ftp_in(), the is_control_port(ntohs(cp->vport) - 1) test depends
only on configuration, not on packet contents. Take an FTP virtual service
on port V where V-1 is also in the ports= module parameter (for example
ports=20,21 or ports=2120,2121). Wouldn't every PORT/EPRT command on V be
dropped, retransmissions included? The control session would then stall
until TCP gives up, and nothing would be logged.

Before this patch, active-mode FTP worked in that configuration. The data
connection was created with vport V-1, and tcp_app_conn_bind() also bound
it to the FTP app, because binding depends only on the vport.

In ip_vs_ftp_out(), the return 0 comes before cp->app_data is reset to
IP_VS_FTP_ACTIVE. Wouldn't each retransmitted 227/229 reply then be parsed
and dropped again? A comment later in that function justifies a 0 return
only because mangling failures are transient:

		 * Mangling can only fail under memory pressure,
		 * hopefully it will succeed on the retransmitted
		 * packet.

This rejection isn't transient.

Would returning 1 work better here? The payload would pass through
unmangled and no data connection would be created. The control session
would survive (the server reports a data connection failure), and the
self-binding would still be prevented. A rate-limited log message might
also help.

Since this is tagged for stable, could the commit message also say that
active FTP stops working when V-1 is also a configured control port?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116004404.2821183-2-pablo%40netfilter.org
