From: Aaron Conole <aconole@bytheb.org>
Subject: [RFC -next v0 0/3] netfilter: expose flow offload tables as an ebpf map
Date: Sun, 25 Nov 2018 13:09:16 -0500
Message-ID: <20181125180919.13996-1-aconole@bytheb.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Gospodarek <andy@greyhouse.net>,
        Rony Efraim <ronye@mellanox.com>,
        Simon Horman <horms@verge.net>,
        Marcelo Leitner <marcelo.leitner@gmail.com>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is an alternate approach to exposing connection tracking data
to the XDP + eBPF world.  Rather than having to rework a number of
helper functions to ignore or rebuild metadata from an skbuff data
segment, we reuse the existing flow offload hooks that expose conntrack
tuples directly based on a flow tuple.  As this is an early-version RFC,
the API behavior is definitely going to change.  I'll be working on this
unless the flames grow so high that there's no choice but to bail and
let it burn down.

The goal of this work is to integrate the flow offload infrastructure
from netfilter, in a similar way to the approach that flow hw offload
has taken (ie: the 'slowpath' of netfilter does the heavy lifting for
lots of the required functions, like port allocations, helper parsing,
etc).  The advatange of building a series like this is two-fold:

 1.  We can get the advantages of the netfilter infrastructure today,
     and pull in functionality via various map types or operations (TBD).
     I think the next thing to add to this would be NAT support (so that
     we could actually forward end-to-end and watch things go).

 2.  For the hw offload folks, this gives a way to test out some of the
     proposed conntrack API changes without need hardware available
     today.  In fact, this might let the hardware vendors prototype their
     conntrack offload, see where the proposed APIs are lacking (or where
     they need reworking), and turn around changes quickly.

It's not all sunshine and roses, though.  The first patch in the series is
definitely controversial.  It would allow kernel subsystems to register
their own map types at module load time, rather than being compiled in to
the kernel at run-time.  I think there is a worry about this kind of
functionality enabling the eBPF ecosystem to fracture.  I don't know if
I understand the concern enough.  If that's dead in the water, there might
be an alternate approach with out patch 1 (I have a rough sketch in my
head, but haven't coded it up).

I have only done some rudimentary testing with this.  Just enough to prove
that I wasn't breaking anything existing.  I'm sending this out just as
it matched the first packet (and I'm re-running the build and retesting so
that I didn't forget to save something).  So I don't have any benchmark
data, and I don't even have support yet to do anything useful (NAT would
be needed for my IPv4 testing to to proceed, so that's my next task).

I have a small (and hacky) test program at:
  https://github.com/orgcandman/conntrack_bpf

It is only used to exercise the lookup call - it doesn't actually prevent
connections from eventually succeeding.  I eventually hope to flesh that
out into a bpf implementation of hardware offload (with various features,
like window tracking, flag validation, etc).

Aaron Conole (3):
  bpf: modular maps
  netfilter: nf_flow_table: support a new 'snoop' mode
  netfilter: nf_flow_table_bpf_map: introduce new loadable bpf map

 include/linux/bpf.h                       |   6 +
 include/linux/bpf_types.h                 |   2 +
 include/net/netfilter/nf_flow_table.h     |   5 +
 include/uapi/linux/bpf.h                  |   7 +
 include/uapi/linux/netfilter/nf_tables.h  |   2 +
 init/Kconfig                              |   8 +
 kernel/bpf/syscall.c                      |  57 +++++-
 net/netfilter/Kconfig                     |   9 +
 net/netfilter/Makefile                    |   1 +
 net/netfilter/nf_flow_table_bpf_flowmap.c | 202 ++++++++++++++++++++++
 net/netfilter/nf_flow_table_core.c        |  44 ++++-
 net/netfilter/nf_tables_api.c             |  13 +-
 12 files changed, 351 insertions(+), 5 deletions(-)
 create mode 100644 net/netfilter/nf_flow_table_bpf_flowmap.c

-- 
2.19.1
