From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bug (?) in ipt_reject doesn't follow policy routing (2.4.x)
Date: Mon, 14 Apr 2003 10:49:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E9A7603.6030607@trash.net>
References: <Pine.LNX.4.21.0304132035370.31823-100000@debian.besselink> <20030414075933.GJ18520@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Leen Besselink <leen@wirehub.nl>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030414075933.GJ18520@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf wrote:

>Maybe, if you can answer these questions, we'll be able to understand
>your problem. Maybe somebody can do that even without those answers,
>but the silence you received up to now indicates that's unlikely.
>  
>

May I ? ;)

Without beeing specific to his setup, the problem he describes is
that ipt_REJECT (and others) always choose lsrc to be 0 if it's 
non-local for
the routing decision. I'll just make a simple example:

Routing Rules (incomplete):
1000: from 10.0.0.0/8 lookup abc
32766:  from all lookup main

Routing tables (incomplete):
abc: default via 192.168.0.1 dev eth0
main: default via 172.20.0.1 dev eth1

So all packets except those with src=10.0.0.0/8 should go through 
172.20.0.1.
When ipt_REJECT send a reject for any non-local address in 10.0.0.0/8 it 
chooses
lsrc=0 for the routing lookup, so it ends up with default route of table 
main
instead of table abc.

I wonder why ip_route_input isn't used, this should eliminate the need for
using different information from what is contained in the actual packet for
the routing lookup ..

Bye,
Patrick
