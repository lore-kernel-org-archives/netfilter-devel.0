From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] ulogd: Implement PID file writing
Date: Sun, 12 May 2013 12:49:57 +0200
Message-ID: <20130512104957.GA13242@localhost>
References: <1368291713-40132-1-git-send-email-bootc@bootc.net>
 <1368291713-40132-3-git-send-email-bootc@bootc.net>
 <20130511192150.GA10646@localhost>
 <518EA9B3.8050606@bootc.net>
 <20130512004852.GA11205@localhost>
 <518F4EC7.1050403@bootc.net>
 <20130512093405.GA12095@localhost>
 <1368352062.22387.15.camel@ice-age.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Chris Boot <bootc@bootc.net>, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51041 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab3ELKuH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 May 2013 06:50:07 -0400
Content-Disposition: inline
In-Reply-To: <1368352062.22387.15.camel@ice-age.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

On Sun, May 12, 2013 at 11:47:42AM +0200, Eric Leblond wrote:
> Hi,
>=20
> Le dimanche 12 mai 2013 =E0 11:34 +0200, Pablo Neira Ayuso a =E9crit =
:
> > Hi Chris,
> >=20
> > On Sun, May 12, 2013 at 09:11:51AM +0100, Chris Boot wrote:
> > > On 12/05/2013 01:48, Pablo Neira Ayuso wrote:
> > > > On Sat, May 11, 2013 at 09:27:31PM +0100, Chris Boot wrote:
> > > > [...]
> > > >> Hi Pablo,
> > > >>
> > > >> I'd argue exactly the opposite point: that when you want multi=
ple
> > > >> instances a PID file can help you work out which is which.
> > > > That new option may break existing setups with multiple instanc=
es.
> > >=20
> > > My patch explicitly doesn't change the behaviour of existing
> > > configurations. If you don't pass '--pidfile /path/to/file.pid', =
no pid
> > > file is written and there is no change in how ulogd works.
> >=20
> > Existing setups having already two ulogd2 instances will break, as
> > they won't be passing --pidfile, thus clashing on the same default =
pid
> > file. One of the instances will not proceed. They will have to add
> > --pidfile to their scripts to get things back working.
>=20
> If I read the patch correctly, the pidfile is not created if the opti=
on
> is not given:
>=20
> In main we have:
>=20
> +       if (write_pidfile() < 0)
> +               warn_and_exit(daemonize);
>=20
> and in the write_pidfile() function we have:
>=20
> +static int write_pidfile()
> +{
> +       int pid_fp;
> +       char pidtext[16];
> +       int len;
> +
> +       if (!ulogd_pidfile)
> +               return 0;
>=20
> So, the default behavior is not changed.
>=20
> If the default behavior is not changed, I see no problem in adding th=
e
> pidfile feature. And if it can help to get ulogd into distributions, =
I'm
> in favor of it ;)

I checking my /etc/init.d/ directory in my debian installation and
many other daemon use pidof.

Sorry, I still don't get why we need this extra code for something
that really belongs to the scope of ulogd's shell script.

Regards.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
