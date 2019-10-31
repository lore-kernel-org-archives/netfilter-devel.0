Return-Path: <SRS0=LKiS=YY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B9D7CA9EC3
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 09:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E66912086D
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 09:26:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SWK350it"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfJaJ0a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Oct 2019 05:26:30 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37506 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbfJaJ0a (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 05:26:30 -0400
Received: by mail-io1-f67.google.com with SMTP id 1so5928183iou.4
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2019 02:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VOu+yxVTCLGMyRjtI6fEkvvAojJUGSwMVlCdQfjA4B0=;
        b=SWK350itr1uwHiVbn02aZBpp9uHQEgvgoYs/0i1gD4PBn3C+AGRlB3wb9KXb7Odzgk
         VAZE7KxKeF9jEC+GQnV5fpFmnYAT2Sy6j4etjUvjzOZeNPMrUHHYgXu1Vv2Nhy+WkbLN
         sWZKgnnL0q/dqCWxi+RPAf7tgY3aU4A5icDLhHCcFJ+OJSenGSbYoHdItpn/33yl3KJJ
         3+qeAlWsDjyk+hMJNk37YuIrr23G/hiYfRLUOh5Dl2RQDx3g+qkzb4bqw65faE7vwHRm
         whguR+aTb8NTUpXqhfCLBxUgyGRn7mC3MZSzJslU2RfUDLqIoSQFK7jTdbJN1+jd86jl
         DNfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VOu+yxVTCLGMyRjtI6fEkvvAojJUGSwMVlCdQfjA4B0=;
        b=Z2RW2y3WtyiXL4fNiXWuTJbivI14L7vESs4H03+In8FIKjgmNP8GSCn02blaunmnqL
         LYO7ckMBeQbwCsw+xY2zZCY/lvIr8zJO8EKETrpB11pLnBQa6DWLAlSdYJRSxWHIhQvw
         ZfOt+K4LtC7dYhdUsmPXyHyVeQz7/ZDwB3p8wyrhdh65sCOWIie9KG1r64fimAuqh3gT
         lRYROGR29b3BsfT+iLp9WXVUWBi103fY272OVyQrgkYPMdjIIbwQEKP7DiJuyHSAtD5y
         bj9apKJd3T6WVttWNpIvFMkKdQ0KmQyHCWIsq7Db81GpdeCUbdL0yUnuSvunDgcj+5jj
         BTXw==
X-Gm-Message-State: APjAAAWrxKh8Inf+37KVhuolEmH+mtM45KbwMP1GwrA5P/Y4AuoM3pk5
        AxLZt2IkAkI3rsVe4u+gfrKRPJPqowHeH4l2/E8L2Q==
X-Google-Smtp-Source: APXvYqzVJtbUi4WVUTq3xr8r/FIGHSgUvzWLaYAWuuzrkfokhswgbdBEirmYBEF1DfHuF+eLdXtIF1xl/+8iimGopP0=
X-Received: by 2002:a6b:9089:: with SMTP id s131mr4314939iod.107.1572513989659;
 Thu, 31 Oct 2019 02:26:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190926105354.8301-1-kristian.evensen@gmail.com> <alpine.DEB.2.20.1910022039530.21131@blackhole.kfki.hu>
In-Reply-To: <alpine.DEB.2.20.1910022039530.21131@blackhole.kfki.hu>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Thu, 31 Oct 2019 10:26:18 +0100
Message-ID: <CAKfDRXjgsAbTxgLwBpY+MiYWAyu4n4puJjgTOaBx0oSr+pNzrQ@mail.gmail.com>
Subject: Re: [PATCH] ipset: Add wildcard support to net,iface
To:     =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jozsef,

On Wed, Oct 2, 2019 at 8:46 PM Kadlecsik J=C3=B3zsef
<kadlec@blackhole.kfki.hu> wrote:
> Sorry for the long delay - I'm still pondering on the syntax.

I hope you are doing fine. I don't mean to be rude or anything by
nagging, but I was wondering if you have had time to think some more
about the syntax for wildcard-support?

Have a nice day!

BR,
Kristian
