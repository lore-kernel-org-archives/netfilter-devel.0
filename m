From: Patrick Schaaf <bof@bof.de>
Subject: how trustworthy is the current iptables user/kernel interface?
Date: Thu, 4 Jul 2002 09:30:35 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020704093035.D10726@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi list,

I need your advice on this:

Imagine there would be a new iptables table, independant of filter/mangle/nat.
Let's call it the 'ctx' table. This new table has one chain, OUTPUT, and a
subset of the current matches and targets is available in rules defined
for that table.  The ctx OUTPUT chain would work like the filter table
OUTPUT chain, and probably come just before that.

Next, imagine that we had a mechanism to group processes into so-called
contexts [1]. The new 'ctx' table would be per-context, with copy-on-write
sharing when new process contexts are created.

Now, imagine that suser() non-CAP_NET_ADMIN processes, while disallowed to
muddle with the filter, nat, and mangle tables, would be permitted to
modify the new 'ctx' table. If it is shared with a parent context at
the first modification, a copy is made private to the context of the
calling process. Oh, and add a nonreversible mechanism to "lock" the
context private table against further modifications.

The questions to people who know the implementation innards, are:

- can the incoming table validator in the kernel be trusted far enough?
- same question for each match and target made available to iptable_ctx?
- what are the matches/targets keeping global state? those would probably
  better not be available.

thanks in advance for all your thoughts

  Patrick

[1] ftp://ftp.solucorp.qc.ca/pub/vserver/
