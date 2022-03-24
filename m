Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00F2C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Mar 2022 12:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350161AbiCXMZY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Mar 2022 08:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350124AbiCXMZT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Mar 2022 08:25:19 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355256C93A;
        Thu, 24 Mar 2022 05:23:47 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id k10so5438049edj.2;
        Thu, 24 Mar 2022 05:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=l6C93k9VVPLR/0Jfqmka7vcT6jFa06WK7gH559/5qJo=;
        b=aUNTCcuhIJOfJ1DktkETBxJz8cLKJLmUghuq+aJCWbcPYtE54stSLzdnwR0Bye7q+/
         UyX7CXJqgOzwrSjm/3FhjsxFevRC1mnuPkVP+ftQE99jPsWXD/OG9ow5Vwg9QQKAcDO3
         QNjwKzgiuF4nzrg34MR2D3elpCmcWqh7EDJOClPuazT9lJ/UloV6it/b/27a/PdNqdVN
         VV4Ck3H4oYRDfrGdWYmvaA/Mhu7Kh1roEOZJF3ncVim+9bZqtWOJux+3/uLGAVK28Jlk
         sOSxO+dVCi2gVjrQEfWFjw5AihTZJmk3BX/R/8T2cC6691nnZSbEkLe2HBwYDLeCgPSC
         tTVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=l6C93k9VVPLR/0Jfqmka7vcT6jFa06WK7gH559/5qJo=;
        b=lJ5ZzPDcmJr8/E8EksjZO0DPYGyjobcBxu16Apn7XyjP3qZCTZCLBSzueKXi/2G4F9
         MnQH8B0J61XRJsOYfID/6cdIG1LiX/DCEw49Ec0fOjYmxrIopJXMlPKkmfZU72kx71Oe
         0WsA0HStmgCxpkPT8Zlgb+D6KkXl6cHsAOvbriZOJ76uUZk8T0AjcDmfVckAsFedx2i5
         vIdwDVbjb7YSyyEippzkLuHpjBfgw4hMgajKfOv75SbZ6QXrTNZ9/6HfjyOpAP61AfRg
         KPhEsVnxXC+9i/GMaEp1xlVoFZYLsDvtlKtNl7lgluB2J8kr1LV0vj2mNC+RXwj6JyFe
         wQhw==
X-Gm-Message-State: AOAM533EQXP3xKKm3KPimtGL8UQLWYkXunhGBfS0HGmjepsCFfT49Mfl
        /aaDQ1MNYyy/OBScZmw8UyA/+MEpCVo=
X-Google-Smtp-Source: ABdhPJysR2gRdtoi0B4JZtFe8Y//p/i5lj0xdfd/nQx48PCr7rAfGuXies9Un5FbFORLYDQ3IFgxLA==
X-Received: by 2002:aa7:d403:0:b0:40f:739c:cbae with SMTP id z3-20020aa7d403000000b0040f739ccbaemr6466899edq.267.1648124625716;
        Thu, 24 Mar 2022 05:23:45 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id 27-20020a17090600db00b006df6b34d9b8sm1062376eji.211.2022.03.24.05.23.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Mar 2022 05:23:45 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: bug report and future request
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <YjxiB6Jk4plpx48G@salvia>
Date:   Thu, 24 Mar 2022 14:23:44 +0200
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9ED435A1-F1B8-4220-9466-FA3E9D100B1D@gmail.com>
References: <AE6DAC96-EC3E-43C9-A95A-B230842DD7B1@gmail.com>
 <20220321212750.GB24574@breakpoint.cc>
 <4B0C8933-C7D8-49BA-B7F2-29625B0865C1@gmail.com>
 <20220322103203.GD24574@breakpoint.cc>
 <04C4931B-553E-4FEA-85D4-B3E186520EE5@gmail.com>
 <FE0EEED5-48C9-412F-81BA-0028818C2EE8@gmail.com>
 <DB57EE0F-F4CE-4198-89E0-F25ED3C321A5@gmail.com> <YjxiB6Jk4plpx48G@salvia>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo

base on this rule :=20

table inet nft-qos-static {
        set limit_ul {
                typeof ip saddr
                flags dynamic
        }
        set limit_dl {
                typeof ip daddr
                flags dynamic
        }

        chain download {
                type filter hook postrouting priority filter; policy =
accept;
                ip daddr @limit_dl drop

        }
        chain upload {
                type filter hook prerouting priority filter ; policy =
accept;
                ip saddr @limit_ul drop;
        }
        flowtable fastnat {
                hook ingress priority filter; devices =3D { eth0, eth1 =
};
        }
        chain forward {
                type filter hook forward priority filter; policy accept;
                ip protocol { tcp , udp } flow offload @fastnat;
        }
}


where to set this , please help.


> On 24 Mar 2022, at 14:20, Pablo Neira Ayuso <pablo@netfilter.org> =
wrote:
>=20
> On Thu, Mar 24, 2022 at 02:09:25PM +0200, Martin Zaharinov wrote:
>> One more update=20
>>=20
>> I try to make rule for limiter in offload mode :
>>=20
>> table inet nft-qos-static {
>>        set limit_ul {
>>                typeof ip saddr
>>                flags dynamic
>>        }
>>        set limit_dl {
>>                typeof ip daddr
>>                flags dynamic
>>        }
>>=20
>>        chain upload {
>>                type filter hook prerouting priority filter ; policy =
accept;
>>                ip saddr @limit_ul drop;
>>        }
>>=20
>>        chain download {
>>                type filter hook postrouting priority filter; policy =
accept;
>>                ip daddr @limit_dl drop;
>>=20
>>        }
>>        flowtable fastnat {
>>                hook ingress priority filter; devices =3D { eth0, eth1 =
};
>>        }
>>        chain forward {
>>                type filter hook forward priority filter; policy =
accept;
>>                ip protocol { tcp , udp } flow offload @fastnat;
>>        }
>> }
>>=20
>> its not work perfect only upload limit work , download get full =
channel=20
>>=20
>> in test i set 100mbit up/down  upload is stay on ~100mbit , but =
download up to 250-300mbit (i have this limit be my isp).
>>=20
>> the problem is limiter work only for Upload , is it posible to make =
work on download rule ?
>=20
> If you want to combine ratelimit/policing with flowtable, then you
> have to use the ingress and egress hooks, not prerouting and
> postrouting.
>=20
> Make sure you place the flowtable in a priority that comes after the
> priority of your ingress hook.

