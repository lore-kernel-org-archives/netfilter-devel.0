Return-Path: <SRS0=n2xU=WN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93B6C3A59F
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Aug 2019 12:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE6D62173B
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Aug 2019 12:46:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PY1uvxiY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfHQMqW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 17 Aug 2019 08:46:22 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:42657 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfHQMqV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Aug 2019 08:46:21 -0400
Received: by mail-wr1-f50.google.com with SMTP id b16so4102876wrq.9;
        Sat, 17 Aug 2019 05:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2pfNQGCh4bl0mf6scXIqLXLsi31gckxp3PKJLBvyYTg=;
        b=PY1uvxiYFchcVO/vymSgiIaAMFTTfTQrsU4+DUupB4PEy2w4ui0VP0rB3sx4axUXNd
         GeTBfL8vauDDt538K7+SChie9W97RTf4H8r6qfmMZ5KcXsPKkr1J0S0r+eUlMaxgzonc
         +0d9wDkUpgTQWHAGIutiTFz9BsKklohtAbtjEN+kf/LkHw7myG7c+24t3WKRa//zUgHy
         Rh3D2wtrZTaVEf/AdyIqPCCLqm9BxrrKV6/0e2ycGuDn1fegeOzubN96fH9q6zaedZ+2
         UvAMX90EfgB7+RZlz6DijqNtJO99iMY39rCMpAlZlwnAeasjvlefcytktQjAnTH43UzN
         8wfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2pfNQGCh4bl0mf6scXIqLXLsi31gckxp3PKJLBvyYTg=;
        b=EhRfpftySNw4EnkOBrLhuziwJ3m/Tic0gQxVh82xTkOmBB9PRgYYWuA7qixzz9cOsp
         5+73r5mMiU2r57wYIJ+pGgUFzUDLfwghQQDry8TDOTWv15+Rh82TImEX88GmiyBkrTfh
         EdwvJMHIFtnPr/7s00CFca/eE0fTHJud1LB2u3IW8SlUzYHF7JhtL29QJwsNjjiV4NQb
         /JVifGPLzpS9Aij+4AfPRUsZDK1H/WelmgjZL7zHnuyblRfgoImJ970h5vwi7FZ9Ac6L
         mGB7k5CHd6qXD72kGNicQVVC080opaMhSREp7Yc9HySEKdOnVE8x4fs6cbV8AD/KpV+i
         OY+Q==
X-Gm-Message-State: APjAAAW065ptn3IfUwgH1wAuYAGimltGg1eVYvMluj1WtvbNhFQB9QZk
        gfxq3BEugfTMFJ1MF4C83jR08KJ3vOCz7+0bJ36jmu7s
X-Google-Smtp-Source: APXvYqzcahsc6U7mNTgJExlQl/MPBfE73r2bJmCpxK7jg2R3glGaGaCDzVvWTvZkJALgNWEzJEibXbyxM2l7aWKbM5k=
X-Received: by 2002:a05:6000:110f:: with SMTP id z15mr15402092wrw.162.1566045979073;
 Sat, 17 Aug 2019 05:46:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com>
 <CAM_iQpVyEtOGd5LbyGcSNKCn5XzT8+Ouup26fvE1yp7T5aLSjg@mail.gmail.com>
In-Reply-To: <CAM_iQpVyEtOGd5LbyGcSNKCn5XzT8+Ouup26fvE1yp7T5aLSjg@mail.gmail.com>
From:   Akshat Kakkar <akshat.1984@gmail.com>
Date:   Sat, 17 Aug 2019 18:16:19 +0530
Message-ID: <CAA5aLPiqyhnWjY7A3xsaNJ71sDOf=Rqej8d+7=_PyJPmV9uApA@mail.gmail.com>
Subject: Re: Unable to create htb tc classes more than 64K
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        lartc <lartc@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I agree that it is because of 16bit of minor I'd of class which
restricts it to 64K.
Point is, can we use multilevel qdisc and classes to extend it to more
no. of classes i.e. to more than 64K classes

One scheme can be like
                                      100: root qdisc
                                         |
                                       / | \
                                     /   |   \
                                   /     |     \
                                 /       |       \
                          100:1   100:2   100:3        child classes
                            |              |           |
                            |              |           |
                            |              |           |
                           1:            2:          3:     qdisc
                           / \           / \           / \
                         /     \                     /     \
                      1:1    1:2             3:1      3:2 leaf classes

with all qdisc and classes defined as htb.

Is this correct approach? Any alternative??

Besides, in order to direct traffic to leaf classes 1:1, 1:2, 2:1,
2:2, 3:1, 3:2 .... , instead of using filters I am using ipset with
skbprio and iptables map-set match rule.
But even after all this it don't work. Why?

What I am missing?
