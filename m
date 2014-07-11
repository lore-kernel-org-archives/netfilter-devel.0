From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 4/7] autotools conversion: include the header 'config.h'
 in every C source file.
Date: Fri, 11 Jul 2014 09:24:41 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1407110921430.777@nerf08.vanv.qr>
References: <1404742796-8039-1-git-send-email-giorgio.nicole@arcor.de> <1404742796-8039-5-git-send-email-giorgio.nicole@arcor.de> <20140710100409.GA13741@macbook.localnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Giorgio Dal Molin <giorgio.nicole@arcor.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:51934 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaGKHYn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:24:43 -0400
In-Reply-To: <20140710100409.GA13741@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2014-07-10 12:04, Patrick McHardy wrote:
>> --- a/src/cli.c
>> +++ b/src/cli.c
>> @@ -11,6 +11,9 @@
>>   *
>>   * Development of this code funded by Astaro AG (http://www.astaro.com/)
>>   */
>> +#ifdef HAVE_CONFIG_H
>> +#include <config.h>
>> +#endif
>
>Do we really need those ifdefs?

Practically no, since AC_CONFIG_HEADERS is unconditionally called in 
configure.ac.
