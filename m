Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA90C7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 12:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D73C229F9
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 12:24:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i9qdM+Af"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbfGYMYz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 08:24:55 -0400
Received: from mail-ot1-f49.google.com ([209.85.210.49]:33329 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfGYMYz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 08:24:55 -0400
Received: by mail-ot1-f49.google.com with SMTP id q20so51353333otl.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 05:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZhZc1k6o/1c6J0SshxHfuvnZje0v/zVbfAkPxQoSBOU=;
        b=i9qdM+Afx6+bjvFD1Gbr7orWRT+bC6+X4jJNekYb+1oXp5P/xwjPBFfF8OnpeVxj/Q
         asd8lZnzL8i903aGPymXhNb0gSrVrDoHhdJUtY/snKmJyDSLtZkQmF2ktA+Ver1VV20Y
         g+NxZCN2ETM/8bsh/1XXLXec99hITbhwA+hHl0BlHmPp2ROpdw5rp2s+5o8+cYUEX9Mi
         3/5oU7ZICFAYbMhlYEzulDas9AxFg+j+O66uvBJsdQcaA1nPYbJ57PSYnUxq+99CN5Xj
         s4scuK+kOpPsS+JFhzVHNDcvDibJgfSrkQud3tySa10UVu+ULHXgJ1PHROkslPlSOR9y
         gASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZhZc1k6o/1c6J0SshxHfuvnZje0v/zVbfAkPxQoSBOU=;
        b=sLcCWBydOpBjkC+QD4PBzwZ3KPNhIhXCy2DGx98QnebED4wOAhup5eqxp6wcjO1Chi
         AwIfOchu1+XnPG2KiXmKnGYcoQ5kMQvkaTbOfbxCvOLap+UC9fqs+FtsSgOa6ad9oe+n
         G+Ps6PzlgHLAagcFAUXahYbXCuCmhC+Oofhfzx4JCxOkRhRZtZ41bXlF4jm/Li/OSIMO
         5GIMH8N4C7/q8XHtG+ZgtCsBXuICbSDBv1JHoeoKnR3A9Hkg9Ybj1c1Z9RLjXtvibzba
         Zo3AsEvziydo4WY9n38e3Ejw6YyTlzJ5eCYoIhe4Rb0olichoTJCDfcQi6SoViyP5SeR
         /URw==
X-Gm-Message-State: APjAAAUSQktPbHiX+12k73y/S3wR4M4po1JgTCUpFX+VZAT47SHknQif
        IFLDZzO+k+8Q/4ht/dEBpC8hhXJvzIIpaQGV9JxgvXqU
X-Google-Smtp-Source: APXvYqw4ULMJlN+fIEUpt+7MeDK2hDyZrosKD7Q1LRjcotLx+ARp30JoxHAD2Xjti5cqVExKf0BPO3feagbp6U4TvzY=
X-Received: by 2002:a9d:61d8:: with SMTP id h24mr4495117otk.53.1564057494474;
 Thu, 25 Jul 2019 05:24:54 -0700 (PDT)
MIME-Version: 1.0
References: <CALOK-OeZcoZZCbuCBzp+1c5iXoqVx33UW_+G3_5aUjw=iRMxHw@mail.gmail.com>
In-Reply-To: <CALOK-OeZcoZZCbuCBzp+1c5iXoqVx33UW_+G3_5aUjw=iRMxHw@mail.gmail.com>
From:   Laura Garcia <nevola@gmail.com>
Date:   Thu, 25 Jul 2019 14:24:42 +0200
Message-ID: <CAF90-WiSA88hMQSsvDP=vJK=DhLQPzUN4JzX=OR88oFowqJ8gQ@mail.gmail.com>
Subject: Re: nftables feature request: modify set element timeout
To:     Fran Fitzpatrick <francis.x.fitzpatrick@gmail.com>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 23, 2019 at 1:10 AM Fran Fitzpatrick
<francis.x.fitzpatrick@gmail.com> wrote:
>
> This morning I was using the `timeout` feature of nftables, but came
> across an apparent limitation where I was not able to update an
> element in a set's timeout value unless I removed the element from the
> set.
>
> Can it be possible to handle the element timeout value without needed
> to remove it from a set?
>
> [root@fedora29 vagrant]# nft add element inet filter myset {10.0.0.1
> timeout 1m }
> [root@fedora29 vagrant]# nft add element inet filter myset {10.0.0.1
> timeout 10m }
> [root@fedora29 vagrant]# nft list ruleset
> table inet filter {
>         set myset {
>                 type ipv4_addr
>                 flags timeout
>                 elements = { 10.0.0.1 timeout 1m expires 59s542ms }
>         }
> }

Hi,

The timeout attribute per element is designed to be created as a
constant value where the expiration is calculated and reseted to the
timeout value during an element update. I don't know exactly your use
case but what you're able to do is something like:

nft add element inet filter myset {10.0.0.1 timeout 10m }

Where the timeout would be the max reachable value, and then update
the expiration date:

nft add element inet filter myset {10.0.0.1 expires 1m }

For this, you would need an upstream kernel and nftables.

Cheers!
