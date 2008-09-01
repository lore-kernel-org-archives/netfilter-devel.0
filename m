From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: + netfilter-xt_time-gives-a-wrong-monthday-in-a-leap-year.patch
 added to -mm tree
Date: Mon, 1 Sep 2008 11:32:12 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809011131340.3450@fbirervta.pbzchgretzou.qr>
References: <200808272320.m7RNKUUn028077@imap1.linux-foundation.org> <48BBDAE2.7010507@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: akpm@linux-foundation.org, kaih.luo@gmail.com,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46904 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbYIAPcO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Sep 2008 11:32:14 -0400
In-Reply-To: <48BBDAE2.7010507@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-09-01 08:06, Patrick McHardy wrote:
> akpm@linux-foundation.org wrote:
>> Subject: netfilter: xt_time gives a wrong monthday in a leap year
>> From: Kaihui Luo <kaih.luo@gmail.com>
>> 
>> The function localtime_3 in xt_time.c gives a wrong monthday in a leap
>> year after 28th 2.  calculating monthday should use the array
>> days_since_leapyear[] not days_since_year[] in a leap year.
>
> Jan, do you want me to apply this patch?

Acked-by: Jan Engelhardt <jengelh@medozas.de>
