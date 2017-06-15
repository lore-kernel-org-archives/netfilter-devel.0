From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [PATCHv2] tests: shell: Add test for ambguity while setting the value
Date: Thu, 15 Jun 2017 16:25:51 +0530
Message-ID: <CAOfkYf5QC1AMMWj9PXwsEQYDkpK+rmcr=g5D8DOHTBkAQDOtOA@mail.gmail.com>
References: <1497024060-6142-1-git-send-email-mayhs11saini@gmail.com> <20170615095156.GA8936@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35204 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751979AbdFOKz6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Jun 2017 06:55:58 -0400
Received: by mail-oi0-f50.google.com with SMTP id e11so5731769oia.2
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2017 03:55:52 -0700 (PDT)
In-Reply-To: <20170615095156.GA8936@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 15, 2017 at 3:21 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Jun 09, 2017 at 09:31:00PM +0530, Shyam Saini wrote:
>> This test checks bug identified and fixed in the commit mentioned below
>> In a statement if there are  multiple src data then it  would be
>> totally ambiguous to decide which value to set.
>>
>> We don't add this test in python testsuite, because there we only have
>> "ok"  and "fail"  as return code. So, we can't detect 134 != 1 there.
>> (both 1 and 134 stats failure)
>
> OK I see, so 134 and 1 refers to the exit code we return to the shell
> (or whoever runs nft).
>
> Could you have a look at tests/py/nft-test.py
>
Sure

> If the problem is just the exit code, then I suggest you add these
> tests to the python infrastructure, then make sure that the python
> script checks for 1 for 'fail'.
>
> Could you have a look, please?

I'll send the python version of this test.

Thanks,
shyam
