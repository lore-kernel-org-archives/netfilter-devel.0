From: Vijaya Chandra Vupputuri <vijay@tachyontech.net>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Wed, 17 Mar 2004 15:08:02 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1079516281.4874.11.camel@vijay>
References: <Pine.LNX.4.33.0403121424070.20054-100000@blackhole.kfki.hu>
	 <1079458116.843.62.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1079458116.843.62.camel@nienna.balabit>
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

've tried to do the same but I don't seem to have any problem on a test
box with redhat 7.3 (2.4.18-3)

If I understood what you said properly the following is your setup,
the ip of the test box is 10.1.0.1 and you have a lan 10.1.0.0/16 whose
gateway is 10.1.0.1
on 10.1.0.1 you redirect any traffic to port 80 to the local port 8080

now if 10.1.0.2 tries to connect to, say, 216.239.41.104 it gets
redirected to the port 8080 on 10.1.0.1

but, from 10.1.0.2, if you try to connect directly to port 80 on
10.1.0.1, with your setup where nothing is listening on 80, the box
would hang. am i right?!

please do let me know if i've missed anything obvious.

Regards,
Vijaya Chandra Vupputuri,
Tachyon Technologies.

On Tue, 2004-03-16 at 22:58, KOVACS Krisztian wrote:
>   Hi,
> 
> On Fri, 2004-03-12 at 14:30, Jozsef Kadlecsik wrote:
> > >   Jozsef, and others pursuing this ugly thing. Please take a look at
> > > http://lists.netfilter.org/pipermail/netfilter-devel/2004-March/014442.html
> > > and probably the thread about find_appropriate_src(). I'd be really glad
> > > to have someone answer it, or somehow show some interest in it.
> > 
> > I'll try to look at it. Unfortunately at the moment I'm very busy with
> > issues from the institute I work for. Sigh. Hopefully I'll find some
> > time-slot...
> 
>   I can reliably reproduce the bug. One of the IPs of the host is
> 10.1.0.1. Only one NAT rule is needed:
> 
> # iptables -t nat -A PREROUTING -p tcp -s 10.1.0.0/16 --dport 80 -j
> REDIRECT --to-ports 8080
> 
>   Then try to connect to port 80 of 10.1.0.1. The connection gets stuck
> in SYN_SENT state, and when it times out, corrupts its REPLY_DIR hash
> chain. Note that LOCAL_NAT is _off_, so this connection won't have a
> null binding allocated.
