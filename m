From: agashi shipora <gashipo@gmail.com>
Subject: Re: uisng L7 filter in ebtables commands
Date: Thu, 1 Apr 2010 15:18:52 +0530
Message-ID: <z2t861e3bca1004010248z4bbaf9b7ld414baa09a4153ff@mail.gmail.com>
References: <x2v861e3bca1003311124sa0aa2ab6y94fa42c650ef16f8@mail.gmail.com>
	 <4BB4427A.3020706@pandora.be>
	 <n2z861e3bca1004010050j7063cee8ya8c27ac73458b8bf@mail.gmail.com>
	 <alpine.LSU.2.01.1004010958390.18225@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.01.1004010958390.18225@obet.zrqbmnf.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi ,

The customizations in the linux kernel are provided as binary
modules(libraries) hence making CONFIG_BRIDGE_NETFILTER work is been
ruled out.  Thats why I am looking for L7 filter support directly by
ebtables.

Thanks
GP


On Thu, Apr 1, 2010 at 1:30 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Thursday 2010-04-01 09:50, agashi shipora wrote:
>>
>>Whereas in the linux kernel source I am working with (which is also
>>2.6.30 but customized) CONFIG_BRIDGE_NETFILTER option , though present
>>in the "make menuconfig" for selection is not compatible with the
>>customizations , hence results in crash.
>
> So the crash is a result of your own modification, so as far as I
> can see, you should fix that, given it's working in a standard kernel.
>
