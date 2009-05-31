From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] TCP simultaneous open support
Date: Sun, 31 May 2009 16:33:08 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905311631480.760@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0905311614330.760@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Saatvik Agarwal <saatvik.agarwal@stanford.edu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:52023 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbZEaOdH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 May 2009 10:33:07 -0400
In-Reply-To: <alpine.DEB.2.00.0905311614330.760@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 31 May 2009, Jozsef Kadlecsik wrote:

> ---
>  include/linux/netfilter/nf_conntrack_tcp.h |    2 +-
>  net/netfilter/nf_conntrack_proto_tcp.c     |   97 +++++++++++++++++-----------
>  2 files changed, 61 insertions(+), 38 deletions(-)

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Sorry, that line was not added.

Best regards,
Jozseg
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
