From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables-save counters on builtin chains not restored?
Date: Sat, 21 Aug 2004 02:01:44 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408210143150.8001@filer.marasystems.com>
References: <20040817211821.GE23109@eychenne.org> <20040819101314.GD3921@sunbeam.de.gnumonks.org>
 <20040820143617.GD4883@eychenne.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Harald Welte <laforge@netfilter.org>,
   Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20040820143617.GD4883@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 20 Aug 2004, Herve Eychenne wrote:

> The side effect of this change will be that dump files created by new
> iptables-save command (without -c) won't be restorable with old
> iptables-restore (without -c).

Are you sure? From what I can see this should work. I never specify 
counters in my iptables-restore input from what I can tell.. not on 
policies, not in rules. And it works just fine.

iptables-restore -c without having counters specified in policies or 
custom chains complains, but I never use this so I don't care, and what 
would the point be?

What would break is reading in output from new iptables-save (with or 
without -c) using old iptables-restore -c.

> One thing that puzzles me is that old iptables-restore -c used to
> restore old iptables-save (without -c) dumps without any complaints
> about missing counters (for rules, as counters for builtin-chains were
> dumped anyway).

This is due to the parser nor caring if -c is specified or not when 
parsing the rules. It always parse the counters if there is any (in_table 
block), it then discards the result if -c is not specified.

> So I guess new iptables-restore -c should act likewise, that is
> restore new iptables-save dumps (without -c) without error, but shouldn't
> it at least issue a warning about the lack of the expected counters?

Why? Is there a problem with reading a missing counter as an implicit 
zero?

Regards
Henrik
