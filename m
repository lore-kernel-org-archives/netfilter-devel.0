From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [RFC PATCH v2 6/6] src: add events reporting
Date: Wed, 26 Feb 2014 18:36:18 +0100
Message-ID: <CAOkSjBgy01=uMzxqGpGS7Ha0qcUcr9GHPHZaR8uDb9zaecT_PA@mail.gmail.com>
References: <20140226160918.18974.64532.stgit@nfdev.cica.es>
 <20140226161015.18974.17832.stgit@nfdev.cica.es> <CAOkSjBjFNzeHWaN5gaAeifH2rAqBbUrTJBvzNiLqE7bP4H4R4g@mail.gmail.com>
 <20140226172714.GA23009@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:44300 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbaBZRgj convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:36:39 -0500
Received: by mail-la0-f41.google.com with SMTP id gl10so887267lab.28
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2014 09:36:38 -0800 (PST)
In-Reply-To: <20140226172714.GA23009@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26 February 2014 18:27, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
> On Wed, Feb 26, 2014 at 06:17:36PM +0100, Arturo Borrero Gonzalez wro=
te:
>> On 26 February 2014 17:10, Arturo Borrero Gonzalez
>> <arturo.borrero.glez@gmail.com> wrote:
>> >
>> > +
>> > +       /* XXXX */
>> > +       sleep(1);
>> > +
>> > +       /* only way, by now, to know set_elems (no set_elem events=
) */
>> > +       if (netlink_get_setelems(&set_tmpctx, &s->handle, monh->lo=
c, s) < 0)
>> > +               goto out;
>> > +
>>
>> About this:
>>
>> it seems that I can't query the kernel just after the set is created=
,
>> because I get an empty set.
>
> I see. Since sets are first created then elements are added, I think
> you have to make a kernel patch to add set element events.

Ok,

I am working on that already, the patch is half done.

So this monitor stuff goes to my tasks queue.

regards.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
