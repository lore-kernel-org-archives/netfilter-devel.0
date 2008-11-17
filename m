From: John Haxby <john.haxby@oracle.com>
Subject: Re: Problem compiling
Date: Mon, 17 Nov 2008 22:37:22 +0000
Message-ID: <4921F222.7020809@oracle.com>
References: <49219BF2.6090904@oracle.com> <alpine.LNX.1.10.0811172259080.17946@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet14.oracle.com ([148.87.113.126]:31081 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYKQWjH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:39:07 -0500
Received: from rgminet11.oracle.com (rcsinet11.oracle.com [148.87.113.123])
	by rgminet14.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id mAHMcO1L012559
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Nov 2008 22:39:54 GMT
In-Reply-To: <alpine.LNX.1.10.0811172259080.17946@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2008-11-17 17:29, John Haxby wrote:
>
>   
>> Hello All,
>>
>> I'm having problems compiling this:
>> http://marek.terminus.sk/prog/ipt_sysrq.shtml
>>
>> This is on Fedora 9 and RHEL5 and in both cases I get this error:
>>
>> /usr/include/iptables.h:5:29: error: libiptc/libiptc.h: No such file or
>> directory
>>     
>
> (Just noting that this error has nothing to do with ipt_sysrq.)
>   

Correct -- it's just an example.
>   
>> Now, the easiest way to "fix" this is it to make sure that libiptc/libiptc.h is
>> installed into /usr/include
>>     
>
> What iptables version?
>   
Fedora says iptables-1.4.1.1-2.fc9.x86_64 -- the few patches on top of 
1.4.1 don't do anything for this problem.

jch
