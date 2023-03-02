Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF66EC678D4
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Mar 2023 10:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjCBKxW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Mar 2023 05:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjCBKxW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2023 05:53:22 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9629E3B0;
        Thu,  2 Mar 2023 02:53:18 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so1235852wmq.1;
        Thu, 02 Mar 2023 02:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677754396;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0At0SBCwz53k/gUPABIwuv70VkdNp8AOj/Qveiu+YGY=;
        b=UIIq40uBd3BVFxq/BDBHGbjDPTUs2iP+vZId/ObVjQ3Qjcq2AShHuuB1a9QduMqIaM
         PCUOKdyhbhIKvSBoUEFjzpvVVoDs3PZ65acDYMgeJ0m29uRniy6mJg52V+dwhLug1hn1
         ixM7TXp0UDLRpKDLLbcnqRlU0cjX9e18sGjxMs3MM6alb8xfYSTu+EMErXdMK+C0GEVd
         I+70vJRhvAOcP9h64t1ueqCZc+2vlLNR8ktKYaNFZ5L/f9bQiJEE2BM/t3M2IwWhIcrA
         RAciQ3yJUkQq5Y0O1KpeYuOX2pSWfWzEzO28s4TuN9hYNUmEzhrwqdepNsdUEVc2qsPH
         hp7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677754396;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0At0SBCwz53k/gUPABIwuv70VkdNp8AOj/Qveiu+YGY=;
        b=NjSIF2JYYKK4hZUrxU9uOfZddfYTVRPNnRbqNLAYNNN44Xf0O6MWYH8wLJ3PLueANv
         mccBH5rncamkF7QHHuFbSlK8rIqtX0rip3axcy5OHCCTAGpwF7zrFSIPvZKGFDLq5mSS
         7GPrCxKMpWj9uA8kVYNq8iJ3m/ih/MFvxYk40mExOb6ec8+EW5fWCeg28NEYoCyb1AcC
         PBKJzOuTEbQ79P74a0rbFGSxJKFfeo2Oi3nHop6jBldOZ+j7eXElAvc56LklzsrGXnFQ
         pl1Fua+BMwrq1oNga7niijK/BNhmFHCOPMW8y2/d61OBEtVy1V+4vg8zPD17VfX25dpw
         ZAhQ==
X-Gm-Message-State: AO0yUKUhPv1F+ZXcN6f1OraUl6FBg9VCpjpMokj75lptDhuXtWSW88Wx
        cJXocQwhoGlnp0EfcRphTFSLTMKMv9k=
X-Google-Smtp-Source: AK7set8wRtbJz1wSBjElsWRBYkVStMfU89OQ6GZ9Msqf5leUK8vfFY6pLExuoa1SB9+8IfB52rizEg==
X-Received: by 2002:a05:600c:4687:b0:3ea:f73e:9d8a with SMTP id p7-20020a05600c468700b003eaf73e9d8amr7366129wmo.30.1677754396609;
        Thu, 02 Mar 2023 02:53:16 -0800 (PST)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id r18-20020a05600c35d200b003dfe549da4fsm2737606wmq.18.2023.03.02.02.53.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Mar 2023 02:53:15 -0800 (PST)
From:   Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.14\))
Subject: Re: Bug report DNAT destination not work
Date:   Thu, 2 Mar 2023 12:53:13 +0200
References: <CALidq=VJF36a6DWf8=PNahwHLJd5FKspXVJfmzK3NFCxb6zKbg@mail.gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
In-Reply-To: <CALidq=VJF36a6DWf8=PNahwHLJd5FKspXVJfmzK3NFCxb6zKbg@mail.gmail.com>
Message-Id: <6EBC0AF9-A76E-4CD1-BE97-ED0A97C562A7@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.14)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Team
Little update

iptables 1.8.8 work=20
after rebuild and install 1.8.9=20
 iptables -t nat -A PREROUTING -d 100.91.1.238/32 -i bond0 -p tcp =
--dport 7878 -j DNAT --to-destination 78.142.32.70:7878

stop work with this error.

m.

> On 1 Mar 2023, at 17:05, Martin Zaharinov <micron10@gmail.com> wrote:
>=20
> Hi team
>=20
> i see one bug after kernel 6.1
>=20
>=20
> iptables -t nat -A PREROUTING -d 100.91.1.238/32 -i bond0 -p tcp =
--dport 7878 -j DNAT --to-destination 10.240.241.99:7878
> iptables v1.8.9 (legacy): unknown option "--to-destination"
> Try `iptables -h' or 'iptables --help' for more information.
>=20
> try with kernel 6.1.11 6.1.12 6.1.13
> and 6.2.1
>=20
> Best regards,
> Martin
>=20

