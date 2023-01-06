Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58C0C5479D
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Jan 2023 15:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbjAFPS0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Jan 2023 10:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjAFPRz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Jan 2023 10:17:55 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB384115;
        Fri,  6 Jan 2023 07:17:54 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id bk16so1527481wrb.11;
        Fri, 06 Jan 2023 07:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=qL2BhxVV1ZdfqOKMX4Hspp3iBL8W+UuUVwHvZ9bz4EU=;
        b=KHkjNFja+ezKQftN/wV81Q5xig0Atq0GR221LtmMaGRbDbYwOjExgnSEvANL94BSE8
         BDUrb6Dvhxtf379WR2tDuX5Ot+NqMgSTSZ8tkEjwcd8A7lJSZtEPiLhdocUw8bOkYP9u
         43tPtzE2Uctf4F4CFDb4tCYJKAjRVIfwJW8H/XgknaAoAlNq6g/IT7RuPglT+mGVxkhG
         iI4BGdZEXfEH5ZoWRIhpfisyLC/XbxHyHclb8MRCnDXk+VMRO4nHd1X52t0RmUdwHQ1n
         t6/TXYJpb+CzBM6cm+WARBMVe/qiKLbs1hChdliG+EdULD/supg3uENRzmoWfSDWjZuK
         pj9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qL2BhxVV1ZdfqOKMX4Hspp3iBL8W+UuUVwHvZ9bz4EU=;
        b=4rmMeWv7ZaKRJlNf0sEj0DAIut1sOTNHuxUfTG49RsGKhtkpRa1kmup4SoP2zXeQws
         p/vOlW3qeH6rcDp9gWdCPzish1gVSDSxDQTa0Q/zQU4fPjR4IYaqvJms3zIbgCt6FBtQ
         HE9ngqcviRvlD9kja2k+yxXxsvKilxoQloIkR4OCBUcRQcaRBE9pbdtfgw4l2013pFjA
         dthncbGXMlcvan25uWTYVrnNoFCF30ZQmpeHigDQuyhcJtq69hrzHFt9w+l259+lBMi5
         HSkprHZBmbrXqOUMThTqHl9IgDT0vYrIo/6WJ3xzY1aBVtdfH0I8rDJ3KJZzKdo1QQkk
         baxw==
X-Gm-Message-State: AFqh2kpUGCPYWuNsa+qL3pfErqYFXgvxzG1HPItN6mqHbJQwsTo0DL4z
        EPkPa/t7D5dXiNPArr30UWp9t9b5IzU=
X-Google-Smtp-Source: AMrXdXvLNVc5KfaiEDC42F3vDdJT/5C0HZoFOuuHP3TE0bFlxg42c0I5JTu+7hlTV62Uz2Ip/tMYOw==
X-Received: by 2002:a5d:46c3:0:b0:242:863:3076 with SMTP id g3-20020a5d46c3000000b0024208633076mr42002424wrs.17.1673018273205;
        Fri, 06 Jan 2023 07:17:53 -0800 (PST)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id e7-20020a056000120700b00241dd5de644sm1445981wrx.97.2023.01.06.07.17.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Jan 2023 07:17:52 -0800 (PST)
From:   Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: [nft] src: allow for updating devices on existing netdev chain - Test
 result
Message-Id: <DD658C3B-2FB9-451E-893C-EE37ABDC678A@gmail.com>
Date:   Fri, 6 Jan 2023 17:17:51 +0200
To:     20230106010251.27038-1-pablo@netfilter.org, pablo@netfilter.org,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo

Patch look good and work but in my test after try to add ppp0 on over =
chain 1024 receive : Error: Could not process rule: Argument list too =
long


Test is make like this :


create chain :

for i in `seq 2 9999`; do nft create chain netdev x int$i \{ type filter =
hook egress priority -500\; policy accept\; \}; done


after that add device:=20

for i in `seq 2 9999`; do nft add chain netdev qos int$i '{ devices =3D =
{ ppp0 }; }'; done


when reach int1023 all is fine but in next 1024 receive this error .

change device from ppp0 to eth0 add device on int1024.

=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94

And one more when run add device line this for 1023 line added for 30 =
sec

Is there options to optimize little more.


Best regards,
Martin=
