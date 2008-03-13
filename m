From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Do nfnl_query and nfnl_catch are blocking fuctions ?
Date: Thu, 13 Mar 2008 17:36:12 +0100
Message-ID: <47D957FC.3000900@netfilter.org>
References: <000e01c88502$8f4212c0$adc63840$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Nishit Shah <nishit@elitecore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50858 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752319AbYCMQag (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:30:36 -0400
In-Reply-To: <000e01c88502$8f4212c0$adc63840$@com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nishit Shah wrote:
> Hi,
>                 Is it possible that on high rate of conntrack
> addition/deletion/updation, nfnl_query or nfnl_catch, If space is not
> available at the sending socket these fuctions will block as they are using
> sendto and recvmsg calls ?

What kind of behaviour are you observing? Please elaborate.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
