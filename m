From: Patrick Schaaf <bof@bof.de>
Subject: Re: owner based routing
Date: Mon, 10 Oct 2005 07:05:05 +0200
Message-ID: <20051010050505.GD9644@oknodo.bof.de>
References: <226310304.20051010005011@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ignatich <ignatich@gmail.com>
Content-Disposition: inline
In-Reply-To: <226310304.20051010005011@gmail.com>
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

> Is it possible to configure owner-based routing via some other way?

It is possible to solve what you described without any reference
to who owns which processes on the router...

You want to learn about policy routing. Read all of www.lartc.org.
When you still have problems, ask a _users_ mailing list or newsgroup.

Roughly, you want to formulate a solution to your task which is based on
looking at IP addresses, and network interface names, only.

The best you can do with owner, and the overall concept of a
process-identity-based firewall functionality, is to forget about it.

> If  not then how much work required to make ipt_owner work in PREROUTING
> table?

Very much work. At PREROUTING, we don't even know whether the packet
will be for the local machine or another one behind the router...

> Does netfilter team plan to add such functionality?

As far as I know, no. To the contrary: functionality is removed.

> I'm no
> linux kernel programmer but experienced with C so I might be able to
> help if that's not very complicated.

It is very complicated.

When processing packets in the kernel, especially for receive, the concept
of a user level process does not make much sense, if you look at it in
detail. At the moment the packet is received (and netfiltered), there
isn't even a guarantee that the process that will ultimately handle it,
already exists!

best regards
  Patrick
