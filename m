Return-Path: <SRS0=Vh4p=6F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969ECC54FCC
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 14:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7259E20679
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 14:03:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iNSoReSC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgDUODc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Apr 2020 10:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726628AbgDUODb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 10:03:31 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F59C061A10
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2020 07:03:31 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id h30so8032140vsr.5
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2020 07:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B35D0jI8LN5q5XNwCoa3xE2PFpxh4HO6z4DdY1MmZKM=;
        b=iNSoReSC0kN5p6Y+MK4OFOOaKrGbah8BGCr8hjwdtA72KNIiYj5XuqGXN866kveKg5
         FM2SUgPN/hTG2ShC2XfHQd/m6Sv1W76lqVnZXpNx9b1R9/GO5ro6Gc+tUPyRmytejuGj
         YlD+3DF1GXOLJk2CZUzupQg69SlPMOrhat73MUNL+wlmow968rTHnsUahxo9UILh52+q
         MlYreJcFCIgj3bvIcS3WInXyR2Mp0RVhgFNS3Yhfj5eHOYtIaqEx3vZHbCQ7eL+qUCXd
         gddXzzCudDGnWIYiWwGZVwv8yt2zOO2PfMioOqNDiQleQiwY/54Uey7NoZZNDD8qHtLk
         G7eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B35D0jI8LN5q5XNwCoa3xE2PFpxh4HO6z4DdY1MmZKM=;
        b=FGahiozUMYfAEt0hNLEcui6LTe97pLpZKUv5ouFt+iAbuLB4uLGXlJbf4v1VaupRaG
         Jt7DXafr2amyNp7EnUW9AJ0rrLSOcX9LqfMe7z08EONBJlT4M5Kr7/iaQ66i6WtOYzx6
         prxsWSFJNDapK+BWOVlIWsO3+2eIwyRFaq0egVi5vpiSjtd9ldqNLpgGz0O1zasivNgk
         THuV8ywPr5fLbcusFE0HrrXQnKoByeyAtnu0YzjsIKcF5iw1QN9Np4v3mDLOFVdW+v+Q
         Xz4DgZwj/WFPF7mtrClkbUX+aK9oSpBIiaitnumSQY1/PMIXwN+GERiaLIADL+zkOqw7
         Xipw==
X-Gm-Message-State: AGi0PuY5vogaRN3t32lrudBTC8SfVQrho226n+VT+5y/uhHaS47wQQtg
        KYrPFMUGvxHd0GTL2vfvUiUUvjEE3FbZQi443neyXQ==
X-Google-Smtp-Source: APiQypI6rpa4fTokweP9tN5YW2kreIutvpDWa2397Huu3gbq/EKTFkf0vMVJ7PLmjqC7piulvc8Dg1StcxUm8fSuLms=
X-Received: by 2002:a67:7d83:: with SMTP id y125mr13956104vsc.96.1587477810356;
 Tue, 21 Apr 2020 07:03:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200421081507.108023-1-zenczykowski@gmail.com>
 <20200421104014.7xfnfphpavmy6yqg@salvia> <CANP3RGfBtFhP8ESVprekuGB-664RHoSYC50mHEKYZwosfHHLxA@mail.gmail.com>
In-Reply-To: <CANP3RGfBtFhP8ESVprekuGB-664RHoSYC50mHEKYZwosfHHLxA@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 21 Apr 2020 07:03:18 -0700
Message-ID: <CANP3RGdpJDbfQVSSHh6YM5kD7HAsU-Qrk=Hn7Jf_HrOD-Go2PA@mail.gmail.com>
Subject: Re: [PATCH] libipt_ULOG.c - include strings.h for the definition of ffs()
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

note: I guess it could also be bionic vs libc header files...
but per man ffs:
http://man7.org/linux/man-pages/man3/ffs.3.html

       #include <strings.h>
       int ffs(int i);

       #include <string.h>
       int ffsl(long int i);
       int ffsll(long long int i);

strings.h is the right header file.
