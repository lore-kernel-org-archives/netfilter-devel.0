From: Marco Angaroni <marcoangaroni@gmail.com>
Subject: Re: [PATCH v2] nf_conntrack_sip: extend request line validation
Date: Tue, 25 Oct 2016 09:07:23 +0200
Message-ID: <CANHHuCU6VoZFbP3TmKa1ajrJyFLydaSeqrwcSgycAB6chJmTHw@mail.gmail.com>
References: <20161024160723.GA30272@gir>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Ulrich Weber <ulrich.weber@riverbed.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33366 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750804AbcJYHHZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Oct 2016 03:07:25 -0400
Received: by mail-oi0-f67.google.com with SMTP id i127so5605827oia.0
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Oct 2016 00:07:24 -0700 (PDT)
In-Reply-To: <20161024160723.GA30272@gir>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

2016-10-24 18:07 GMT+02:00 Ulrich Weber <ulrich.weber@riverbed.com>:
> on SIP requests, so a fragmented TCP SIP packet from an allow header starting with
>  INVITE,NOTIFY,OPTIONS,REFER,REGISTER,UPDATE,SUBSCRIBE
>  Content-Length: 0
>
> will not bet interpreted as an INVITE request. Also Request-URI must start with an alphabetic character.
>
> Confirm with RFC 3261
>  Request-Line   =  Method SP Request-URI SP SIP-Version CRLF
>
> Signed-off-by: Ulrich Weber <ulrich.weber@riverbed.com>

Looks ok to me.

Acked-by: Marco Angaroni <marcoangaroni@gmail.com>

> ---
>  net/netfilter/nf_conntrack_sip.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
> index 7700556..df773d6 100644
> --- a/net/netfilter/nf_conntrack_sip.c
> +++ b/net/netfilter/nf_conntrack_sip.c
> @@ -1436,9 +1436,12 @@ static int process_sip_request(struct sk_buff *skb, unsigned int protoff,
>                 handler = &sip_handlers[i];
>                 if (handler->request == NULL)
>                         continue;
> -               if (*datalen < handler->len ||
> +               if (*datalen < handler->len + 2 ||
>                     strncasecmp(*dptr, handler->method, handler->len))
>                         continue;
> +               if ((*dptr)[handler->len] != ' ' ||
> +                   !isalpha((*dptr)[handler->len+1]))
> +                       continue;
>
>                 if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_CSEQ,
>                                       &matchoff, &matchlen) <= 0) {
> --
> 2.7.4
>
