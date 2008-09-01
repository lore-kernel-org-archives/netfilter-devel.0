From: Patrick McHardy <kaber@trash.net>
Subject: Re: + netfilter-xt_time-gives-a-wrong-monthday-in-a-leap-year.patch
 added to -mm tree
Date: Mon, 01 Sep 2008 14:06:58 +0200
Message-ID: <48BBDAE2.7010507@trash.net>
References: <200808272320.m7RNKUUn028077@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kaih.luo@gmail.com, jengelh@computergmbh.de,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: akpm@linux-foundation.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33234 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbYIAMHA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Sep 2008 08:07:00 -0400
In-Reply-To: <200808272320.m7RNKUUn028077@imap1.linux-foundation.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

akpm@linux-foundation.org wrote:
> Subject: netfilter: xt_time gives a wrong monthday in a leap year
> From: Kaihui Luo <kaih.luo@gmail.com>
> 
> The function localtime_3 in xt_time.c gives a wrong monthday in a leap
> year after 28th 2.  calculating monthday should use the array
> days_since_leapyear[] not days_since_year[] in a leap year.

Jan, do you want me to apply this patch?
