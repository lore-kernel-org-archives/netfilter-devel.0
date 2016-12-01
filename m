From: Vadim Kochan <vadim4j@gmail.com>
Subject: Re: [RFC nft PATCH] tests: shell: add a basic scapy test
Date: Thu, 1 Dec 2016 13:04:07 +0200
Message-ID: <CAMw6YJ+ZpePTFvkkAgwtGBH1FS0i8AWJxitiWUTwf=xCAvOQrQ@mail.gmail.com>
References: <148049874652.26121.17744801893432354214.stgit@nfdev2.cica.es>
 <20161130182704.GA7892@salvia> <20161130182801.GB7892@salvia>
 <CAOkSjBibmjB6Uo2z9Wx1+tfkpO=eY1vY2_79qXN+TEB_tvPcEA@mail.gmail.com> <20161201104535.GA13152@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Arturo Borrero Gonzalez <arturo@debian.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Shivani Bhardwaj <shivanib134@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:35070 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753150AbcLALEI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2016 06:04:08 -0500
Received: by mail-yw0-f193.google.com with SMTP id b66so17624271ywh.2
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Dec 2016 03:04:08 -0800 (PST)
In-Reply-To: <20161201104535.GA13152@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 1, 2016 at 12:45 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Dec 01, 2016 at 09:10:53AM +0100, Arturo Borrero Gonzalez wrote:
>> On 30 November 2016 at 19:28, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> >> * You can probably augment this at some pointer to rely on the new
>> >>   nf_tables tracing infrastructure.
>> >>
>>
>> That would be rather complex.
>
> OK, let's start with this something simple.
>
>> > Only one more question left: Do you think you can slightly generalize
>> > this so we decouple test files from the script? Similar to what we
>> > have for nft-tests.py.
>>
>> What do you mean?
>>
>> This testcase script is decoupled enough that you can even call it
>> this way (and it works):
>>
>>  % NFT=%(which nft) testcases/scapy/0001_ip_ttl_0
>>
>> Do you mean you would like to have a different testsuite (with a
>> different runner script) for these datapath tests?
>
> I mean, it would be good if you place as much common code as possible
> in the runner script, so individual unit tests don't result in too
> much copy and paste.
>
> Thanks Arturo.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Sorry for the noise, may PTF framework help for you ? Usually it is
used for datapath testing
on switches, but may be it can cover your cases.

Regards,
Vadim Kochan
