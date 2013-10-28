From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH] test: xml: fix malformed ruleset testfile
Date: Mon, 28 Oct 2013 09:28:22 +0100
Message-ID: <CAOkSjBiwg6WOSMGBVr6QHoy3prt4UkeURiPmrWPG74Zfv9eoOw@mail.gmail.com>
References: <20131024150058.21634.49651.stgit@nfdev.cica.es> <20131027200107.GA6569@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:63587 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab3J1I2o convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:28:44 -0400
Received: by mail-lb0-f182.google.com with SMTP id w6so2511296lbh.41
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Oct 2013 01:28:43 -0700 (PDT)
In-Reply-To: <20131027200107.GA6569@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27 October 2013 21:01, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> On Thu, Oct 24, 2013 at 05:00:58PM +0200, Arturo Borrero Gonzalez wro=
te:
>> Give a new XML ruleset testfile. For some reason, the previous was t=
runcated.
>> This passed silently as nft-parsing-test is not reporting some error=
s properly.
>>
>> This new file provides:
>>  * 2 tables
>>  * 3 chains
>>  * 2 sets, with and without maps
>>  * 3 rules with mixed exprs
>
> Applied, thanks Arturo.

something went wrong again. The new testfile is also malformed...

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
