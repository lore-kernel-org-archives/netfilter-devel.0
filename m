From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: nft option to flush out the existing ruleset [was Re: [libnftnl
 PATCH] examples: add nft-ruleset-replace]
Date: Tue, 26 Aug 2014 15:12:57 +0200
Message-ID: <CAOkSjBhHGygRWjY04M-H3JUp8uy5DzOFB7oL219jsHrOQYUsxw@mail.gmail.com>
References: <20140826095716.3463.89684.stgit@nfdev.cica.es>
 <20140826110954.GA5648@salvia> <20140826121420.GA22955@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:43179 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982AbaHZNNT convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:13:19 -0400
Received: by mail-la0-f53.google.com with SMTP id gl10so14679639lab.26
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2014 06:13:17 -0700 (PDT)
In-Reply-To: <20140826121420.GA22955@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26 August 2014 14:14, Patrick McHardy <kaber@trash.net> wrote:
> On Tue, Aug 26, 2014 at 01:09:54PM +0200, Pablo Neira Ayuso wrote:
>> Renaming the subject to make it to start a new discussion on somethi=
ng
>> related. Cc'ing Patrick too, perhaps he can pull some better idea ou=
t
>> of his hat.
>>
>> On Tue, Aug 26, 2014 at 11:57:16AM +0200, Arturo Borrero Gonzalez wr=
ote:
>> > This code examples uses the new NFT_MSG_DELTABLE functionality to =
replace
>> > an entire ruleset in a single transaction/batch.
>>
>> Thanks for the example but we already have quite a lot of them, and
>> this is yet another almost copy and paste that would need to be
>> maintained.
>>
>> Please, implement this in nft. I think we can probably have an -x
>> option, eg.
>
> Agreed. The naive aproach seems to be something like this:
>
> - add a generation ID to the ruleset
> - dump the entire ruleset
> - generate delete commands for each existing rule/chain/set...
> - generate add commands for each new rule/chain/set...
> - send the entire thing to the kernel, including the generation ID
> - if the generation ID doesn't match, meaning the ruleset has changed
>   since the last dump, return an error to userspace, retry

The approach in my patchset is different:

- generate a delete command that will flush all the previous ruleset
- generate add commands for each new rule/chain/set/tables
- send the batch to the kernel

In this approach, we don't care about what is in the kernel previous
to the delete command.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
