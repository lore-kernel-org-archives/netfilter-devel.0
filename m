From: "pankaj jain" <jainp1979@gmail.com>
Subject: Re: ebtables v/s arptables
Date: Mon, 18 Jun 2007 17:47:18 +0530
Message-ID: <d41814cf0706180517v58e4aa98r687e6ee957524c25@mail.gmail.com>
References: <d41814cf0706130120x5609dfc2o285a07ceda1ba21b@mail.gmail.com>
	<1181755998.2976.1.camel@localhost.localdomain>
	<d41814cf0706140125i52cef5a6u6e73ab3395290e35@mail.gmail.com>
	<1181837804.2972.16.camel@localhost.localdomain>
	<d41814cf0706142221u735ff9a8v1b1debf802c3f400@mail.gmail.com>
	<Pine.LNX.4.64.0706150833230.27797@fbirervta.pbzchgretzou.qr>
	<d41814cf0706142341m427b0c56p6ade6d2f3925cd15@mail.gmail.com>
	<Pine.LNX.4.64.0706150855530.27797@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706150855530.27797@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
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

On 6/15/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jun 15 2007 12:11, pankaj jain wrote:
> > Hi Jan,
> > I am sorry I did not get the meaning of last line "And don't top post."
> >
> > I would also want to know is there any theoretical limit on number of
 > > iptable , ebtable, arptable rules we can set?
>
> I was able to add about 320K dummy rules. Might depend on memory.
>
>
>         Jan
> --
>

HI Jan,
As I was using arptables for responding arp-requests, I did not plumb
the interfaces on my machine.
Now I want to add a gateway from the same subnet, for example:
I am sending arp responses for 203.200.192.24 (sorry if some one has
this IP) using arp tables so I have not plumbed this IP on my
interface
Now I want to add a gateway e.g. 203.200.192.1 in the route table
"ip route add default via  203.200.192.1 dev eth0 table 10"
but when I try this it says
RTNETLINK answers: Network is unreachable

please suggest some solution.
-- 
Thanks
Pankaj Jain
