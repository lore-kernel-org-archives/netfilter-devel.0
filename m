From: ilninno <ilninno@gmail.com>
Subject: Re: Hi again, get the process id associated to a packet
Date: Mon, 5 Jan 2009 10:59:24 +0100
Message-ID: <92770c820901050159j6c256448j80d0ec92f96c4a37@mail.gmail.com>
References: <92770c820901041643t1b460c2bj4323a60ffcfc2c94@mail.gmail.com>
	 <1231118620.3927.18.camel@ice-age>
	 <alpine.LSU.2.00.0901050355380.4014@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:31907 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbZAEJ72 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:59:28 -0500
Received: by an-out-0708.google.com with SMTP id d40so2313268and.1
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Jan 2009 01:59:24 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.0901050355380.4014@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi again!

then i will try using /proc/net/tcp to get the process associated, thanks


2009/1/5 Jan Engelhardt <jengelh@medozas.de>:
>
> On Monday 2009-01-05 02:23, Eric Leblond wrote:
>>
>>By the way, you will find some libnetfilter_queue documentation here:
>>http://www.nufw.org/doc/libnetfilter_queue/
>
> By the way, I notice that nfq_errno is not thread-safe.
>
