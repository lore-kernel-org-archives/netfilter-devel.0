From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 0/4] Netlink bus descriptions
Date: Wed,  7 Feb 2018 02:37:09 +0100
Message-ID: <20180207013713.2432-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

Modern messaging systems usually provide facilities that allows you to
inquire about supported commands and message layouts. Netlink has no
such facility so far, hence people end up probing for features, which is
a bit sloppy. Sometimes there are also magic version numbers in place
that gives a hint to userspace on what this kernel supports, so
userspace makes assumptions based on this version number.

This patchset aims to improve this situation by adding a new
NETLINK_DESC bus with two commands, one to fetch the list of existing
commands and another one to describe supported objects. Command
descriptions also indicate what netlink objects the interface expects to
be used in the netlink message payload, thus, we can relate commands and
objects. Objects are represented as compounds of attributes, some of
these attributes are nesting other attributes. The netlink description
exports the attribute tree and, for simplicity, a linear list of netlink
objects identified via unique ID.

Patch 1 adds NLA_PAD, this datatype is needed by netlink description.
Patch 2 adds the new generic netlink description bus NETLINK_DESC.
Patch 3 adds support for netlink descriptions to nfnetlink.
Patch 4 adds a netlink description for nf_tables, so you have an initial
	client for this infrastructure to look at as reference.

Not covered by this patchset, but I think it should be possible to
(fully?) generate the C file containing the description and the netlink
headers based on some generic notation that describes the netlink
interface, something like this:

    netlink description  ---> nldesc_compiler ---> .c and .h files
         notation

This would probably make the work of describing the netlink interface
less error prone, given people may add a new attribute to the header
file and forget about updating the description. I also think this
description could be also useful to fuzz tests netlink interfaces, by
interpreting the description that the kernel provides.

I've been looking into this since NetDev 2.1 in Canada - already one
year ago - I think we need this in nftables so we can evolve more
freely.

Comments welcome.

Pablo Neira Ayuso (4):
  netlink: add NLA_PAD definition
  netlink: add generic object description infrastructure
  netfilter: nfnetlink: add support for netlink descriptions
  netfilter: nf_tables: add netlink description

 include/linux/netfilter/nfnetlink.h           |   9 +
 include/net/net_namespace.h                   |   1 +
 include/net/netfilter/nf_tables.h             |   2 +
 include/net/netlink.h                         |   2 +
 include/net/nldesc.h                          | 163 +++++++++
 include/uapi/linux/netfilter/nf_tables_desc.h |  57 +++
 include/uapi/linux/netfilter/nfnetlink.h      |   7 +
 include/uapi/linux/netlink.h                  |  67 ++++
 net/netfilter/Makefile                        |   7 +-
 net/netfilter/nf_tables_api.c                 |   2 +
 net/netfilter/nf_tables_desc.c                | 471 ++++++++++++++++++++++++
 net/netfilter/nfnetlink.c                     | 108 ++++++
 net/netlink/Makefile                          |   2 +-
 net/netlink/desc.c                            | 499 ++++++++++++++++++++++++++
 14 files changed, 1393 insertions(+), 4 deletions(-)
 create mode 100644 include/net/nldesc.h
 create mode 100644 include/uapi/linux/netfilter/nf_tables_desc.h
 create mode 100644 net/netfilter/nf_tables_desc.c
 create mode 100644 net/netlink/desc.c

-- 
2.11.0
