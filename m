From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [conntrack-tools PATCH 2/4] conntrackd: make the daemon run in RT
 mode by default
Date: Wed, 7 Jun 2017 22:53:53 +0200
Message-ID: <CAOkSjBiav4tXaBVt5X5zQHkv_pX=Fyv8EjhHxfit+1vSskS2=Q@mail.gmail.com>
References: <149674670719.18546.7841033150308352826.stgit@nfdev2.cica.es>
 <149674671245.18546.17167682826049346258.stgit@nfdev2.cica.es> <20170606111040.GA1839@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33540 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751425AbdFGUyP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2017 16:54:15 -0400
Received: by mail-io0-f178.google.com with SMTP id b184so12332819ioe.0
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Jun 2017 13:54:15 -0700 (PDT)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com. [209.85.223.181])
        by smtp.gmail.com with ESMTPSA id e31sm1423502ioi.51.2017.06.07.13.54.14
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jun 2017 13:54:14 -0700 (PDT)
Received: by mail-io0-f181.google.com with SMTP id b184so12332596ioe.0
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Jun 2017 13:54:14 -0700 (PDT)
In-Reply-To: <20170606111040.GA1839@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 6 June 2017 at 13:10, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> But I think we should keep the Nice and Scheduler clauses. Just in
> case anyone wants to do this fine grain tunning.
>

The nice value can be changed at runtime externally: using the
nice/renice commands
Perhaps is a bit redundant to have it included in the conntrackd code.
Also, nice values are somehow overridden by either SCHED_RR (our
default) or SCHED_FIFO.
Not sure if it makes sense to run in RT and then lower priority by
means of nice.

I'm tempted to just remove the nice thing in v2, what do you think?
