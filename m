Return-Path: <SRS0=JJ+7=6B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=BODY_SINGLE_WORD,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2939C38A29
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Apr 2020 19:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99087206B9
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Apr 2020 19:38:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ILubfIuS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730582AbgDQTit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Apr 2020 15:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730336AbgDQTis (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Apr 2020 15:38:48 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A370FC061A0C
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Apr 2020 12:38:48 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id e5so2344671edq.5
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Apr 2020 12:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=BhsA1aKlglGjpRdMu2peVecDmERAuTyLLhI53Hw2hvM=;
        b=ILubfIuST/TsNWr0c9BkzpnuSHut5yzNyOF4lg2+jMah3wZinbB4gJhA4s/bdWYTWZ
         pmNk48KU5nsOgJuEwu/RNrVf1TEKYQm2lZQN4LgtVoPRivQNFBRNYoegbLIDHyJmkajX
         8jp+GmMpiEZNCQpzUNUNrp0/oIYJpdkDYfplJZb4HZLT6E/U/wRAAoW4r4d18jMoU4EH
         omNJtyAdiXYS4n3l0k2vgyr5Ew5sQBPus6bIafB04YwXzDzYg7SUtdLSdpSQi6DgVbwM
         GVf7CkBVH+qWCtVVEXqUGYkXPzHVxa/O8TbHbWkuM6f3T3tEowrSuvC5lS9e3S1PEHBR
         9opg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=BhsA1aKlglGjpRdMu2peVecDmERAuTyLLhI53Hw2hvM=;
        b=JwWG8QK3+J9Q28uhVyGe+UwZ4HEgbmnq1+XxUGxD5GAeQBRE0MIVawjyt5BS/azh5N
         6oOzdkf7pJKGCjjVUR8AaBcBu2p1PxiNTZ9K/g6KLi/CS4ozJ7OWhYCB8G87RIHIGZ1x
         tccx9Tnb352dJwl16e3+cjhZMKP+rQNc57tEY9x0DQZVYFfSM6HSofBWmo8f6JOJqUAs
         zPn7A+CG6ixpN1DTpnfm42jMPQ63sOphVtOCJmB7O+xmZ9f0lWmsBu88LozZMOHEonHA
         D/u+AFwiEKjxukuFDuhxNGAm5hB+CRwiS+wpY5kq/iPakbMW8OKT1t7i2JkHycNRan3a
         lt5A==
X-Gm-Message-State: AGi0Pubx9+1Les5CUm/KJeuSKjldC5NGnggKi8MQAaT/Ch3t83gL26ws
        1kaLP57dooPZ72BdaMoTJLUIij4GPAhu88WJ1cvmQw==
X-Google-Smtp-Source: APiQypK29un/xtNwuHT1z61C7ASNvKgtGPDghzqM3101q70JyQlIiiBtXFGr1k2JjKJ6PNf5xWj2g5IPMyO0HPwQ3mk=
X-Received: by 2002:a05:6402:22f7:: with SMTP id dn23mr4713412edb.167.1587152327120;
 Fri, 17 Apr 2020 12:38:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200407190508.21496-1-mattst88@gmail.com>
In-Reply-To: <20200407190508.21496-1-mattst88@gmail.com>
From:   Matt Turner <mattst88@gmail.com>
Date:   Fri, 17 Apr 2020 12:38:35 -0700
Message-ID: <CAEdQ38FeA5wwRVYjET3eD6p2Ueki1ZHPAHhDE7n2D3gHigYq9w@mail.gmail.com>
Subject: Re: [PATCH nftables] doc: Include generated man pages in dist tarball
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ping
