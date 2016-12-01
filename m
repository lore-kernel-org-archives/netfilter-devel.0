From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [RFC nft PATCH] tests: shell: add a basic scapy test
Date: Thu, 1 Dec 2016 16:05:07 +0100
Message-ID: <CAOkSjBjnKTk14-32+5faKsJG3CMARrywZ2814o1L2cC5Mj2TOQ@mail.gmail.com>
References: <148049874652.26121.17744801893432354214.stgit@nfdev2.cica.es>
 <20161130182704.GA7892@salvia> <20161130182801.GB7892@salvia>
 <CAOkSjBibmjB6Uo2z9Wx1+tfkpO=eY1vY2_79qXN+TEB_tvPcEA@mail.gmail.com> <20161201104535.GA13152@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Shivani Bhardwaj <shivanib134@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:33434 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752954AbcLAPFa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2016 10:05:30 -0500
Received: by mail-lf0-f43.google.com with SMTP id c13so173395672lfg.0
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Dec 2016 07:05:29 -0800 (PST)
Received: from mail-lf0-f49.google.com (mail-lf0-f49.google.com. [209.85.215.49])
        by smtp.gmail.com with ESMTPSA id g12sm97324lfg.28.2016.12.01.07.05.28
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Dec 2016 07:05:28 -0800 (PST)
Received: by mail-lf0-f49.google.com with SMTP id c13so173395434lfg.0
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Dec 2016 07:05:28 -0800 (PST)
In-Reply-To: <20161201104535.GA13152@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 1 December 2016 at 11:45, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I mean, it would be good if you place as much common code as possible
> in the runner script, so individual unit tests don't result in too
> much copy and paste.
>

Ok, I understand.

Actually, as you know I'm just experimenting with this.

Anyway the problem I see is that we could end losing a lot of flexibility.
The current py testsuite is only able to perform one kind of tests
because of this approach.
In the other hand, the shell testsuite is able to perform almost any
kind of tests because it only executes arbitrary binaries.

So perhaps we could take an intermediate approach:
 * scapy tests are executed by the shell testsuite runner (they are
standalone scripts)
 * we develop a common lib of functions inside
tests/shell/testcases/scapy/ (for example common.py)
 * then, each scapy test load that common lib which includes most of
the factorised code

Common functions would be something like this:

* configure(): we do the scapy configuration, network config, or whatever
* load_ruleset): we pass a nft ruleset (a string) and load it using nft -f
* check_result(): we grep the ruleset counters, or whatever

I'm thinking of some tests we could have using this approach:

* atomic replacement of ruleset during a network transfer
* conntrack modifications (using the conntrack-tools binaries)
* packet mangling, NAT, etc

In any case, I think we should retain the ability to load nft rules,
send/recv scapy packets and check for nft counters at any time during
the execution.
