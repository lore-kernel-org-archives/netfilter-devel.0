From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: [PATCH 0/1] Adjust nfnetlink structure size between kernel and user space
Date: Tue,  9 Mar 2010 19:05:23 +0100
Message-ID: <1268157924-4879-1-git-send-email-ljaenicke@innominate.com>
Cc: Lutz Jaenicke <ljaenicke@innominate.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host2.bln.innominate.com ([77.245.32.75]:54882 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab0CISF0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:05:26 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Revision 2:
Move __attribute__ ((packed)) to the end of the structure definition as
used in other locations allowing for simpler grep etc.

The attached patch adjust the size of struct nf_ct_tcp_flags in the kernel
to match the hardcoded size in the respective user space tools.
This issue has so far only been visible for an Intel IXP4xx network
processor (ARM big endian, gcc-4.2.4) while the same code and
toolchain works fine on powerpc (32bit) and x86_64.

Lutz Jaenicke (1):
  netfilter: nf_ct_tcp: pack nf_ct_tcp_flags to match user space

 include/linux/netfilter/nf_conntrack_tcp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

