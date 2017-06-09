From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [PATCH] tests: shell: Add test for ambguity while setting the value
Date: Fri, 9 Jun 2017 11:58:10 +0200
Message-ID: <CAOkSjBgWAV7fTHRrAdJXVPkqHv7GV75+-HeMe+zob3TvPuDOXA@mail.gmail.com>
References: <1497000633-10954-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:37143 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751519AbdFIJ6d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Jun 2017 05:58:33 -0400
Received: by mail-it0-f42.google.com with SMTP id m47so29784575iti.0
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Jun 2017 02:58:32 -0700 (PDT)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com. [209.85.223.181])
        by smtp.gmail.com with ESMTPSA id b72sm673818itd.5.2017.06.09.02.58.31
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Jun 2017 02:58:31 -0700 (PDT)
Received: by mail-io0-f181.google.com with SMTP id k93so31028646ioi.2
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Jun 2017 02:58:31 -0700 (PDT)
In-Reply-To: <1497000633-10954-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 9 June 2017 at 11:30, Shyam Saini <mayhs11saini@gmail.com> wrote:
> This test checks bug identified and fixed in the commit mentioned below
> In a statement if there are  multiple src data then it  would be
> totally ambiguous to decide which value to set.
>
> We don't add this test in python testsuite, because there we only have
> "ok"  and "fail"  as return code. So, we can't detect 134 != 1 there.
> (both 1 and 134 stats failure)
>
> Test: 986dea8 ("evaluate: avoid reference to multiple src data in statements which set values")
> Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
> ---
>  .../testcases/sets/0023unknown_value_to_use_0      | 34 ++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>  create mode 100755 tests/shell/testcases/sets/0023unknown_value_to_use_0
>

Thanks Shyam,

minor things below, almost there!
Please send an v2 with the requested changes, as you could see, they
are cosmetic changes

> diff --git a/tests/shell/testcases/sets/0023unknown_value_to_use_0 b/tests/shell/testcases/sets/0023unknown_value_to_use_0
> new file mode 100755
> index 0000000..011cedd
> --- /dev/null
> +++ b/tests/shell/testcases/sets/0023unknown_value_to_use_0
> @@ -0,0 +1,34 @@
> +#!/bin/bash
> +
> +       # This test checks bug identified and fixed in the commit Id "986dea8".
> +       # i.e, If in a statement there are  multiple src data then it would be totally ambiguous to decide which value to set.
> +
> +       # Before this commit 986dea8, nft returns 134 which indicates the bug but after this commit it returns 1.
> +       # We don't add this test in python testsuite, because there we can't detect 134 != 1 (returns code stating failure)
> +

Better remove the indentations.

> +declare -a rules=(
> +                "tcp dport set {1, 2, 3}" "udp dport set {1, 2, 3}"
> +                "meta pkttype set {unicast, multicast, broadcast}"
> +                "meta mark set {0xffff, 0xcc}"
> +                "ct mark set {0x11333, 0x11}" "ct zone set {123, 127}"
> +                "ct label set {123, 127}"
> +                "ct event set {new, related, destroy, label}"
> +                "ether daddr set {01:00:5e:00:01:01, 01:00:5e:00:02:02}"
> +                "ip saddr set {192.19.1.2, 191.1.22.1}"
> +                )
> +

I don't really like this approach of using a bash array,
I think it makes things harder to understand and requires to decode
the rather complex
bash variable expansions, but hey, it works, so OK.
I left this up to you.

> +$NFT add table t
> +$NFT add chain t c
> +
> +for (( i = 0 ; i < ${#rules[@]} ; i++ ))
> +do
> +       $1

$1 <-- what does this? I think we can safely remote it.

> +       `$NFT add rule t c ${rules[$i]} 2>>/dev/null`

No need to run command in `a subshell`. BTW this $(syntax) is preferred.

Also, no need to redirect stderr, we are actually interested in it.
In fact, if you delete the redirection and you run this test:

% sudo ./run-tests.sh testcases/sets/0023unknown_value_to_use_0
I: using nft binary ../../src/nft

I: [OK]        testcases/sets/0023unknown_value_to_use_0
<cmdline>:1:28-36: Error: you cannot use a set here, unknown value to use
add rule t c tcp dport set {1, 2, 3}
             ~~~~~~~~~~~~~~^^^^^^^^^
<cmdline>:1:28-36: Error: you cannot use a set here, unknown value to use
add rule t c udp dport set {1, 2, 3}
             ~~~~~~~~~~~~~~^^^^^^^^^
[...]
<cmdline>:1:30-67: Error: you cannot use a set here, unknown value to use
add rule t c ether daddr set {01:00:5e:00:01:01, 01:00:5e:00:02:02}
             ~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
<cmdline>:1:27-50: Error: you cannot use a set here, unknown value to use
add rule t c ip saddr set {192.19.1.2, 191.1.22.1}
             ~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^

I: results: [OK] 1 [FAILED] 0 [TOTAL] 1

You get access to the actual error messages, which is useful to see
that the return code of 1 maps to
the error message itself.

Still, if you run the complete testsuite (i.e, not a single test), you
can hide/show these messages
using the '-v' switch.
