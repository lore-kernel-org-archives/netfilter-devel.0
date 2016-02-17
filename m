From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrackd] conntrackd: Disable systemd support by default
Date: Wed, 17 Feb 2016 12:06:02 +0100
Message-ID: <20160217110602.GA2379@salvia>
References: <1455649785-10958-1-git-send-email-pablo@netfilter.org>
 <CAOkSjBgUyOd65kZZqg1JZDS1VbDk7mfixLghvMjdDofDsbHTuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38621 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161137AbcBQLGN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Feb 2016 06:06:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B15B361E8A
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Feb 2016 12:06:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A1433DA38F
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Feb 2016 12:06:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B7E75DA38F
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Feb 2016 12:06:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAOkSjBgUyOd65kZZqg1JZDS1VbDk7mfixLghvMjdDofDsbHTuw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 17, 2016 at 08:50:26AM +0100, Arturo Borrero Gonzalez wrote:
> On 16 February 2016 at 20:09, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > By default, conntrackd is compiled with no built-in systemd support.
> > This patch updates the default runtime behaviour to be consistent
> > with what ./configure provides by default.
> >
> > Thus, users should explicitly indicate "Systemd On" in their configuration
> > file to enable this.
> >
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  conntrackd.conf.5                | 4 ++--
> >  doc/stats/conntrackd.conf        | 4 ++--
> >  doc/sync/alarm/conntrackd.conf   | 4 ++--
> >  doc/sync/ftfw/conntrackd.conf    | 4 ++--
> >  doc/sync/notrack/conntrackd.conf | 4 ++--
> >  src/read_config_yy.y             | 4 ++--
> >  6 files changed, 12 insertions(+), 12 deletions(-)
> >
> [...]
> > diff --git a/src/read_config_yy.y b/src/read_config_yy.y
> > index 58ad2d0..6052390 100644
> > --- a/src/read_config_yy.y
> > +++ b/src/read_config_yy.y
> > @@ -1864,8 +1864,8 @@ init_config(char *filename)
> >         CONFIG(stats).syslog_facility = -1;
> >         CONFIG(netlink).subsys_id = -1;
> >
> > -       /* enable systemd by default */
> > -       CONFIG(systemd) = 1;
> > +       /* disable systemd by default */
> > +       CONFIG(systemd) = 0;
> >
> >         /* Initialize list of user-space helpers */
> >         INIT_LIST_HEAD(&CONFIG(cthelper).list);
> 
> If we change this logic, there are a parser rules that need changes as well.
> 
> [...]
> systemd: T_SYSTEMD T_ON { /* already enabled in init_config() */ };
> systemd: T_SYSTEMD T_OFF
> {
>      conf.systemd = 0;
> };

I'll fix this, we should anyway explicitly set on/off this based on
what the parser sees, ie.

systemd: T_SYSTEMD T_ON { conf.systemd = 1; };
systemd: T_SYSTEMD T_OFF { conf.systemd = 0; };

And remove the default setting to zero, it's not required.

> [...]
> 
> I agree with the patch, so
> 
> Acked-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

Will send a v2 including this. Thanks.
