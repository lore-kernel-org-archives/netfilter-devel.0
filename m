From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/2] src/rule: Removed mandatory attribute
 printing in rules
Date: Wed, 12 Mar 2014 13:50:12 +0100
Message-ID: <20140312125012.GA26001@localhost>
References: <20140309125959.23270.43422.stgit@Ph0enix>
 <CAOkSjBhtRP+aVF8qNcP0uwV4LFRFxnZCS1GCKox1uw7Vfimuew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alvaro Neira Ayuso <alvaroneay@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33354 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbaCLMuU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:50:20 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBhtRP+aVF8qNcP0uwV4LFRFxnZCS1GCKox1uw7Vfimuew@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 09, 2014 at 02:14:23PM +0100, Arturo Borrero Gonzalez wrote=
:
> On 9 March 2014 13:59, Alvaro Neira Ayuso <alvaroneay@gmail.com> wrot=
e:
> > From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
> >
> > Before this patch, the program tried to print some attribute
> > that maybe the user hasn't defined for printing. We can't
> > assume that the user want to print some attribute that we have put
> > mandatory in the rules. Example:
> >
> > Before this patch, it's mandatory have a rule with family
> > and this is the output:
> >
> > {"rule":{"family":"ip","handle":4...
> > <rule><family>ip</family><handle>4</handle>...
> >
> > Now, we can print rule without some attribute:
> >
> > {"rule":{"handle":4...
> > <rule><handle>4</handle>...
> >
> > Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> > ---
>=20
> Hi there!
>=20
> These attributes are no longer mandatory? What is the idea behind thi=
s?

I think we already discussed this time ago.

I'd like that the parsers don't enforce the occurrence of any
attribute, we should just let the kernel bail out if the configuration
that the user provides doesn't make sense.

This provides us more flexibility in case that we change any aspect
from the kernel side.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
