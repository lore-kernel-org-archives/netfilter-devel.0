From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf_tables] suggestion: system-wide sets
Date: Thu, 27 Feb 2014 15:46:12 +0100
Message-ID: <CAOkSjBgUNb_4ruqd4m7sdv2aQXDAtds+dgogLXvzSNEeHdCyQw@mail.gmail.com>
References: <CAOkSjBjSzf3tmdBPtXtrrcPe1xXh5S4pp4znE2ek1dEr4LzKCQ@mail.gmail.com>
 <20140227140230.GA18385@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:54620 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaB0Oqd convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:46:33 -0500
Received: by mail-lb0-f171.google.com with SMTP id w7so1726491lbi.2
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2014 06:46:32 -0800 (PST)
In-Reply-To: <20140227140230.GA18385@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27 February 2014 15:02, Patrick McHardy <kaber@trash.net> wrote:
> On Thu, Feb 27, 2014 at 01:15:36PM +0100, Arturo Borrero Gonzalez wro=
te:
>> Hi there!
>>
>> I can't remember this subject being discussed in the near past.
>>
>> Why not using system-wide sets? Or at least, family-wide sets?
>>
>> >From the user point of view, I think is very interesting to define
>> sets that can be used in rules all across the ruleset, same set in
>> different tables and families.
>
> Yeah, I agree. I think family wide sets and global (AF_UNSPEC) sets s=
hould
> bet quite easy to add. However there's the question how to expose the=
m
> in the nft list table output. The idea is to be able to recreate the
> current ruleset, including sets and elements, by parsing the output o=
f
> nft list table. If we don't include sets, the user will have to seper=
ately
> save and restore them. OTOH if we simply include global and AF-specif=
ic
> sets, they will be restored once for each table and this will fail on
> the second table.
>
> Any other ideas?

idea 1:

print global sets when listing every time a table is listed.

To backup the ruleset, the user must iterate over the list of
tables/AF (nft list table $AF $TABLE), so the global sets get printed
several times.

when restoring, try to add the global set to the kernel.
If the set already exist, return EEXIST from the kernel, and let nft
ignore that if operating with 'nft -f'.

idea 2:

add `nft list ruleset', which prints all tables in all AF, including
global sets.
Global sets are only printed in this 'ruleset' view.

Still, the ignore EEXIST errors from the kernel for globals sets.

>
>> Being family-wide is what ipset does, and I'm sure is what most peop=
le
>> will expect.
>>
>> On the other hand, I understand this would be a major change at this=
 point.
>
> Should be fine. I'm thinking of keeping the table specific sets and a=
lso
> having per AF and AF_UNSPEC sets. For maps we should restrict this fe=
ature
> to data maps since verdicts may need a table context.

I agree.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
