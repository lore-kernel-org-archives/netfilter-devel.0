From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [ANNOUNCE] ipset 2.4 released
Date: Thu, 23 Oct 2008 19:11:21 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0810231902001.6831@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0810201254190.23040@blackhole.kfki.hu> <alpine.LNX.1.10.0810230418300.20661@bizon.gios.gov.pl> <Pine.LNX.4.64.0810231657350.28810@blackhole.kfki.hu> <Pine.LNX.4.64.0810231723570.28839@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-2104020473-1224781881=:6831"
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([195.187.34.71]:55407 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbYJWRL2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:11:28 -0400
In-Reply-To: <Pine.LNX.4.64.0810231723570.28839@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-2104020473-1224781881=:6831
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Thu, 23 Oct 2008, Jozsef Kadlecsik wrote:

> On Thu, 23 Oct 2008, Jozsef Kadlecsik wrote:
>
>> On Thu, 23 Oct 2008, Krzysztof Oledzki wrote:
>>
>>> More problems. :| Restoring my sets+iptables configuration and running "ipset
>>> -F" oopses the kernel, please look at the attached oops.
>>
>> This is a serious issue in 2.4.x, I'll look into it.
>
> Type of a structure elem when flushing (memsetting to zero) was specified
> as uint32_t instead of uint16_t :-(.
>
> Please give a try to the patch below, on top of ipset 2.4.1.
>
> I fixed the bug above and modified all places which might lead to a
> similar bug in the future if a type changes. The missing <linux/timer.h>
> header files are also added.

Perfect: kernel compiles cleanly and no longer oopses.

Thank you very much!

Best regards,

 			Krzysztof Olêdzki
---1144830174-2104020473-1224781881=:6831--
