From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 00/11] TProxy for IPv6
Date: Mon, 14 Sep 2009 14:29:51 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0909141429060.6887@obet.zrqbmnf.qr>
References: <cover.1251295408.git.bazsi@balabit.hu> <4AA0AE8C.30203@treenet.co.nz> <alpine.LSU.2.00.0909041124090.27609@obet.zrqbmnf.qr> <4AAE34F0.2080301@treenet.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Balazs Scheidler <bazsi@balabit.hu>,
	netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu,
	Harry Mason <harry.mason@smoothwall.net>
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58081 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418AbZINM3s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:29:48 -0400
In-Reply-To: <4AAE34F0.2080301@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-09-14 14:20, Amos Jeffries wrote:
>> assert(socket(PF_INET6, ...) >= 0);
>> assert(setsockopt(fd, SOL_IP, IP_TRANSPARENT, ...) == 0);
>> assert(bind(fd, {::2}) == 0);
>>
>> At least something like that I remember to have used to determine
>> tproxy-2.x ipv4 availability in the days. (I.e. seeing if setsockopt
>> failed.)
>
> Thanks Jan. I gave a variant that a try. It does seem to detect the feature
> support nicely.
>
> However, trying to bind the real IP:port soon after results in "(98) Address
> already in use" even with a shutdown(tmp_sock,...) added to clean up after the
> test.

Odd, since binding to port 0 should give you a random one,
and there are plenty.
Does SO_REUSEADDR help it a bit?
