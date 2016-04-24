From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 0/6] ruleset tracing
Date: Sun, 24 Apr 2016 22:30:34 +0100
Message-ID: <1461533440-10605-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52078 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbcDXVjU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Apr 2016 17:39:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches contain the latest version of the ruleset tracing
functionality.

Packets received from the kernel are decoded based on the nft protocol
definitions and are printed in the regular nft syntax. Uninteresting
fields are filtered to reduce the noise.

I've compacted the output so we only show a single line per rule, which
also contains the verdict and mark, if present. Examples can be found in
patch 6/6. This version fully supported stacked headers like VLAN.

The patchset is structured as follows:

* fixed for protocol context tracking of stacked headers, necessary for
  proper packet decoding
* header resync
* moving of payload dependency tracking to payload.c to make it usable for
  packet decoding
* introduction of a helper function for stacked header decoding
* tracing functionality

I consider this patchset complete. Testing and comments welcome.



Patrick McHardy (6):
  payload: fix stacked headers protocol context tracking
  nft: resync kernel header files
  payload: move payload depedency tracking to payload.c
  payload: add payload_is_stacked()
  proto: add protocol header fields filter and ordering for packet decoding
  nft monitor [ trace ]

 include/linux/netfilter/nf_tables.h |  91 +++++++++++-
 include/linux/netfilter/nfnetlink.h |   4 +
 include/payload.h                   |  24 ++++
 include/proto.h                     |   5 +
 include/rule.h                      |   1 +
 src/evaluate.c                      |  62 ++++-----
 src/netlink.c                       | 269 +++++++++++++++++++++++++++++++++++-
 src/netlink_delinearize.c           |  97 +++----------
 src/payload.c                       |  77 ++++++++++-
 src/proto.c                         |  47 ++++++-
 src/rule.c                          |  61 ++++++--
 11 files changed, 611 insertions(+), 127 deletions(-)

-- 
2.5.5

