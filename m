From: "mstrfixit" <mstrfixit@rogers.com>
Subject: RE: NF_IP_POST ROUTING - Send packet back out on same interface it came in on
Date: Thu, 8 Apr 2010 09:02:17 -0400
Message-ID: <002701cad71b$b7b8a260$2729e720$@com>
References: <266849.47310.qm@web88106.mail.re2.yahoo.com> <alpine.LSU.2.01.1004081446220.28332@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Jan Engelhardt'" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp104.rog.mail.re2.yahoo.com ([206.190.36.82]:29834 "HELO
	smtp104.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758731Ab0DHNI7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Apr 2010 09:08:59 -0400
In-Reply-To: <alpine.LSU.2.01.1004081446220.28332@obet.zrqbmnf.qr>
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Like I said. I solved the problem and it works a treat. Yes I swapped the
Mac addresses and the input/output devices.

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

