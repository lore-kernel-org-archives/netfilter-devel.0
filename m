From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [PATCH V2] tests: json: Add test cases for json format
Date: Thu, 24 Aug 2017 15:00:08 +0200
Message-ID: <CAOkSjBi-E7HTi_4t0rP=hSWzd3CwQFZv=TiP2Lr=dkZLPFaF=w@mail.gmail.com>
References: <1503564545-28426-1-git-send-email-mayhs11saini@gmail.com>
 <CAOkSjBhaLkRbVFo9TENJ=tKWfOw3Hvcmx+Brp9vU0AoryZiwGA@mail.gmail.com> <CAOfkYf5CDMihfi9tkUQcOv5eFMDFi2nfr012QwTy-DJ4fy65Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36957 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751475AbdHXNAa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 09:00:30 -0400
Received: by mail-wm0-f54.google.com with SMTP id p30so4759399wmi.0
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2017 06:00:30 -0700 (PDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com. [74.125.82.52])
        by smtp.gmail.com with ESMTPSA id h28sm2217190ede.56.2017.08.24.06.00.29
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Aug 2017 06:00:29 -0700 (PDT)
Received: by mail-wm0-f52.google.com with SMTP id m207so4763186wma.1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2017 06:00:29 -0700 (PDT)
In-Reply-To: <CAOfkYf5CDMihfi9tkUQcOv5eFMDFi2nfr012QwTy-DJ4fy65Zw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24 August 2017 at 14:08, Shyam Saini <mayhs11saini@gmail.com> wrote:
>> That was quick and dirty code for you to get the idea.
>> Please follow the example of other testcases [0] to compare ruleset,
>> create tempfiles and so on.
>>
>
> One issue with this approach, incase of set rules
> nft will throw this error
> "Error: Could not process rule: File exists"
> So, i need to flush ruleset before import them with json.
> Is it okay?
>

yes, something like:

nft export
nft flush ruleset
nft import

we can later on investigate how to do something like:

nft export json | nft import json

>>
>> Please, if possible, try to add a testcase that is [OK]. Not sure what
>> is wrong with the dup statement.
>>
> I tried, but they always throw the same error.
> Shouldn't we keep them in testsuite so that we know that these set of
> rules needs to be fixed.
>

yes, but the point is to try to fix the issue or at least identify
where the issue is.
