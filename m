From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: remove messages print and boot/module
 load time
Date: Fri, 19 Jan 2018 19:50:43 +0100
Message-ID: <CAOkSjBga-SBmxXtedw3oaVzTdo94+d=r5yzPktwdxS8BWRVQbw@mail.gmail.com>
References: <20180119124702.2650-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34001 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755830AbeASSvG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 13:51:06 -0500
Received: by mail-wm0-f68.google.com with SMTP id 81so8531887wmb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 10:51:06 -0800 (PST)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com. [74.125.82.54])
        by smtp.gmail.com with ESMTPSA id o42sm7146511edc.33.2018.01.19.10.51.04
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jan 2018 10:51:04 -0800 (PST)
Received: by mail-wm0-f54.google.com with SMTP id b21so5470383wme.4
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 10:51:04 -0800 (PST)
In-Reply-To: <20180119124702.2650-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19 January 2018 at 13:47, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Several reasons for this:
>
> * Several modules maintain internal version numbers, that they print at
>   boot/module load time, that are not exposed to userspace, as a
>   primitive mechanism to make revision number control from the earlier
>   days of Netfilter.
>
> * IPset shows the protocol version at boot/module load time, instead
>   display this via module description, as Jozsef suggested.
>
> * Remove copyright notice at boot/module load time in two spots, the
>   Netfilter codebase is a collective development effort, if we would
>   have to display copyrights for each contributor at boot/module load
>   time for each extensions we have, we would probably fill up logs with
>   lots of useless information - from a technical standpoint.
>
> So let's be consistent and remove them all.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
