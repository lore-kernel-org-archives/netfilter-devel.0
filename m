From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [PATCH] tests: json: Add test cases for json format
Date: Thu, 24 Aug 2017 14:20:14 +0530
Message-ID: <CAOfkYf6aM4T1rm7p5KUmYf606xg1+HbpTVNZzrf6FSVk+hZohw@mail.gmail.com>
References: <1503348904-16654-1-git-send-email-mayhs11saini@gmail.com>
 <CAOkSjBgo0AWBMdmfh7hEvAcNZepS5m_p9pXK5jp-L+ZVn5UjRQ@mail.gmail.com>
 <CAOfkYf7B09Z+nHf8EMJ2qQ6W-1u2-j_UmiwzSXgF+Mdk7Gc5dQ@mail.gmail.com> <CAOkSjBge_Zk4L3b5CDxthHz6v+Vrx6tMtqfBxrcMLv5unZCGWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33851 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752512AbdHXIuP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 04:50:15 -0400
Received: by mail-oi0-f54.google.com with SMTP id j144so23911245oib.1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2017 01:50:15 -0700 (PDT)
In-Reply-To: <CAOkSjBge_Zk4L3b5CDxthHz6v+Vrx6tMtqfBxrcMLv5unZCGWw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 23, 2017 at 3:32 PM, Arturo Borrero Gonzalez
<arturo@netfilter.org> wrote:
> On 22 August 2017 at 11:30, Shyam Saini <mayhs11saini@gmail.com> wrote:
>>
>> Should I send the version 2 of this patch with this script?
>>
>
> Yes,
>
> my suggestion is:
>
> * create a new testcase in nftables: tests/shell/testcases/import/yourscript_0
> * put all the json files in: tests/shell/testcases/import/json and
> read them from yourscript_0
>
> in the script use the $NFT environment variable to call nft.
>
> This way we avoid adding a new testsuite just for this and reuse existing code.

Again, Thanks a lot for the suggestions. I've sent  V2 of this patch.
:-)
