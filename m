From: Yechiel Levi <gmistick@gmail.com>
Subject: Re: libnetfilter_queue: extracting TCP options.
Date: Sun, 14 Nov 2010 20:11:53 +0200
Message-ID: <AANLkTinsE5DQcb5_=+6x971TUx2CN_RHBN0EbZvwcA-y@mail.gmail.com>
References: <AANLkTimJdQAjc_-r1R8ELN_Y+EVaN5Q30Y=Rzxg-Bg_j@mail.gmail.com>
 <AANLkTik_MQCmDSJCRSoj-oCT5VnEE_Q9jWB7ypZZV6J3@mail.gmail.com> <AANLkTi=35M8KtJUzOcAjJvW=_m0x_G3bYwxs77u7rLEv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: =?KOI8-R?B?SWdvciAnTG8nICjpLkwuKQ==?= <bombsiteunrested@gmail.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44031 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab0KNSMP convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Nov 2010 13:12:15 -0500
Received: by fxm6 with SMTP id 6so1270293fxm.19
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2010 10:12:14 -0800 (PST)
In-Reply-To: <AANLkTi=35M8KtJUzOcAjJvW=_m0x_G3bYwxs77u7rLEv@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

You said you want the Checksum and Timestamp.
1. Timestamp as i said could be achieved from nfq_get_timestamp,
2. Checksum could be achieved from the tcphdr,
3. Data length could be computed with iphdr(get the data length - tcp
header length ) ...

I guess that if you want to get the other options, you could just use
the tcphdr, and address the wanted members of the struct...


2010/11/14 Igor 'Lo' (=E9.L.) <bombsiteunrested@gmail.com>:
> Hi,
> which .h contains a correct struct tcp? I guess it is tcphdr from
> netinet/tcp.h, which only gives a doff (whole header length), so have
> to get payload, skip header length and read the options by byte?
>
> 2010/11/14 Yechiel Levi <gmistick@gmail.com>:
>> Hi,
>>
>> You should use the nfq_handle_packet method, and in the callback it
>> activates use a casting of tcp struct on the payload (nfq_get_payloa=
d
>> method)
>>
>> timestamp can be achieved from netfilter using the :
>> nfq_get_timestamp (struct nfq_data *nfad, struct timeval *tv)
>>
> cheer,
> Igor.
>



--=20
Kind Regards,
Yechiel Levi
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
