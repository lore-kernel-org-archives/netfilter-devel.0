From: Patrick McHardy <kaber@trash.net>
Subject: Re: + netfilter-xt_time-gives-a-wrong-monthday-in-a-leap-year.patch
 added to -mm tree
Date: Tue, 09 Sep 2008 09:22:56 +0200
Message-ID: <48C62450.1050601@trash.net>
References: <200808272320.m7RNKUUn028077@imap1.linux-foundation.org> <48BBDAE2.7010507@trash.net> <alpine.LNX.1.10.0809011131340.3450@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, kaih.luo@gmail.com,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64368 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbYIIHW7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:22:59 -0400
In-Reply-To: <alpine.LNX.1.10.0809011131340.3450@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2008-09-01 08:06, Patrick McHardy wrote:
>> akpm@linux-foundation.org wrote:
>>> Subject: netfilter: xt_time gives a wrong monthday in a leap year
>>> From: Kaihui Luo <kaih.luo@gmail.com>
>>>
>>> The function localtime_3 in xt_time.c gives a wrong monthday in a leap
>>> year after 28th 2.  calculating monthday should use the array
>>> days_since_leapyear[] not days_since_year[] in a leap year.
>> Jan, do you want me to apply this patch?
> 
> Acked-by: Jan Engelhardt <jengelh@medozas.de>

Applied, thanks.

