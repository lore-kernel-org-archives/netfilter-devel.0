From: Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH nf-next 0/2] nf_conntrack: validate crc32c on SCTP packets hitting PREROUTING hook
Date: Mon,  2 Jan 2017 13:29:39 +0100
Message-ID: <cover.1483355460.git.dcaratti@redhat.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S . Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53854 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751440AbdABMaI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2017 07:30:08 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

unlike what happens with other protcols, conntrack entries are matched by
SCTP packets even when crc32c is incorrect. Moreover, netfilter 'REJECT'
target does not generate any ICMP on reception of SCTP packets, because it
computes RFC 1624 checksum ad compares it with crc32c in the transport
header, resulting in a systematic mismatch.

The above issues can be resolved by implementing .error() callback in SCTP
conntrack helper. Patch 1 of this series lets LIBCRC32C be selected with
NF_CT_PROTO_SCTP, to allow crc32c validation within nf_conntrack. Patch 2
implements .error() callback in nf_conntrack_l4proto_sctp{4,6}: like other
protocols do with the Internet Checksum, sctp_error() validates crc32c in
PREROUTING hook, updates the value of skb->ip_summed and returns the result
of checksum validation to let conntrack core skip corrupted packets.

Davide Caratti (2):
  netfilter: select LIBCRC32C together with SCTP conntrack
  netfilter: conntrack: validate SCTP crc32c in PREROUTING

 net/netfilter/Kconfig                   |  2 +-
 net/netfilter/nf_conntrack_proto_sctp.c | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 1 deletion(-)

-- 
2.7.4

