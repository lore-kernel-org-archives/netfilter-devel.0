From: Tim Gardner <timg@tpi.com>
Subject: Re: linux-next netfilter: xt_recent: Add an entry reaper
Date: Sun, 28 Feb 2010 15:42:18 -0700
Message-ID: <4B8AF14A.5030904@tpi.com>
References: <20100228033841.265CFF8BB0@sepang.rtg.net> <1267331677.9082.46.camel@edumazet-laptop> <alpine.LSU.2.01.1002281146470.9681@obet.zrqbmnf.qr>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>, kaber@trash.net,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:4098 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032075Ab0B1Wmf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Feb 2010 17:42:35 -0500
In-Reply-To: <alpine.LSU.2.01.1002281146470.9681@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2010-02-28 05:34, Eric Dumazet wrote:
>>> One of the problems with the way xt_recent is implemented is that
>>> there is no efficient way to remove expired entries.
> 
> Oh there is:
> 
> 	echo "- 2001:db8::1" >/proc/net/xt_recent/foo
> 
>> 2) All entries are flushed when
>> 	echo clear > /proc/net/xt_recent/<tablename>
> 
> 	echo "/" >/proc/net/xt_recent/foo
> 
> it is.
> 
>> 3) You could eventually implement a purge operation to remove all
>> expired entries at will
>>
>>      echo purge > /proc/net/xt_recent/<tablename>
> 
> Entries do not expire (except "falling off" the LRU when it's full) -
> there is no counter that tells them when they expired.
> "--seconds" is just a match option, not something that defines
> the LRU's properties. And that's actually good, because that allows
> you to write
> 
> 	-m recent --name foo --seconds 60 -j do that
> 
> 	-m recent --name foo --seconds 3600 -j do something else
> 
> If you purged "expired" entries after 60 secs, there would be nothing
> left for the 3600 one to check for.
> 

I hadn't really considered your example as a valid use case. It seems to
me that the second rule might also match even after the first rule
matches, but its also very dependent on how you've crafted your rule set.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
