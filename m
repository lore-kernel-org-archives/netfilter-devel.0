From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [contrack-tools PATCH] build: do not compile nfct if we disabled
 cttimeout
Date: Mon, 12 May 2014 17:24:21 +0200
Message-ID: <20140512152421.GA12618@localhost>
References: <1399543345-3634-1-git-send-email-liuhangbin@gmail.com>
 <20140509112959.GA3812@localhost>
 <20140509115411.GJ25631@localhost.localdomain>
 <20140509135942.GA11325@localhost>
 <20140510025123.GK25631@localhost.localdomain>
 <20140512152354.GA6781@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="pf9I7BMVVzbSWLtt"
Cc: netfilter-devel@vger.kernel.org
To: Hangbin Liu <liuhangbin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39771 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758554AbaELPYl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 11:24:41 -0400
Content-Disposition: inline
In-Reply-To: <20140512152354.GA6781@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 12, 2014 at 05:23:54PM +0200, Pablo Neira Ayuso wrote:
> On Sat, May 10, 2014 at 10:51:23AM +0800, Hangbin Liu wrote:
> > On Fri, May 09, 2014 at 03:59:42PM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, May 09, 2014 at 07:54:11PM +0800, Hangbin Liu wrote:
> > > > On Fri, May 09, 2014 at 01:29:59PM +0200, Pablo Neira Ayuso wrote:
> > > > > On Thu, May 08, 2014 at 06:02:25PM +0800, Hangbin Liu wrote:
> > > > > > If we do not have libnetfilter_cttimeout and disabled cttimeout, conntrack-tools
> > > > > > will compile fail because nfct.c include nfnetlink_cttimeout.h. Fix it by only
> > > > > > compile nfct when we have enabled cttimeout
> > > 
> > > OK, I see. That's not nfnetlink_cttimeout.h, it's
> > > libnetfilter_cttimeout.h.
> > 
> > Ah, sorry, my mistake
> 
> Please, give a try to the attached patch.

Now, really attaching the patch.

--pf9I7BMVVzbSWLtt
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-nfct-remove-unneeded-included-header.patch"

>From 34a8e200eee54b4bbecadf52bba8901cae129795 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 12 May 2014 17:21:21 +0200
Subject: [PATCH] nfct: remove unneeded included header

This fixes a compilation breakage when libnetfilter_cttimeout.h is
not installed.

Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/nfct.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/src/nfct.c b/src/nfct.c
index 19e44be..533d75d 100644
--- a/src/nfct.c
+++ b/src/nfct.c
@@ -22,8 +22,6 @@
 #include <errno.h>
 
 #include <libmnl/libmnl.h>
-#include <linux/netfilter/nfnetlink_cttimeout.h>
-#include <libnetfilter_cttimeout/libnetfilter_cttimeout.h>
 
 #include "linux_list.h"
 #include "nfct.h"
-- 
1.7.10.4


--pf9I7BMVVzbSWLtt--
