Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="a5ePcaRn"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36C4D4A
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Nov 2023 06:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XgtQBDUsUh2xdzou4wh1Gb6+vbCpLfvMZhnbRQkh4DI=; b=a5ePcaRnO7GTgcMec5dMFeSCRi
	tDj9Gvehvn6yNTY1uFyRtc6JsM/4MgXJcfKdKJ3gEoeldWik6QUEg8hJjz2GYmnRMboYue/RG8pwX
	c7q8NrspNgGam//UJDTzN0liPi7xCqf6tXYHPPxH03cmBmFZi+MOad7wVKzbbbzpifYheNdVA3VFE
	QCj0PZZ1JqmqEtqr67TCLtf2GJtPmuFqrg9Szz4lsl6NMyleTsvU0UlGOunwvVL/Eba4UJKC/HX7C
	J5z93JqTFsVpuqBdiKAEm/LTjByrOKhaFqHDIitJP0CodLOX27MQaTdfCdqLiCPgDIkBKvS/bct2h
	+5JunvkA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r6Ah3-0001Et-3Z; Thu, 23 Nov 2023 15:28:37 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH] tests/shell: Treat json-nft dumps as binary in git
Date: Thu, 23 Nov 2023 15:37:12 +0100
Message-ID: <20231123143712.17341-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The stored JSON dumps containing a single line of a thusand characters
in average mess up diffs in history and patches if they change. Mitigate
this by treating them as binary files.

In order to get useable diffs back, one may undo/override the attribute
within $GIT_DIR/info/attributes, preferrably by defining a custom diff
driver converting the single-line dumps into something digestable by
diff:

| # cat >>$GIT_DIR/info/attributes <<EOF
| tests/shell/testcases/**/dumps/*.json-nft diff=json-nft
| EOF
| # cat >>$GIT_DIR/config <<EOF
| [diff "json-nft"]
|         binary = true
|         textconv = tests/shell/helpers/json-pretty.sh
| EOF

Stating the obvious: The textconv tool is for display purposes only,
patches will still contain binary diffs for the files.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .gitattributes                     | 1 +
 tests/shell/helpers/json-pretty.sh | 4 ++++
 2 files changed, 5 insertions(+)
 create mode 100644 .gitattributes

diff --git a/.gitattributes b/.gitattributes
new file mode 100644
index 0000000000000..17d78d0554929
--- /dev/null
+++ b/.gitattributes
@@ -0,0 +1 @@
+tests/shell/testcases/**/dumps/*.json-nft binary
diff --git a/tests/shell/helpers/json-pretty.sh b/tests/shell/helpers/json-pretty.sh
index 0d6972b81e2f0..d773da2be29de 100755
--- a/tests/shell/helpers/json-pretty.sh
+++ b/tests/shell/helpers/json-pretty.sh
@@ -1,5 +1,9 @@
 #!/bin/bash -e
 
+# support being called with input
+# in a file specified on command line
+[ -f "$1" ] && exec $0 <"$1"
+
 # WARNING: the output is not guaranteed to be stable.
 
 if command -v jq &>/dev/null ; then
-- 
2.41.0

