From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: CRYPT target patch for newer kernel ?
Date: Wed, 8 Aug 2012 15:41:23 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208081535440.857@frira.zrqbmnf.qr>
References: <1344428741.4763.21.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	nefilter@vger.kernel.org
To: Arif Hossain <etothepowerpi@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:51002 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758211Ab2HHNlZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:41:25 -0400
In-Reply-To: <1344428741.4763.21.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2012-08-08 14:25, Arif Hossain wrote:
>
>I've come across many "CRYPT" or similar target patches will encrypt UDP
>or TCP traffic.

And they are mostly pointless..

>1. A simple XOR target(-j XOR --key)
>http://lists.netfilter.org/pipermail/netfilter-devel/2003-May/011532.html

XOR is not really an encryption.

>2. A more robust ENCRYPT/DECRYPT target which will use full crypto api
>of linux kernel:
>http://0pointer.de/lennart/projects/seppl/
>"IPSEC/FreeSwan is extremely complicated to use. Due to its strange routing
>scheme it is nearly impossible to use together with routing daemons. IPSEC is
>heavyweight."

Complicated? No, not at all. http://inai.de/2008/02/24
Heavyweight? Neither. The RSS is ~5 MB, most of which is pretty much
glibc anyway.

