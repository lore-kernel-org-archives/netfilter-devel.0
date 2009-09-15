From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: [PATCH 00/11] TProxy for IPv6
Date: Tue, 15 Sep 2009 23:58:44 +1200
Message-ID: <4AAF8174.5080904@treenet.co.nz>
References: <cover.1251295408.git.bazsi@balabit.hu> <4AA0AE8C.30203@treenet.co.nz> <alpine.LSU.2.00.0909041124090.27609@obet.zrqbmnf.qr> <4AAE34F0.2080301@treenet.co.nz> <alpine.LSU.2.00.0909141429060.6887@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Balazs Scheidler <bazsi@balabit.hu>,
	netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu,
	Harry Mason <harry.mason@smoothwall.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:36871
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZIOL6p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Sep 2009 07:58:45 -0400
In-Reply-To: <alpine.LSU.2.00.0909141429060.6887@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-09-14 14:20, Amos Jeffries wrote:
>>> assert(socket(PF_INET6, ...) >= 0);
>>> assert(setsockopt(fd, SOL_IP, IP_TRANSPARENT, ...) == 0);
>>> assert(bind(fd, {::2}) == 0);
>>>
>>> At least something like that I remember to have used to determine
>>> tproxy-2.x ipv4 availability in the days. (I.e. seeing if setsockopt
>>> failed.)
>> Thanks Jan. I gave a variant that a try. It does seem to detect the feature
>> support nicely.
>>
>> However, trying to bind the real IP:port soon after results in "(98) Address
>> already in use" even with a shutdown(tmp_sock,...) added to clean up after the
>> test.
> 
> Odd, since binding to port 0 should give you a random one,
> and there are plenty.
> Does SO_REUSEADDR help it a bit?

um... thanks for the hint.
I was re-using a handy address object without un-setting the port.
It works fully now.

AYJ
