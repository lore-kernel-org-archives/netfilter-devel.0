From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft] the -nnn switch
Date: Mon, 22 Sep 2014 11:54:57 +0200
Message-ID: <CAOkSjBisG3f4fm3bw2NfX5MyyCR-n8ud_A3zUAhyJJAaXxBA3Q@mail.gmail.com>
References: <CAOkSjBgOpbJmOXEX=a1kPXqDMs673ZTfB_Qg=q4V5L2JTsg77g@mail.gmail.com>
 <20140919112505.GA1158@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:54911 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbaIVJzT convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:55:19 -0400
Received: by mail-lb0-f178.google.com with SMTP id z12so3770680lbi.23
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Sep 2014 02:55:17 -0700 (PDT)
In-Reply-To: <20140919112505.GA1158@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19 September 2014 13:25, Patrick McHardy <kaber@trash.net> wrote:
> On Fri, Sep 19, 2014 at 11:49:02AM +0200, Arturo Borrero Gonzalez wro=
te:
>> Hi,
>>
>> the -nnn switch in in nftables is IMO a bit annoying.
>> We are bounded to use that switch in every serious usage of nft.
>>
>> Let me remember the current behaviour:
>>
>>  -n -> don't translate IP addresses to names.
>>  -nn -> also, don't translate gids/uids to names.
>>  -nnn -> also, don't translate port numbers to names.
>> default -> translate all numbers to names.
>>
>> I propose here that before nftables goes absolutely mainstream we
>> change the behaviour to the opposite:
>>
>> -n -> translate IP addresses to names.
>> -nn -> translate gids/uids to names.
>> -nnn -> translate port numbers to names.
>> default -> show all numerically.
>>
>> What do you think?
>
> That seems quite counter intuitive. I'd say the default should be not
> to cause any network traffic for a regular system (not using LDAP or
> whatever), which would be -n. So I would be fine with -n being the
> default and adding an option to also translate hostnames.

So, your proposal is to make the current '-n' the default? This is
what I've understood:

=C2=B7 default (no -n given): show IP addresses (no DNS names), show GI=
D
names, port names
=C2=B7 -n: show DNS names, show GID names, port names
=C2=B7 -nn: show DNS names, show GID numbers, port names
=C2=B7 -nnn: show DNS names, show GID numbers, port numbers

That seems pretty counter intuitive to me, actually.

Whit that combination of options you can't show all numerically, which
I think it should be the default in fact.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
