From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 00/14] netfilter: nf_tables: concatenation support
Date: Sat, 11 Apr 2015 02:27:25 +0100
Message-ID: <1428715659-31358-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46109 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbbDKB1n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Apr 2015 21:27:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches add support for concatenations, which allow multi
dimensional exact matches in O(1).

The basic idea is to split the data registers, currently consisting of
4 registers of 16 bytes each, into smaller units, 16 registers of 4
bytes each, and making sure each register store always leaves the
full 32 bit in a well defined state, meaning smaller stores will
zero the remaining bits.

Based on that, we can load multiple adjacent registers with different
values, thereby building a concatenated bigger value, and use that
value for set lookups.

Sets are changed to use variable sized extensions for their key and
data values, removing the fixed limit of 16 bytes while saving memory
if less space is needed.

As a side effect, these patches will allow some nice optimizations in
the future, like using jhash2 in nft_hash, removing the masking in
nft_cmp_fast, optimized data comparison using 32 bit word size etc.
These are not done so far however.

The patches are split up as follows:

 * the first five patches add length validation to register loads and
   stores to make sure we stay within bounds and prepare the validation
   functions for the new addressing mode

 * the next patches prepare for changing to 32 bit addressing by
   introducing a struct nft_regs, which holds the verdict register as
   well as the data registers. The verdict members are moved to a new
   struct nft_verdict to allow to pull struct nft_data out of the stack.

 * the next patches contain preparatory conversions of expressions and
   sets to use 32 bit addressing

 * the next patch introduces so far unused register conversion helpers
   for parsing and dumping register numbers over netlink

 * following is the real conversion to 32 bit addressing, consisting of
   replacing struct nft_data in struct nft_regs by an array of u32s and
   actually translating and validating the new register numbers.

 * the final two patches add support for variable sized data items and
   variable sized keys / data in set elements

The patches have been verified to work correctly with nft binaries using
both old and new addressing.

Examples:

# MAC address filter
nft add set filter test { type ether_addr . ipv4_addr }
nft add element filter test {
	52:54:00:73:c0:55 . 192.168.122.128,
	...
}

nft filter input ether saddr . ip saddr @test counter

# Also works with dynamic set updates:
nft add set filter test { type ipv4_addr . inet_service; timeout 60s }

nft filter input set update ip daddr . tcp dport @test
nft filter output ip saddr . tcp sport @test counter


Please apply, thanks!


Patrick McHardy (14):
  netfilter: nf_tables: validate len in nft_validate_data_load()
  netfilter: nf_tables: rename nft_validate_data_load()
  netfilter: nft_lookup: use nft_validate_register_store() to validate types
  netfilter: nf_tables: kill nft_validate_output_register()
  netfilter: nf_tables: introduce nft_validate_register_load()
  netfilter: nf_tables: get rid of NFT_REG_VERDICT usage
  netfilter: nf_tables: use struct nft_verdict within struct nft_data
  netfilter: nf_tables: convert expressions to u32 register pointers
  netfilter: nf_tables: kill nft_data_cmp()
  netfilter: nf_tables: convert sets to u32 data pointers
  netfilter: nf_tables: add register parsing/dumping helpers
  netfilter: nf_tables: switch registers to 32 bit addressing
  netfilter: nf_tables: support variable sized data in nft_data_init()
  netfilter: nf_tables: variable sized set element keys / data

 include/net/netfilter/nf_tables.h        |  79 +++++++-----
 include/net/netfilter/nft_meta.h         |   4 +-
 include/uapi/linux/netfilter/nf_tables.h |  34 +++++-
 net/bridge/netfilter/nft_meta_bridge.c   |  26 ++--
 net/bridge/netfilter/nft_reject_bridge.c |   6 +-
 net/ipv4/netfilter/nft_masq_ipv4.c       |   9 +-
 net/ipv4/netfilter/nft_redir_ipv4.c      |  11 +-
 net/ipv4/netfilter/nft_reject_ipv4.c     |   4 +-
 net/ipv6/netfilter/nft_masq_ipv6.c       |   7 +-
 net/ipv6/netfilter/nft_redir_ipv6.c      |  11 +-
 net/ipv6/netfilter/nft_reject_ipv6.c     |   4 +-
 net/netfilter/nf_tables_api.c            | 198 +++++++++++++++++++------------
 net/netfilter/nf_tables_core.c           |  41 +++----
 net/netfilter/nft_bitwise.c              |  37 +++---
 net/netfilter/nft_byteorder.c            |  40 +++----
 net/netfilter/nft_cmp.c                  |  44 +++----
 net/netfilter/nft_compat.c               |  14 +--
 net/netfilter/nft_counter.c              |   2 +-
 net/netfilter/nft_ct.c                   | 110 +++++++++++------
 net/netfilter/nft_dynset.c               |  25 ++--
 net/netfilter/nft_exthdr.c               |  23 ++--
 net/netfilter/nft_hash.c                 |  19 ++-
 net/netfilter/nft_immediate.c            |  18 ++-
 net/netfilter/nft_limit.c                |   4 +-
 net/netfilter/nft_log.c                  |   2 +-
 net/netfilter/nft_lookup.c               |  28 ++---
 net/netfilter/nft_meta.c                 | 107 +++++++++--------
 net/netfilter/nft_nat.c                  |  71 ++++++-----
 net/netfilter/nft_payload.c              |  24 ++--
 net/netfilter/nft_queue.c                |   4 +-
 net/netfilter/nft_rbtree.c               |  15 ++-
 net/netfilter/nft_redir.c                |  19 +--
 net/netfilter/nft_reject_inet.c          |   5 +-
 33 files changed, 580 insertions(+), 465 deletions(-)

-- 
2.1.0

