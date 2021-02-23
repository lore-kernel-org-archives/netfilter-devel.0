Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA56C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Feb 2021 08:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41D2364E4B
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Feb 2021 08:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhBWITw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Feb 2021 03:19:52 -0500
Received: from mout.gmx.net ([212.227.15.18]:48407 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232008AbhBWITm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Feb 2021 03:19:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1614068288;
        bh=JpH1pH1HkVPJ/d2pRGlugpPWIuCY40Zib/EytDXptI4=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=PwQQfK1jXWgsIq5+CdUjo2pO3kcjXAN4FtJh1ihrWD1+UHg8qZXDJa2GCANNWuG+g
         aMaBzenBH5GHaKdTvwVREeGpcABLnkow9lgTtzpncxVTvAXDMSQIyoaM0EY6QomJD5
         5bmiwZPAaZqhO+nqmEf6QWXhjGA0LC5RLs2yQkhA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.23] ([77.3.203.224]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N7iCW-1lsUTK0Ppq-014j2B; Tue, 23
 Feb 2021 09:18:08 +0100
Subject: Re: increasing ip_list_tot in net/netfilter/xt_recent.c for a
 non-modular kernel
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <df5eb9af-568a-ef0e-bc4f-33b0fbe1307f@gmx.de>
 <2981762-4fc1-38be-d658-31413e36e4cd@netfilter.org>
From:   =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Message-ID: <4ee34303-8954-108d-5fdb-28c47033a2b5@gmx.de>
Date:   Tue, 23 Feb 2021 09:18:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <2981762-4fc1-38be-d658-31413e36e4cd@netfilter.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:7YKsj0bTOO90VQRds8jWkvgvcMy2NZBI5R4K1QQBjKESZ/ac7OA
 1ok1lY1JOCc41/YMiJ558nvvMtjX2se5LnsvwALWjcWv7h4Mv0NZ3r4/uCWnwgUQVzaDDjp
 pivPkHVCYl0wOtdYQf3kh7UGwTdiB1LM3qdONjNLm5KpGj5NZr8nK1P9SS7AsEGynh6vAM0
 LNr9DCzaFK81oMc7klpDQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ylrdM4Fcbqo=:1SXv0tIZfEhHDJpkktaOi+
 fkdN4gL3JvuyfHYdBsoVUZsbruwk08O/1jfgOs6IyXIZ3qYHku0TnZ3ZeCm0cSEQCouKNuLzT
 OdlWkyNQE9b5lWI78H5NmdYKgZ+jUlVAArxgUUOwOnumQKxucsgM1v3Cw1ozCRXRYxvJgtfBP
 EPfznjtCpzeVVyya5nujSuE0oYthzqPQRy6KjqVyO9RCl8k5jnHVvJMslKwd7M84RCvV0dbmO
 gG4WRqQn/PfdBQeD8YeLyWRLkQEfnIkyWnY6Lum6gPL+qbpGF/ikUol9MaOwakDKW9nNI/WEE
 LLl53/9+874mh1ktWcTP5GiEjAuCCC1l7GlkvPNYIJCoF0pF/n6/liB12AgKC366nRkHbLmsF
 LSmJ6LnnNHxePtWd7VN/9YUqrsv/cEu5C6rBEQs4LvH3iq5mJKnFkO91ekDe+qcey5WVKEOHL
 u7pmb4sTbWWcmBmSSg89Ymo+RUhZrL50r3yiHjHWY5J2iTezU8E4NZHx9gJfAGiPWTTXEkju9
 T3VavYqbe6Cn6HNKZA31tx/JaUC/AIBm55vVc65dhB91FW31+GVwEC2EGykxnvPH00KoLezCC
 ck3tx8nWvkk2c7NgGeF8sTuNA72fBNxbXh79+JY+6jh7Az8YqZ3GpBO2gz/EUiJxI5JfMZRbG
 IWcaWLPEcPt1deLRadsyGHqy9HEgr33LHzJr/t77aO+kkWVSggAzwhaQ9HLeYOsabu2z6qwCr
 FCS0QV8j5tbHrqBwO+uf4u6SyPC8FnklzY528S9uERdSa8ylZWm31NMEIH8AynhA+aueDPzIL
 LX+D4SFDswHBUKTSARHylB0xD1D2UaWPwrVy+joxJp9CuYOHIBUoS4qhN+A85I6NnmOqfUJKs
 0SAIEcGdC/gg907FLVng==
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2/22/21 10:44 PM, Jozsef Kadlecsik wrote:
> On Mon, 22 Feb 2021, Toralf F=C3=B6rster wrote:
>
>> I'm curious if there's a better solution than local patching like:
>
> See "modinfo xt_recent": you can tune it via a module parameter.
>
> Best regards,
> Jozsef

It is a non-modular kernel.

=2D-
Toralf
