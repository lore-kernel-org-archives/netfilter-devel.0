From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH 2/3] table: json: fix json style
Date: Mon, 30 Sep 2013 23:55:25 +0200
Message-ID: <CAOkSjBgtDpNAJ0zHbpJ417+rdnse0gstAHqgEQqiNo9BSRv+Jw@mail.gmail.com>
References: <20130930150551.32124.23680.stgit@nfdev.cica.es>
 <20130930150557.32124.88117.stgit@nfdev.cica.es> <20130930110644.07aa64c1@nehalam.linuxnetplumber.net>
 <20130930183401.GA972@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephen Hemminger <stephen@networkplumber.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Alvaro Neira Ayuso <alvaroneay@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:62758 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab3I3Vzr convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 17:55:47 -0400
Received: by mail-lb0-f180.google.com with SMTP id q8so4959408lbi.25
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2013 14:55:45 -0700 (PDT)
In-Reply-To: <20130930183401.GA972@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30 September 2013 20:34, Pablo Neira Ayuso <pablo@netfilter.org> wro=
te:
> On Mon, Sep 30, 2013 at 11:06:44AM -0700, Stephen Hemminger wrote:
>> On Mon, 30 Sep 2013 17:05:57 +0200
>> Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
>>
>> > Be consistent in JSON style.
>> >
>> > Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.=
com>
>>
>> All the effort to format and add whitespace in JSON is not that impo=
rtant
>> since it is intended to be parsed by something, and parsers ignore i=
t.
>> Many applications just use as little whitespace as possible to reduc=
e size
>> of output!
>
> Thanks Stephen, we'll stick to using as little whitespace as possible=
=2E
>
> Moreover, there are tools and functions (included in libjansson) to
> make this human friendly, in case anyone needs it.

I also don't care so much about the format, actually (white spaces or
not..). I just tried to give some consistency.

{ \"rule\":
{ \"chain\":
{ \"set\":
{\"table\" :

I did not notice other inconsistencies in order to make a patch fixing
all of them. Maybe Alvaro knows others.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
