From: Valentijn Sessink <valentyn@blub.net>
Subject: Re: xt_recent.c bug - and cleanup
Date: Thu, 05 Sep 2013 16:55:17 +0200
Message-ID: <52289B55.1000902@blub.net>
References: <521F1F77.3030808@blub.net> <20130829220904.GA6810@linuxace.com> <52202D25.6030606@blub.net> <20130830152448.GB7648@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gateway.openoffice.nl ([95.97.76.242]:32794 "EHLO
	openoffice.kantoor.openoffice.nl" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752529Ab3IEOzU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:55:20 -0400
In-Reply-To: <20130830152448.GB7648@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

On 30-08-13 17:24, Phil Oester wrote:
> Eh?  You might be misreading the code.

I was. I stand corrected.
[...]

> You can certainly use inversion with this match, but in your original example,
> you are expecting that anything which does not match will get it's timestamp
> updated.  That is simply not how the match works.

I contacted Stephen Frost to ask his opinion about the "!" qualifier and 
he agrees with the current source, i.e. only update if the match returns 
true.

Thank you for your thorough reading and sorry for the misunderstanding. 
I have closed the bug.

Best regards,

Valentijn Sessink



