From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: ebtables broken for kernel above 2.6.28
Date: Sun, 21 Jun 2009 17:16:25 +0200
Message-ID: <4A3E4EC9.1020901@pandora.be>
References: <alpine.LSU.2.00.0906160838410.25132@fbirervta.pbzchgretzou.qr> <4A3A6C57.6080403@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, Peter Volkov <pva@gentoo.org>,
	Sachin Nasap <sachin.sanap.1gb@gmail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:47368 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbZFUPQb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Jun 2009 11:16:31 -0400
In-Reply-To: <4A3A6C57.6080403@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer schreef:
> Jan Engelhardt schreef:
>>
>> The userspace patch proposed by Sachin Nasap is, IMHO, one to fix the 
>> alignment problems (both old and recent) in one clap.
>>   
>
> Thanks, I'll have a look at it this weekend.

I applied the patch and will release a new ebtables version.

cheers,
Bart

