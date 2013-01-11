From: Florian Westphal <fw@strlen.de>
Subject: [PATCH next V2] netfilter connlabel extension
Date: Fri, 11 Jan 2013 17:30:43 +0100
Message-ID: <1357921846-29650-1-git-send-email-fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50595 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753818Ab3AKQ2p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2013 11:28:45 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.72)
	(envelope-from <fw@breakpoint.cc>)
	id 1TthTH-0005JZ-FR
	for netfilter-devel@vger.kernel.org; Fri, 11 Jan 2013 17:28:43 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following three patches add the connlabel extension, plus
ctnetlink support to set/clear labels from userspace.

Connlabels are similar to connmarks, except labels are bit-based; i.e.
all labels may be attached to a flow at the same time.

Up to 128 labels are supported at this time.

This limit could be increased later, if the need arises.

To do this safely, one needs to check that the
conntrack extension array won't wrap when all conntrack extensions are in
use at the same time (offsets are stored in 'u8' array).

Mapping of bit-identifier to label name is done in userspace.

The extension is enabled at run-time once "-m connlabel" netfilter rules
are added. Existing conntracks will not be able to make use of the labels
added later.

Change since V1:
- add ctnetlink bitmask attribute (CTA_LABELS_MASK)
  to allow userspace to only manipulate a subset of the bitmask.
- otherwise, cosmetic changes only.

Changes since RFCv2:
- make it a variable-size extension and remove dynamic
  reallocation of the label array
- add ctnetlink support for receiving/setting labels
- limit to 128 instead of 1k labels due to limited extension
  space (128 is more than enough for now, so this is no problem).

The following changes since commit 61c5e88aecd6fbf2480f39394bb495964e6d9984:

  skbuff: make __kmalloc_reserve static (2012-12-28 20:32:36 -0800)

are available in the git repository at:
  git://git.breakpoint.cc/fw/nf-next.git nfct_ext_clabel_19

Florian Westphal (3):
      netfilter: add connlabel conntrack extension
      netfilter: ctnetlink: deliver labels to userspace
      netfilter: ctnetlink: allow userspace to modify labels

 include/net/netfilter/nf_conntrack_extend.h        |    4 +
 include/net/netfilter/nf_conntrack_labels.h        |   58 ++++++++++
 include/net/netns/conntrack.h                      |    4 +
 include/uapi/linux/netfilter/nf_conntrack_common.h |    1 +
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |    2 +
 include/uapi/linux/netfilter/xt_connlabel.h        |   12 ++
 net/netfilter/Kconfig                              |   18 +++
 net/netfilter/Makefile                             |    2 +
 net/netfilter/nf_conntrack_core.c                  |   12 ++
 net/netfilter/nf_conntrack_labels.c                |  115 ++++++++++++++++++++
 net/netfilter/nf_conntrack_netlink.c               |   88 +++++++++++++++
 net/netfilter/xt_connlabel.c                       |   99 +++++++++++++++++
 12 files changed, 415 insertions(+), 0 deletions(-)
 create mode 100644 include/net/netfilter/nf_conntrack_labels.h
 create mode 100644 include/uapi/linux/netfilter/xt_connlabel.h
 create mode 100644 net/netfilter/nf_conntrack_labels.c
 create mode 100644 net/netfilter/xt_connlabel.c
