From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: [PATCH 00/11] TProxy for IPv6
Date: Tue, 15 Sep 2009 00:20:00 +1200
Message-ID: <4AAE34F0.2080301@treenet.co.nz>
References: <cover.1251295408.git.bazsi@balabit.hu> <4AA0AE8C.30203@treenet.co.nz> <alpine.LSU.2.00.0909041124090.27609@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Balazs Scheidler <bazsi@balabit.hu>,
	netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu,
	Harry Mason <harry.mason@smoothwall.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:57015
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZINMUH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:20:07 -0400
In-Reply-To: <alpine.LSU.2.00.0909041124090.27609@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2009-09-04 08:07, Amos Jeffries wrote:
>>> Also, I have written a Python test script to test TProxy functionality
>>> automatically both for IPv4 and IPv6, I can post that as well if anyone is
>>> interested.
>> I'm interested :)
>>
>> Now that you have done this I'm going to have to find a robust userland
>> run-time test to see if the underlying TPROXY is v4-only or v6-enabled. If
>> anyone has suggestions they would be welcome.
> 
> Would this perhaps suffice?
> 
> assert(socket(PF_INET6, ...) >= 0);
> assert(setsockopt(fd, SOL_IP, IP_TRANSPARENT, ...) == 0);
> assert(bind(fd, {::2}) == 0);
> 
> At least something like that I remember to have used to determine
> tproxy-2.x ipv4 availability in the days. (I.e. seeing if setsockopt
> failed.)

Thanks Jan. I gave a variant that a try. It does seem to detect the 
feature support nicely.

However, trying to bind the real IP:port soon after results in "(98) 
Address already in use" even with a shutdown(tmp_sock,...) added to 
clean up after the test.

AYJ
