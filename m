From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 14/34] netfilter: ipset: Properly calculate extensions offsets and total length
Date: Sat,  2 May 2015 19:28:03 +0200
Message-ID: <1430587703-3387-15-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:36683 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbbEBR2F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:05 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Sergey Popovich <popovich_sergei@mail.ua>

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
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index b00dd23..d0a098a 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -366,7 +366,7 @@ size_t
 ip_set_elem_len(struct ip_set *set, struct nlattr *tb[], size_t len)
 {
 	enum ip_set_ext_id id;
-	size_t offset = 0;
+	size_t offset = len;
 	u32 cadt_flags = 0;
 
 	if (tb[IPSET_ATTR_CADT_FLAGS])
@@ -376,12 +376,12 @@ ip_set_elem_len(struct ip_set *set, struct nlattr *tb[], size_t len)
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
1.8.5.1

