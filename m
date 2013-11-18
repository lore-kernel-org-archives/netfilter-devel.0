From: "Dawid Stawiarski - nazwa.pl" <dawid.stawiarski@netart.pl>
Subject: Re: linux 3.12 regression - snat problem with ftp helper
Date: Mon, 18 Nov 2013 08:41:49 +0100
Message-ID: <5289C4BD.3030708@netart.pl>
References: <52862618.4030202@netart.pl> <20131115200928.GA11322@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.netart.pl ([85.128.128.50]:55317 "EHLO mail.netart.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab3KRHlw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Nov 2013 02:41:52 -0500
In-Reply-To: <20131115200928.GA11322@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

W dniu 15.11.2013 21:09, Phil Oester pisze:
>> in packet 8 host sends rewriten PORT command (with changed private
>> to public IP) - however the packet has incorrect sequence number
>> (should have 41).
>> the ftp server responds with SACK but the host resets the connection.
>
> Does the attached patch solve the problem for you?

yes, I can confirm that the kernel with your patch applied works as 
expected. Thank you for quick reply and the fix.

Dawid

