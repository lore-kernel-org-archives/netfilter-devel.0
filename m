Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6645BC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Mar 2022 22:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238495AbiCVW4p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Mar 2022 18:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238552AbiCVW4p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Mar 2022 18:56:45 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542BE5E145;
        Tue, 22 Mar 2022 15:55:16 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id r13so39292301ejd.5;
        Tue, 22 Mar 2022 15:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=dPberEcHvinDoL0MKw9Bz1UY9GEmtToHC5YiJuekCnU=;
        b=AM5y89ikFNJYcD0ADphc0QQyruNgYtKcdfFImynxTU2lxZw8FYhLISPvUzEKEIPLgb
         ECFQb9Tuq6T+hlansIUhfgkOoq3u74QiWKrFfJmdShKbh/Z2ll2UowVchfWOj8OZ6X5f
         GBVaUv/bvGBVvYmym4zTmtnQuLzh+nCXy72uCXGNP0tDJ2d003qSNoRJB52HsRDHchXS
         s84s7tOgvXJDMVFxjHDFtyqCCN7fUE/vaLzl02qCRy3PTlE6zLCA/N0G0n0tEp35u1X7
         C3gum2jIBiHdfsVfsaeu1gJHTpNIoddytUpTm49Zu744QUjhu0ma0SRVdfO1Lcg+KwjF
         5qkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=dPberEcHvinDoL0MKw9Bz1UY9GEmtToHC5YiJuekCnU=;
        b=h88W02o72/5RUVExvjzwjCnQZxfGgB4UMI6x62fCtFo3tkHe427AaqlJfqIkQ7jWMe
         7Th7L87MwPsI7ZSsXQOHTtg3Fuy747t2N3ChEe3PVPxEoR6pLCMa5mVGUTw4srD0cP9K
         QcMgdhJYGmJnchC3ICKB1IvnSD78s22lgI2up9MYkhignz0H4uP84hhB+z8r41ZWiEEf
         TSZqDZyOyGhyxV8hZq5KlBiZp0/RFzH70e6LsJ1Ih7UmNUWKoyocv6EAwdUgDh5JqYao
         tEda5YDVPD5nsru1ZoxEZm434TbZxiT0RqErEUMh3fi1J+HWGw52l/ywGsyHRB+RT4hG
         8rvg==
X-Gm-Message-State: AOAM533VDVR1VQuhhaPgZyS9J9iLEQk1IBn/iZvrqZjwyN7EMig/5xEc
        Z5iddeZp7g3Vl1Zh8Hj83vmF95udAk0=
X-Google-Smtp-Source: ABdhPJwPsDGGrr5VM8O6S53cY21jI2mmj3817NG2SBWCM1z5viQcK4gpOMP6+AdPXG/n5OkRSzCiVQ==
X-Received: by 2002:a17:907:7d8d:b0:6df:f3a6:b0d9 with SMTP id oz13-20020a1709077d8d00b006dff3a6b0d9mr15616434ejc.13.1647989714791;
        Tue, 22 Mar 2022 15:55:14 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id w22-20020a056402269600b004194f4eb3e7sm3083046edd.19.2022.03.22.15.55.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Mar 2022 15:55:14 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: bug report and future request 
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20220322103203.GD24574@breakpoint.cc>
Date:   Wed, 23 Mar 2022 00:55:13 +0200
Cc:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <04C4931B-553E-4FEA-85D4-B3E186520EE5@gmail.com>
References: <AE6DAC96-EC3E-43C9-A95A-B230842DD7B1@gmail.com>
 <20220321212750.GB24574@breakpoint.cc>
 <4B0C8933-C7D8-49BA-B7F2-29625B0865C1@gmail.com>
 <20220322103203.GD24574@breakpoint.cc>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian

yes now work perfect
i will test with 1-4k ips to see performance vs qdisc or iptables.

for second offload question:

is it possible to make limiter work in offload mode and ia it posible to =
add dynamic interface like ppp* or vlan* or other type.



P.S.

thanks for fast reply for first part!

P.S.2=20

resend mail to netfilter group

Martin

> On 22 Mar 2022, at 12:32, Florian Westphal <fw@strlen.de> wrote:
>=20
> Martin Zaharinov <micron10@gmail.com> wrote:
>> Hi Florian
>>=20
>> Look good this config but not work after set user not limit by speed.
>=20
> Works for me.  Before:
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  5.09 GBytes  4.37 Gbits/sec    0 sender
> [  5]   0.00-10.00  sec  5.08 GBytes  4.36 Gbits/sec receiver
>=20
> After:
> [  5]   0.00-10.00  sec  62.9 MBytes  52.7 Mbits/sec    0 sender
> [  5]   0.00-10.00  sec  59.8 MBytes  50.1 Mbits/sec receiver
>=20
>> table inet nft-qos-static {
>>        set limit_ul {
>>                typeof ip saddr
>>                flags dynamic
>>                elements =3D { 10.0.0.1 limit rate over 5 =
mbytes/second burst 6000 kbytes, 10.0.0.254 limit rate over 12 =
mbytes/second burst 6000 kbytes }
>>        }
>> 		set limit_dl {
>>                typeof ip saddr
>>                flags dynamic
>>                elements =3D { 10.0.0.1 limit rate over 5 =
mbytes/second burst 6000 kbytes, 10.0.0.254 limit rate over 12 =
mbytes/second burst 6000 kbytes }
>>       }
>>=20
>>        chain upload {
>> 			type filter hook postrouting priority filter; =
policy accept;
>> 			ip saddr @limit_ul drop
>>        }
>> 		chain download {
>> 			type filter hook prerouting priority filter; =
policy accept;
>> 			ip saddr @limit_dl drop
>> 		}
>=20
> daddr?
>=20
>> With this config user with ip 10.0.0.1 not limited to 5 mbytes ,=20
>=20
>> When back to this config :
>>=20
>> table inet nft-qos-static {
>> 	chain upload {
>> 		type filter hook postrouting priority filter; policy =
accept;
>> 		ip saddr 10.0.0.1 limit rate over 5 mbytes/second burst =
6000 kbytes drop
>> 	}
>>=20
>> 	chain download {
>> 		type filter hook prerouting priority filter; policy =
accept;
>> 		ip daddr 10.0.0.1 limit rate over 5 mbytes/second burst =
6000 kbytes drop
> 	           ~~~~~

