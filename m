From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2] src: new error reporting approach for
 XML/JSON parsers
Date: Tue, 7 Jan 2014 00:35:53 +0100
Message-ID: <20140106233553.GA25742@localhost>
References: <20140105235114.3752.26544.stgit@Ph0enix>
 <20140106122344.GA7589@localhost>
 <CAOkSjBgQt_=obGONgOUmOM+yCXJ7bxK3f1-ZYSmP2089DzddmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alvaro Neira <alvaroneay@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44727 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933182AbaAFXf7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 18:35:59 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBgQt_=obGONgOUmOM+yCXJ7bxK3f1-ZYSmP2089DzddmA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 06, 2014 at 11:46:46PM +0100, Arturo Borrero Gonzalez wrote=
:
> On 6 January 2014 13:23, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
> > On Mon, Jan 06, 2014 at 12:51:14AM +0100, Alvaro Neira wrote:
> >> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
> >>
> >> I have added a new structure for reporting some errors in parser
> >> that we can't cover with errno.
> >>
> >> In this patch, we have three errors that we can't cover with errno=
:
> >>
> >> NFT_PARSE_EBADINPUT : Bad XML/JSON format in the input
> >> NFT_PARSE_EMISSINGNODE : Missing node in our input
> >> NFT_PARSE_EBADTYPE : Wrong type value in a node
> >
> > This looks good. Applied, thanks Alvaro.
>=20
> Hi Pablo,
>=20
> I don't see this applied:
>=20
> ~/libnftables$ git pull --rebase
> Current branch master is up to date.
> ~/libnftables$ gldoc
> * b4a0d19 (HEAD, origin/master, origin/HEAD, master) src: rename the
> parameter tag to node_name in jansson function
> * 24e08e5 build: properly handle --without-{xml,json}-parsing
> * 2307124 include: update netlink.h to 3.13
> [...]

=46orgot to push it, here it is:

http://git.netfilter.org/libnftables/commit/?id=3De87d2f9ef8a4a298de551=
4b30ec2d43d3c90a644
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
