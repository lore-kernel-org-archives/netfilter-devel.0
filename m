Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZW7NsA3+"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68019CB
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2023 04:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700830098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VzghYHckLmDegCHitcuReKb14hSj880mcWKORkoKgIE=;
	b=ZW7NsA3+MH5boj0uqWB/L5Ewl0xQaJDVcQ8LaOmVW0julskC4kEJt7IS3u3agj6EOkPH/t
	d/d8H6hn2Chuk7d+QkXi7TxZQ0CbHmqS6Q7VROoWrgLhXdxzYIdsSYUAK3fIjkfTZJpmh+
	ee+5OqlQhFAzOmKP438iQbS4i4N/Epw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-eGhqFV0bO8uaIaB9skjWPw-1; Fri,
 24 Nov 2023 07:48:16 -0500
X-MC-Unique: eGhqFV0bO8uaIaB9skjWPw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DEBC3C0C489
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2023 12:48:16 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.249])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE412492BEE;
	Fri, 24 Nov 2023 12:48:11 +0000 (UTC)
From: Thomas Haller <thaller@redhat.com>
To: NetFilter <netfilter-devel@vger.kernel.org>
Cc: Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 0/2] pretty print .json-nft files
Date: Fri, 24 Nov 2023 13:45:52 +0100
Message-ID: <20231124124759.3269219-1-thaller@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

The plain `nft -j list ruleset` output is hard to read in diffs.
Instead, commit pretty printed JSON to git and compare that.

Existing .json-nft continue to work, and don't need to be regenerated.
But when the dump content changes, the prettified version is committed
to git.

Thomas Haller (2):
  tests/shell: use generated ruleset for `nft --check`
  tests/shell: have .json-nft dumps prettified to wrap lines

 tests/shell/helpers/json-pretty.sh  | 27 +++++++---
 tests/shell/helpers/test-wrapper.sh | 81 ++++++++++++++++++++---------
 2 files changed, 75 insertions(+), 33 deletions(-)

-- 
2.42.0

