From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Query abt updation of byte/pkt counters with multiple processors
Date: Sun, 22 Feb 2004 17:02:52 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402221656300.17860-100000@filer.marasystems.com>
References: <1077368009.20114.11.camel@vijay>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Vijaya Chandra Vupputuri <vijay@tachyontech.net>
In-Reply-To: <1077368009.20114.11.camel@vijay>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 21 Feb 2004, Vijaya Chandra Vupputuri wrote:

> A cursory glance at the ip_tables source shows that a separate copy of
> the set of rules is made for every cpu.
> Does this include the byte and packet counters as well?

Yes.

The reason to this is to avoid CPU cache ping-pong effect due to both CPUs 
writing in the same memory area.

> If yes, how is the updation of the counters done upon receival of pkts,
> so that we have the same value in all the sets?

It doesn't.

At best it sums the counters of the CPUs when you read them with 
iptables, but I am not entirely sure this is done.

What I do remember and related to this is that the limit match is
defenitely running per CPU, and when you read the status using iptables 
only the limit couters of the dirst CPU is reported.

Regards
Henrik
