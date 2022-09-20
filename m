Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A3DC6FA90
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Sep 2022 14:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiITO13 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Sep 2022 10:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiITO1V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Sep 2022 10:27:21 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7067CE4
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2022 07:27:20 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id lc7so6743557ejb.0
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2022 07:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date;
        bh=vbogA3Hd9mXP1fkFaTT7JUNrDM33W6IuiTg6IbcuscY=;
        b=InIjDcdQ36/hYY/bQWR2K0c2SWVtRUpav0g0Ecz9hBYN1hF2AmN34E+6+0CIZJazAQ
         9v9YIfQp+Ottoir6fUXLHLds6e3EkSM59Ul48LAgkMi99QL8nYm+X+ICgHMgK9YkUqf1
         WcGDf/g5EJ1MGQsFxFmrFHzfy+tsaA/TaTBZp57HGGBG+CXZdynzt5ndwnLlpKAzaxt5
         gwPY3FDWxAFsHNj+J+9oibSATv83/lTbGc90YgZbDjMUjDdjdjVNIC+miF/z0ZmJYhWR
         QBURsPTluYEjUiCy2Ar09GkOMUeA0zzKAQh603LRXKrCTfiRrAinC7O07VWRvcgXuVas
         OpLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=vbogA3Hd9mXP1fkFaTT7JUNrDM33W6IuiTg6IbcuscY=;
        b=nSi3at4m3/RXVi4CGnY7EE0uFsEGwJgzjdBXYNR26fixoYMuokhTI6gZKlORFqo/vq
         dfqhAYlnz+7VRzCYlPxeW38hcPAdL7g0eLhuiOWEea6M/vpgRhb/sae2YhOP/tKRYYZY
         PbexmJ9wvJWli8n9BS8Jbbkhrrejf71z4Bx07LHLuKBxWSmDbHkhnGiXtVwKzbvVPSW2
         ByhkJvyGNNO6ZhpewsOFGPKGysS0UPz7iDgNsU0PDvFjqRRpnFfsr5bosBQmpXJw8hRi
         RB3tIrppSlAblnBoD/LhRn5w7tWWZmyba0pxYVDhKnhXMka6lxj3TOP7CBBVeuYP0akz
         CwaA==
X-Gm-Message-State: ACrzQf0p+3n0wsojdnRXTnewOJyG3quaeBldrFFGxg+yxpT5s4RRyhbh
        tw2o5mq2OBpH3Mp6bTrS0Ko=
X-Google-Smtp-Source: AMsMyM5+Tk6/UnuSQTU0/v+K5pCZYCsDxJCMbIKkQq4alS4JYKlLPEx2hxfsMrRosFYjQg2uv+hkNA==
X-Received: by 2002:a17:906:844a:b0:77c:1d87:b81e with SMTP id e10-20020a170906844a00b0077c1d87b81emr16741532ejy.675.1663684039263;
        Tue, 20 Sep 2022 07:27:19 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id h22-20020a17090791d600b00722e50dab2csm914603ejz.109.2022.09.20.07.27.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Sep 2022 07:27:18 -0700 (PDT)
From:   Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Question for table netdev set list
Date:   Tue, 20 Sep 2022 17:27:17 +0300
References: <08BAFEF0-E82D-468C-A855-F5CB1A81ED8F@gmail.com>
To:     Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org
In-Reply-To: <08BAFEF0-E82D-468C-A855-F5CB1A81ED8F@gmail.com>
Message-Id: <8DFC78BC-5511-4877-B27D-6C6C44D227DE@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Or to send device like ppp* eth0.* tap*

in this case  no need to write list to set interface

> On 20 Sep 2022, at 17:15, Martin Zaharinov <micron10@gmail.com> wrote:
>=20
> Hi Pablo and Florian
>=20
>=20
> I have one question=20
> is it possible to set list in netdev hook
>=20
>=20
> Like this :=20
>=20
> table netdev test {
> 	set test_list {
> 		typeof iifname
> 		flags dynamic
> 		elements =3D { eth0, eth1 }
> 	}
>=20
> 	chain INGRESS {
> 		type filter hook ingress devices =3D { @test_list } =
priority -450; policy accept;
> 	}
>=20
> 	chain EGRESS {
> 		type filter hook egress devices =3D { @test_list  } =
priority -450; policy accept;
> 	}
> }
> table inet filter {
> 	set test_list {
> 		typeof iifname
> 		flags dynamic
> 		elements =3D {  eth0, eth1 }
> 	}
> =09
> 	flowtable fastpath {
> 		hook ingress priority filter
> 		devices =3D { @test_list }
> 	}
> }
>=20
>=20
>=20
> Idea is to set interface in list not to create many chains for every =
interface=20
>=20
> now i receive:=20
>=20
> Error: syntax error, unexpected @, expecting string or quoted string =
or '$'
> type filter hook ingress devices =3D { @device_list }  priority -450; =
policy accept;
>=20
>=20
>=20
> m.

