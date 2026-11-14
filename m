Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794622543;
	b=n8y69Fpp11zWDj12oUQoh0lpjFOrHJ88vm+D3rfCElSAh92zPKGsncvuhMssyYgTvX4/
	 mZFZmNzHW4wK6sc8uI/vjn5Xt2TkVomCfVq26PMpY99a6qEyEQZhmSrsPR2S5K9a2rV8b
	 L3LzeRpPNWHlbDTk3gC8rlST/XSbnLCZIfTq6+Bk5M/4vbaL/LCC6ZeU7nTz5mOKRkg74
	 zN5lZR1vJ+LPVcx9Gk/Vbk26HIEK/8IfdRC0pQHwwwERFGSZinZP4wpcpzdXi231gyTix
	 w3Xu5wuxNvWQWd36GZnEw4zy7j4OPQD4JhFUegCcP4WEQTAsMQuNcnrcTooReEbwI4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794622543;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=7McMDbOIQ4W/arVxJ2j2bXQ1Ce5dX3OQSA31MNX80Oo=;
	b=cfyoiGdTj9UI4nTh0uCc1MUGZtg9kelfg38+W4yx6+Pl1luRWVQIVtDreJhjiqPObGMg
	 ZCGSkKnjQw47bE4YcztQBU0TQ6V7fyfSY17ixICJeSSN1RC3Qf6vsicx2gHXYn2yqmZH9
	 4vuO+7AKK8vjtlMGELN2oO5cPJk5zDrgaqXLKCoXrH4Japc84fiWKwZ2wCiMznjzQLAR5
	 pVhFWy/qhkWEoqDf2vAlcT77lXirR7mR7QQLauZiruZ3Qjexmmm+vO/YsLr/wsqJ5JgZJ
	 IXn+rtPepsmhBNFt87rZEskV6mAyUnkNF6lQalXe8KmBC2CfqjwKi/Pkqd4V7chtVWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="oqF/AhwN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5EF606A88C;
	Sat, 14 Nov 2026 02:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oqF/AhwN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4F01F000CB;
	Sat, 14 Nov 2026 02:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794622543;
	bh=7McMDbOIQ4W/arVxJ2j2bXQ1Ce5dX3OQSA31MNX80Oo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=oqF/AhwN8StSNxgJuATfgMBCjYRRW7fGOmFaMpouDRR2tXEpOwL73Zn/Qh5gqJyXN
	 lpkledPALWtFkq0CEPNleeNTxJIFejMXuDa4UCjnGjNGPzSs1Y6y2aIEea6PFAdkIa
	 js8s60QezviAcps8zepykp0SoXBNsLL0rgiJ4mMqZw8MDcXry738vE8BDaUFzUfIcJ
	 wZ0VSwme+VLEUcKc00kq6i0iQFRf6kpP5Qix+vW2eteL0M4bS/4+fIAsTpoOOIJW1o
	 ltxBZBcTCuRhGFrtdpHQBNQC6KPVKOMmooOEqKR2VTVQDxtVfoRSRYeOgMW7JT0M54
	 krbyDUg7yXo2A==
Subject: Re: [PATCH net 05/15] ipvs: reject FTP control ports as data ports
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 02:15:42 +0000
Message-ID: <179462254263.2199510.8837041620739510741@kernel.org>
In-Reply-To: <20261113011447.2357709-6-pablo@netfilter.org>
References: <20261113011447.2357709-6-pablo@netfilter.org>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The two new rejection checks in ip_vs_ftp_in() and
  ip_vs_ftp_out() return 0.

--

ipvs: reject FTP control ports as data ports

This patch adds is_control_port() to the IPVS FTP helper and uses it to
refuse a zero port, or a configured FTP control port, as a data port.
ip_vs_ftp_out() refuses such ports in PASV/EPSV replies. ip_vs_ftp_in()
refuses PORT/EPRT commands that carry a zero port, or where vport - 1 is
a control port.

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

[Severity: Medium]
Does returning 0 here stall the whole FTP control connection, rather than
only refusing the data connection?

The pkt_in/pkt_out contract in include/net/ip_vs.h treats 0 as an error:

    Return: 0=Error, 1=Payload Not Mangled/Mangled but checksum is ok,

On the inbound side, tcp_dnat_handler() passes that result up:

    if (!(ret = ip_vs_app_pkt_in(cp, skb, iph)))
        return 0;

ip_vs_nat_xmit() then takes the tx_error path and frees the skb. The
segment that carries the PORT/EPRT command is dropped.

cp->vport is fixed for the life of the connection, and ip_vs_ftp_in()
keeps no state for this case. Every retransmission of that segment is
parsed the same way and dropped again. Nothing after it in the TCP stream
gets through until the client's TCP gives up (tcp_retries2).

If vport - 1 is also in the ports module parameter (for example
ports=2120,2121), would active mode hang for every client of that service?
A client that sends PORT/EPRT with port 0 would hang its own session the
same way.

The check added to ip_vs_ftp_out() above behaves similarly. It returns 0
while cp->app_data is still IP_VS_FTP_PASV or IP_VS_FTP_EPSV, and
tcp_snat_handler() passes that up:

    if (!(ret = ip_vs_app_pkt_out(cp, skb, iph)))
        return 0;

handle_response() then drops the 227/229 reply. The server retransmits
it, the same port is parsed again, and the reply is dropped again.

The existing ret = 0 path at the end of ip_vs_ftp_out() sets
cp->app_data = IP_VS_FTP_ACTIVE before it returns, so it never re-parses
the reply. The ip_vs_conn_new() failure return is transient, which fits
the existing "hopefully it will succeed on the retransmitted packet"
comment. The new checks reject the same input every time.

Could ip_vs_ftp_in() return 1 here without creating the data connection,
since nothing is mangled on that path anyway? And could ip_vs_ftp_out()
set cp->app_data to IP_VS_FTP_ACTIVE before rejecting, so that only the
data connection fails?

>  	/* Passive mode off */
>  	cp->app_data = (void *) IP_VS_FTP_ACTIVE;
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113011447.2357709-2-pablo%40netfilter.org
