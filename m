From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xt_time: never matches a correct monthday
 in a leap year after 28th 2
Date: Tue, 09 Sep 2008 09:24:06 +0200
Message-ID: <48C62496.6070706@trash.net>
References: <c0ff893e0808252007p72cd9676j437a72024b71612c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: luo kaih <kaih.luo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64397 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbYIIHYJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:24:09 -0400
In-Reply-To: <c0ff893e0808252007p72cd9676j437a72024b71612c@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

luo kaih wrote:
> the function localtime_3 in xt_time.c  gives a wrong monthday in a
> leap year after 28th 2 . calculating monthday should use the array
> days_since_leapyear[] not days_since_year[]  in a leap year .

Your mailer corrupted whitespace in this patch. Please resend as
attachment. Thanks.
