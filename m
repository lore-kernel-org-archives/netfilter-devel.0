From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libmnl PATCH] debug: don't colorize output on non tty
Date: Fri, 11 Oct 2013 10:53:38 +0200
Message-ID: <20131011085338.GA4103@localhost>
References: <1380577106-13006-1-git-send-email-eric@regit.org>
 <20131002152512.GA22293@localhost>
 <1380728840.24406.29.camel@ice-age.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48816 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab3JKIxo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:53:44 -0400
Content-Disposition: inline
In-Reply-To: <1380728840.24406.29.camel@ice-age.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

On Wed, Oct 02, 2013 at 05:47:20PM +0200, Eric Leblond wrote:
> Hi Pablo,
>=20
> Le mercredi 02 octobre 2013 =E0 17:25 +0200, Pablo Neira Ayuso a =E9c=
rit :
> > Hi Eric,
> >=20
> > On Mon, Sep 30, 2013 at 11:38:26PM +0200, Eric Leblond wrote:
> > > When output is not a tty (pipe or redirect to a file), the color
> > > display is causing the output to be unreadable:
> > >   02 00 00 00  |        |  extra header  |
> > >  |ESC[1;31m00008ESC[0m|ESC[1;32m--ESC[0m|ESC[1;34m00001ESC[0m|   =
|len |flags| type|
> > > This patch tests if the output is a terminal and only add color i=
n
> > > this case. It also displays space instead of char 0 if a letter i=
s
> > > not existing.
> >=20
> > In both cases, you can use less -r to interpret the colors, is that
> > enough to address what you're noticing?
>=20
> No, I don't think this is enough. First, you've got to know -r option=
 of
> less ;) Second, this is really painful if you want to redirect the
> output to a file to edit it with a standard editor (that was my case)=
=2E
> At last, git and a lot of software are doing that so some user are us=
ed
> to that behavior.

I can see that git allows you to enable/disable colors on demand. I
think we can have a new interface that includes a flags field for
this, so we can achieve the same way of working.

I'd like to keep some way to request colors, I usually redirect the
output to files and use less -r to watch them. Some days, when you
spent more than 8 hours in front of the computer, some colors help,
really :-).
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
