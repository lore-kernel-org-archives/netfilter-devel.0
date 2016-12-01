From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [RFC nft PATCH] tests: shell: add a basic scapy test
Date: Thu, 1 Dec 2016 09:10:53 +0100
Message-ID: <CAOkSjBibmjB6Uo2z9Wx1+tfkpO=eY1vY2_79qXN+TEB_tvPcEA@mail.gmail.com>
References: <148049874652.26121.17744801893432354214.stgit@nfdev2.cica.es>
 <20161130182704.GA7892@salvia> <20161130182801.GB7892@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Shivani Bhardwaj <shivanib134@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:35805 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753276AbcLAILP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2016 03:11:15 -0500
Received: by mail-lf0-f53.google.com with SMTP id b14so165317661lfg.2
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Dec 2016 00:11:14 -0800 (PST)
Received: from mail-lf0-f43.google.com (mail-lf0-f43.google.com. [209.85.215.43])
        by smtp.gmail.com with ESMTPSA id e37sm14989877lji.42.2016.12.01.00.11.13
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Dec 2016 00:11:13 -0800 (PST)
Received: by mail-lf0-f43.google.com with SMTP id o141so165322703lff.1
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Dec 2016 00:11:13 -0800 (PST)
In-Reply-To: <20161130182801.GB7892@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30 November 2016 at 19:28, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> * You can probably augment this at some pointer to rely on the new
>>   nf_tables tracing infrastructure.
>>

That would be rather complex.

>
> Only one more question left: Do you think you can slightly generalize
> this so we decouple test files from the script? Similar to what we
> have for nft-tests.py.

What do you mean?

This testcase script is decoupled enough that you can even call it
this way (and it works):

 % NFT=%(which nft) testcases/scapy/0001_ip_ttl_0

Do you mean you would like to have a different testsuite (with a
different runner script) for these datapath tests?
