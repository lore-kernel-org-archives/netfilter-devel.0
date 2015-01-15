From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [ebtables-compat PATCH] ebtables-compat: fix ACCEPT printing by
 simplifying logic
Date: Thu, 15 Jan 2015 13:44:16 +0100
Message-ID: <CAOkSjBiG0KPZRfJuw2skqDuL8u6nEi8uyQmmSNbdZd4A7UEv0Q@mail.gmail.com>
References: <20150113173610.3965.9202.stgit@nfdev.cica.es> <20150115123225.GA8323@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:35349 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbbAOMoi convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:44:38 -0500
Received: by mail-la0-f43.google.com with SMTP id s18so13364678lam.2
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jan 2015 04:44:37 -0800 (PST)
In-Reply-To: <20150115123225.GA8323@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15 January 2015 at 13:32, Pablo Neira Ayuso <pablo@netfilter.org> wr=
ote:
> On Tue, Jan 13, 2015 at 06:36:10PM +0100, Arturo Borrero Gonzalez wro=
te:
>> The commit bc543af ("ebtables-compat: fix segfault in rules w/o targ=
et")
>> doesn't handle all possible cases of target printing, and ACCEPT is =
left
>> behind.
>>
>> BTW, the logic of target (-j XXX) printing is a bit weird. This patc=
h
>> simplifies it.
>>
>> I assume:
>>  * cs->jumpto is only filled by nft_immediate.
>>  * cs->target is only filled by nft_target.
>>
>> So we end with these cases:
>>  * nft_immediate contains a 'standard' target (ACCEPT, DROP, CONTINU=
E, RETURN, chain)
>>   Then cs->jumpto contains the target already. We have the rule.
>>  * No standard target. If nft_target contains a target, try to load =
it.
>>  * Neither nft_target nor nft_immediate exist. Then, assume CONTINUE=
=2E
>>
>> The printing path is then straight forward: either cs.jumpto or cs.t=
arget
>> contains the target.
>>
>> As there isn't support for target extensions yet, there is no way to=
 test the
>> nft_target (cs.target) path.
>
> Not telling this is wrong, but I guess the resulting code to print th=
e
> target has to converge to what we have in iptables-compat (see
> iptables/nft-ipv4.c). I mean, the handling should look similar. Could
> you revisit that and make sure that this and the existing code
> converge to the point? Thanks.

I could try to factorize code to a common function, something like:
void nft_shared_rule_translate_target(char **jumpto, struct
xtables_target **target)
void nft_shared_print_target(const char *jumpto, const struct
xtables_target *target)

Do you like the idea?
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
