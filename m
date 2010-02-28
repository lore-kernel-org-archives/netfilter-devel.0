From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: linux-next netfilter: xt_recent: Add an entry reaper
Date: Sun, 28 Feb 2010 11:50:55 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002281146470.9681@obet.zrqbmnf.qr>
References: <20100228033841.265CFF8BB0@sepang.rtg.net> <1267331677.9082.46.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Tim Gardner <timg@tpi.com>, kaber@trash.net,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37908 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031766Ab0B1Ku7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Feb 2010 05:50:59 -0500
In-Reply-To: <1267331677.9082.46.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2010-02-28 05:34, Eric Dumazet wrote:
>> One of the problems with the way xt_recent is implemented is that
>> there is no efficient way to remove expired entries.

Oh there is:

	echo "- 2001:db8::1" >/proc/net/xt_recent/foo

>2) All entries are flushed when
>	echo clear > /proc/net/xt_recent/<tablename>

	echo "/" >/proc/net/xt_recent/foo

it is.

>3) You could eventually implement a purge operation to remove all
>expired entries at will
>
>      echo purge > /proc/net/xt_recent/<tablename>

Entries do not expire (except "falling off" the LRU when it's full) -
there is no counter that tells them when they expired.
"--seconds" is just a match option, not something that defines
the LRU's properties. And that's actually good, because that allows
you to write

	-m recent --name foo --seconds 60 -j do that

	-m recent --name foo --seconds 3600 -j do something else

If you purged "expired" entries after 60 secs, there would be nothing
left for the 3600 one to check for.
