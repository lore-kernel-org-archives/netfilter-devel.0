From: agashi shipora <gashipo@gmail.com>
Subject: Re: uisng L7 filter in ebtables commands
Date: Thu, 1 Apr 2010 13:20:56 +0530
Message-ID: <n2z861e3bca1004010050j7063cee8ya8c27ac73458b8bf@mail.gmail.com>
References: <x2v861e3bca1003311124sa0aa2ab6y94fa42c650ef16f8@mail.gmail.com>
	 <4BB4427A.3020706@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f179.google.com ([209.85.222.179]:56027 "EHLO
	mail-pz0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab0DAHu5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:50:57 -0400
In-Reply-To: <4BB4427A.3020706@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi ,

Sorry I forget to mention one more constraint with the linux kernel
source base I am working with.

In the general linux 2.6.30 kernel , iptables are introduced into the
bridge path by selecting the CONFIG_BRIDGE_NETFILTER  option at
compile time which selects the br_netfilter.c which invokes the
traversal of iptables. Also the CONFIG_BRIDGE_NF_EBTABLES option is
dependent on  CONFIG_BRIDGE_NETFILTER being selected.

Whereas in the linux kernel source I am working with (which is also
2.6.30 but customized) CONFIG_BRIDGE_NETFILTER option , though present
in the "make menuconfig" for selection is not compatible with the
customizations , hence results in crash.Here also
CONFIG_BRIDGE_NF_EBTABLES has been made independent of
CONFIG_BRIDGE_NETFILTER.

So as you can see one doesn't have the luxury of iptables in the
bridging path.Hence unable to use the L7 filter with iptables in the
bridging path.

I wasn't aware of the option of setting
/proc/sys/net/bridge/bridge-nf-call-iptables to 1 . But i think this
must be  same as selecting CONFIG_BRIDGE_NETFILTER and hence
br_netfilter.c.

Thanks
GP







On Thu, Apr 1, 2010 at 12:21 PM, Bart De Schuymer <bdschuym@pandora.be> wrote:
> agashi shipora wrote:
>> I want to use L7 filter with ebtables for setting a MARK on the packet
>> similar to how it is being done with iptables today.
>>
>> Using brouting the bridge packet can be re-directed to the routing
>> path traversing the iptables.But all packets arriving on the interface
>> enslaved to the bridge would have to be brouted.This may not be
>> acceptable as a solution in my case.
>>
>> example:
>> Whats available:
>> iptables -t filter -A FORWARD -m layer7 --l7proto edonkey -j MARK --set-mark 3
>>
>> What needs to be supported:
>> ebtables -t nat -A PRE-ROUTING -m layer7 --l7proto edonkey -j MARK --mark-set 3
>>
>> Is any work going on to port L7 filter to ebtables or does this port
>> of L7 filter already exist?
>>
>
> You can use iptables to filter bridged IP traffic, so I don't see the
> problem. Just make sure /proc/sys/net/bridge/bridge-nf-call-iptables
> contains 1. No need for brouting.
>
> cheers,
> Bart
>
>
> --
> Bart De Schuymer
> www.artinalgorithms.be
>
