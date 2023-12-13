Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5B5DD
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 08:37:20 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rDSEZ-0001KN-9T; Wed, 13 Dec 2023 17:37:19 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] meta: fix tc classid parsing out-of-bounds access
Date: Wed, 13 Dec 2023 17:37:11 +0100
Message-ID: <20231213163714.10524-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

AddressSanitizer: heap-buffer-overflow on address 0x6020000003af ...
  #0 0x7f9a83cbb402 in tchandle_type_parse src/meta.c:89
  #1 0x7f9a83c6753f in symbol_parse src/datatype.c:138

strlen() - 1 can underflow if length was 0.

Simplify the function, there is no need to duplicate the string
while scanning it.

Expect the first strtol to stop at ':' or '\0', error out otherwise.

If it stopped at ':', then scan for the minor number.
Require the second scan to stop at \0, else error.

Fixes: 6f2eb8548e0d ("src: meta priority support using tc classid")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/meta.c                                    | 29 ++++++-------------
 .../nft-f/tchandle_type_parse_heap_overflow   |  6 ++++
 2 files changed, 15 insertions(+), 20 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/tchandle_type_parse_heap_overflow

diff --git a/src/meta.c b/src/meta.c
index d7f810ce19d0..8d0b7aae9629 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -62,50 +62,39 @@ static struct error_record *tchandle_type_parse(struct parse_ctx *ctx,
 						struct expr **res)
 {
 	uint32_t handle;
-	char *str = NULL;
 
 	if (strcmp(sym->identifier, "root") == 0)
 		handle = TC_H_ROOT;
 	else if (strcmp(sym->identifier, "none") == 0)
 		handle = TC_H_UNSPEC;
 	else if (strchr(sym->identifier, ':')) {
+		char *colon, *end;
 		uint32_t tmp;
-		char *colon;
-
-		str = xstrdup(sym->identifier);
-
-		colon = strchr(str, ':');
-		if (!colon)
-			goto err;
-
-		*colon = '\0';
 
 		errno = 0;
-		tmp = strtoull(str, NULL, 16);
-		if (errno != 0)
+		tmp = strtoul(sym->identifier, &colon, 16);
+		if (errno != 0 || sym->identifier == colon)
 			goto err;
 
-		handle = (tmp << 16);
-		if (str[strlen(str) - 1] == ':')
-			goto out;
+		if (*colon != ':')
+			goto err;
 
+		handle = tmp << 16;
 		errno = 0;
-		tmp = strtoull(colon + 1, NULL, 16);
-		if (errno != 0)
+		tmp = strtoul(colon + 1, &end, 16);
+		if (errno != 0 || *end)
 			goto err;
 
 		handle |= tmp;
 	} else {
 		handle = strtoull(sym->identifier, NULL, 0);
 	}
-out:
-	free(str);
+
 	*res = constant_expr_alloc(&sym->location, sym->dtype,
 				   BYTEORDER_HOST_ENDIAN,
 				   sizeof(handle) * BITS_PER_BYTE, &handle);
 	return NULL;
 err:
-	free(str);
 	return error(&sym->location, "Could not parse %s", sym->dtype->desc);
 }
 
diff --git a/tests/shell/testcases/bogons/nft-f/tchandle_type_parse_heap_overflow b/tests/shell/testcases/bogons/nft-f/tchandle_type_parse_heap_overflow
new file mode 100644
index 000000000000..ea7186bfc23e
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/tchandle_type_parse_heap_overflow
@@ -0,0 +1,6 @@
+table t {
+map m {
+	type ipv4_addr : classid
+	elements = { 1.1.26.3 : ::a }
+}
+}
-- 
2.41.0

