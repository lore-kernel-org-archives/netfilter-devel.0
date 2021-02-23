Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F173C433DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Feb 2021 13:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C97F64E4D
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Feb 2021 13:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBWNtL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Feb 2021 08:49:11 -0500
Received: from mout.gmx.net ([212.227.15.19]:58133 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229886AbhBWNtK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Feb 2021 08:49:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1614088056;
        bh=WzJ1tBxld+ZFKeddYEQ6hr6NxD2+yEvL0S54CCxrn7Y=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=GDNd0tmA0JNXPgcL701sYCfZQmlIZfdbcIN7yXskhr/tXaKNazCL2oKKup2oyzNYj
         zFcB2LAbVH68pALG4U/auPLpiTTHILT4GV0LLw2/lXt2kGf8RLQ4RDdGJaxgo/4BGn
         f/oQ4WSkW03rTDENDxVKTUm+vgcsPiO+ykxU43po=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.23] ([77.3.203.224]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MvsEn-1m4icR1Chr-00stA0; Tue, 23
 Feb 2021 14:47:36 +0100
Subject: Re: increasing ip_list_tot in net/netfilter/xt_recent.c for a
 non-modular kernel
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <df5eb9af-568a-ef0e-bc4f-33b0fbe1307f@gmx.de>
 <2981762-4fc1-38be-d658-31413e36e4cd@netfilter.org>
 <4ee34303-8954-108d-5fdb-28c47033a2b5@gmx.de>
 <9dbca26a-4dad-a9b5-d389-8493b44c3331@netfilter.org>
From:   =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Message-ID: <2878e2ed-8fee-f4b4-1b7d-61adbd08090d@gmx.de>
Date:   Tue, 23 Feb 2021 14:47:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <9dbca26a-4dad-a9b5-d389-8493b44c3331@netfilter.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:LF2LwQYE/MlA4Tky/TjKjiyb7KqbezmNljlkX+/Wm+YKh2RXnpt
 zyJ0BiSxBJOLLjRuTssmcvGdvv96OLZXKGn3MWuhFmPB3kFuta+RTpwbVgXoTIDdiVoQEDA
 AI06vz8ZQPXFcI9XSdVzMziZ1kbJNE14K1noMLNov/j+QAdyeOJ1irAtjrqEvhgvRlSknFY
 DfNm4zdGx+WvbDaN6R+6Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Zemu5dmEphw=:o6qJB8l2Xi1yBkGEDVEiuO
 dE7dyCEofw3q39QJjdBo91N8cQhhFjvhJaKC+NhqS2Kv9sEI54ZVBjD4Zg0wuh+hg3yNoVWXS
 ifi9rhfTk3pQ01vKiIETHrXJjz9ZbCfyRMVHgmGFFWZQngDHRlOJ7Nh3YmiN9RDRDQz7mSDbp
 jmSza9n6PbZDgieOPTE35L1Us9AA9hiy81jmIYdDaLNcQZbxqX0cbwyizyUuCSq+9rsdP9GwE
 ro8OZ65B3vt+f28auP7zZIbKJJiQ+xO/MwLKG8KijbrvaXgSZDsFcZl5EIDNgsG7UrSHaN0MZ
 CGHbYfAZTKQ6gTGwSFf+qXMR8o+iBEgqkwlxxtuZHSye+czHtUZLlXU/rEHukKrUIdH8O+gp6
 Tz+A/Egy/w2Y0mcG39OpHlmBcUlxRwJYXl4ASsP0pVaavSyz/iVpD8sPpiEuYbBLWeNaX4vNF
 tf5pnQHO+oNGZNaCBTVoQpKQZ+R2M5byBFO2SlBOiO/0jQL2suzx66ZeyHQvLJJ5kE69jui5b
 9kbc5rBEB6Vva0+cRarVeYcYNQsvanMd78H1cYxKP22g1/889uzd4tDWauVPTop3m+ELDVC3d
 CBi0+bM2ZiIh07kG4g637j9qC63hGyLUKySLr+rC1d7dSmQ9egX/ToEc89LS1iR9i/RvFOop+
 M2bBrcCS//7t0pfY3oqvqQUpImCfNUUnP+NdAycb8PzyqE+Mqpe0U8YjiT6WP5Ic3fYj7FpvD
 qQeYHzIaScEf4bSZHPnKtSz9NeoPliRwkDJUpTgANbgznibin/ZT+cF74D9kCdbjcfsL0dEJl
 NLGt6Ap1okdn1LdmZM2lOEHa+7RFKZ+Kt6DtjV3PtPrY/m9GUota/p1j2DPax66Sv1l1Z/1N1
 8FBF76x8vHa0mXrDBSHA==
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2/23/21 9:34 AM, Jozsef Kadlecsik wrote:
> On Tue, 23 Feb 2021, Toralf F=C3=B6rster wrote:
>
>>>> I'm curious if there's a better solution than local patching like:
>>> See "modinfo xt_recent": you can tune it via a module parameter.
>> It is a non-modular kernel.
> Then you can specify it as a kernel boot parameter:
> xt_recent.ip_list_tot=3DN
>
> Best regards,
> Jozsef
Ah - good advice, thx !

=2D-
Toralf
