Return-Path: <SRS0=DSQd=3Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6CDC35247
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 15:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CB5020730
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 15:31:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="rcaY4f4+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgBDPbn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Feb 2020 10:31:43 -0500
Received: from mx1.riseup.net ([198.252.153.129]:42660 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727321AbgBDPbn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Feb 2020 10:31:43 -0500
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 48BpZj0TpFzFdC4;
        Tue,  4 Feb 2020 07:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1580830302; bh=zPEvW44WaIRC1/bD86wR2NAqz/3smZqt888LhHp9PgE=;
        h=To:References:From:Subject:Date:In-Reply-To:From;
        b=rcaY4f4+201mjDpNd7YBDtcYEpLbVhPuqtTtuIGC6fqky69tp261k+5ViyPnFyx2Q
         qRmtAw2kHY2cWCy6Mq2/llna/GJbgbtub1kaIslNXwm8WBXqBzE0HwR1j+aGNNmoC1
         z8Gl0e6SZrygajIYLtfuvnoUNiz7t+3GqWDIaCUo=
X-Riseup-User-ID: 4C0019C614E92179B1CAA3A6B1AD06A12D93491189537E37064B539AF4F2551D
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 48BpYd15c2z8w97;
        Tue,  4 Feb 2020 07:30:44 -0800 (PST)
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
References: <20200131105123.dldbsjzqe6akaefr@salvia>
From:   =?UTF-8?Q?Jos=c3=a9_M=2e_Guisado?= <guigom@riseup.net>
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
Subject: Re: [MAINTENANCE] migrating git.netfilter.org
Message-ID: <fbd79f10-0e17-a46e-32f5-e079389ac1f6@riseup.net>
Date:   Tue, 4 Feb 2020 16:30:50 +0100
MIME-Version: 1.0
In-Reply-To: <20200131105123.dldbsjzqe6akaefr@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 31/01/2020 11:51, Pablo Neira Ayuso wrote:
> Hi,
> 
> A few of our volunteers have been working hard to migrate
> git.netfilter.org to a new server. The dns entry also has been updated
> accordingly. Just let us know if you experience any troubles.
> 
> Thanks.

Great!

https://git.netfilter.org/iptables/ has been showing "Repository seems
to be empty" for a few hours but the git url
(git://git.netfilter.org/iptables) is working fine.





