From: jamal <hadi@cyberus.ca>
Subject: Re: several messages
Date: Mon, 09 Feb 2009 16:27:21 -0500
Message-ID: <1234214841.20903.27.camel@dogo.mojatatu.com>
References: <1234213032.20903.13.camel@dogo.mojatatu.com>
	 <alpine.LSU.2.00.0902092202020.25199@fbirervta.pbzchgretzou.qr>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:33189 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbZBIV3Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:29:16 -0500
Received: by ewy14 with SMTP id 14so2797097ewy.13
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Feb 2009 13:29:14 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.0902092202020.25199@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2009-02-09 at 22:04 +0100, Jan Engelhardt wrote:

> 
> I do not think a library should call exit() and cause the main program 
> to terminate; 
> to this end it might be best to add a
> 
> 	void (*exit_error)(..
> 
> function pointer to the xtables_global struct you are proposing.
> 
> 

Thanks for the suggestion - it sounds reasonable. 
Note, however, grep says there are about 700 references  to exit_error()
- so my intent of moving it into xtables.c is for usability more than
anything.

> If you could convert iptables.c and friends to also make use of this, 
> that'd be great.

There are only 3 definitions as far as i can see. If i can convert those
to use that global struct then I should be able to compile that basic
program.

cheers,
jamal

