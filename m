From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [conntrack-tools PATCH 4/4] conntrackd: introduce RequestResync option
Date: Tue, 2 May 2017 10:18:55 +0200
Message-ID: <CAOkSjBjBMjfx1VHAtH1z+4fV-hzLWp_O7DGwg4sACB+U_vGgzg@mail.gmail.com>
References: <149270928083.1751.9498250834672625764.stgit@nfdev2.cica.es>
 <149270929676.1751.18425946182083865800.stgit@nfdev2.cica.es>
 <20170425113732.GB5355@salvia> <CAOkSjBiYGg76HichZbLkmyHyHTV3OPu3H7BqSE1ZJki0gh7pxA@mail.gmail.com>
 <20170425131843.GB1050@salvia> <CAOkSjBj3wqnCVMAfMek3NKbgbo35EjMQ842gOzgOpmH=qBu=6g@mail.gmail.com>
 <20170501091319.GA2925@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34792 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbdEBITR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 May 2017 04:19:17 -0400
Received: by mail-io0-f194.google.com with SMTP id h41so27728396ioi.1
        for <netfilter-devel@vger.kernel.org>; Tue, 02 May 2017 01:19:17 -0700 (PDT)
Received: from mail-it0-f52.google.com (mail-it0-f52.google.com. [209.85.214.52])
        by smtp.gmail.com with ESMTPSA id 93sm7623401ioj.58.2017.05.02.01.19.16
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 May 2017 01:19:16 -0700 (PDT)
Received: by mail-it0-f52.google.com with SMTP id c15so30923061ith.0
        for <netfilter-devel@vger.kernel.org>; Tue, 02 May 2017 01:19:16 -0700 (PDT)
In-Reply-To: <20170501091319.GA2925@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 1 May 2017 at 11:13, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>
>> the ALARM mode requires to commit the external cache instead of the
>> conns being directly injected into the kernel.
>
> You may want to disable the external cache with the alarm mode. The
> alarm mode only needs the internal cache though, but that shouldn't be
> much of a problem.
>
> With the alarm mode, you will skip spikes in CPU consumption since
> resync is expensive.  With a very large table, this results in some
> sort of lazy busy polling.
>

I do the equivalent of this RequestResync by hand (i.e. using conntrackd -n) and
it seems to work fine, see below.

>> I think the new RequestResync method (or whatever other alternative)
>> provides a good tradeoff between methods and increases general
>> usefulness of conntrackd.
>
> I'm trying to help here if I can give something better ;-)
>
> Look, you should at least combine this new RequestResync with
> CommitTimeout. Even if you don't explicitly request a commit command,
> this sets the timeout for the entries that are pushed into the kernel.
>
> So, if you set:
>
>         RequestResync 30
>         CommitTimeout 180
>
> connections we don't get any information from for 180 seconds will
> expire.
>

It seems that CommitTimeout can't be combined with
DisableExternalCache, see the evaluate() function.

However a patch to enable this seems easy. I guess we could extend a
bit external_inject_ct_new() to allow reading the commit_timeout
instead of using 0 (similar to what cache_ct_commit_step() does,
right?)

I can add a new previous patch to the series to enable this.

> BTW, how are you measuring this improvement? Is that you get less logs
> error messages that you reported before or so?
>

What I detect is that after the initial startup/sync, the amount of
conntracks in each node diverges.
After 10 minutes, the conntracks in each node are quite different, i.e:

aborrero@node1:~ $ sudo conntrack -C
7885

aborrero@node2:~ $ sudo conntrack -C
17813

A manual 'conntrackd -n' seems to solve the problem:

aborrero@node1:~ $ sudo conntrackd -n ; sudo conntrack -C
18583

aborrero@node2:~ $ sudo conntrackd -n ; sudo conntrack -C
18473

I can understand that each node sees different traffic (is a
multi-master symmetric configuration) but still,
according to my conntrackd setup, I understand that the numbers
shouldn't show that big divergence.

Then, in this scenario, if node2 failover to node1, there are 10k
entries missing in node1, connections that will be presumably lost and
dropped by the stateful configuration of nftables.

I currently solve this by means of scripts and cron calls which is a
bit ugly, given how easy could be for conntrackd to resync by himself.

You may ask, what kind of traffic does each node see? In my current
setup, node1 sees all the IPv4 traffic and node2 sees all the IPv6
traffic (or reverse). In case of failover, a sigle node can see all
the traffic.
