From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] build: restore -version-info
Date: Sun, 1 Jul 2012 00:15:05 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207010013340.4459@frira.zrqbmnf.qr>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <1341082043-26584-1-git-send-email-jengelh@inai.de> <1341082043-26584-2-git-send-email-jengelh@inai.de> <alpine.DEB.2.00.1206302357430.1075@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:50501 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab2F3WXH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jun 2012 18:23:07 -0400
In-Reply-To: <alpine.DEB.2.00.1206302357430.1075@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2012-07-01 00:05, Jozsef Kadlecsik wrote:
>> 
>> diff --git a/Make_global.am b/Make_global.am
>> index 4a8f61a..446c4de 100644
>> --- a/Make_global.am
>> +++ b/Make_global.am
>> @@ -69,7 +69,7 @@
>>  # interface. 
>>  
>>  #            curr:rev:age
>> -LIBVERSION = 3:0:1
>> +LIBVERSION = 3:0:0
>
>The new library release is backward compatible with the previous one, so 
>age must be incremented. That's why I set LIBVERSION to 3:0:1 from 2:1:0. 

Correct -- if you had stayed with "-version-info", which you did not.
