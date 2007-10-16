From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [ANNOUNCE] Release of iptables 1.4.0rc1
Date: Tue, 16 Oct 2007 17:01:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710161659080.10197@fbirervta.pbzchgretzou.qr>
References: <47139AD0.8060002@netfilter.org> <slrnfh7f7l.crr.petr.pisar@album.ics.muni.cz>
 <471479F5.4000002@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Petr Pisar <petr.pisar@atlas.cz>, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50722 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758851AbXJPPBf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:01:35 -0400
In-Reply-To: <471479F5.4000002@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 16 2007 10:44, Patrick McHardy wrote:
> Please CC netfilter-devel on bugreports.
>
> Petr Pisar wrote:
>> On 2007-10-15, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > The netfilter coreteam proudly presents:
>> >
>> >  iptables version 1.4.0rc1
>> >
>> Great to hear it. But it doesn't build ip6tables-{save,restore} as older
>> versions either. The problem is that these two makefile targets are in
>> *_EXP veriable.
>> 
>> It is bug or a feature?
>
>
> I would say its a bug. I've added this patch, please test if it works
> for you.
>

>Index: ip6tables-restore.c
>===================================================================
>--- ip6tables-restore.c	(Revision 7068)
>+++ ip6tables-restore.c	(Arbeitskopie)
>@@ -77,7 +77,11 @@
> 
> static int parse_counters(char *string, struct ip6t_counters *ctr)
> {
>-	return (sscanf(string, "[%llu:%llu]", (unsigned long long *)&ctr->pcnt, (unsigned long long *)&ctr->bcnt) == 2);
>+	u_int64_t *pcnt, *bcnt;
>+
>+	pcnt = &ctr->pcnt;
>+	bcnt = &ctr->bcnt;
>+	return (sscanf(string, "[%llu:%llu]", (unsigned long long *)pcnt, (unsigned long long *)bcnt) == 2);
> }

This is also wrong (even though it may work in practice), since unsigned long
long does not necessarily need to be 64 bit (it may be larger, and if so,
you'll smash the stack).
What you want is:

static int parse_counters(const char *string, struct ip6t_counter *ctr)
{
	unsigned long long pcnt, bcnt;
	int ret;

	ret = sscanf(string, "[%llu:%llu]", &pcnt, &bcnt);
	ctr->pcnt = pcnt;
	ctr->bcnt = bcnt;
	return ret;
}

> 
> /* global new argv and argc */
>Index: Makefile
>===================================================================
>--- Makefile	(Revision 7068)
>+++ Makefile	(Arbeitskopie)
>@@ -61,8 +61,8 @@
> ifeq ($(DO_IPV6), 1)
> EXTRAS+=ip6tables ip6tables.o ip6tables.8
> EXTRA_INSTALLS+=$(DESTDIR)$(BINDIR)/ip6tables $(DESTDIR)$(MANDIR)/man8/ip6tables.8
>-EXTRAS_EXP+=ip6tables-save ip6tables-restore
>-EXTRA_INSTALLS_EXP+=$(DESTDIR)$(BINDIR)/ip6tables-save $(DESTDIR)$(BINDIR)/ip6tables-restore # $(DESTDIR)$(MANDIR)/man8/iptables-restore.8 $(DESTDIR)$(MANDIR)/man8/iptables-save.8 $(DESTDIR)$(MANDIR)/man8/ip6tables-save.8 $(DESTDIR)$(MANDIR)/man8/ip6tables-restore.8
>+EXTRAS+=ip6tables-save ip6tables-restore
>+EXTRA_INSTALLS+=$(DESTDIR)$(BINDIR)/ip6tables-save $(DESTDIR)$(BINDIR)/ip6tables-restore # $(DESTDIR)$(MANDIR)/man8/iptables-restore.8 $(DESTDIR)$(MANDIR)/man8/iptables-save.8 $(DESTDIR)$(MANDIR)/man8/ip6tables-save.8 $(DESTDIR)$(MANDIR)/man8/ip6tables-restore.8
> endif
> 
> ifndef IPT_LIBDIR
>
