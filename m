From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 09/11] db: add ring buffer for DB query
Date: Tue, 21 May 2013 15:38:02 +0200
Message-ID: <20130521133802.GA5160@localhost>
References: <1368168538-29780-1-git-send-email-eric@regit.org>
 <1368168538-29780-10-git-send-email-eric@regit.org>
 <20130511192922.GA10791@localhost>
 <1368354569.22387.48.camel@ice-age.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45493 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab3EUNiM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 May 2013 09:38:12 -0400
Content-Disposition: inline
In-Reply-To: <1368354569.22387.48.camel@ice-age.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

On Sun, May 12, 2013 at 12:29:29PM +0200, Eric Leblond wrote:
> Le samedi 11 mai 2013 =E0 21:29 +0200, Pablo Neira Ayuso a =E9crit :
> > On Fri, May 10, 2013 at 08:48:56AM +0200, Eric Leblond wrote:
> > > This patch adds an optional ring buffer option which modify
> > > the way database queries are made. The main thread is only handli=
ng
> > > kernel message reading and query formatting. The SQL request is m=
ade
> > > in a separate dedicated thread.
> > > The idea is to try to avoid buffer overrun by minimizing the time
> > > requested to treat kernel message. Doing synchronous SQL request,=
 as
> > > it was made before was causing a delay which could cause some mes=
sages
> > > to be lost in case of burst from kernel side.
> >=20
> > Would be feasible to make asynchronous SQL requests instead, so you
> > can skip the use of pthread?
[...]
> From a lazy point of view, this would require to update all the datab=
ase
> backends instead of simply updating the db abstraction layer as it is
> done with the proposed patch.

=46air enough, it provides a generic way to support this and the main
thread should be really taking care of netlink messages coming from
the kernel to avoid the overrun.

If the target is to overcome small bursts, this should help to relief
those peaks for some time, but at some point the intermediate queue
(the ring) will also get full if the situation lasts long.

Regards.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
