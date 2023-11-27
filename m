Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GuMlm3Rp"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084ABD72
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Nov 2023 11:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701112650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v+yc3jnEqQW+8dBSJgRAMNAAJPMjhTLDt4uvck+ZskI=;
	b=GuMlm3RpDapS0eMfNzyJMyRTLNTVkkzXo+q7ZhE9IfkZN1sazNw7BfhOpkCb1TLW6HY9B8
	UXT+IrS9ezHf3HqfIXdPNwJ3AKTu0SM2pNaDPrYy86x61NzckP8Az2MSQ+3zXBFNsEBCac
	qCDaowHcjN3MxlPDfi7OpGoh9fzmfKM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-evBYDIxEPBGvil6gDHEFQw-1; Mon, 27 Nov 2023 14:17:27 -0500
X-MC-Unique: evBYDIxEPBGvil6gDHEFQw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28700803CE3
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Nov 2023 19:17:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.43])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EBB91121307;
	Mon, 27 Nov 2023 19:17:26 +0000 (UTC)
From: Thomas Haller <thaller@redhat.com>
To: NetFilter <netfilter-devel@vger.kernel.org>
Cc: Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/2] tests/shell: workaround lack of $SRANDOM before bash 5.1
Date: Mon, 27 Nov 2023 20:15:36 +0100
Message-ID: <20231127191713.3528973-3-thaller@redhat.com>
In-Reply-To: <20231127191713.3528973-1-thaller@redhat.com>
References: <20231127191713.3528973-1-thaller@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

$SRANDOM is only supported since bash 5.1. Add a fallback to $RANDOM.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index f1345bb14e7c..e54f8bf3e3ee 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -314,6 +314,7 @@ DO_LIST_TESTS=
 if [ -z "$NFT_TEST_RANDOM_SEED" ] ; then
 	# Choose a random value.
 	n="$SRANDOM"
+	[ -z "$n" ] && n="$RANDOM"
 else
 	# Parse as number.
 	n="$(strtonum "$NFT_TEST_RANDOM_SEED")"
-- 
2.43.0

