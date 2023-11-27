Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JXaT9KMd"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD9DD5F
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Nov 2023 11:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701112646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DM3wf/D/jD0HFWefY0atvQj36Vh8+lRzs/XHYCbOm8U=;
	b=JXaT9KMd7uNqIY1x196JAVPRUXMxeMEBQ6YYvQEI046wLay4/Rs77Hvh2yNkNk6czaUBno
	2YfMmO6aJk8vndwW/AI2XqdBiWgbReBxt+tNBmoE2I9TWV+IWjvoy8i5MnVabX9lI20XN5
	saSBN65ha+aQ2Mr5Wdgj5sZYce7Bn5I=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-328-ouQN_uADP5qMhpjc4xJhew-1; Mon,
 27 Nov 2023 14:17:25 -0500
X-MC-Unique: ouQN_uADP5qMhpjc4xJhew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C47C12818741
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Nov 2023 19:17:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.43])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 114301121307;
	Mon, 27 Nov 2023 19:17:23 +0000 (UTC)
From: Thomas Haller <thaller@redhat.com>
To: NetFilter <netfilter-devel@vger.kernel.org>
Cc: Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 0/2] tests/shell: workaround for bash
Date: Mon, 27 Nov 2023 20:15:34 +0100
Message-ID: <20231127191713.3528973-1-thaller@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

RHEL8 has bash 4.4. Make some adjustments so that the test script works
there.

*** BLURB HERE ***

Thomas Haller (2):
  tests/shell: workaround lack of `wait -p` before bash 5.1
  tests/shell: workaround lack of $SRANDOM before bash 5.1

 tests/shell/run-tests.sh | 48 ++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 7 deletions(-)

-- 
2.43.0

