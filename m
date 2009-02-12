From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: Netfilter API and libiptc
Date: Thu, 12 Feb 2009 11:42:08 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0902121125190.22398@ask.diku.dk>
References: <20090205141722.GB21417@qubit> <4990636B.9080900@trash.net>
 <20090209183941.GA1050@zenon.in.qult.net> <Pine.LNX.4.64.0902111408210.4822@ask.diku.dk>
 <4992E2B3.3030009@trash.net> <alpine.LSU.2.00.0902111656400.22845@fbirervta.pbzchgretzou.qr>
 <4993AFF9.9010002@trash.net> <alpine.LSU.2.00.0902120640480.32504@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0902121014550.22322@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Patrick McHardy <kaber@trash.net>, Ignacy Gawedzki <i@lri.fr>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>,
	hawk@comx.dk
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:35833 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759043AbZBLKmO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:42:14 -0500
In-Reply-To: <Pine.LNX.4.64.0902121014550.22322@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 12 Feb 2009, Jesper Dangaard Brouer wrote:

> On Thu, 12 Feb 2009, Jan Engelhardt wrote:
>
>>  If Jesper then wants to play with the API, no problem, just
>>  don't forget bumping the so_version correctly.
>
> I'll try it out today... lets see how intrusive it is...

That was almost too easy...

Although, Jan has priviously introduced some libiptc API changes, so I had 
to adjust my old example/test libiptc programs a bit. e.g. removed the 
typedef iptc_handle_t.

Whats missing is that the libiptc.h header file should be installed.
My patch below is not doing the right thing. I don't know automake well 
enough, to make it create a directory libiptc/ under include/ where it 
should install libiptc.h.

Cheers,
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------

commit af01026f992347b70bcad05eda750b3808d7e970
Author: Jesper Dangaard Brouer <hawk@comx.dk>
Date:   Thu Feb 12 11:32:09 2009 +0100

     Install the libiptc.h header file.

     This patch is not what I really want, as it installs libiptc.h directly in
     include/ where is should be placed in include/libiptc/ to comply with the
     old standard.  The problem is that I don't know automake well enough...

diff --git a/Makefile.am b/Makefile.am
index 274b015..85dd1c7 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -81,7 +81,7 @@ man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
                     ip6tables-save.8
  CLEANFILES       = iptables.8 ip6tables.8
  if ENABLE_DEVEL
-include_HEADERS  = include/xtables.h
+include_HEADERS  = include/xtables.h include/libiptc/libiptc.h
  endif

  if ENABLE_STATIC
