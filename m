Return-Path: <SRS0=aqP0=2Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCFEFC00523
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jan 2020 21:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DB9D21835
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jan 2020 21:31:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="p6Z1uHiO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgACVbr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jan 2020 16:31:47 -0500
Received: from mx1.riseup.net ([198.252.153.129]:41106 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728549AbgACVbq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jan 2020 16:31:46 -0500
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 47qJ4x73KvzFcZW;
        Fri,  3 Jan 2020 13:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1578087106; bh=02xsvHNcLTUgI9oFbmbwzqDeOvlwoP2Z0tmE3G9vyPQ=;
        h=To:Cc:References:From:Subject:Date:In-Reply-To:From;
        b=p6Z1uHiOSUb8yWpMZTNIl/5WRmLf0EBopQW7mx+YMpP1Bsc7QtY2CmyHZbdROUBie
         tASj04BOXyo66kGj+KLlD3zrdlwSmwuXkySeNKG6isjABPreW58X4tx7+KTgY3j1tv
         bOdc8Y4M75vmMhevk940Ae2h3PIPLQtjZ43MTr0U=
X-Riseup-User-ID: D7CCE615DF1AB57F89E6E2CAE0CED7BE5DBE076942B74563A1D8144CD9EA3A51
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 47qJ4x16nVz8tJC;
        Fri,  3 Jan 2020 13:31:44 -0800 (PST)
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <cover.1577738918.git.guigom@riseup.net>
 <d1b18191-7f44-1625-97d9-6d8adcf0654b@netfilter.org>
From:   "Jose M. Guisado" <guigom@riseup.net>
Autocrypt: addr=guigom@riseup.net; keydata=
 mQENBFvZsBUBCACwz0EO8bYf6CLL3445nBrt+EPX+pDgGpEh1vFG71UwLCc0Q52SsNJDOML8
 EwnlMjCJS8jofSarvLZ/GbV6yABfw1BlYy+EzfDV7q/jPWioN1OzrfKaGo7M0eOmCM1RrePD
 EBqd7u5vKbpK9K2jSR4ZLCkoUho/HFSj7Ef1PRbuKQbVoGkEOsLQlHebWnK0iaAsUiGnvgVi
 9O5ydijBIs1K/W0kvx9y50R6ZsbwzenljLkyo7nBZEBx+M+5g/O8Gi8jDc3p9z5VZBFkDaez
 AigMeCMF9ajzaU9ir26LL6HuBrCJyiKCx4wecMr+9izVJK55lsnnOAwerv3dvq7G25pTABEB
 AAG0JEpvc8OpIE0uIEd1aXNhZG8gPGd1aWdvbUByaXNldXAubmV0PokBVwQTAQgAQQIbAwUL
 CQgHAgYVCgkICwIEFgIDAQIeAQIXgAIZARYhBORobWbTHQlsWyQKpCSafhl6luu5BQJeD3XU
 BQkEFvk/AAoJECSafhl6luu5hQ0IAKaHPO3+7ce097MWCjKkNxHd/pBimYx+YD7GF3r/dZ59
 7LKBQcPIxJriubL6zM0Qc8su8v5pL42N+5GdcppbkPPw2IMhF3M0A1pk249fxo1udE1a/Z+Y
 o25hNdVYjngsNraqHe2Om6u89KON5mBW194+RCxWzhhjQcG6JEONJ4ONVPbn/1mvK0Rex2sO
 o7S5IwX7YXxpFsRgX6SewqFr/N3EJ7J5UrD9+SH6z8AsvTIKEBdKtrOaIdKO66flRXrG/Cyq
 2hZtMaCW8PVZJL6m2701PjDGeJeJ1oGHaVQbn23JRsx9KRPLAkGbGa1GiE349BFI/aon1/+x
 lJG84SxbkKS5AQ0EW9mwFQEIALWeJTGQVwIPxMVEChhWl5RTnSiQNAheWt4rg+i5QTp5o1Xn
 M4I5VKceEwoUnxp5CxAtLzTQIyBar7+K6GLorCgxstDoimzcqsC25CmHCEHV+sgDGUQeOUpB
 oYD2Qiv2OC0V/EPpN4jfzZdA5IXSMq/ERAuI3EwZ3ig0deEI7f+w/cMqW02OLJKV77j4ZVas
 iYgQgh8zsgWsn7nRqIPJl/Eqc7Mh25uTEdQsolfZE2QnPq9koCsiDHlsxjiZUOrCCj+7yb5k
 FAHagkkL7torBwyVQfbHHRW854HbZLtfc6Yntp9MPd9UMjYsphQXaCl2/8aQo6kqkWP/XboG
 J+ihLlcAEQEAAYkBPAQYAQgAJgIbDBYhBORobWbTHQlsWyQKpCSafhl6luu5BQJeD3aMBQkE
 Fvn3AAoJECSafhl6luu5rIAH/j+R+SwRtTwa9BALuTKq3JwJxIvd5IYi5ymh5x6Qgkc6vuu4
 hnLjOvMcYEC65+jEeJizjZrKBmQmvOx5TvCTjJWws75luLEAl2gnyPZP+Sc18d9PJeBsWLXQ
 psN/otNzhtB2rRpOzSyMPK7VHEAbUk80sIY80uyTEkMefBkoe43Rw5IKJZ1IYykITj6C6LHp
 N894e1s6MkjDLRZ8OJ1HNqP2Ew1sp9QuO9mAQcgBQHdGelEsha3ePUkhGdWHkQrolZC2G0yG
 ANIb809yJG+8M216U2yt6FhtDqJzYIfIdxd8/i/cC7HJT5be+UD3fOWlv8lHwfuvRAhrhUfO
 seoA1UI=
Subject: Re: [PATCH nftables geoip 0/1] contrib: geoip: add geoip python
 script
Message-ID: <57a336c2-0d68-81a6-7c2e-052d4c2d148e@riseup.net>
Date:   Fri, 3 Jan 2020 22:31:42 +0100
MIME-Version: 1.0
In-Reply-To: <d1b18191-7f44-1625-97d9-6d8adcf0654b@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Arturo! Thanks for the feedback,

On 3/1/20 10:46, Arturo Borrero Gonzalez wrote:
> On 12/30/19 10:19 PM, Jose M. Guisado Gomez wrote:
>> This patch adds a python script which generates .nft files that
>> contains mappings between the IP address and its geolocation.
>>
> 
> Thanks for the patch!
> 
> I have some concerns about including this in the main nftables repository tree.
> My experience dealing with them in other repos (iptables, ebtables, etc) is that
> they tend to go ignored from the maintenance point of view, being a burden at
> the end.> Please don't get me wrong, I find this script very useful for many use
cases.
> I'm just wondering about the right place for storage. Perhaps a more convenient
> approach could be to have an additional repo somewhere to hold this kind of
> contributions.
I understand, those concerns seem reasonable.

If a place is to be decided to have the script I wouldn't mind having
the script in a repository on Github or some other platform in the mean
time. And build on feedback as soon as there is some.

PS. Main purpose of the script is to provide some starting geoip
solution to nftables *which does not depend on MaxMind's geolite*
(there's been a policy update requiring signing up to download and
accepting a new EULA, breaking xt_geoip_dl for example).

