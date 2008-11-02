From: Philip Prindeville <philipp_subx@redfish-solutions.com>
Subject: Re: Issues building iptables-1.4.2 w/ linux 2.6.25 (and IMQ)
Date: Sun, 02 Nov 2008 13:27:25 -0800
Message-ID: <490E1B3D.7030003@redfish-solutions.com>
References: <490E111C.9060006@redfish-solutions.com> <alpine.LNX.1.10.0811022204140.25491@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:39403 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754070AbYKBV1a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:27:30 -0500
In-Reply-To: <alpine.LNX.1.10.0811022204140.25491@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2008-11-02 21:44, Philip Prindeville wrote:
>
>   
>> Subject: Issues building iptables-1.4.2 w/ linux 2.6.25 (and IMQ)
>>
>> I'm trying to build iptables 1.3.8
>>     
>
> Version mismatch.
>
>   
>> Is this a known issue?  Is there a patch for this?
>>     
>
> Yes. (Can't remember.)
>
>   
>> I tried bumping to 1.4.2, but that dies with a different issue:
>>
>> libipt_IMQ.c: In function 'help':
>> libipt_IMQ.c:18: error: 'IPTABLES_VERSION' undeclared (first use in this
>> function)
>>     
>
> IMQ is not packaged in an original iptables tarball, hence this falls 
> under the IMQ maintainer's care. What you see here is what happens when 
> you try to use an old patch with a new version.
>   

Ok, so taking this from the other direction:  what is the recommended 
version of iptables to run on Linux 2.6.25.19?

-Philip

