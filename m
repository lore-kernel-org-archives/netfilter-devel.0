From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Tue, 16 Mar 2004 18:28:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1079458116.843.62.camel@nienna.balabit>
References: <Pine.LNX.4.33.0403121424070.20054-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0403121424070.20054-100000@blackhole.kfki.hu>
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

On Fri, 2004-03-12 at 14:30, Jozsef Kadlecsik wrote:
> >   Jozsef, and others pursuing this ugly thing. Please take a look at
> > http://lists.netfilter.org/pipermail/netfilter-devel/2004-March/014442.html
> > and probably the thread about find_appropriate_src(). I'd be really glad
> > to have someone answer it, or somehow show some interest in it.
> 
> I'll try to look at it. Unfortunately at the moment I'm very busy with
> issues from the institute I work for. Sigh. Hopefully I'll find some
> time-slot...

  I can reliably reproduce the bug. One of the IPs of the host is
10.1.0.1. Only one NAT rule is needed:

# iptables -t nat -A PREROUTING -p tcp -s 10.1.0.0/16 --dport 80 -j
REDIRECT --to-ports 8080

  Then try to connect to port 80 of 10.1.0.1. The connection gets stuck
in SYN_SENT state, and when it times out, corrupts its REPLY_DIR hash
chain. Note that LOCAL_NAT is _off_, so this connection won't have a
null binding allocated.

-- 
 Regards,
   Krisztian KOVACS
