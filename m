From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [PATCHv3] tests: py: Add test for ambiguity while setting the value
Date: Wed, 21 Jun 2017 14:15:40 +0530
Message-ID: <CAOfkYf4n9FOi4tqvG7p1SGgMVPavJhQ9nt+MKBdtF3GDTbkDkA@mail.gmail.com>
References: <1497641742-25272-1-git-send-email-mayhs11saini@gmail.com> <20170618092913.GA8026@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:35246 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdFUIpm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2017 04:45:42 -0400
Received: by mail-ot0-f175.google.com with SMTP id u13so92954869otd.2
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2017 01:45:41 -0700 (PDT)
In-Reply-To: <20170618092913.GA8026@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 18, 2017 at 2:59 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Jun 17, 2017 at 01:05:42AM +0530, Shyam Saini wrote:
>> This test checks bug identified and fixed in the commit mentioned below
>> In a statement if there are  multiple src data then it  would be
>> totally ambiguous to decide which value to set.
>>
>> Before the commit was made it returned 134(BUG), but now it returns 1
>> i.e, an error message.
>
> Applied, thanks.
>
> One change though before applying, see below.
>
>> Test: 986dea8 ("evaluate: avoid reference to multiple src data in
>> statements which set values")
>> Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
>> ---
>>  tests/py/any/ct.t       | 10 ++++++++++
>>  tests/py/any/meta.t     |  8 ++++++++
>>  tests/py/bridge/ether.t |  7 +++++++
>>  tests/py/inet/tcp.t     |  7 +++++++
>>  tests/py/inet/udp.t     |  7 +++++++
>>  tests/py/ip/ip.t        |  7 +++++++
>>  6 files changed, 46 insertions(+)
>>
>> diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
>> index 20f047a..f7c2321 100644
>> --- a/tests/py/any/ct.t
>> +++ b/tests/py/any/ct.t
>> @@ -58,6 +58,16 @@ ct mark set 0x11;ok;ct mark set 0x00000011
>>  ct mark set mark;ok;ct mark set mark
>>  ct mark set mark map { 1 : 10, 2 : 20, 3 : 30 };ok;ct mark set mark map { 0x00000003 : 0x0000001e, 0x00000002 : 0x00000014, 0x00000001 : 0x0000000a}
>>
>> +# Following rules tests ambguity while setting the value
>> +# sudo nft add rule ip test-ip4 output ct mark set {0x11333, 0x11}
>> +# <cmdline>:1:41-55: Error: you cannot use a set here, unknown value to use
>> +# add rule ip test-ip4 output ct mark set {0x11333, 0x11}
>> +#                             ~~~~~~~~~~~~^^^^^^^^^^^^^^^
>
> No need to copy and paste this over and over again.
>
> Look, next time you place this in the commit message, we can find the
> reason why this line was added via:
Sure

Thanks

> $ git annotate
>
> So I have removed them all before applying.
