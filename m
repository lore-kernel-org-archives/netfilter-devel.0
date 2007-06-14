From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: ebtables v/s arptables
Date: Thu, 14 Jun 2007 18:16:44 +0200
Message-ID: <1181837804.2972.16.camel@localhost.localdomain>
References: <d41814cf0706130120x5609dfc2o285a07ceda1ba21b@mail.gmail.com>
	<1181755998.2976.1.camel@localhost.localdomain>
	<d41814cf0706140125i52cef5a6u6e73ab3395290e35@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: pankaj jain <jainp1979@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <d41814cf0706140125i52cef5a6u6e73ab3395290e35@mail.gmail.com>
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

Op do, 14-06-2007 te 13:55 +0530, schreef pankaj jain:
> Hi Bart,
> I am quite new to these concepts and tools,
> It would be great if you could please elaborate the statement and
> throw some light on arptables also.
> I believe for ebtables to work , we have to create a bridge interface also.
> without creating a bridge I was not able to respond to arp requests
> for IPs which are with me but are not plumbed on any interface.

That's correct. If you don't need a bridge (you're not forwarding based
on MAC addresses) you should probably not use one. It's possible to get
packets sent to ebtables on a device with only one network interface,
though. See http://ebtables.sourceforge.net/examples.html#ex_nobridge

> Does ip_forwarding have any impact on arptables and ebtables.

No.

cheers,
Bart
