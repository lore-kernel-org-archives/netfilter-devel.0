Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46B15192B82
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 15:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720624823; cv=none; b=JoOuB1UPmV3WisjdhkG8YZrBZnDuk4XRAlvUyGaiIp5L9H+GGn7vhtWWSlXYu7bBI0l3C5BrwYOOJJ++wsE9gaDp0xUBo30lfYAn5ia/tDBF6SaRm3f/473duaYBv0m8Lj3IMBqtWqECuH4fl3Jc8KjWfC+jziifTBjXD4V579g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720624823; c=relaxed/simple;
	bh=gUVSRvD0qaEi4pt2Yu6AmGye+LgDEkBllf6WROgMj2c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MlQiah8N4cU4KU094b6nPLI+hHppZpqijxdyeLrXpx/Wx3f+RROcE27TLPm47AQBW5sVsvA8rWqwyecLTg8dBHhUkOxiP9Psy1sKXAImiOVxr3VFbwHiAShQ5mSWs2TSfnkoMvnVePTtIrtbg81E3TBweEXNtYMpfVIQYDR8WP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	thaller@redhat.com,
	jami.maenpaa@wapice.com
Subject: [PATCH nft 1/2] parser_json: use stdin buffer if available
Date: Wed, 10 Jul 2024 17:20:03 +0200
Message-Id: <20240710152004.11526-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since 5c2b2b0a2ba7 ("src: error reporting with -f and read from stdin")
stdin is stored in a buffer, update json support to use it instead of
reading from /dev/stdin.

Some systems do not provide /dev/stdin symlink to /proc/self/fd/0
according to reporter (that mentions Yocto Linux as example).

Fixes: 935f82e7dd49 ("Support 'nft -f -' to read from stdin")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: remove check for nft_output_json() in nft_run_cmd_from_filename()
    as suggested by Phil Sutter, so JSON support does not really use
    /dev/stdin.

 src/libnftables.c | 3 +--
 src/parser_json.c | 7 +++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index af4734c05004..89317f9f6049 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -807,8 +807,7 @@ int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 	if (!strcmp(filename, "-"))
 		filename = "/dev/stdin";
 
-	if (!strcmp(filename, "/dev/stdin") &&
-	    !nft_output_json(&nft->output))
+	if (!strcmp(filename, "/dev/stdin"))
 		nft->stdin_buf = stdin_to_buffer();
 
 	if (!nft->stdin_buf &&
diff --git a/src/parser_json.c b/src/parser_json.c
index ee4657ee8044..4912d3608b2b 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -4357,6 +4357,13 @@ int nft_parse_json_filename(struct nft_ctx *nft, const char *filename,
 	json_error_t err;
 	int ret;
 
+	if (nft->stdin_buf) {
+		json_indesc.type = INDESC_STDIN;
+		json_indesc.name = "/dev/stdin";
+
+		return nft_parse_json_buffer(nft, nft->stdin_buf, msgs, cmds);
+	}
+
 	json_indesc.type = INDESC_FILE;
 	json_indesc.name = filename;
 
-- 
2.30.2

