From: "Martin Schiller" <mschiller@tdt.de>
Subject: RE: [PATCH] NAT and requests to unrouted targets
Date: Tue, 20 Mar 2007 12:56:18 +0100
Message-ID: <000f01c76ae6$c5bdc880$1a04010a@V505CP>
References: <000001c766d8$66f1cc00$1a04010a@V505CP> <45F90905.4000408@trash.net> <001101c76711$cf7dc6a0$1a04010a@V505CP> <45FEB411.5050004@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netdev@vger.kernel.org>,
	"'Netfilter Development Mailinglist'"
	<netfilter-devel@lists.netfilter.org>
To: "'Patrick McHardy'" <kaber@trash.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <45FEB411.5050004@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Monday, March 19, 2007 5:02 PM, Patrick McHardy wrote:

> Martin Schiller wrote:
>> To be more exactly, it's the examination of
>> "ct->tuplehash[dir].tuple.dst.u.all !=
>> ct->tuplehash[!dir].tuple.src.u.all" which is only be done if XFRM
>> is configured. Since I don't need this anyway, I deactivated XFRM
>> now and my "ping -I" is working now. 
> 
> 
> Could you try this patch (against current -git) with CONFIG_XFRM
> enabled please? 

I've tried it and the ping is still working now with enabled CONFIG_XFRM.

Thanks for the patch.

Regards,
Martin


