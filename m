From: Josh Hunt <johunt@akamai.com>
Subject: Re: ipset restore behavior with newer glibc
Date: Tue, 27 Nov 2012 13:53:14 -0600
Message-ID: <50B51A2A.8020304@akamai.com>
References: <50915160.1090908@akamai.com> <alpine.LNX.2.01.1210311737030.20899@nerf07.vanv.qr> <alpine.DEB.2.00.1210311904120.14824@blackhole.kfki.hu> <alpine.DEB.2.00.1210312005580.14998@blackhole.kfki.hu> <50B511EA.3070203@akamai.com> <alpine.DEB.2.00.1211272048001.17363@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@inai.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:34952 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754601Ab2K0TxS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 14:53:18 -0500
In-Reply-To: <alpine.DEB.2.00.1211272048001.17363@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On 11/27/2012 01:51 PM, Jozsef Kadlecsik wrote:
> On Tue, 27 Nov 2012, Josh Hunt wrote:
>
>> On 10/31/2012 02:07 PM, Jozsef Kadlecsik wrote:
>>>
>>> It seems to me, the best is to add a stripped down version of
>>> "getaddrinfo" to ipset itself. That'll be the first library workaround...
>>
>> Is this something that would be an acceptable solution? If so I can try my
>> hand at it unless someone else is eager to do it.
>
> In ipset 6.15 getaddrinfo was replaced by gethostbyname2 (where it's
> available in libc).

Sweet! :D
