From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: [PATCH] arptables: Add man pages for arptables-{save,restore}
Date: Thu, 14 Nov 2013 13:40:04 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1311141337350.2659@ask.diku.dk>
References: <20131114121412.20830.46585.stgit@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: bdschuym@pandora.be, netfilter-devel@vger.kernel.org
To: Jesper Dangaard Brouer <brouer@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:58311 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab3KNNG1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Nov 2013 08:06:27 -0500
In-Reply-To: <20131114121412.20830.46585.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 14 Nov 2013, Jesper Dangaard Brouer wrote:

> Also fixed up the Makefile to install these man pages.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
> userspace/arptables/Makefile            |   15 +++++++----
> userspace/arptables/arptables-restore.8 |   41 +++++++++++++++++++++++++++++++
> userspace/arptables/arptables-save.8    |   37 ++++++++++++++++++++++++++++
> 3 files changed, 87 insertions(+), 6 deletions(-)
> create mode 100644 userspace/arptables/arptables-restore.8
> create mode 100644 userspace/arptables/arptables-save.8
>
> diff --git a/userspace/arptables/Makefile b/userspace/arptables/Makefile
> index 38158d9..0cf780a 100644
> --- a/userspace/arptables/Makefile
> +++ b/userspace/arptables/Makefile
> @@ -5,11 +5,13 @@ KERNEL_DIR:=./
> PREFIX:=/usr/local
> LIBDIR:=$(PREFIX)/lib
> BINDIR:=$(PREFIX)/sbin
> -MANDIR:=$(PREFIX)/man
> +MANDIR:=$(PREFIX)/man/man8

Self NACK

I must not add "/man8" to MANDIR, because it can be redefined by a user 
on the command line, when invoking make.

I'll send a new V2 patch fixing this.

Hilsen
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
