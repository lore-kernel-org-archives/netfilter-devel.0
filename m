From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrackd PATCH 2/2 v2] conntrackd: add systemd support
Date: Wed, 11 Nov 2015 16:59:33 +0100
Message-ID: <20151111155933.GA20284@salvia>
References: <144619584355.30622.12279676149815885959.stgit@r2d2.cica.es>
 <20151106135318.GA7657@salvia>
 <CAOkSjBh92vvnW2UV=6E3V8ha1+wRi0+eLuPcoyPQku1K0SCakw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58659 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbbKKP7h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2015 10:59:37 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 31DB0153AB3
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 16:59:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 221F636D65
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 16:59:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3CE4A5DE
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 16:59:34 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAOkSjBh92vvnW2UV=6E3V8ha1+wRi0+eLuPcoyPQku1K0SCakw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 06, 2015 at 04:59:22PM +0100, Arturo Borrero Gonzalez wrote=
:
> On 6 November 2015 at 14:53, Pablo Neira Ayuso <pablo@netfilter.org> =
wrote:
> >> +void sd_ct_watchdog_init(void)
> >> +{
> >> +     /* ignoring systemd API erros: only care if admin expects wa=
tchdog */
> >
> > Not sure what you mean with this comment.
>=20
> The API call may returns:
>  * negative errno-style error code
>  * 0 if watchdog is not expected by systemd for this daemon
>  * >0 if watchdog is expected by systemd for this daemon
>=20
> My patch ignores the 2 first options, we only continue executing this
> function if watchdog is expected by systemd (i.e, the admin configure=
d
> it).

I think it is a good idea to report that no systemd watchdog is going
on through log messages.

> I ignored errors because I would not like to exit conntrackd if there
> is some issue in the systemd side, just ignore it.
>=20
> >
> >> +     if (sd_watchdog_enabled(0, &sd_watchdog_interval) < 1)
> >
> > So sd_watchdog_enabled is setting sd_watchdog_interval?
> >
> > What is the value that sd_watchdog_interval is being set?
> >
>=20
> Yes, only if sd_watchdog_enabled returned >0.
>=20
> From the man page:
>=20
> ""
> int sd_watchdog_enabled(int unset_environment, uint64_t *usec);
> [...]
> If the usec parameter is non-NULL, sd_watchdog_enabled() will write
> the timeout in =B5s for the watchdog logic to it.
> ""

I guess this is configured from systemd, what is the default?

On top of this, I wonder if we should have a configuration option from
our configuration file, something that allows us to do "Systemd Off".
I would suggest default in "Systemd On" if not specified, given that
main distros decided to follow this path.

After this patch, we can only enable/disable systemd integration at
configuration/compilation stage, however I expect most users will be
using packages from distros. I think it would be good to provide them
a runtime way to disable this if they don't want any interference with
their existing infrastructure.

Does this sound reasonable to you? Other than that above, this patch
looks good to me.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
