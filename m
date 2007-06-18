From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: ebtables v/s arptables
Date: Mon, 18 Jun 2007 14:25:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706181425170.5731@fbirervta.pbzchgretzou.qr>
References: <d41814cf0706130120x5609dfc2o285a07ceda1ba21b@mail.gmail.com>
	<1181755998.2976.1.camel@localhost.localdomain>
	<d41814cf0706140125i52cef5a6u6e73ab3395290e35@mail.gmail.com>
	<1181837804.2972.16.camel@localhost.localdomain>
	<d41814cf0706142221u735ff9a8v1b1debf802c3f400@mail.gmail.com>
	<Pine.LNX.4.64.0706150833230.27797@fbirervta.pbzchgretzou.qr>
	<d41814cf0706142341m427b0c56p6ade6d2f3925cd15@mail.gmail.com>
	<Pine.LNX.4.64.0706150855530.27797@fbirervta.pbzchgretzou.qr>
	<d41814cf0706180517v58e4aa98r687e6ee957524c25@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: pankaj jain <jainp1979@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <d41814cf0706180517v58e4aa98r687e6ee957524c25@mail.gmail.com>
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


On Jun 18 2007 17:47, pankaj jain wrote:
> Now I want to add a gateway e.g. 203.200.192.1 in the route table
> "ip route add default via  203.200.192.1 dev eth0 table 10"
> but when I try this it says
> RTNETLINK answers: Network is unreachable

You do no thave a route to 203.200.192.1.



	Jan
-- 
