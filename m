From: jamal <hadi@cyberus.ca>
Subject: Re: [PATCH] libxtables: Introduce xtables_set_revision() and make
	iptables and ip6tables use it
Date: Wed, 11 Feb 2009 12:24:24 -0500
Message-ID: <1234373064.20903.121.camel@dogo.mojatatu.com>
References: <1234301869.20903.82.camel@dogo.mojatatu.com>
	 <alpine.LSU.2.00.0902111624380.20223@fbirervta.pbzchgretzou.qr>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:38172 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZBKR0W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:26:22 -0500
Received: by ewy14 with SMTP id 14so255793ewy.13
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2009 09:26:19 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.0902111624380.20223@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2009-02-11 at 16:26 +0100, Jan Engelhardt wrote:
> On Tuesday 2009-02-10 22:37, jamal wrote:
> >
> >As i mentioned to Jan I would like to unify that into
> >a simple call:
> >
> >-----------
> >        xtables_init_all(&tcxt_globals);
> >----------
> >
> >Then I will be more confident that we we will have peace going
> >forward. Please let me know if this is acceptable and i will
> >prepare a patch.
> 
> Ok.

Ok, goody - I actually had almost finished it; have some cycles.
I will post shortly.

> 
> >+extern void xtables_free_opts(int reset_offset);
> >+extern void xtables_set_revision(char *name, u_int8_t revision);
> 
> You need const char * to avoid warnings.

Ok. 

> >diff --git a/xtables.c b/xtables.c
> >index 805b940..48b4104 100644
> >--- a/xtables.c
> >+++ b/xtables.c
> >@@ -99,6 +99,8 @@ void xtables_free_opts(int reset_offset)
> > 	}
> > }
> > 
> >+void xtables_set_revision_ipv4(char *name, u_int8_t revision);
> >+void xtables_set_revision_ipv6(char *name, u_int8_t revision);
> > 
> > struct option *
> > xtables_merge_options(struct option *oldopts, const struct option *newopts,
> 
> Why are these prototypes here? (You can make the functions static
> and reorder to leave them out.)
> 

True.

> Since IPT_FUNCTION_MAXNAMELEN is the same as IP6T_FUNCTION_MAXNAMELEN,
> these functions can be consolidated.
> 

Shouldve checked that.
Ok, since this patch hasnt been merged; i will resend it and i dont
see the need for a callback in xtables_globals

Thanks for all the feedback Jan.

cheers,
jamal


