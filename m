From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/1] socket: Added 'transparent' option
Date: Tue, 05 May 2009 17:52:39 +0200
Message-ID: <4A0060C7.4060007@trash.net>
References: <1240589223-12494-1-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45376 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZEEPwk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 May 2009 11:52:40 -0400
In-Reply-To: <1240589223-12494-1-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Laszlo Attila Toth wrote:
> Added new revision of the 'socket' match. If its new option is set,
> enabled 'transparent' socket option is required for the socket to be matched.
> 
> +socket_match(const struct sk_buff *skb, const struct xt_match_param *par, bool check_transparent)
>  {
>  	const struct iphdr *iph = ip_hdr(skb);
>  	struct udphdr _hdr, *hp = NULL;
> @@ -142,10 +144,19 @@ socket_mt(const struct sk_buff *skb, const struct xt_match_param *par)
>  				   saddr, daddr, sport, dport, par->in, false);
>  	if (sk != NULL) {
>  		bool wildcard = (sk->sk_state != TCP_TIME_WAIT && inet_sk(sk)->rcv_saddr == 0);
> +		bool transparent = (sk->sk_state != TCP_TIME_WAIT && inet_sk(sk)->transparent) ||
> +				   (sk->sk_state == TCP_TIME_WAIT && inet_twsk(sk)->tw_transparent);
> +		const struct xt_socket_match_info *info;

Please use proper line breaks at 80 characters.


