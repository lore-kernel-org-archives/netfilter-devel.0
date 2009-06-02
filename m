From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] TCP simultaneous open support
Date: Tue, 2 Jun 2009 10:41:39 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906021036090.11925@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0905311614330.760@blackhole.kfki.hu>  <alpine.DEB.2.00.0905311631480.760@blackhole.kfki.hu>  <4ddb24250905311604o8d0f2c2l9ba3984ae296a009@mail.gmail.com>  <alpine.LSU.2.00.0906010149510.12927@fbirervta.pbzchgretzou.qr>
 <4ddb24250905311750q33f6193fi12dda710d75b2b28@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Saatvik Agarwal <saatvik.agarwal@stanford.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:52905 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990AbZFBIli (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:41:38 -0400
In-Reply-To: <4ddb24250905311750q33f6193fi12dda710d75b2b28@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 31 May 2009, Saatvik Agarwal wrote:

> Hmm. I tried both the latest RC and the latest stable release. Same
> problem. For example, the arrays in chunk 2 & 3 of nf_conntrack_tcp.h
> are significantly longer in the latest release than indicated in the
> diff. Am I missing something?

My patch is on top of the patch

Date: Mon, 25 May 2009 12:35:19 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
Subject: [PATCH] Fix accepting invalid RST segments

So first you should apply that.

Or pull Patrick's git tree from 
git://git.kernel.org/pub/scm/kaber/nf-2.6.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
