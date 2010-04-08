From: "mstrfixit" <mstrfixit@rogers.com>
Subject: RE: NF_IP_POST ROUTING - Send packet back out on same interface it came in on
Date: Thu, 8 Apr 2010 09:19:30 -0400
Message-ID: <002801cad71e$1f6d2dc0$5e478940$@com>
References: <266849.47310.qm@web88106.mail.re2.yahoo.com> <alpine.LSU.2.01.1004081446220.28332@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1252"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp108.rog.mail.re2.yahoo.com ([68.142.225.206]:24911 "HELO
	smtp108.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758420Ab0DHN0L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Apr 2010 09:26:11 -0400
In-Reply-To: <alpine.LSU.2.01.1004081446220.28332@obet.zrqbmnf.qr>
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Error was simple logic:

if (ethdr != NULL)

Should have been 

if (ethdr == NULL)

I could not see the forest through the trees.

Cheers

-----Original Message-----
From: Jan Engelhardt [mailto:jengelh@medozas.de] 
Sent: Thursday, April 08, 2010 8:50 AM
To: Robert SZABO
Cc: netfilter-devel@vger.kernel.org
Subject: Re: NF_IP_POST ROUTING - Send packet back out on same interface it
came in on


On Thursday 2010-04-08 14:15, Robert SZABO wrote:
>
>> Subject: NF_IP_POST ROUTING - Send packet back out on same interface it
came in on
>
>Problem solved. Thanks for all your input!

You cannot just send "to (ethernet) interfaces", because the hardware
would not know where to send it to once the packet *is* in the
interface. Don'tcha think?
You need a target for those, like MAC address.

