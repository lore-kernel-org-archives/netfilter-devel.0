From: Ranjeet Shetye <ranjeet.shetye2@zultys.com>
Subject: Re: Reg Connection Tracking
Date: 17 Jan 2003 09:17:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1042791460.1694.38.camel@knoppix>
References: <20030117094029.77519.qmail@web41502.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Amit Kumar <amitkumargupta_wip@yahoo.com>
In-Reply-To: <20030117094029.77519.qmail@web41502.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi,

If you've written your own NAT, then I guess my answers can only be
generic at best, cos I dont know the details of your NAT implementation
e.g. what part of the ICMP packet is used to uniquely identify a flow of
ICMP packets, how do you do conn-tracking for the NAT, etc. Sorry about
that.

I'll think about this and come up with some more Q/A if I can.

Is your ping utility a standard issue ping from the linux/gnu/bsd suite
or is that also something you guys have written on your own ?

Did your first test setup work flawlessly ? and only the second one has
problems ? or did they both have problems ?

take care,
Ranjeet.

On Fri, 2003-01-17 at 10:40, Amit Kumar wrote:
> 
> Hi,
> Well First thing is I am not using LOCAL NAT. I am using NAT for the external outgoing traffic from inhome and RG uses that to convert to valid IP address. Another thing is I am not using NAT available with LINUX. We have wriiten our own NAT, which we have already tested.
> Answer to 2nd que is :- I don't know whether ping packet is properly created. 
> I also think that ping packet is not getting created properly but i am not sure. I am not using static routing. Well in certain conditions we can switch on the asymmetric routing, but we are not hitting those conditions now.
> We have already tested however this stuff on one test setup and this is the second one on which the differences are :-
> (1) Different vedor board which i think will not have any effect.
> (2) Different Linux Source version. Previously we tested with 2.4.2 and 2.4.5 sources and here it's 2.4.3
> (3) CONFIG_SYSCTL is disabled.
> But i think the above 3 changes should not effect it.
> Regards,
> Amit
>  
>  Ranjeet Shetye <ranjeet.shetye2@zultys.com> wrote:
> Things to verify:
> 1. Do you have local NAT on i.e. NAT for traffic from the machine itself
> ?
> 2. Is your ping packet being created in the proper manner ?
> 
> Sounds like your request packets and reply packets are being seen by the
> netfilter on two different interface. or the ping packet contents that
> are used by conntrack are not being created correctly. e.g type, id and
> code. If any of those are messed up, your conntrack will start going
> beserk cos the replies cannot be matched back to the original traffic. 
> 
> Look at the CONFIG_IP_NF_LOCAL_NAT option and your routing tables. Do
> you have any static routes or other conditions that can asymmetric
> routing ?
> 
> Ranjeet.
> 
> 
> 
> 
> 
> ---------------------------------
> Do you Yahoo!?
> Yahoo! Mail Plus - Powerful. Affordable. Sign up now
