From: Vineet Mehta <extreme@zayanionline.com>
Subject: Re: Query abt updation of byte/pkt counters with multiple processors
Date: Mon, 23 Feb 2004 09:04:01 +0300 (AST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402230902230.15581-100000@sillypoint.zayanionline.com>
References: <Pine.LNX.4.44.0402221656300.17860-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Vijaya Chandra Vupputuri <vijay@tachyontech.net>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0402221656300.17860-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 22 Feb 2004, Henrik Nordstrom wrote:

> On Sat, 21 Feb 2004, Vijaya Chandra Vupputuri wrote:
> 
> > A cursory glance at the ip_tables source shows that a separate copy of
> > the set of rules is made for every cpu.
> > Does this include the byte and packet counters as well?
> 
> Yes.
> 
> The reason to this is to avoid CPU cache ping-pong effect due to both CPUs 
> writing in the same memory area.
> 
> > If yes, how is the updation of the counters done upon receival of pkts,
> > so that we have the same value in all the sets?
> 
> It doesn't.
> 
> At best it sums the counters of the CPUs when you read them with 
> iptables, but I am not entirely sure this is done.

in ip_tables.c, get_counters() function this is done. It sums for all 
CPU's in the system.

> 
> What I do remember and related to this is that the limit match is
> defenitely running per CPU, and when you read the status using iptables 
> only the limit couters of the dirst CPU is reported.
> 
> Regards
> Henrik
> 
> 
