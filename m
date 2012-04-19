From: Miguel GAIO <miguel.gaio@efixo.com>
Subject: Re: libiptc: fix retry path in TC_INIT
Date: Thu, 19 Apr 2012 12:14:33 +0200
Message-ID: <1334830473.25428.2.camel@mgo-thinkpad>
References: <1334651363.10712.6.camel@mgo-thinkpad>
	 <20120418231242.GB12354@1984>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ljAvJzmiwvKpWPreVacx"
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp25.services.sfr.fr ([93.17.128.119]:31652 "EHLO
	smtp25.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab2DSKOh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Apr 2012 06:14:37 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2508.sfr.fr (SMTP Server) with ESMTP id 864227000452
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Apr 2012 12:14:34 +0200 (CEST)
Received: from [192.168.100.226] (21.67.64.86.rev.sfr.net [86.64.67.21])
	by msfrf2508.sfr.fr (SMTP Server) with ESMTP id 228F3700041C
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Apr 2012 12:14:34 +0200 (CEST)
In-Reply-To: <20120418231242.GB12354@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-ljAvJzmiwvKpWPreVacx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2012-04-19 at 01:12 +0200, Pablo Neira Ayuso wrote:

Hi,


> Hi Miguel,
> 
> On Tue, Apr 17, 2012 at 10:29:23AM +0200, Miguel GAIO wrote:
> > Hi,
> > 
> > There is an issue on TC_INIT retry path:
> > In error case, TC_FREE is called and close sockfd.
> > The retry does not reopen then always fail.
> > 
> > The proposing patch reopen sockfd in retry patch.
> > 
> > 
> > Miguel
> >
> > From 6dbb1a9f16c70a60c06559b31eac7ab3af789fa1 Mon Sep 17 00:00:00 2001
> > From: Miguel GAIO <miguel.gaio@efixo.com>
> > Date: Tue, 17 Apr 2012 10:16:28 +0200
> > Subject: [PATCH 2008/2008]  libiptc: TC_INIT fix retry
> > 
> > ---
> >  libiptc/libiptc.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
> > index 63965e7..cd2ad9d 100644
> > --- a/libiptc/libiptc.c
> > +++ b/libiptc/libiptc.c
> > @@ -1314,6 +1314,7 @@ TC_INIT(const char *tablename)
> >  		return NULL;
> >  	}
> >  
> > +retry:
> 
> Still iptc_fn is set to TC_FREE. We have to move up to the beginning
> of TC_INIT.


Your right, I miss it.
I resend patch with the retry at the beginning of TC_INIT.

--=-ljAvJzmiwvKpWPreVacx
Content-Disposition: attachment; filename="0001-libiptc-TC_INIT-fix-retry.patch"
Content-Type: text/x-patch; name="0001-libiptc-TC_INIT-fix-retry.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 202e62cd5f143ce9ef5d7fc8cdd2aca81dc013bf Mon Sep 17 00:00:00 2001
From: Miguel GAIO <miguel.gaio@efixo.com>
Date: Thu, 19 Apr 2012 12:11:06 +0200
Subject: [PATCH]  libiptc: TC_INIT fix retry

---
 libiptc/libiptc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 63965e7..f0f7815 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1307,6 +1307,7 @@ TC_INIT(const char *tablename)
 	socklen_t s;
 	int sockfd;
 
+retry:
 	iptc_fn = TC_INIT;
 
 	if (strlen(tablename) >= TABLE_MAXNAMELEN) {
@@ -1324,7 +1325,6 @@ TC_INIT(const char *tablename)
 		abort();
 	}
 
-retry:
 	s = sizeof(info);
 
 	strcpy(info.name, tablename);
-- 
1.7.9.5


--=-ljAvJzmiwvKpWPreVacx--
