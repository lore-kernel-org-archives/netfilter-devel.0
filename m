From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2 v5] New netfilter target to trigger LED devices
Date: Thu, 19 Feb 2009 11:14:55 +0100
Message-ID: <499D311F.7050304@trash.net>
References: <49934702.9060909@shikadi.net> <4993B34C.1020307@trash.net>	 <49940D58.3040404@shikadi.net>  <49998E6C.2030504@trash.net> <1234878654.5312.34.camel@dax.rpnet.com> <499C17C2.9020502@trash.net> <499C899F.5010002@shikadi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Richard Purdie <rpurdie@linux.intel.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45929 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbZBSKO5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2009 05:14:57 -0500
In-Reply-To: <499C899F.5010002@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adam Nielsen wrote:
>> Adam, I wanted to apply this, but I get rejects for every single
>> existing file. There appears to be some whitespace damage, please
>> resend as attachment.
> 
> Hmm, that's odd - Thunderbird must not like sending tabs - sorry
> about that!
> 
> I hope the attached files work better.

It applies with some minor manual fixups (please diff against the
nf-next tree at git.kernel.org). It doesn't compile though:

   CC [M]  net/netfilter/xt_LED.o
net/netfilter/xt_LED.c:40: error: field 'netfilter_led_trigger' has 
incomplete type
net/netfilter/xt_LED.c: In function 'led_timeout_callback':
net/netfilter/xt_LED.c:77: warning: unused variable 'ledinternal'
net/netfilter/xt_LED.c: In function 'led_tg_check':
net/netfilter/xt_LED.c:101: error: implicit declaration of function 
'led_trigger_register'
net/netfilter/xt_LED.c: In function 'led_tg_destroy':
net/netfilter/xt_LED.c:134: error: implicit declaration of function 
'led_trigger_unregister'
