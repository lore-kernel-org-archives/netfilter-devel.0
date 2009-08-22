From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCEMENT] ipset-3.2
Date: Sun, 23 Aug 2009 00:21:43 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908222330200.2057@fbirervta.pbzchgretzou.qr>
References: <alpine.DEB.2.00.0908211609150.6879@blackhole.kfki.hu>  <alpine.LSU.2.00.0908212012250.24079@fbirervta.pbzchgretzou.qr>  <alpine.DEB.2.00.0908221527190.7819@blackhole.kfki.hu>  <alpine.LSU.2.00.0908221549540.11168@fbirervta.pbzchgretzou.qr>
 <1250969455.12729.4.camel@kushiel.sterenborg.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Rob Sterenborg <rob@sterenborg.info>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <1250969455.12729.4.camel@kushiel.sterenborg.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Saturday 2009-08-22 21:30, Rob Sterenborg wrote:

>On Sat, 2009-08-22 at 15:57 +0200, Jan Engelhardt wrote:
>> Ah right. CentOS. Should have known. The platform where you can't
>> deploy any modules, because during their backport spree, they failed
>> to realize that external modules do rely on, say, < 2.6.22 _not_
>> having skb_*_header(), but skb->nh. I've given up on them.
>> 
>> But thanks for the reminder. :)
>
>Since, as far as I understood, Centos is supposed to be a free and as
>much as possible binary compatible replacement for RHEL, does this also
>go for RHEL or is this behaviour Centos specific?

With high probability this breakage extends to all RedHat Enterprise 
products with 2.6.18.
(As a side note, they are not running a -stable either.
v2.6.18.4-7-gfaed318 is absent, for example.)
