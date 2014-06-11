From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 3/5] src: set: Do not print unset values in json
Date: Wed, 11 Jun 2014 17:50:49 +0200
Message-ID: <1402501851-22208-5-git-send-email-anarey@gmail.com>
References: <1402501851-22208-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47979 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbaFKPvS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:51:18 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so5715787wib.2
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2014 08:51:16 -0700 (PDT)
In-Reply-To: <1402501851-22208-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and the snprint functions to omit unset values.

This json file is gotten for a set:
{
  "set": {
    "name": "mi6set3",
    "table": "test6",
    "flags": "0",
    "family": "unknown",
    "key_type": "0",
    "key_len": "0",
    "set_elem": [
      {
        "flags": "0",
        "key": {
          "data_reg": {
            "type": "value",
            "len": "16",
            "data0": "0x000080fe",
            "data1": "0x00000000",
            "data2": "0xffb30202",
            "data3": "0x89001efe"

Now, This json file is gotten for a set without unset elements.
{
  "set": {
    "name": "mi6set3",
    "table": "test6",
    "family": "unknown",
    "set_elem": [
      {
        "key": {
          "data_reg": {
            "type": "value",
            "len": "16",
            "data0": "0x000080fe",
            "data1": "0x00000000",
            "data2": "0xffb30202",
            "data3": "0x89001efe"


Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/jansson.c  | 12 +++------
 src/set.c      | 79 ++++++++++++++++++++++++++++++++++++++--------------------
 src/set_elem.c |  8 +++---
 3 files changed, 61 insertions(+), 38 deletions(-)

diff --git a/src/jansson.c b/src/jansson.c
index affe8fe..8805044 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -243,15 +243,11 @@ int nft_jansson_set_elem_parse(struct nft_set_elem *e, json_t *root,
 	uint32_t uval32;
 	int set_elem_data;
 
-	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &uval32, err) < 0)
-		return -1;
-
-	nft_set_elem_attr_set_u32(e, NFT_SET_ELEM_ATTR_FLAGS, uval32);
-
-	if (nft_jansson_data_reg_parse(root, "key", &e->key, err) != DATA_VALUE)
-		return -1;
+	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &uval32, err) == 0)
+		nft_set_elem_attr_set_u32(e, NFT_SET_ELEM_ATTR_FLAGS, uval32);
 
-	e->flags |= (1 << NFT_SET_ELEM_ATTR_KEY);
+	if (nft_jansson_data_reg_parse(root, "key", &e->key, err) == DATA_VALUE)
+		e->flags |= (1 << NFT_SET_ELEM_ATTR_KEY);
 
 	if (nft_jansson_node_exist(root, "data")) {
 		set_elem_data = nft_jansson_data_reg_parse(root, "data",
diff --git a/src/set.c b/src/set.c
index e328288..152b81c 100644
--- a/src/set.c
+++ b/src/set.c
@@ -358,29 +358,21 @@ int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
 	if (valstr == NULL)
 		return -1;
 
-	nft_set_attr_set_str(s, NFT_SET_ATTR_TABLE, valstr);
-
-	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &uval32, err) < 0)
-		return -1;
-
-	nft_set_attr_set_u32(s, NFT_SET_ATTR_FLAGS, uval32);
+	if (nft_jansson_parse_family(root, &family, err) == 0)
+		nft_set_attr_set_u32(s, NFT_SET_ATTR_FAMILY, family);
 
-	if (nft_jansson_parse_family(root, &family, err) < 0)
-		return -1;
+	nft_set_attr_set_str(s, NFT_SET_ATTR_TABLE, valstr);
 
-	nft_set_attr_set_u32(s, NFT_SET_ATTR_FAMILY, family);
+	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &uval32, err) == 0)
+		nft_set_attr_set_u32(s, NFT_SET_ATTR_FLAGS, uval32);
 
 	if (nft_jansson_parse_val(root, "key_type", NFT_TYPE_U32, &uval32,
-				  err) < 0)
-		return -1;
-
-	nft_set_attr_set_u32(s, NFT_SET_ATTR_KEY_TYPE, uval32);
+				  err) == 0)
+		nft_set_attr_set_u32(s, NFT_SET_ATTR_KEY_TYPE, uval32);
 
 	if (nft_jansson_parse_val(root, "key_len", NFT_TYPE_U32, &uval32,
-				  err) < 0)
-		return -1;
-
-	nft_set_attr_set_u32(s, NFT_SET_ATTR_KEY_LEN, uval32);
+				  err) == 0)
+		nft_set_attr_set_u32(s, NFT_SET_ATTR_KEY_LEN, uval32);
 
 	if (nft_jansson_node_exist(root, "data_type")) {
 		if (nft_jansson_parse_val(root, "data_type", NFT_TYPE_U32,
@@ -584,19 +576,52 @@ static int nft_set_snprintf_json(char *buf, size_t size, struct nft_set *s,
 	int len = size, offset = 0, ret;
 	struct nft_set_elem *elem;
 
-	ret = snprintf(buf, len, "{\"set\":{\"name\":\"%s\","
-				  "\"table\":\"%s\","
-				  "\"flags\":%u,\"family\":\"%s\","
-				  "\"key_type\":%u,\"key_len\":%u",
-			s->name, s->table, s->set_flags,
-			nft_family2str(s->family), s->key_type, s->key_len);
+	ret = snprintf(buf, len, "{\"set\":{");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	if(s->flags & (1 << NFT_SET_ATTR_DATA_TYPE) &&
-	   s->flags & (1 << NFT_SET_ATTR_DATA_LEN)){
+	if (s->flags & (1 << NFT_SET_ATTR_NAME)) {
+		ret = snprintf(buf+offset, len, "\"name\":\"%s\"",
+			       s->name);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	} else
+		return -1;
+	if (s->flags & (1 << NFT_SET_ATTR_TABLE)) {
+		ret = snprintf(buf+offset, len, ",\"table\":\"%s\"",
+			       s->table);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	} else
+		return -1;
+
+	if (s->flags & (1 << NFT_SET_ATTR_FLAGS)) {
+		ret = snprintf(buf+offset, len, ",\"flags\":%u",
+			       s->set_flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (s->flags & (1 << NFT_SET_ATTR_FAMILY)) {
+		ret = snprintf(buf+offset, len, ",\"family\":\"%s\"",
+			       nft_family2str(s->family));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	} else
+		return -1;
+	if (s->flags & (1 << NFT_SET_ATTR_KEY_TYPE)) {
+		ret = snprintf(buf+offset, len, ",\"key_type\":%u",
+			       s->key_type);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (s->flags & (1 << NFT_SET_ATTR_KEY_LEN)) {
+		ret = snprintf(buf+offset, len, ",\"key_len\":%u",
+			       s->key_len);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if(s->flags & (1 << NFT_SET_ATTR_DATA_TYPE)) {
 		ret = snprintf(buf+offset, len,
-				  ",\"data_type\":%u,\"data_len\":%u",
-			s->data_type, s->data_len);
+				  ",\"data_type\":%u", s->data_type);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if(s->flags & (1 << NFT_SET_ATTR_DATA_LEN)) {
+		ret = snprintf(buf+offset, len, ",\"data_len\":%u", s->data_len);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
diff --git a/src/set_elem.c b/src/set_elem.c
index 2ccaf3f..09f6fc5 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -493,10 +493,12 @@ static int nft_set_elem_snprintf_json(char *buf, size_t size,
 {
 	int ret, len = size, offset = 0, type = -1;
 
-	ret = snprintf(buf, len, "\"flags\":%u", e->set_elem_flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_SET_ELEM_ATTR_FLAGS)) {
+		ret = snprintf(buf, len, "\"flags\":%u,", e->set_elem_flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
-	ret = snprintf(buf+offset, len, ",\"key\":{");
+	ret = snprintf(buf+offset, len, "\"key\":{");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = nft_data_reg_snprintf(buf+offset, len, &e->key,
-- 
2.0.0

