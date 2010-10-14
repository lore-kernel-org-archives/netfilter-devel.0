From: Peter Volkov <pva@gentoo.org>
Subject: Re: [patch] arptables: some patches from debian
Date: Thu, 14 Oct 2010 19:37:32 +0400
Message-ID: <1287070653.28231.11.camel@tablet>
References: <1284558534.22085.164.camel@tablet>
	 <1286630249.3611.514.camel@tablet>  <4CB0BFE5.7070201@pandora.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-1yVX+uQT/MRSDFn+6eAM"
Cc: ebtables-devel@lists.sourceforge.net,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:56214 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218Ab0JNPhm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Oct 2010 11:37:42 -0400
In-Reply-To: <4CB0BFE5.7070201@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-1yVX+uQT/MRSDFn+6eAM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Hi Bart. Thank you for review/applying patches. Could you also apply
attached patch to fix not respecting LDFLAGS issue (very similar to one
I've sent you long time ago for ebtables :) )

--
Peter.

В Сбт, 09/10/2010 в 21:17 +0200, Bart De Schuymer пишет:
> Hello Peter,
> 
> Patch 2 and 3 are committed.
> For the '*' part of patch 1 I'd rather remove the -v usage in 
> arptables-restore. This will require fixing the reason why -v is used in 
> the first place. I wasn't aware this is due to a bug: the -i and -o 
> interfaces aren't printed unless -v is specified. I'll look into this.
> 
> cheers,
> Bart
> 
> On 09-10-10 15:17, Peter Volkov wrote:
> > Hi again. What is the best way to contact arptables developers? My
> > previous patch was left without attention, should I resend it? In
> > attachment there are three fixes from debian:
> >
> > 1. arptables_save patch makes arp_tables don't resolve host names and
> > don't convert '*' interface names to any. Remove '*' interface names.
> > 2. manpage patch removes old version from man page
> > 3. is a patch from Jeroen van Wolffelaar to make arptables --proto-type
> > also accept hexadecimal inputs (ethernet protocol numbers are often
> > specfied in hex, not decimal), using standard strtol() behaviour (hex
> > iff starts with 0x).


--=-1yVX+uQT/MRSDFn+6eAM
Content-Disposition: attachment; filename="arptables-0.0.3.4-ldflags.patch"
Content-Type: text/x-patch; name="arptables-0.0.3.4-ldflags.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

=== modified file 'Makefile'
--- Makefile	2010-09-15 11:51:49 +0000
+++ Makefile	2010-09-15 11:52:56 +0000
@@ -31,7 +31,7 @@
 	$(CC) $(CFLAGS) -c -o $@ $<
 
 arptables: arptables-standalone.o arptables.o libarptc/libarptc.o $(EXT_OBJS)
-	$(CC) $(CFLAGS) -o $@ $^
+	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^
 
 $(DESTDIR)$(MANDIR)/man8/arptables.8: arptables.8
 	mkdir -p $(@D)


--=-1yVX+uQT/MRSDFn+6eAM--

