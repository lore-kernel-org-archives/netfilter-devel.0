From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [PATCHv2] tests: shell: Add test for ambguity while setting the value
Date: Mon, 12 Jun 2017 16:54:18 +0530
Message-ID: <CAOfkYf6PiXccqcrXKnFJt50nQC8Zh-c0NNnUA_rD0HCoLvxeSQ@mail.gmail.com>
References: <1497024060-6142-1-git-send-email-mayhs11saini@gmail.com>
 <20170612092207.GA3997@salvia> <CAOfkYf7evsUh4k_xZfUyU-MU0mMo=RH2VLruQX6ADTRo7o1N9w@mail.gmail.com>
 <20170612104940.GA7990@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:34952 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752545AbdFLLYU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jun 2017 07:24:20 -0400
Received: by mail-ot0-f176.google.com with SMTP id a2so64583877oth.2
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jun 2017 04:24:19 -0700 (PDT)
In-Reply-To: <20170612104940.GA7990@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 12, 2017 at 4:19 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jun 12, 2017 at 04:16:16PM +0530, Shyam Saini wrote:
>> On Mon, Jun 12, 2017 at 2:52 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > On Fri, Jun 09, 2017 at 09:31:00PM +0530, Shyam Saini wrote:
>> >> diff --git a/tests/shell/testcases/sets/0023unknown_value_to_use_0 b/tests/shell/testcases/sets/0023unknown_value_to_use_0
>> >> new file mode 100755
>> >> index 0000000..ee9be68
>> >> --- /dev/null
>> >> +++ b/tests/shell/testcases/sets/0023unknown_value_to_use_0
>> >> @@ -0,0 +1,33 @@
>> >> +#!/bin/bash
>> >> +
>> >> +     # This test checks bug identified and fixed in the commit Id "986dea8".
>> >> +     # i.e, If in a statement there are  multiple src data then it would be totally ambiguous to decide which value to set.
>> >> +
>> >> +     # Before this commit 986dea8, nft returns 134 which indicates the bug but after this commit it returns 1.
>> >> +     # We don't add this test in python testsuite, because there we can't detect 134 != 1 (returns code stating failure)
>> >> +
>> >> +declare -a rules=(
>> >> +"tcp dport set {1, 2, 3}" "udp dport set {1, 2, 3}"
>> >> +"meta pkttype set {unicast, multicast, broadcast}"
>> >> +"meta mark set {0xffff, 0xcc}"
>> >> +"ct mark set {0x11333, 0x11}" "ct zone set {123, 127}"
>> >> +"ct label set {123, 127}"
>> >> +"ct event set {new, related, destroy, label}"
>> >> +"ether daddr set {01:00:5e:00:01:01, 01:00:5e:00:02:02}"
>> >> +"ip saddr set {192.19.1.2, 191.1.22.1}"
>> >> +)
>> >> +
>> >> +$NFT add table t
>> >> +$NFT add chain t c
>> >> +
>> >> +for (( i = 0 ; i < ${#rules[@]} ; i++ ))
>> >> +do
>> >> +     $NFT add rule t c ${rules[$i]}
>> >> +     ret=$?
>> >> +     if [ $ret -ne 1 ];
>> >> +     then
>> >> +             echo "E: failed test: returned $ret instead of 1" >&2
>> >> +             exit 1
>> >> +     fi
>> >> +done
>> >
>> > Better use tests/py/ for this?
>>
>> We only have "ok" and "fail" as return codes in python test suites and
>> we can't can't detect 134 != 1 there.
>
> Not sure what you mean "we can't can't detect 134 != 1 there."
> You probably refer to the fact that we cannot distinguish between
> assertion failure and command failure?
>

Yes,
Sorry my bad. I was missing the  context.

I'm adding snippet from Arturo where he explained why we don't add
this in python test suite

                          "They are good candidates for the python testsuite,
                           but there we have no way to detect return
codes (apart of fail/ok), so we can't
                           detect 134 != 1 (which both indicates failure)"


>> So it was added in the tests/shell/.
>>
>> further we would need "*.payload" file for that respective test.
>>
>> $ nft --debug=netlink add rule t c udp dport set {1, 3}
>>
>> But in our case it is not generated at all.
>
> We have no *.payload for tests that fail anyway, right?

say we add some test.t file in the tests suite then don't we need
corresponding test.t.payload file?
and in our case we if add some test.t file as our test then wouldn't
we need corresponding test.t.payload file?


>> Is it right ?
>
> Probably I missing anything, I'm asking because I just wondering if py
> tests would be a better fit for this.

Do we still need this in python test suite?

Thanks,
Shyam
