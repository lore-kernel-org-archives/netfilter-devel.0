From: Patrick McHardy <kaber@trash.net>
Subject: Re: [resend net-next] socket: Added 'transparent' option
Date: Thu, 04 Jun 2009 15:34:18 +0200
Message-ID: <4A27CD5A.6040303@trash.net>
References: <1244122013-25970-1-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, jengelh@medozas.de
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65044 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZFDNeT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:34:19 -0400
In-Reply-To: <1244122013-25970-1-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Laszlo Attila Toth wrote:
> +++ b/include/linux/netfilter/xt_socket.h
> @@ -0,0 +1,8 @@
> +#ifndef _XT_SOCKET_H_match
> +#define _XT_SOCKET_H_match
> +
> +struct xt_socket_match_info1 {
> +	__u8 transparent;
> +};

Please use a bitmask.

>  static bool
> -socket_mt(const struct sk_buff *skb, const struct xt_match_param *par)
> +socket_match(const struct sk_buff *skb, const struct xt_match_param *par,
> +	     bool check_transparent)
>  {
>  	const struct iphdr *iph = ip_hdr(skb);
>  	struct udphdr _hdr, *hp = NULL;
> @@ -142,10 +145,22 @@ socket_mt(const struct sk_buff *skb, const struct xt_match_param *par)
>  				   saddr, daddr, sport, dport, par->in, false);
>  	if (sk != NULL) {
>  		bool wildcard = (sk->sk_state != TCP_TIME_WAIT && inet_sk(sk)->rcv_saddr == 0);
> +		bool transparent = (sk->sk_state != TCP_TIME_WAIT &&
> +					inet_sk(sk)->transparent) ||
> +				   (sk->sk_state == TCP_TIME_WAIT &&
> +					inet_twsk(sk)->tw_transparent);
> +		const struct xt_socket_match_info1 *info = NULL;

This is not particulary well readable. Please do the initializations
seperately from the definitions.

> +
> +		if (check_transparent)
> +			info = par->matchinfo;

How about just passing par->matchinfo to socket_match()?

>  		nf_tproxy_put_sock(sk);
> +
>  		if (wildcard)
>  			sk = NULL;
> +		else if (check_transparent && info->transparent &&
> +			 !transparent)
> +			sk = NULL;

Please add a comment what this is doing exactly. And why do the lookup
at all in this case?
