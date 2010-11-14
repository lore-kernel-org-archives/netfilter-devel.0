From: Yechiel Levi <gmistick@gmail.com>
Subject: Re: libnetfilter_queue: extracting TCP options.
Date: Sun, 14 Nov 2010 07:05:07 +0200
Message-ID: <AANLkTik_MQCmDSJCRSoj-oCT5VnEE_Q9jWB7ypZZV6J3@mail.gmail.com>
References: <AANLkTimJdQAjc_-r1R8ELN_Y+EVaN5Q30Y=Rzxg-Bg_j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: =?KOI8-R?B?SWdvciAnTG8nICjpLkwuKQ==?= <bombsiteunrested@gmail.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64778 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab0KNFF3 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Nov 2010 00:05:29 -0500
Received: by fxm6 with SMTP id 6so1076749fxm.19
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Nov 2010 21:05:28 -0800 (PST)
In-Reply-To: <AANLkTimJdQAjc_-r1R8ELN_Y+EVaN5Q30Y=Rzxg-Bg_j@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

You should use the nfq_handle_packet method, and in the callback it
activates use a casting of tcp struct on the payload (nfq_get_payload
method)

timestamp can be achieved from netfilter using the :
nfq_get_timestamp (struct nfq_data *nfad, struct timeval *tv)



2010/11/14 Igor 'Lo' (=E9.L.) <bombsiteunrested@gmail.com>:
> Hi all,
>
> How one can get TCP packet's options (especially timestamp and MD5)
> using only libnetfilter_queue in userspace?
> Having a callback routine(struct nfq_q_handle *qh, struct nfgenmsg
> *nfmsg, struct nfq_data *nfa, void *data) - which structure may
> contain the desired options set?
>
> Most adequate Netfilter-based code to solve this problem was found in
> linux/net/netfilter/nf_conntrack_proto_tcp.c - not a best kind of
> documentation, but provided a nice method of reading a structure. Now
> just need to get a bytes to read.
>
> cheers,
> Igor
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =9Ahttp://vger.kernel.org/majordomo-info.html
>



--=20
Kind Regards,
Yechiel Levi
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
