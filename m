Return-Path: <SRS0=Eqja=WM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C7CC41514
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 17:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0C8C205F4
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 17:45:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dc+uFNYU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfHPRpU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Aug 2019 13:45:20 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39633 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727486AbfHPRpT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Aug 2019 13:45:19 -0400
Received: by mail-pl1-f196.google.com with SMTP id z3so2735582pln.6;
        Fri, 16 Aug 2019 10:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RyCXVhRN+ce8wTQS17+Ol/8skNZ2vgCgTWCjwmTFLGM=;
        b=dc+uFNYUI5lcwQJgLQMs1y4B8iUf6H+6kx3JMIVyf3nUO/7W+6YbukJIvtuXg4dgD8
         sMAa4o6wjL5QkbYthTKS2+TjEWtLxXzkk5Tqn4mnaT4wUkDOTjjOpS2TAoSjJeLjaBiA
         QJ5v3Xh/oJkro4YN8vKN/aASH/bKNWvzZ2PLZ5/gmKMjapQ9PT12q3TtepGRz0wYUCip
         WosCcYiaViTuDmvekvY0eJ+BJPKAoRocbjnj9uOMMn4G3Ayk1ULae9fLZFNEjLAB75RL
         2D9nAhTc9AzNR0B0YspUhkFpVI3LhUEhlTO6mM4WHdCKXoqvk+3wnFUWswwmb1Qw/RKr
         uY6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RyCXVhRN+ce8wTQS17+Ol/8skNZ2vgCgTWCjwmTFLGM=;
        b=CfTSYXJgeb6MCprqFa4lCPBgTdyp8o3IRbUE7KITQuyT6dkFUohtJl0LQfTwJI4qJ6
         rzYBEdF7Kj9IBTLIs+TyOqYNPWXAqWixc5fZnCfNvbLlG2ELuHZxrrMJFgCYdx5Lnu4I
         7A16bR8MGgNQMUkfq5y7u/WK9Th+PwCSLOz/6OFvtigdoRVp2VNZtWZ+fQojpbdjKyW7
         pYKMQEZXGHVnK9GTX2NgQeDg9quU7CmoVbn70ZXcMZaWLihhi6TEzIRx3JjPjTuBT4Gg
         W/GEtNWohHOwL3y5xAdLD6/QuKPOe8HcmEJ1tH2yUWRHZBwA6xRYdx2AZh6+cyvCNkKq
         9l+A==
X-Gm-Message-State: APjAAAXY+5NBFH8z69w61uvcpJrYQN4GGmsVFjbp4roo5V4BwwRX0rNN
        rY7tMRtT5RtKi2JfTIQcRo1qXKjkbH+KOkN4bJKgDA==
X-Google-Smtp-Source: APXvYqw8xOpt4KdjG/NA/xWzu6Qn+d25WhlD671OL0tFrbTkmVj/CgAzSbdLTMHFFNusj8zIv4XiYN1tkSp2JuMET/c=
X-Received: by 2002:a17:902:7286:: with SMTP id d6mr10489652pll.61.1565977519072;
 Fri, 16 Aug 2019 10:45:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com>
In-Reply-To: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 16 Aug 2019 10:45:07 -0700
Message-ID: <CAM_iQpVyEtOGd5LbyGcSNKCn5XzT8+Ouup26fvE1yp7T5aLSjg@mail.gmail.com>
Subject: Re: Unable to create htb tc classes more than 64K
To:     Akshat Kakkar <akshat.1984@gmail.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        lartc <lartc@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 16, 2019 at 5:49 AM Akshat Kakkar <akshat.1984@gmail.com> wrote:
>
> I want to have around 1 Million htb tc classes.
> The simple structure of htb tc class, allow having only 64K classes at once.

This is probably due the limit of class ID which is 16bit for minor.


> But, it is possible to make it more hierarchical using hierarchy of
> qdisc and classes.
> For this I tried something like this
>
> tc qdisc add dev eno2 root handle 100: htb
> tc class add dev eno2 parent 100: classid 100:1 htb rate 100Mbps
> tc class add dev eno2 parent 100: classid 100:2 htb rate 100Mbps
>
> tc qdisc add dev eno2 parent 100:1 handle 1: htb
> tc class add dev eno2 parent 1: classid 1:10 htb rate 100kbps
> tc class add dev eno2 parent 1: classid 1:20 htb rate 300kbps
>
> tc qdisc add dev eno2 parent 100:2 handle 2: htb
> tc class add dev eno2 parent 2: classid 2:10 htb rate 100kbps
> tc class add dev eno2 parent 2: classid 2:20 htb rate 300kbps
>
> What I want is something like:
> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
> 0x00000001 fw flowid 1:10
> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
> 0x00000002 fw flowid 1:20
> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
> 0x00000003 fw flowid 2:10
> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
> 0x00000004 fw flowid 2:20
>
> But I am unable to shape my traffic by any of 1:10, 1:20, 2:10 or 2:20.
>
> Can you please suggest, where is it going wrong?
> Is it not possible altogether?

The filter could only filter for classes on the same level, you are
trying to filter for the children classes, which doesn't work.

Thanks.
