From: "Yossi Weihs" <yw@seafire.com>
Subject: RE: newbie: writing custom target, need help with getting it to work
Date: Mon, 9 Aug 2010 00:23:32 -0400
Message-ID: <013501cb377a$a04e60a0$e0eb21e0$@com>
References: <00fe01cb3737$19358d20$4ba0a760$@com> <alpine.LSU.2.01.1008082225540.14264@obet.zrqbmnf.qr> <011101cb373d$f0b6b6b0$d2242410$@com> <alpine.LSU.2.01.1008082312200.20773@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Jan Engelhardt'" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns2.server274.com ([64.14.68.54]:47071 "EHLO server274.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750799Ab0HIEYk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Aug 2010 00:24:40 -0400
In-Reply-To: <alpine.LSU.2.01.1008082312200.20773@obet.zrqbmnf.qr>
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

OK - xt_TAP.ko is not getting loaded by iptables. I can modprobe it
manually, but iptables won't load it. Trying telling iptables which modprobe
to use, but no luck. xt_TEE.ko is getting loaded fine, and I cloned my
module off it ... I feel we're getting close.

-YW

-----Original Message-----
From: netfilter-devel-owner@vger.kernel.org
[mailto:netfilter-devel-owner@vger.kernel.org] On Behalf Of Jan Engelhardt
Sent: Sunday, August 08, 2010 5:13 PM
To: Yossi Weihs
Cc: netfilter-devel@vger.kernel.org
Subject: RE: newbie: writing custom target, need help with getting it to
work

On Sunday 2010-08-08 23:09, Yossi Weihs wrote:

>I have added the env variable, but saw no change.

Make sure that xt_TAP.ko is then actually loaded.

>going on? I know my module is calling xt_register_targets(), is there a 
>way for me to check the contents of its tables?

iptables -vvL

should print the semi-raw dump of the table before trying to resolve 
targets.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


