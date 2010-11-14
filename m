From: =?KOI8-R?B?SWdvciAnTG8nICjpLkwuKQ==?= <bombsiteunrested@gmail.com>
Subject: Re: libnetfilter_queue: extracting TCP options.
Date: Sun, 14 Nov 2010 17:45:06 +0200
Message-ID: <AANLkTi=35M8KtJUzOcAjJvW=_m0x_G3bYwxs77u7rLEv@mail.gmail.com>
References: <AANLkTimJdQAjc_-r1R8ELN_Y+EVaN5Q30Y=Rzxg-Bg_j@mail.gmail.com> <AANLkTik_MQCmDSJCRSoj-oCT5VnEE_Q9jWB7ypZZV6J3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Yechiel Levi <gmistick@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52379 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab0KNPpr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Nov 2010 10:45:47 -0500
Received: by gyh4 with SMTP id 4so2612806gyh.19
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2010 07:45:47 -0800 (PST)
In-Reply-To: <AANLkTik_MQCmDSJCRSoj-oCT5VnEE_Q9jWB7ypZZV6J3@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
which .h contains a correct struct tcp? I guess it is tcphdr from
netinet/tcp.h, which only gives a doff (whole header length), so have
to get payload, skip header length and read the options by byte?

2010/11/14 Yechiel Levi <gmistick@gmail.com>:
> Hi,
>
> You should use the nfq_handle_packet method, and in the callback it
> activates use a casting of tcp struct on the payload (nfq_get_payload
> method)
>
> timestamp can be achieved from netfilter using the :
> nfq_get_timestamp (struct nfq_data *nfad, struct timeval *tv)
>
cheer,
Igor.
