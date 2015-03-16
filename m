From: Sergey Popovich <popovich_sergei@mail.ua>
Subject: netfilter: ipset: Fix double free of comment string when adding element
Date: Mon, 16 Mar 2015 15:40:15 +0200
Message-ID: <c711808889c4462a07d4caa715c9fa62569e5510.1426509747.git.popovich_sergei@mail.ua>
References: <cover.1426509747.git.popovich_sergei@mail.ua>
To: netfilter-devel@vger.kernel.org, popovich_sergei@mail.ru
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fallback3.mail.ru ([94.100.181.189]:33322 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbbCPNvi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 09:51:38 -0400
Received: from smtp32.i.mail.ru (smtp32.i.mail.ru [94.100.177.92])
	by fallback3.mail.ru (mPOP.Fallback_MX) with ESMTP id 7C4A4146EF142
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2015 16:40:22 +0300 (MSK)
In-Reply-To: <cover.1426509747.git.popovich_sergei@mail.ua>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When new element added hbucket_elem_add() is called to allocate
new ahash slot when number of elements (n->pos) in bucket reaches
current bucket size (n->size). New ahash slot area initialized
with zeros. In case there is room for element in the current
slot hbucket_elem_add() returns without initializing area
for the new element.

This is ok for the most cases, as we use ip_set_ext_destroy()
to free resources used by the extensions. Currently only comment
extension should be destroyed. Destroying comment also initializes
pointer to string to NULL, so that on slot reuse in mtype_add()
ip_set_init_comment() does not free already freed comment string.

However in case of call sequence mtype_del() -> mtype_add()
for set with comment extension enabled it might happen that
ahash_data() points to the dirty area, where comment extension
data area has it's pointer set to already freed area, causing
ip_set_init_comment() in mtype_add() to double free comment
string.

This happens if mtype_del()/mtype_expire() deletes non-last
element from the slot in bucket (and ip_set_ext_destroy()
properly initializes comment string to NULL), then we use
memcpy() to copy last element in place of the deleted element
and finally decrement first free element position n->pos.

Later if new element added to the bucket it's data area is not
clear, and ip_set_init_comment() in mtype_add() will attempt
to free comment string used by an valid element previously
seen at last position or double free area if that element
already deleted.

In most cases this leads to oops as slab cache structures
gets corrupted.

Test case for this condition is following:

  1. Use current upstream ipset code.
  2. Compile kernel with CONFIG_DEBUG_SLAB=y
  3. Use following script to reproduce condition:

    #!/bin/bash

    ipset -exist create test-1 hash:net family inet comment \
           hashsize 65536 maxelem 65536

    declare -i cmd_add_index=0 cmd_del_index=1
    declare -a cmd_a=(
        [cmd_add_index]="add"
        [$cmd_del_index]="del"
    )
    declare -i cmd_index cmd_a_size=${#cmd_a[@]} o4

    fmt="%s test-1 10.0.10.%u%s\n"

    while :; do
      for ((o4 = 0; o4 < 256; o4++)); do
          cmd_index=$((RANDOM % cmd_a_size))
          [ $cmd_index -eq $cmd_add_index ] &&
              comment=" comment $RANDOM" ||
              comment=
          printf "$fmt" "${cmd_a[$cmd_index]}" $o4 "$comment"
      done
    done |ipset -exist restore

    ipset destroy test-1

An slab debug reports would be generated reporting memory
double free conditions and memory corruptions.

Fix by initializing memory area for new element in mtype_add().

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
---
 net/netfilter/ipset/ip_set_hash_gen.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index fcf75be..e886d18 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -695,6 +695,7 @@ reuse_slot:
 			goto out;
 		}
 		data = ahash_data(n, n->pos++, set->dsize);
+		memset(data, 0, set->dsize);
 #ifdef IP_SET_HASH_WITH_NETS
 		for (i = 0; i < IPSET_NET_COUNT; i++)
 			mtype_add_cidr(h, SCIDR(d->cidr, i), NLEN(set->family),
-- 
1.7.10.4

