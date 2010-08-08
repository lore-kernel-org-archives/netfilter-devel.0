From: "Yossi Weihs" <yw@seafire.com>
Subject: RE: newbie: writing custom target, need help with getting it to work
Date: Sun, 8 Aug 2010 17:09:07 -0400
Message-ID: <011101cb373d$f0b6b6b0$d2242410$@com>
References: <00fe01cb3737$19358d20$4ba0a760$@com> <alpine.LSU.2.01.1008082225540.14264@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: <netfilter-devel@vger.kernel.org>
To: "'Jan Engelhardt'" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns2.server274.com ([64.14.68.54]:34251 "EHLO server274.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751835Ab0HHVKN convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Aug 2010 17:10:13 -0400
In-Reply-To: <alpine.LSU.2.01.1008082225540.14264@obet.zrqbmnf.qr>
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks Jan!

I have added the env variable, but saw no change. My libxt_TAP.so is getting found as it is checking my parameter. I have tried a different xtables_addons target such as TEE, and the rule gets inserted fine. I had SELinux block my libxt_TAP.so and had added it to the SELinux rules, so that shouldn't be a problem. Any other idea what might be going on? I know my module is calling xt_register_targets(), is there a way for me to check the contents of its tables?

Thanks for looking at my code! I'll switch my mutex to a spinlock - I'd be wasting a lot of time once I get running with this without your help.

Yossi Weihs

-----Original Message-----
From: Jan Engelhardt [mailto:jengelh@medozas.de] 
Sent: Sunday, August 08, 2010 4:29 PM
To: Yossi Weihs
Cc: netfilter-devel@vger.kernel.org
Subject: Re: newbie: writing custom target, need help with getting it to work

On Sunday 2010-08-08 22:20, Yossi Weihs wrote:

>Hi List,
>
>I have been working on a custom netfilter target to help with some in-house
>testing. I?m running Fedora 13 and building within xtables-addons v 1.2.6 ;
>I have gotten both the kernel module and library to build correctly within
>the xtables-addons build enviroment, and am inserting the kernel module with
>no errors. When trying to create a rule with my target, I get the cryptic
>error:
>
>iptables --verbose --table filter --insert INPUT --protocol TCP -m state
>--state ESTABLISHED --jump TAP --device TAPPY
>TAP  tcp opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  state ESTABLISHED TAP
>dev:TAPPY 
>iptables: No chain/target/match by that name.

When you want iptables to recognize (the user portion) of Xt-a's extra 
modules, you need to point to it via the XTABLES_LIBDIR environment 
variable.

XTABLES_LIBDIR=$HOME/xta/extensions:/usr/lib(64)/xtables iptables -S

Don't forget usr/lib/xtables otherwise it won't find the tcp match and 
all the ones that already ship with iptables.



