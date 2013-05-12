From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] ulogd: Implement PID file writing
Date: Sun, 12 May 2013 12:50:04 +0200
Message-ID: <20130512105004.GA13219@localhost>
References: <1368291713-40132-1-git-send-email-bootc@bootc.net>
 <1368291713-40132-3-git-send-email-bootc@bootc.net>
 <20130511192150.GA10646@localhost>
 <518EA9B3.8050606@bootc.net>
 <20130512004852.GA11205@localhost>
 <518F4EC7.1050403@bootc.net>
 <20130512093405.GA12095@localhost>
 <518F6306.2090007@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: Chris Boot <bootc@bootc.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51051 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab3ELKuM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 May 2013 06:50:12 -0400
Content-Disposition: inline
In-Reply-To: <518F6306.2090007@bootc.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 12, 2013 at 10:38:14AM +0100, Chris Boot wrote:
> On 12/05/2013 10:34, Pablo Neira Ayuso wrote:
> > Hi Chris,
> >
> > On Sun, May 12, 2013 at 09:11:51AM +0100, Chris Boot wrote:
> >> On 12/05/2013 01:48, Pablo Neira Ayuso wrote:
> >>> On Sat, May 11, 2013 at 09:27:31PM +0100, Chris Boot wrote:
> >>> [...]
> >>>> Hi Pablo,
> >>>>
> >>>> I'd argue exactly the opposite point: that when you want multiple
> >>>> instances a PID file can help you work out which is which.
> >>> That new option may break existing setups with multiple instances.
> >> My patch explicitly doesn't change the behaviour of existing
> >> configurations. If you don't pass '--pidfile /path/to/file.pid', no pid
> >> file is written and there is no change in how ulogd works.
> > Existing setups having already two ulogd2 instances will break, as
> > they won't be passing --pidfile, thus clashing on the same default pid
> > file. One of the instances will not proceed. They will have to add
> > --pidfile to their scripts to get things back working.
> 
> There is no default pidfile. No --pidfile option: no pidfile is created.
> No change in behaviour.
> 
> You only get the new behaviour if you explicitly add --pidfile to the
> arguments.

You're right, I overlooked that.

> > But anyway, I suggest that that the standalone debian installation
> > sticks to one single instance at the same time, that's just fine for
> > most people.
> 
> The init script is indeed sticking to just one instance as-shipped.

Assuming that, you'll have one single instance and pidof would be just
fine. But I leave final decision to Eric.
