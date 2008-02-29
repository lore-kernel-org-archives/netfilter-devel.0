From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH (resend)][EBTABLES]: Fix alignment checks in ebt_among.ko
 module.
Date: Fri, 29 Feb 2008 19:46:30 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802291946040.24056@fbirervta.pbzchgretzou.qr>
References: <47C7C23C.2050100@openvz.org> <47C7FF31.1060108@trash.net>
 <Pine.LNX.4.64.0802291639390.24056@fbirervta.pbzchgretzou.qr>
 <1204305793.2923.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Pavel Emelyanov <xemul@openvz.org>,
	David Miller <davem@davemloft.net>,
	Linux Netdev List <netdev@vger.kernel.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1204305793.2923.12.camel@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Feb 29 2008 18:23, Bart De Schuymer wrote:
>Op vr, 29-02-2008 te 16:40 +0100, schreef Jan Engelhardt:
>> > It seems the kernel is correct and userspace is doing it
>> > wrong, so I think userspace should be fixed instead.
>> > The problem with your patch is that is causes misalignment
>> > for following structures that contain u64 members.
>> 
>> ebt_among is a true mess! It hinders my efforts to port ebtables
>> to xtables, but I could of course use a hack and will likely
>> do just that.
>
>Ebtables' dynamic memory allocation scheme is probably not portable to
>iptables. I agree the fix is in userspace. Anyway, I think the author of
>that module did a great job and provided a very useful and often-used
>functionality.

Actually yes, it's kind of a weird mixup of TLV and static blocks :p
