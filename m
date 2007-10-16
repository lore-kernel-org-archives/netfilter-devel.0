From: Petr Pisar <petr.pisar@atlas.cz>
Subject: Re: [ANNOUNCE] Release of iptables 1.4.0rc1
Date: Tue, 16 Oct 2007 14:30:49 +0000 (UTC)
Message-ID: <slrnfh9ioo.31t.petr.pisar@album.ics.muni.cz>
References: <47139AD0.8060002@netfilter.org> <slrnfh7f7l.crr.petr.pisar@album.ics.muni.cz> <471479F5.4000002@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 2007-10-16, Patrick McHardy <kaber@trash.net> wrote:
> Petr Pisar wrote:
>> On 2007-10-15, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>> The netfilter coreteam proudly presents:
>>>
>>> 	iptables version 1.4.0rc1
>>>
>> Great to hear it. But it doesn't build ip6tables-{save,restore} as older
>> versions either. The problem is that these two makefile targets are in
>> *_EXP veriable.
>> 
>> It is bug or a feature?
>
> I would say its a bug. I've added this patch, please test if it works
> for you.
>
Yes, it works.

Probably you forgot on manual pages:

--- Makefile.old	2007-10-16 16:05:07.000000000 +0200
+++ Makefile	2007-10-16 16:07:37.000000000 +0200
@@ -62,7 +62,7 @@
 EXTRAS+=ip6tables ip6tables.o ip6tables.8
 EXTRA_INSTALLS+=$(DESTDIR)$(BINDIR)/ip6tables $(DESTDIR)$(MANDIR)/man8/ip6tables.8
 EXTRAS+=ip6tables-save ip6tables-restore
-EXTRA_INSTALLS+=$(DESTDIR)$(BINDIR)/ip6tables-save $(DESTDIR)$(BINDIR)/ip6tables-restore # $(DESTDIR)$(MANDIR)/man8/iptables-restore.8 $(DESTDIR)$(MANDIR)/man8/iptables-save.8 $(DESTDIR)$(MANDIR)/man8/ip6tables-save.8 $(DESTDIR)$(MANDIR)/man8/ip6tables-restore.8
+EXTRA_INSTALLS+=$(DESTDIR)$(BINDIR)/ip6tables-save $(DESTDIR)$(BINDIR)/ip6tables-restore $(DESTDIR)$(MANDIR)/man8/ip6tables-save.8 $(DESTDIR)$(MANDIR)/man8/ip6tables-restore.8
 endif
 
 ifndef IPT_LIBDIR

