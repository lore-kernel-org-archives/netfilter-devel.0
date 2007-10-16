From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ANNOUNCE] Release of iptables 1.4.0rc1
Date: Tue, 16 Oct 2007 10:44:37 +0200
Message-ID: <471479F5.4000002@trash.net>
References: <47139AD0.8060002@netfilter.org> <slrnfh7f7l.crr.petr.pisar@album.ics.muni.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070905020303040802050201"
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Petr Pisar <petr.pisar@atlas.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34648 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245AbXJPIox (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Oct 2007 04:44:53 -0400
In-Reply-To: <slrnfh7f7l.crr.petr.pisar@album.ics.muni.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------070905020303040802050201
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Please CC netfilter-devel on bugreports.

Petr Pisar wrote:
> On 2007-10-15, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> The netfilter coreteam proudly presents:
>>
>> 	iptables version 1.4.0rc1
>>
> Great to hear it. But it doesn't build ip6tables-{save,restore} as older
> versions either. The problem is that these two makefile targets are in
> *_EXP veriable.
> 
> It is bug or a feature?


I would say its a bug. I've added this patch, please test if it works
for you.



--------------070905020303040802050201
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: ip6tables-restore.c
===================================================================
--- ip6tables-restore.c	(Revision 7068)
+++ ip6tables-restore.c	(Arbeitskopie)
@@ -77,7 +77,11 @@
 
 static int parse_counters(char *string, struct ip6t_counters *ctr)
 {
-	return (sscanf(string, "[%llu:%llu]", (unsigned long long *)&ctr->pcnt, (unsigned long long *)&ctr->bcnt) == 2);
+	u_int64_t *pcnt, *bcnt;
+
+	pcnt = &ctr->pcnt;
+	bcnt = &ctr->bcnt;
+	return (sscanf(string, "[%llu:%llu]", (unsigned long long *)pcnt, (unsigned long long *)bcnt) == 2);
 }
 
 /* global new argv and argc */
Index: Makefile
===================================================================
--- Makefile	(Revision 7068)
+++ Makefile	(Arbeitskopie)
@@ -61,8 +61,8 @@
 ifeq ($(DO_IPV6), 1)
 EXTRAS+=ip6tables ip6tables.o ip6tables.8
 EXTRA_INSTALLS+=$(DESTDIR)$(BINDIR)/ip6tables $(DESTDIR)$(MANDIR)/man8/ip6tables.8
-EXTRAS_EXP+=ip6tables-save ip6tables-restore
-EXTRA_INSTALLS_EXP+=$(DESTDIR)$(BINDIR)/ip6tables-save $(DESTDIR)$(BINDIR)/ip6tables-restore # $(DESTDIR)$(MANDIR)/man8/iptables-restore.8 $(DESTDIR)$(MANDIR)/man8/iptables-save.8 $(DESTDIR)$(MANDIR)/man8/ip6tables-save.8 $(DESTDIR)$(MANDIR)/man8/ip6tables-restore.8
+EXTRAS+=ip6tables-save ip6tables-restore
+EXTRA_INSTALLS+=$(DESTDIR)$(BINDIR)/ip6tables-save $(DESTDIR)$(BINDIR)/ip6tables-restore # $(DESTDIR)$(MANDIR)/man8/iptables-restore.8 $(DESTDIR)$(MANDIR)/man8/iptables-save.8 $(DESTDIR)$(MANDIR)/man8/ip6tables-save.8 $(DESTDIR)$(MANDIR)/man8/ip6tables-restore.8
 endif
 
 ifndef IPT_LIBDIR

--------------070905020303040802050201--
