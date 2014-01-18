From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH] data_reg: fix verdict format approach
Date: Sat, 18 Jan 2014 22:06:41 +0100
Message-ID: <CAOkSjBjGX1AgBNT4AL7zP-J2ZMO8Vkk_EcQNLQZgiOC0MMLEEg@mail.gmail.com>
References: <20140118163944.23453.46552.stgit@nfdev.cica.es> <20140118205321.GB4840@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:59474 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaARVHD convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Jan 2014 16:07:03 -0500
Received: by mail-lb0-f172.google.com with SMTP id c11so3955457lbj.3
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2014 13:07:01 -0800 (PST)
In-Reply-To: <20140118205321.GB4840@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18 January 2014 21:53, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> On Sat, Jan 18, 2014 at 05:39:44PM +0100, Arturo Borrero Gonzalez wro=
te:
>> Patrick reports that the XML/JSON formats of the data_reg object
>> are not accuarate.
>>
>> This patch updates these formats, so they are now as follow:
>>
>>  * <data_reg type=3Dvalue> with raw data (this doesn't change).
>>  * <data_reg type=3Dverdict> with a concrete verdict (eg drop accept=
) and an
>>   optional <chain>, with destination.
>
> Applied.
>

I included an unrelated change! :(

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index b2ad62e..df981ad 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -121,6 +121,7 @@ failparsing:
fclose(fp);
printf("parsing %s: ", filename);
printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
+ nft_parse_perror("fail", err);
return -1;
}

i'm very sorry. What should I do?

>> In XML:
>>       <data_reg type=3D"verdict">
>                   ^------------^
>
> I think we decided time ago that we prefer elements instead of
> attributes. I would take a patch for that conversion.

I think this particular case is more like in expressions.
We need a 'type' attribute, so we can know which nodes to expect
inside <data_reg>.

I think the absence of this 'type' attribute may harden the parsing,
validating and error reporting. Don't you?
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
