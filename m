From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: arptables ruleset not working when compiling on  fedora6,7,8/centos
 5/redhat 5
Date: Mon, 6 Jul 2009 22:01:37 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907062200500.27775@fbirervta.pbzchgretzou.qr>
References: <b2d58cb80906290712k33c1ebbvfc8e661cb34c502c@mail.gmail.com>  <56378e320906290721i63f969edm90aed19619decf71@mail.gmail.com>  <b2d58cb80906290751j7fb3976bx9d04fed852c8b451@mail.gmail.com>  <4A48D6AD.4010005@trash.net>
 <b2d58cb80906290818t66616f70k2fe7596b906a8a4e@mail.gmail.com>  <4A48E14A.3060708@trash.net>  <b2d58cb80906290918q2da5af1ap87772755b3363032@mail.gmail.com> <b2d58cb80906300108q2ee5a060gf8013a88560d8820@mail.gmail.com> <4A4B32C4.8050800@trash.net>
 <4A50A3BA.8060905@pandora.be> <alpine.LSU.2.00.0907051758550.22722@fbirervta.pbzchgretzou.qr> <4A52567A.3080202@pandora.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Nishit Shah <nsshah.82@gmail.com>,
	Richard Horton <arimus.uk@googlemail.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4A52567A.3080202@pandora.be>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Monday 2009-07-06 21:54, Bart De Schuymer wrote:

> Jan Engelhardt schreef:
>>> Nishit, please try the attached file. It uses more recent kernel headers that
>>> use x_tables. I prefer that approach...
>>>    
>>
>> You need to use the unifdef'ed headers or funny things like
>> compiler complaining about __user might pop up.
>>  
> The tarball I sent compiled fine on my (old) system. Does it give such warnings
> on your system?

You bet. iptables was also cursed by this [our own lack of using
unifdefed headers from the start] before:


$ make
cc -O2 -Wall -Wunused -I.//include/ -Iinclude/ -DARPTABLES_VERSION=\"0.0.3-4\"
-c -o arptables-standalone.o arptables-standalone.c
In file included from .//include/libarptc/libarptc.h:6,
                 from .//include/arptables.h:5,
                 from arptables-standalone.c:38:
.//include/linux/netfilter_arp/arp_tables.h:19:28: error: linux/compiler.h: No
such file or directory
In file included from .//include/libarptc/libarptc.h:6,
                 from .//include/arptables.h:5,
                 from arptables-standalone.c:38:
.//include/linux/netfilter_arp/arp_tables.h:183: error: expected `:', `,', `;',
`}' or `__attribute__' before `*' token
make: *** [arptables-standalone.o] Error 1
