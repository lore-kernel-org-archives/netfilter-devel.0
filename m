From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: ebtables v/s arptables
Date: Fri, 15 Jun 2007 08:35:04 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706150833230.27797@fbirervta.pbzchgretzou.qr>
References: <d41814cf0706130120x5609dfc2o285a07ceda1ba21b@mail.gmail.com>
	<1181755998.2976.1.camel@localhost.localdomain>
	<d41814cf0706140125i52cef5a6u6e73ab3395290e35@mail.gmail.com>
	<1181837804.2972.16.camel@localhost.localdomain>
	<d41814cf0706142221u735ff9a8v1b1debf802c3f400@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Bart De Schuymer <bdschuym@pandora.be>
To: pankaj jain <jainp1979@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <d41814cf0706142221u735ff9a8v1b1debf802c3f400@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


On Jun 15 2007 10:51, pankaj jain wrote:
>
> Hi Bart,
> Do I have to create a bridge to use "arpreply --arpreply-mac <MAC
> address>" as a target.
> I am asking this because I was not getting arp responses from the
> machine where I inserted the ebtable rule but did not create a bridge.

Of course. Ebtables works ONLY with bridges. So you create
your regular eth0 or whatever, give it its ip address, and
create a br0 device that binds eth0, but do not give br0
any address. (That's how one preferably does it if you only
need arpreply.)

And don't top post.


	Jan
-- 
