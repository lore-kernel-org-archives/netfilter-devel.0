From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [RFC PATCH nft V4] src: Add import command for json
Date: Mon, 25 Sep 2017 22:53:34 +0530
Message-ID: <CAOfkYf59GXeT_QA4HnvLmUe0FAhrLB5q9nTPD_DEVko7NqUJ7A@mail.gmail.com>
References: <1505902479-24405-1-git-send-email-mayhs11saini@gmail.com>
 <CAOkSjBj0SZ18kUPrp4r-4P18ZOwmC+6hS16ZSyOU=JOYK6UZTw@mail.gmail.com> <20170921110826.GB4504@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:56911 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964851AbdIYRXf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Sep 2017 13:23:35 -0400
Received: by mail-oi0-f53.google.com with SMTP id b184so8016800oii.13
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Sep 2017 10:23:35 -0700 (PDT)
In-Reply-To: <20170921110826.GB4504@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> My only concern with this is that we'll end up having a json
> representation in high-level format.
>
> So I wonder if it would be good to make a distinction between the
> low-level VM (Virtual-Machine) json representation and the high-level
> one.
>
> What I'm proposing is that we just add a command like this:
>
> nft add export vm json
>
> So the vm keyword specifies that we want a VM representation. So we
> leave room for Eric Leblond's high level json representation.
>
> I would turn 'nft export json' into no-op now, and we document this
> change in the 0.8 release, since we aren't yet on 1.0, we still have a
> bit of room to make these changes...
>
> Fine with this?


Hi Pablo,

How should we proceed to include features requested by you?

Thanks,
Shyam
