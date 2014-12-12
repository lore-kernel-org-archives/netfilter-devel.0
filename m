From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/6] nftables: support concat types in sets
Date: Fri, 12 Dec 2014 00:22:30 +0000
Message-ID: <1418343756-2886-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57275 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681AbaLLAWm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Dec 2014 19:22:42 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset is a first step to implement full concatenation support.
It adds support to specify concat types in set declarations and to
reconstruct the proper type from the data stored in the kernel.

The changes consist of:

 * generate proper names for the concat types for use in error reporting
 * don't use ->size to store the number of subtypes, the size will be
   needed to hold the entire concatenated data size, which may include
   padding
 * change concat_type_alloc() to construct the type from the numeric id
 * change the grammar to support concat type specification

The next step will be to change register addressing to 4 byte register
size and support loads and stores to spawn multiple registers. Patches
for this will follow shorly.


Patrick McHardy (6):
      datatype: generate name for concat types
      datatype: add new subtypes field to account number of concat data types
      datatype: add define for maximum number of bits and mask of datatype id
      utils: add fls()
      datatype: change concat_type_alloc() to construct type from id
      parser: alloc specifying concat types in set declarations

 include/datatype.h |  7 +++++-
 include/utils.h    | 37 ++++++++++++++++++++++++++++++++
 src/datatype.c     | 30 ++++++++++++++++++--------
 src/evaluate.c     | 11 ++++++----
 src/netlink.c      |  2 ++
 src/parser_bison.y | 63 +++++++++++++++++++++++++++++++++++-------------------
 6 files changed, 114 insertions(+), 36 deletions(-)

