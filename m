From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/3] netfilter: add connlabel conntrack extension
Date: Thu, 15 Nov 2012 16:55:12 +0100
Message-ID: <1352994915-3859-1-git-send-email-fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41051 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138Ab2KOPxU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:53:20 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.72)
	(envelope-from <fw@breakpoint.cc>)
	id 1TZ1kl-0000K8-13
	for netfilter-devel@vger.kernel.org; Thu, 15 Nov 2012 16:53:19 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following three patches add the connlabel extension, plus
ctnetlink support.

Connlabels are similar to connmarks, except labels are bit-based; i.e.
all labels may be attached to a flow at the same time.

Up to 128 labels are supported at this time.

Mapping of bit-identifier to label name is done in userspace.

The extension is enabled at run-time once "-m connlabel" netfilter rules
are added.

The '128-labels' limit could be increased, but we need to check that
extension array won't wrap, when all conntrack extensions are being
used (offsets are stored in 'u8' array).

Changes since RFCv2:
- make it a variable-size extension and remove dynamic
  reallocation of the label array
- add ctnetlink support for receiving/setting labels
- limit to 128 instead of 1k labels due to limited extension
  space (128 is more than enough for now, so this is no problem).

summary of changes:

 include/net/netfilter/nf_conntrack_extend.h        |    4 
 include/net/netfilter/nf_conntrack_labels.h        |   57 +++++++++++
 include/net/netns/conntrack.h                      |    4 
 include/uapi/linux/netfilter/nf_conntrack_common.h |    1 
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |    1 
 include/uapi/linux/netfilter/xt_connlabel.h        |   13 ++
 net/netfilter/Kconfig                              |   18 +++
 net/netfilter/Makefile                             |    2 
 net/netfilter/nf_conntrack_core.c                  |   12 ++
 net/netfilter/nf_conntrack_labels.c                |  107 +++++++++++++++++++++
 net/netfilter/nf_conntrack_netlink.c               |   67 +++++++++++++
 net/netfilter/xt_connlabel.c                       |   96 ++++++++++++++++++
12 files changed, 382 insertions(+)

Best regards,
Florian
