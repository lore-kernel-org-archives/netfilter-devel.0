From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Wed, 17 Mar 2004 12:16:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1079522164.812.93.camel@nienna.balabit>
References: <Pine.LNX.4.33.0403121424070.20054-100000@blackhole.kfki.hu>
	 <1079458116.843.62.camel@nienna.balabit>  <1079516281.4874.11.camel@vijay>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Vijaya Chandra Vupputuri <vijay@tachyontech.net>
In-Reply-To: <1079516281.4874.11.camel@vijay>
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

On Wed, 2004-03-17 at 10:38, Vijaya Chandra Vupputuri wrote:
> 've tried to do the same but I don't seem to have any problem on a test
> box with redhat 7.3 (2.4.18-3)

  I think the problem is present only on kernels > 2.4.22. This is
because of a fix in 2.4.23 which changed when alloc_null_binding() is
called. In 2.4.22, alloc_null_binding() is called even when
CONFIG_IP_NF_LOCAL_NAT is off, while in 2.4.23 (and above) it's only
called when CONFIG_IP_NF_LOCAL_NAT is turned on. I don't know if it
matters or not with respect to this problem.

> If I understood what you said properly the following is your setup,
> the ip of the test box is 10.1.0.1 and you have a lan 10.1.0.0/16 whose
> gateway is 10.1.0.1
> on 10.1.0.1 you redirect any traffic to port 80 to the local port 8080

  Yes, this is the setup. (Although this is a virtual setup using UML,
but it shouldn't matter at all.)

> now if 10.1.0.2 tries to connect to, say, 216.239.41.104 it gets
> redirected to the port 8080 on 10.1.0.1

  Yes, in theory. To trigger the bug, you should connect _from_ the
gateway to itself. (Note that the ruleset is somewhat flawed, since it
should redirect only traffic coming in through the LAN interface.) I
used netcat to connect:

# nc 10.1.0.1 80

> but, from 10.1.0.2, if you try to connect directly to port 80 on
> 10.1.0.1, with your setup where nothing is listening on 80, the box
> would hang. am i right?!

  It does not matter if there is something listening on port 80. I think
it wasn't clear from my previous mail that you have to connect _from_
the gateway, and not from the attached 10.1.0.0/16 LAN.

-- 
 Regards,
   Krisztian KOVACS
