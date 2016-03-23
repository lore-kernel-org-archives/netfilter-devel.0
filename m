From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH] tests/shell: add chain validations tests
Date: Wed, 23 Mar 2016 09:02:32 +0100
Message-ID: <CAOkSjBiKBH1bw0jBn2d5kRSmwJe_9DiHBGYCz46J+nDicqKsMQ@mail.gmail.com>
References: <145865193086.6118.9200431804176858644.stgit@nfdev2.cica.es> <56F1DEA2.70409@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: mart.frauenlob@chello.at
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:34700 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbcCWICx convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Mar 2016 04:02:53 -0400
Received: by mail-wm0-f45.google.com with SMTP id p65so222303087wmp.1
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2016 01:02:52 -0700 (PDT)
In-Reply-To: <56F1DEA2.70409@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23 March 2016 at 01:09, Mart Frauenlob <mart.frauenlob@chello.at> wr=
ote:
>
> I've not looked up the code calling this, but:
> First: bash only?
> Second: It's not granted to be in /bin.
> Third: May not be the wanted version.
>
> So a shebang like:
> #!/usr/bin/env bash
> or
> #!/urs/bin/env sh
> should be more compatible and fail proof.
>
>> +
>> +set -e
>> +
>> +MAX_JUMPS=3D16
>> +
>> +$NFT add table t
>
> Unquoted variable, may fail if, unlikely but possible, the name conta=
ins
> i.e. spaces.
>
>> +
>> +for i in $(seq 1 $MAX_JUMPS)
>> +do
>> +       $NFT add chain t c${i}
>> +done
>
> Requires `seq' binary.
> I think for ((i=3D1; i<=3D$MAX_JUMPS; i++)) is more portable.
>
>> +
>> +for i in $(seq 1 $((MAX_JUMPS - 1)))
>> +do
>> +       $NFT add rule t c${i} jump c$((i + 1))
>> +done
>
>
> Why not add functions? i.e.
>

Hi Mart,

yes, bash only :-) I think it's a very good shell. I'm not using any
bash operand which depends on the version... I don't expect anybody to
run this testsuite in bash v1 (20 years old already).

I didn't really care about portability... this is an internal script
to perform internal tests, this is going to be run in very few
systems.

Also, no functions, because I want the nft commands to be really
really clear, so debugging is easier.

Is this testsuite failing for you? Have you run it?

I would really like to review patches to incrementally improve the
testsuite, which has been deliberately simplified to focus on what
matter for us: testing nftables :-)

thanks, best regards.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
