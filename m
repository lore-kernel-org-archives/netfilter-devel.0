From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH] set: add helper to get the first set_elem
Date: Tue, 15 Apr 2014 10:44:09 +0200
Message-ID: <CAOkSjBgjzx0H4GOcekrXEip7Mqab=cTkMzvdUmRiKLWh=J5qUw@mail.gmail.com>
References: <20140415075842.18544.32525.stgit@nfdev.cica.es>
 <20140415080432.GA15759@macbook.localnet> <20140415081124.GA3675@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:43684 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaDOIob convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:44:31 -0400
Received: by mail-lb0-f169.google.com with SMTP id q8so6746998lbi.0
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2014 01:44:29 -0700 (PDT)
In-Reply-To: <20140415081124.GA3675@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15 April 2014 10:11, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Apr 15, 2014 at 10:04:32AM +0200, Patrick McHardy wrote:
>> On Tue, Apr 15, 2014 at 09:58:42AM +0200, Arturo Borrero Gonzalez wr=
ote:
>> > Add a helper that returns a pointer to the first set_elem in a giv=
en set.
>> >
>> > This function is useful in situations where you know the set only =
have one
>> > element (ie, event reporting from the kernel).
>>
>> That doesn't seem right to me. As I said in my review of the notific=
ation
>> patch, userspace *must* be prepared for multiple elements being repo=
rted
>> at once since it is very likely that we will change the kernel side =
in
>> the future for efficiency reasons.
>
> I see. Arturo, you have to consider that the set may have more than
> one element in the event from userspace, even if currently we only
> have one single element. So use the set iterator to print all the
> elements in the set instead.

ok!

regards.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
