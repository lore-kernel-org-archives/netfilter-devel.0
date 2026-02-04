Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAFA2C08DC
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 14:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216592; cv=none; b=fHCP2CrBBiIFpNZLYIvwuU7eV3c28fHcvH8cDDRqB4Z+Y47CrxMJRWIm1DB+Rpi1SpXYAatXXrUdO5d1mZArtPHE5/ee+dVEJA3f9Q3h3rKqVVN3pBS7Abu/k7g6Ki+llDAmAAJH/Tzqr2gBo4WF/peE9rfmT8BylKt2LnpWdU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216592; c=relaxed/simple;
	bh=opIQ8bX2Wt8Dlacp6feJVzbkduaJndwWFQD+hCPi0PM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CZnVZO/RngWKH5JijiXYVI09bReCGVWvoIJK8uFdzQ1D1/OBnQBoD27sltUy+dkoV4JAMXpPBo7PspznEb3wfb8e0KVI/Edgge8IJNiomPu9Xvi/bVFk2bkPBKN60X3eNNa4sk9UouYVGE4125q1hrCynDRmwIuT3o433ToQPF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ee3bCE9T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ee3bCE9T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770216590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jFMnAjWG3EdqauPPvauJcIC/Ue+ex+VI9NR/OauuudY=;
	b=Ee3bCE9Ttmsl3k41ts0zjZwsyGmO75yb7/SaFNbMnygDVPxOF4/jE7x6XLbaobLDpOfQcc
	xkHbO07EiO5dwu9pZsVVlaYddVxxTOX+fhFPuUeIyq/nDxvBfZixHJnv8wwt7dUpcTt4RQ
	wlOTYMxyyaGxF1dkCF7mOPNqWXtIUeY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-272-pd6DyX8FP3Wa2CfK0KcqKw-1; Wed,
 04 Feb 2026 09:49:47 -0500
X-MC-Unique: pd6DyX8FP3Wa2CfK0KcqKw-1
X-Mimecast-MFC-AGG-ID: pd6DyX8FP3Wa2CfK0KcqKw_1770216586
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 24AD61956046;
	Wed,  4 Feb 2026 14:49:46 +0000 (UTC)
Received: from yiche-laptop.redhat.com (unknown [10.72.116.123])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 335881955D85;
	Wed,  4 Feb 2026 14:49:42 +0000 (UTC)
From: Yi Chen <yiche@redhat.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	netfilter-devel@vger.kernel.org
Subject: [PATCH] test: shell: run-test.sh: introduce NFT_TEST_EXCLUDES
Date: Wed,  4 Feb 2026 22:49:40 +0800
Message-ID: <20260204144940.63422-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Introduce the NFT_TEST_EXCLUDES environment variable to allow excluding
one or more specific test cases.
This is useful for some releases where certain tests are not yet supported.
allowing them to be skipped directly in the test script
without modifying the run-test.sh itself.

Signed-off-by: Yi Chen <yiche@redhat.com>
---
 tests/shell/run-tests.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 46f523b9..6273c9a2 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -255,6 +255,7 @@ usage() {
 	echo "                 Supported <FEATURE>s are: ${_HAVE_OPTS[@]}."
 	echo " NFT_TEST_SKIP_<OPTION>=*|y: if set, certain tests are skipped."
 	echo "                 Supported <OPTION>s are: ${_SKIP_OPTS[@]}."
+	echo " NFT_TEST_EXCLUDES=\"TEST1 TEST2 ...\": Specify tests to be excluded from running"
 }
 
 NFT_TEST_BASEDIR="$(dirname "$0")"
@@ -455,6 +456,11 @@ done
 
 NFT_TEST_SHUFFLE_TESTS="$(bool_y "$NFT_TEST_SHUFFLE_TESTS")"
 
+if [ -n "$NFT_TEST_EXCLUDES" ]; then
+	TESTS=( $(printf '%s\n' "${TESTS[@]}" |
+            grep -vE "$(printf '%s|' $NFT_TEST_EXCLUDES | sed 's/|$//')") )
+fi
+
 if [ "$DO_LIST_TESTS" = y ] ; then
 	printf '%s\n' "${TESTS[@]}"
 	exit 0
-- 
2.52.0

