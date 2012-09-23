From: Patrick McHardy <kaber@trash.net>
Subject: Re: nflog feature request
Date: Sun, 23 Sep 2012 12:45:05 +0200 (MEST)
Message-ID: <Pine.GSO.4.63.1209231244230.3420@stinky-local.trash.net>
References: <CAEmTpZE2=nu8uuviLBvOroCrK4i=1bYgaZSCfQeH1332fDVcYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-559023410-851401618-1348397105=:3420"
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?=
	<socketpair@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56385 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab2IWKpO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Sep 2012 06:45:14 -0400
In-Reply-To: <CAEmTpZE2=nu8uuviLBvOroCrK4i=1bYgaZSCfQeH1332fDVcYQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---559023410-851401618-1348397105=:3420
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 22 Sep 2012, =D0~\=D0=B0=D1~@=D0=BA =D0~Z=D0=BE=D1~@=D0=B5=D0=BD=D0=
=B1=D0=B5=D1~@=D0=B3 wrote:

> Hello. Can you help be to make feature request for NFLOG target ?
>
> I want NFLOG to choose group at run time based on current CPU. This will =
be
> used in userspace accordingly - n threads that handle packets from CPU on
> which packet was originated.

Have a look at xt_NFQUEUE.c and nfnetlink_queue, which implement something
similar for userspace queueing.
---559023410-851401618-1348397105=:3420--
