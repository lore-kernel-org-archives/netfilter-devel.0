From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrackd: Disable runtime systemd support by default
Date: Thu, 18 Feb 2016 14:07:35 +0100
Message-ID: <20160218130735.GA2296@salvia>
References: <1455708361-3143-1-git-send-email-pablo@netfilter.org>
 <CAOkSjBg1cr9tQD_SPhZxN2TBj9z6AfRJB6J5htR3vTdzvaJirg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51993 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620AbcBRNHt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2016 08:07:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C8292FB452
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Feb 2016 14:07:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 54CAF3578
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Feb 2016 14:07:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A5889DA383
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Feb 2016 14:07:41 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAOkSjBg1cr9tQD_SPhZxN2TBj9z6AfRJB6J5htR3vTdzvaJirg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 18, 2016 at 08:54:16AM +0100, Arturo Borrero Gonzalez wrote:
> On 17 February 2016 at 12:26, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > By default, conntrackd is compiled with no built-in systemd support.
> > This patch updates the default runtime behaviour to be consistent
> > with what ./configure provides by default.
> >
> > Thus, users should explicitly indicate "Systemd On" in their configuration
> > file to enable this. This shouldn't cause any problem to old users of
> > conntrackd.
> >
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v2: updates grammar to handle "On" case accordingly.
> >
> >  conntrackd.conf.5                |  4 ++--
> >  doc/stats/conntrackd.conf        |  4 ++--
> >  doc/sync/alarm/conntrackd.conf   |  4 ++--
> >  doc/sync/ftfw/conntrackd.conf    |  4 ++--
> >  doc/sync/notrack/conntrackd.conf |  4 ++--
> >  src/read_config_yy.y             | 10 ++--------
> >  6 files changed, 12 insertions(+), 18 deletions(-)
> >
> [...]
> > diff --git a/src/read_config_yy.y b/src/read_config_yy.y
> > index 58ad2d0..cc0eb18 100644
> > --- a/src/read_config_yy.y
> > +++ b/src/read_config_yy.y
> > @@ -1126,11 +1126,8 @@ general_line: hashsize
> >             | systemd
> >             ;
> >
> > -systemd: T_SYSTEMD T_ON { /* already enabled in init_config() */ };
> > -systemd: T_SYSTEMD T_OFF
> > -{
> > -       conf.systemd = 0;
> > -};
> > +systemd: T_SYSTEMD T_ON                { conf.systemd = 1; };
> > +systemd: T_SYSTEMD T_OFF       { conf.systemd = 0; };
> >
> >  netlink_buffer_size: T_BUFFER_SIZE T_NUMBER
> >  {
> > @@ -1864,9 +1861,6 @@ init_config(char *filename)
> >         CONFIG(stats).syslog_facility = -1;
> >         CONFIG(netlink).subsys_id = -1;
> >
> > -       /* enable systemd by default */
> > -       CONFIG(systemd) = 1;
> > -
> 
> In src/systemd.c we check several times if (CONFIG(systemd) == 0), so
> I think the value should be initialized to something.

This is a global variable allocated in the bss, so we can assume this
is always initialized (zero).
