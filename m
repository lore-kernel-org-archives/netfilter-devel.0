From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: wrong order of received packets/bytes and sent packets/bytes
 with local incoming connections
Date: Sun, 22 Apr 2012 17:55:35 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1204221749230.24779@frira.zrqbmnf.qr>
References: <4F92FD5F.5010204@chello.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "alois.klingler@chello.at" <alois.klingler@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:53109 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab2DVPzk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Apr 2012 11:55:40 -0400
In-Reply-To: <4F92FD5F.5010204@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2012-04-21 20:33, alois.klingler@chello.at wrote:

> in /proc/net/nf_conntrack (and also in conntrack -L) i can see received
> packets/bytes and sent packets/bytes.
> with connections, which are local incoming connections (i.e. a
> ssh-connection from anywhere to my machine) these fields are mixed,
> means that the received packets/bytes are the sent packets/bytes and vice
> versa.
>
> with local outbound connections or forwarding connections these fields
> are correct filled.
>
> is there anywhere a configuation option to fix this?

I do not see any error here. The first bytes/packet= field shows
bytes flowing in the "original direction", and the other
is the reply direction.
