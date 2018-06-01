From: Florian Westphal <fw@strlen.de>
Subject: [RFC nf-next 0/5] netfilter: add ebpf translation infrastructure
Date: Fri,  1 Jun 2018 17:32:11 +0200
Message-ID: <20180601153216.10901-1-fw@strlen.de>
Cc: ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
To: <netfilter-devel@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch series adds a JIT layer to translate nft expressions
to ebpf programs.

>From commit phase, spawn a userspace program (using recently added UMH
infrastructure).

We then provide rules that came in this transaction to the helper via pipe,
using same nf_tables netlink that nftables already uses.

The userspace helper translates the rules, and, if successful, installs the
generated program(s) via bpf syscall.

For each rule a small response containing the corresponding epbf file
descriptor (can be -1 on failure) and a attribute count (how many
expressions were jitted) gets sent back to kernel via pipe.

If translation fails, the rule is will be processed by nf_tables
interpreter (as before this patch).

If translation succeeded, nf_tables fetches the bpf program using the file
descriptor identifier, allocates a new rule blob containing the new 'ebpf'
expression (and possible trailing un-translated expressions).

It then replaces the original rule in the transaction log with the new
'ebpf-rule'.  The original rule is retained in a private area inside the epbf
expression to be able to present the original expressions back to userspace
on 'nft list ruleset'.

For easier review, this contains the kernel-side only.
nf_tables_jit_work() will not do anything, yet.

Unresolved issues:
 - maps and sets.
   It might be possible to add a new ebpf map type that just wraps
   the nft set infrastructure for lookups.
   This would allow nft userspace to continue to work as-is while
   not requiring new ebpf helper.
   Anonymous set should be a lot easier as they're immutable
   and could probably be handled already by existing infra.

 - BPF_PROG_RUN() is bolted into nft main loop via a middleman expression.
   I'm also abusing skb->cb[] to pass network and transport header offsets.
   Its not 'public' api so this can be changed later.

 - always uses BPF_PROG_TYPE_SCHED_CLS.
   This is because it "works" for current RFC purposes.

 - we should eventually support translating multiple (adjacent) rules
   into single program.

   If we do this kernel will need to track mapping of rules to
   program (to re-jit when a rule is changed.  This isn't implemented
   so far, but can be added later.  Alternatively, one could also add a
   'readonly' table switch to just prevent further updates.

   We will also need to dump the 'next' generation of the
   to-be-translated table.  The kernel has this information, so its only
   a matter of serializing it back to userspace from the commit phase.

The jitter is still limited.  So far it supports:

 * payload expression for network and transport header
 * meta mark, nfproto, l4proto
 * 32 bit immediates
 * 32 bit bitmask ops
 * accept/drop verdicts

As this uses netlink, there is also no technical requirement for
libnftnl, its simply used here for convienience.

It doesn't need any userspace changes. Patches for libnftnl and nftables
make debug info available (e.g. to map rule to its bpf prog id).

Comments welcome.

Florian Westphal (5):
      bpf: add bpf_prog_get_type_dev_file
      netfilter: nf_tables: add ebpf expression
      netfilter: nf_tables: add rule ebpf jit infrastructure
      netfilter: nf_tables_jit: add dumping of original rule
      netfilter: nf_tables_jit: add userspace nft to ebpf translator

 include/linux/bpf.h                              |   11 
 include/net/netfilter/nf_tables_core.h           |   22 
 include/uapi/linux/netfilter/nf_tables.h         |   18 
 kernel/bpf/syscall.c                             |   18 
 net/netfilter/Kconfig                            |    7 
 net/netfilter/Makefile                           |    5 
 net/netfilter/nf_tables_api.c                    |   16 
 net/netfilter/nf_tables_core.c                   |   61 +
 net/netfilter/nf_tables_jit.c                    |  242 +++
 net/netfilter/nf_tables_jit/Makefile             |   19 
 net/netfilter/nf_tables_jit/imr.c                | 1401 +++++++++++++++++++++++
 net/netfilter/nf_tables_jit/imr.h                |   96 +
 net/netfilter/nf_tables_jit/main.c               |  579 +++++++++
 net/netfilter/nf_tables_jit/nf_tables_jit_kern.c |  175 ++
 14 files changed, 2670 insertions(+)
