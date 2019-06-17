Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9873C31E50
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 13:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CD2A20657
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 13:46:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eokIgCUq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfFQNqd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 09:46:33 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41756 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfFQNqd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 09:46:33 -0400
Received: by mail-ot1-f68.google.com with SMTP id 107so9297166otj.8
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 06:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ce+tt72KlMYxUZ1i2z2wH+84DXkLcAKQeD03A1C11fw=;
        b=eokIgCUqdZ0MQiNqu2Acl9vM45qT/zR3ZI/f1MA+T5NqkCSXs9cYA3K1QhvmLmg0Iw
         rmYxRQ0oA0m4vc/eIcEkHtqP937GdxnRQTKyQ2yVaCp61RqzE5jysA1emKG8T/hZAQLX
         IkEqpQV8OAUZB+UgPaUWkA31+YRSyUltGYBVqc5+wiHfHEBCJ8Wei0RaaqgBdRHSBFye
         /i1oZBkOot9JKdZdDBpjy5fgo06qf0aEwCqgATw8GICqb+cv/v35IX2tVIwwoTFXp4bP
         DjJS6KXgfrLLJ5oY7nOkJaMPSILV49HpOrKqOxCJ21D7gnmymZCUXXwiDh18Vd5T/Xfp
         39vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ce+tt72KlMYxUZ1i2z2wH+84DXkLcAKQeD03A1C11fw=;
        b=LbgYCJ9S1Pqg9qlQZek6yvPW7t3tt56qE0C48Yv63jKP9BQbb3Mzjxv3Octr1LglKX
         GLsftvMPyebTtPpXZxL4OMrUwxKcR8bd/HpKJT5QmuoW3YeTWasYakNvueNu47ej4NLR
         TmpFHpUZbSVT5M7SYt/XaElmuvsCAgt+P3VsBwLMwvtW58amGNiLNgidPqJ15fn62f+G
         KcJcLtfKmzpEGsZ6QceIhaX652mRs3gL4AP/QMl9gdbziAEZKwbWWUDLoiZmS0s61RNe
         46Cr7kY/6kLZpBd1Es0HAVaaLjlanAl7i6XYLwDiO50GlGVmM1XoUFCGy/mYOQGTd/0t
         UKyg==
X-Gm-Message-State: APjAAAWILZ14P7wTUQH6jMyQ48s0BH8p0p9qV8dye0ECVxTFGEb+69g3
        ThkKDc4N0zR+gicmN44/YIodwskykRkuArCn0KwPT7khoaM=
X-Google-Smtp-Source: APXvYqxHFHYEA/KDkv/0RzYSV2/ovn81A1r1qIGWE11ucOyEu7bWspkBtIwh2AQ9sFIEXVFxxmmH6+r/WSwgRrTga10=
X-Received: by 2002:a9d:5911:: with SMTP id t17mr9806176oth.159.1560779192375;
 Mon, 17 Jun 2019 06:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190614143934.10659-1-shekhar250198@gmail.com> <CAGdUbJEN3czWbbnOJgm_xzn0NPHhKVtc1j2htbRCZ0U6MoAxhA@mail.gmail.com>
In-Reply-To: <CAGdUbJEN3czWbbnOJgm_xzn0NPHhKVtc1j2htbRCZ0U6MoAxhA@mail.gmail.com>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Mon, 17 Jun 2019 19:16:21 +0530
Message-ID: <CAN9XX2p+M0OFdW1q3kn9-2S+UjjR6nVPmkzGfASZLtKvwtSEyA@mail.gmail.com>
Subject: Re: [PATCH nft v7 2/2]tests:py: add netns feature
To:     Jones Desougi <jones.desougi+netfilter@gmail.com>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 17, 2019 at 7:00 PM Jones Desougi
<jones.desougi+netfilter@gmail.com> wrote:
>
>
>
> On Fri, Jun 14, 2019 at 4:41 PM Shekhar Sharma <shekhar250198@gmail.com> wrote:
>>
>> This patch adds the netns feature to the 'nft-test.py' file.
>>
>>
>> Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
>> ---
>> The version history of the patch is :
>> v1: add the netns feature
>> v2: use format() method to simplify print statements.
>> v3: updated the shebang
>> v4: resent the same with small changes
>> v5&v6: resent with small changes
>> v7: netns commands changed for passing the netns name via netns argument.
>>
>>  tests/py/nft-test.py | 141 +++++++++++++++++++++++++++++++------------
>>  1 file changed, 102 insertions(+), 39 deletions(-)
>>
>> diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
>> index 09d00dba..6ec27267 100755
>> --- a/tests/py/nft-test.py
>> +++ b/tests/py/nft-test.py
>
> [...]
>>
>> @@ -280,6 +291,9 @@ def chain_create(chain, table, filename):
>>          return -1
>>
>>      cmd = "add chain %s %s" % (table, chain)
>> +    if netns:
>> +        cmd = "ip netns exec " + "{} {}".format(cmd)
>
>
> This looks broken. The netns is missing in the format call.
>
oops!, missed the netns argument. Will correct it.

>>
>> +
>
>
> Here an extra empty line also starts appearing after the new netns conditional.
>
Will remove it.

>>
>>      if chain.config:
>>          cmd += " { %s; }" % chain.config
>>
> [...]
>>
>> @@ -1319,13 +1376,15 @@ def run_test_file(filename, force_all_family_option, specific_file):
>>
>>      if specific_file:
>>          if force_all_family_option:
>> -            print print_result_all(filename, tests, total_warning, total_error,
>> -                                   total_unit_run)
>> +            print(print_result_all(filename, tests, total_warning, total_error,
>> +                                   total_unit_run))
>>          else:
>> -            print print_result(filename, tests, total_warning, total_error)
>> +            print(print_result(filename, tests, total_warning, total_error))
>>      else:
>>          if tests == passed and tests > 0:
>> -            print filename + ": " + Colors.GREEN + "OK" + Colors.ENDC
>> +            print(filename + ": " + Colors.GREEN + "OK" + Colors.ENDC)
>> +        if netns:
>> +            execute_cmd("ip netns del " + netns, filename, 0)
>
>
> Hmm, looks like this is in the else branch of "if specific_file:", should it be?
>
>>
>>
>>      f.close()
>>      del table_list[:]
>
Not sure. It is in the else branch of 'if specific_file', it can be
nested inside the
'if tests==passed....' statement and written after f.close() as well.
Not sure which one
to choose.

> [...]
Thanks!

Shekhar
