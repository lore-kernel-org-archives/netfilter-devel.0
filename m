From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Google SoC, Optimized netfilter implementation
Date: Wed, 1 Apr 2009 10:11:03 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904010954020.24746@fbirervta.pbzchgretzou.qr>
References: <daf8006b0903311912g2c83d221w68197954d1e08d0d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Shreyas Bhatewara <shreyas.bhatewara@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45187 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbZDAILH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:11:07 -0400
In-Reply-To: <daf8006b0903311912g2c83d221w68197954d1e08d0d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-04-01 04:12, Shreyas Bhatewara wrote:
>
>I am composing a proposal for this project to be submitted at Google
>SoC. Could anyone brief me about what you mean by "dynamic code
>generation" (https://www.linuxfoundation.org/en/Google_Summer_of_Code_2009#Optimized_netfilter_implementation).
>It would be great if you could point me to some document/repository
>path which talks about this.

Umph. Quoting from that page:

"Currently netfilter packet classification is an interpreter that
applies chains of rules to every packet in the system. This can add
thousands of cpu cycles of per packet overhead for a reasonably
simple set of iptables rules.
Dynamic code generation could be used to significantly reduce this
overhead."

It is not as much overhead as one thinks. In fact, Xtables
modules are "hand-crafted" and highly specialized for their task.
They can do something like

	return iph->len >= 256;

in C, which will directly be translated to machine code. On the other
hand, expression based modules like u32 are _much more_ of an
interpreter, as they have to break down

  -m u32 --u32 "0 & 0xFFFF = 0x100:0xFFFF"
	[sic; there seems to be a bug in the u32 manpage
	for testing the layer-3 length.]

i.e. your typical interpreter that loops over tokens and operators
and so on. But see the source of xt_u32.

Sure, dynamic code compilation for expression modules is going to
solve _their_ slowness, but it is not going beyond the specialized
module model that Xtables currently is. You just can't beat the
3 or so ASM instructions emitted on x86 for "iph->len >= 256".
