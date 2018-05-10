From: Joe Perches <joe@perches.com>
Subject: [PATCH 00/18] Convert default pr_fmt from empty to KBUILD_MODNAME
Date: Thu, 10 May 2018 08:45:26 -0700
Message-ID: <cover.1525964381.git.joe@perches.com>
Cc: dri-devel@lists.freedesktop.org,
        linux-security-module@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        selinux@tycho.nsa.gov
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

pr_<level> logging uses allow a prefix to be specified with a
specific #define pr_fmt

The default of pr_fmt in printk.h is #define pr_fmt(fmt) fmt
so no prefixing of logging output is generically done.

There are several output logging uses like dump_stack() that are
unprefixed and should remain unprefixed.

This patch series attempts to convert the default #define of pr_fmt to
KBUILD_MODNAME ": " fmt and as well update the various bits of the kernel
that should _not_ be prefixed by adding #define pr_fmt(fmt) fmt to those
compilation units that do not want output message prefixing.

There are about 1200 uses of #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
that could be removed if the default is changed.

A script that does this removal (and removes any blank lines that follow)
for the linux-kernel tree is included below:

$ git grep -P --name-only "define\s+pr_fmt\b" | \
  grep -v include/linux/printk.h | \
  xargs perl -i -e 'local $/; while (<>) {s/(\n)*[ \t]*#[ \t]*define[ \t]+pr_fmt[ \t]*\([ \t]*(\w+)[ \t]*\)[ \t]*KBUILD_MODNAME[ \t]*\": \"[ \t]*\2[ \t]*\n\s*/\1\n/; s/^\n//; print;}'

This script should be run after this patch series is applied.

The above script output diff is currently:

1198 files changed, 70 insertions(+), 2241 deletions(-)

Joe Perches (18):
  kernel: Use pr_fmt
  lib: Use pr_fmt
  printk: Convert pr_fmt from blank define to KBUILD_MODNAME
  x86: Remove pr_fmt duplicate logging prefixes
  x86/mtrr: Rename main.c to mtrr.c and remove duplicate prefixes
  net: Remove pr_fmt duplicate logging prefixes
  blk-mq: Remove pr_fmt duplicate logging prefixes
  random: Remove pr_fmt duplicate logging prefixes
  ptp: Remove pr_fmt duplicate logging prefixes
  efifb: Remove pr_fmt duplicate logging prefixes
  proc: Remove pr_fmt duplicate logging prefixes
  uprobes: Remove pr_fmt duplicate logging prefixes
  printk: Remove pr_fmt duplicate logging prefixes
  lib/mpi: Remove pr_fmt duplicate logging prefixes
  security: Remove pr_fmt duplicate logging prefixes
  aoe: Remove pr_fmt duplicate logging prefixes
  security: encrypted-keys: Remove pr_fmt duplicate logging prefixes
  rcu: Use pr_fmt to prefix "rcu: " to logging output

 arch/x86/events/amd/ibs.c                      |  2 +-
 arch/x86/kernel/cpu/mtrr/Makefile              |  2 +-
 arch/x86/kernel/cpu/mtrr/{main.c => mtrr.c}    | 33 ++++++-------
 arch/x86/kernel/e820.c                         | 32 ++++++------
 arch/x86/kernel/hpet.c                         |  5 +-
 arch/x86/kernel/uprobes.c                      |  4 +-
 arch/x86/mm/numa.c                             | 22 ++++-----
 block/blk-mq.c                                 |  9 ++--
 drivers/block/aoe/aoeblk.c                     | 29 ++++++-----
 drivers/block/aoe/aoechr.c                     | 11 ++---
 drivers/block/aoe/aoecmd.c                     | 34 ++++++-------
 drivers/block/aoe/aoedev.c                     | 19 +++-----
 drivers/block/aoe/aoemain.c                    |  6 +--
 drivers/block/aoe/aoenet.c                     | 19 +++-----
 drivers/char/hw_random/via-rng.c               | 10 ++--
 drivers/char/random.c                          | 16 +++---
 drivers/ptp/ptp_clock.c                        |  4 +-
 drivers/video/fbdev/efifb.c                    | 48 +++++++++---------
 fs/proc/root.c                                 |  6 +--
 include/linux/printk.h                         |  2 +-
 kernel/acct.c                                  |  2 +
 kernel/async.c                                 | 14 +++---
 kernel/audit_tree.c                            |  2 +-
 kernel/backtracetest.c                         |  8 +--
 kernel/crash_core.c                            | 29 ++++++-----
 kernel/events/uprobes.c                        |  3 +-
 kernel/exit.c                                  |  2 +
 kernel/hung_task.c                             | 13 +++--
 kernel/kprobes.c                               | 20 +++++---
 kernel/module.c                                | 59 +++++++++++------------
 kernel/panic.c                                 |  3 ++
 kernel/params.c                                | 13 +++--
 kernel/pid.c                                   |  2 +
 kernel/printk/printk.c                         |  2 +-
 kernel/profile.c                               |  2 +
 kernel/range.c                                 |  2 +-
 kernel/rcu/rcu_segcblist.c                     |  2 +
 kernel/rcu/rcuperf.c                           | 10 ++--
 kernel/rcu/rcutorture.c                        | 46 +++++++++---------
 kernel/rcu/srcutiny.c                          |  2 +
 kernel/rcu/srcutree.c                          |  5 +-
 kernel/rcu/tiny.c                              |  3 ++
 kernel/rcu/tree.c                              |  8 +--
 kernel/rcu/tree_plugin.h                       | 67 +++++++++++++++-----------
 kernel/rcu/update.c                            | 19 +++++---
 kernel/relay.c                                 |  5 +-
 kernel/seccomp.c                               |  4 +-
 kernel/signal.c                                | 10 ++--
 kernel/smpboot.c                               |  5 +-
 kernel/taskstats.c                             |  4 +-
 kernel/torture.c                               |  6 ++-
 kernel/tracepoint.c                            |  3 ++
 kernel/workqueue.c                             |  2 +
 lib/cpu_rmap.c                                 | 15 +++---
 lib/crc32test.c                                |  2 +
 lib/earlycpio.c                                |  5 +-
 lib/find_bit_benchmark.c                       |  2 +
 lib/kobject.c                                  | 36 +++++++-------
 lib/kobject_uevent.c                           | 27 +++++------
 lib/mpi/mpicoder.c                             | 10 ++--
 lib/nmi_backtrace.c                            |  3 ++
 lib/percpu_ida.c                               |  4 +-
 lib/percpu_test.c                              |  2 +
 lib/random32.c                                 | 10 ++--
 lib/stmp_device.c                              |  2 +
 lib/string.c                                   |  2 +
 lib/swiotlb.c                                  |  4 +-
 lib/test_debug_virtual.c                       |  2 +
 lib/test_rhashtable.c                          | 44 +++++++++--------
 lib/test_sort.c                                |  2 +
 lib/ubsan.c                                    | 61 ++++++++++++-----------
 net/ipv4/ipconfig.c                            | 59 ++++++++++-------------
 net/ipv4/ipmr.c                                |  2 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |  9 ++--
 net/ipv6/ip6mr.c                               |  2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |  6 +--
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |  4 +-
 net/netfilter/nf_conntrack_helper.c            | 11 ++---
 net/netfilter/nf_conntrack_standalone.c        |  2 +-
 net/socket.c                                   |  2 +-
 security/keys/encrypted-keys/encrypted.c       | 63 +++++++++++-------------
 security/selinux/selinuxfs.c                   | 29 ++++++-----
 82 files changed, 580 insertions(+), 532 deletions(-)
 rename arch/x86/kernel/cpu/mtrr/{main.c => mtrr.c} (96%)

-- 
2.15.0
