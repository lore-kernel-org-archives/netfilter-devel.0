From: Eric Leblond <eric@regit.org>
Subject: Re: [libmnl PATCH] debug: don't colorize output on non tty
Date: Wed, 02 Oct 2013 17:47:20 +0200
Message-ID: <1380728840.24406.29.camel@ice-age.regit.org>
References: <1380577106-13006-1-git-send-email-eric@regit.org>
	 <20131002152512.GA22293@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:47814 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab3JBPrb convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:47:31 -0400
In-Reply-To: <20131002152512.GA22293@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Le mercredi 02 octobre 2013 =E0 17:25 +0200, Pablo Neira Ayuso a =E9cri=
t :
> Hi Eric,
>=20
> On Mon, Sep 30, 2013 at 11:38:26PM +0200, Eric Leblond wrote:
> > When output is not a tty (pipe or redirect to a file), the color
> > display is causing the output to be unreadable:
> >   02 00 00 00  |        |  extra header  |
> >  |ESC[1;31m00008ESC[0m|ESC[1;32m--ESC[0m|ESC[1;34m00001ESC[0m|   |l=
en |flags| type|
> > This patch tests if the output is a terminal and only add color in
> > this case. It also displays space instead of char 0 if a letter is
> > not existing.
>=20
> In both cases, you can use less -r to interpret the colors, is that
> enough to address what you're noticing?

No, I don't think this is enough. First, you've got to know -r option o=
f
less ;) Second, this is really painful if you want to redirect the
output to a file to edit it with a standard editor (that was my case).
At last, git and a lot of software are doing that so some user are used
to that behavior.

> The chunk to replace char 0 by 32 looks fine to me.

OK.

BR,
--=20
Eric Leblond <eric@regit.org>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
