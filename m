From: Sergey Popovich <popovich_sergei@mail.ua>
Subject: netfilter: ipset: Properly calculate extensions offsets and total length
Date: Mon, 16 Mar 2015 15:40:11 +0200
Message-ID: <1d1a78681eb40d67d9be6e93a4821b2814d6d21e.1426509747.git.popovich_sergei@mail.ua>
References: <cover.1426509747.git.popovich_sergei@mail.ua>
To: netfilter-devel@vger.kernel.org, popovich_sergei@mail.ru
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fallback3.mail.ru ([94.100.181.189]:33302 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbbCPNvi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 09:51:38 -0400
Received: from smtp32.i.mail.ru (smtp32.i.mail.ru [94.100.177.92])
	by fallback3.mail.ru (mPOP.Fallback_MX) with ESMTP id D2102146EECFD
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2015 16:40:21 +0300 (MSK)
In-Reply-To: <cover.1426509747.git.popovich_sergei@mail.ua>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Offsets and total length returned by the ip_set_elem_len()
calculated incorrectly as initial set element length (i.e.
len parameter) is used multiple times in offset calculations,
also affecting set element total length.

Use initial set element length as start offset, do not add aligned
extension offset to the offset. Return offset as total length of
the set element.

This reduces memory requirements on per element basic for the
hash:* type of sets.

For example output from 'ipset -terse list test-1' on 64-bit PC,
where test-1 is generated via following script:

  #!/bin/bash

  set_name='test-1'

  ipset create "$set_name" hash:net family inet \
              timeout 10800 counters comment \
              hashsize 65536 maxelem 65536

  declare -i o3 o4
  fmt="add $set_name 192.168.%u.%u\n"

  for ((o3 = 0; o3 < 256; o3++)); do
      for ((o4 = 0; o4 < 256; o4++)); do
          printf "$fmt" $o3 $o4
      done
  done |ipset -exist restore

BEFORE this patch is applied

  # ipset -terse list test-1
  Name: test-1
  Type: hash:net
  Revision: 6
  Header: family inet hashsize 65536 maxelem 65536
timeout 10800 counters comment
  Size in memory: 26348440

and AFTER applying patch

  # ipset -terse list test-1
  Name: test-1
  Type: hash:net
  Revision: 6
  Header: family inet hashsize 65536 maxelem 65536
timeout 10800 counters comment
  Size in memory: 7706392
  References: 0

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
---
 net/netfilter/ipset/ip_set_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index d259da3..fb1f2b4 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -365,7 +365,7 @@ size_t
 ip_set_elem_len(struct ip_set *set, struct nlattr *tb[], size_t len)
 {
 	enum ip_set_ext_id id;
-	size_t offset = 0;
+	size_t offset = len;
 	u32 cadt_flags = 0;
 
 	if (tb[IPSET_ATTR_CADT_FLAGS])
@@ -375,12 +375,12 @@ ip_set_elem_len(struct ip_set *set, struct nlattr *tb[], size_t len)
 	for (id = 0; id < IPSET_EXT_ID_MAX; id++) {
 		if (!add_extension(id, cadt_flags, tb))
 			continue;
-		offset += ALIGN(len + offset, ip_set_extensions[id].align);
+		offset = ALIGN(offset, ip_set_extensions[id].align);
 		set->offset[id] = offset;
 		set->extensions |= ip_set_extensions[id].type;
 		offset += ip_set_extensions[id].len;
 	}
-	return len + offset;
+	return offset;
 }
 EXPORT_SYMBOL_GPL(ip_set_elem_len);
 
-- 
1.7.10.4

