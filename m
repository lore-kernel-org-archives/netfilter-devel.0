From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Wed, 17 Mar 2004 14:04:53 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403171351490.9283-100000@filer.marasystems.com>
References: <1079524124.813.103.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Vijaya Chandra Vupputuri <vijay@tachyontech.net>,
   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1079524124.813.103.camel@nienna.balabit>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 17 Mar 2004, KOVACS Krisztian wrote:

>   I think I've got it. When such a connection is initiated, the SYN goes
> out on the LOCAL_OUT hook, and gets confirmed at POSTROUTING. Then it
> arrives in PREROUTING, where it's NAT-ted according to the REDIRECT
> rule.

Ouch... this (new NAT mappings of an already confirmed session) MUST NOT
happen.

A quick and painless fix unless one wants to enable CONFIG_IP_NF_LOCAL_NAT
would be to not apply NAT to confirmed sessions even if no NAT mapping has
priorly been set up for this connection.

But I am still a little confused... this traffic should have been seen by
the POSTROUTING hook where a null source mapping should have been set up
already for this direction, so the PREROUTING on return traffic should do
nothing. Thinking.. ah, now I get it. The problem is that you are doing
traffic local->local and that the NAT code then gets confused as it sees
the same packet twice in each direction, and as no null mapping was
created the first time for the "local" side PREROUTING tries to when it
sees the traffic coming "in" (from itself).

The solution I mentioned above should workI think, but my gut feeling is
that it would be better to simply have the hooks of CONFIG_IP_NF_LOCAL_NAT
always enabled and not try to optimize local traffic by making it such
special case for NAT to deal with.

Regards
Henrik
