From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ULOGD2 PostgresSql errors
Date: Sun, 13 Apr 2008 03:25:40 +0200
Message-ID: <48016114.2020502@netfilter.org>
References: <200804111605.39957.anton.vazir@gmail.com> <20080411193312.GE20469@bayen.regit.org> <200804121243.08408.anton.vazir@gmail.com> <20080412094925.GG20469@bayen.regit.org> <20080412104218.GH20469@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Leblond <eric@inl.fr>, Anton <anton.vazir@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39999 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753873AbYDMBZu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2008 21:25:50 -0400
In-Reply-To: <20080412104218.GH20469@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> On Saturday, 2008 April 12 at 11:49:25 +0200, Eric Leblond wrote:
>> Hello,
>>
>> On Saturday, 2008 April 12 at 12:43:08 +0500, Anton wrote:
>>> Erik,
>>>
>>> Seems it fixes ICMP inserts.
>> Ok, fine.
>>
>>> Just for testing I tried MYSQL 
>>> logging too - it works without errors in log file, and 
>>> looks it logs more data than PGSQL. 
>> Yes, we're working on this issue. It seems PGSQL do not manage to find
>> the called SQL function due to type detection problem. This cause PGSQL
>> to loose some packets.
> 
> The attached patch should fix the ICMP problem and the non-logging
> problem. It is ok now on my test system.

I have applied this patch to SVN. Thanks Eric.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
