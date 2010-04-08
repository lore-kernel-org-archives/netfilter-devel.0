From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: NF_IP_POST ROUTING - Send packet back out on same interface it
 came in on
Date: Thu, 8 Apr 2010 14:50:26 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004081446220.28332@obet.zrqbmnf.qr>
References: <266849.47310.qm@web88106.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Robert SZABO <mstrfixit@rogers.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37424 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758669Ab0DHMu1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Apr 2010 08:50:27 -0400
In-Reply-To: <266849.47310.qm@web88106.mail.re2.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-04-08 14:15, Robert SZABO wrote:
>
>> Subject: NF_IP_POST ROUTING - Send packet back out on same interface it came in on
>
>Problem solved. Thanks for all your input!

You cannot just send "to (ethernet) interfaces", because the hardware
would not know where to send it to once the packet *is* in the
interface. Don'tcha think?
You need a target for those, like MAC address.
