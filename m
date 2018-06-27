From: Flavio Leitner <fbl@redhat.com>
Subject: [PATCH v2 net-next 0/2] net: preserve sock reference when scrubbing the skb.
Date: Wed, 27 Jun 2018 10:34:24 -0300
Message-ID: <20180627133426.3858-1-fbl@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, Flavio Leitner <fbl@redhat.com>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The sock reference is lost when scrubbing the packet and that breaks
TSQ (TCP Small Queues) and XPS (Transmit Packet Steering) causing
performance impacts of about 50% in a single TCP stream when crossing
network namespaces.

XPS breaks because the queue mapping stored in the socket is not
available, so another random queue might be selected when the stack
needs to transmit something like a TCP ACK, or TCP Retransmissions.
That causes packet re-ordering and/or performance issues.

TSQ breaks because it orphans the packet while it is still in the
host, so packets are queued contributing to the buffer bloat problem.

Preserving the sock reference fixes both issues. The socket is
orphaned anyways in the receiving path before any relevant action,
but the transmit side needs some extra checking included in the
first patch.

The first patch will update netfilter to check if the socket
netns is local before use it.

The second patch removes the skb_orphan() from the skb_scrub_packet()
and improve the documentation.

ChangeLog:
- split into two (Eric)
- addressed Paolo's offline feedback to swap the checks in xt_socket.c
  to preserve original behavior.
- improved ip-sysctl.txt (reported by Cong)

Flavio Leitner (2):
  netfilter: check if the socket netns is correct.
  skbuff: preserve sock reference when scrubbing the skb.

 Documentation/networking/ip-sysctl.txt | 10 +++++-----
 include/net/netfilter/nf_log.h         |  3 ++-
 net/core/skbuff.c                      |  1 -
 net/ipv4/netfilter/nf_log_ipv4.c       |  8 ++++----
 net/ipv6/netfilter/nf_log_ipv6.c       |  8 ++++----
 net/netfilter/nf_conntrack_broadcast.c |  2 +-
 net/netfilter/nf_log_common.c          |  5 +++--
 net/netfilter/nf_nat_core.c            |  6 +++++-
 net/netfilter/nft_meta.c               |  9 ++++++---
 net/netfilter/nft_socket.c             |  5 ++++-
 net/netfilter/xt_cgroup.c              |  6 ++++--
 net/netfilter/xt_owner.c               |  2 +-
 net/netfilter/xt_recent.c              |  3 ++-
 net/netfilter/xt_socket.c              |  8 ++++++++
 14 files changed, 49 insertions(+), 27 deletions(-)

-- 
2.14.3
