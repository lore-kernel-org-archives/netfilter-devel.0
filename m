From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 6/6] ulogd: use snprintf instead of sprintf in printpkt
Date: Thu, 30 Sep 2010 11:48:50 +0200
Message-ID: <4CA45D02.8040702@netfilter.org>
References: <1285116442-32490-1-git-send-email-eric@inl.fr> <1285116442-32490-7-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43501 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab0I3Jsy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:48:54 -0400
In-Reply-To: <1285116442-32490-7-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

On 22/09/10 02:47, Eric Leblond wrote:
> diff --git a/util/printpkt.c b/util/printpkt.c
> index 5250792..a800555 100644
> --- a/util/printpkt.c
> +++ b/util/printpkt.c
> @@ -106,91 +106,93 @@ struct ulogd_key printpkt_keys[] = {
>  	[KEY_SCTP_DPORT]	= { .name = "sctp.dport", },
>  };
>  
> -static int printpkt_proto(struct ulogd_key *res, char *buf, int protocol)
> +static int printpkt_proto(struct ulogd_key *res, char *buf, size_t bufsiz, int protocol)
>  {
>  	char *buf_cur = buf;
> +	char *end_buf = buf + bufsiz;
> +
>  
>  	switch (protocol) {
>  	case IPPROTO_TCP:
> -		buf_cur += sprintf(buf_cur, "PROTO=TCP ");
> +		buf_cur += snprintf(buf_cur, bufsiz, "PROTO=TCP ");

If you have to fix this. snprintf can return -1 in case of error.
Moreover, it returns the number of bytes that would have been written if
there's space in the buffer. So you have to check if the return value is
higher that the remaining space in the buffer.

Have a look at the use of snprintf in libnetfilter_queue and
libnetfilter_log in nf*snprintf_xml() function for instance.
