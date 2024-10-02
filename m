Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C010D1D173A
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 19:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727897945; cv=none; b=DlP5VlXLKlons3Jx6dTDeEnFDWuAFk0+zxXmkHwq32C3eCnQIGExLLv7um+UKj54Uk7a5GF9SvtuGJrjwvMo3SR0Ovhqqt2HFw85Fcl1xOZ+ATEdeHKvVrKlfKvqpyPyAEQ1ZDb09M/3sS9zdpdfx7oMAv76h5aunt/pZ/h/Icw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727897945; c=relaxed/simple;
	bh=eLNda0Wnk+IMfrpjF6NFArZJ4iLcMpBxjUM2NkduRVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFz4dDAg/XDZyQ3DtQjfdZW4gog3PAgFAhMnj1hzbx4Ih+hPDgjFQgCBEPohb2kxY7/9lS6aocRZAwBjpXf7xzhprv50DcdUthYtrbvxIdlmvqZbjJOefjVTnWGZsaTLO5vu1tMrv6xK4JXTdpaZoIY72EtrRQw9tk65lpf+pgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dsbraUPJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dsbraUPJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hAZ75g/LWhELt0dEh5Q/uOCIuhCuQx4iRWkWGP75SQ4=; b=dsbraUPJvJ4E/bprmY40juoWj0
	wthPqbkT0TNM6/Dk3Lw4vSH4R0VOtk1Q4dlvN53ag2tEEk6fAbLu9Xjjq8qARxILdxO25peFXn9m8
	e1rvAAQZ7+VTy4G1/pACrSD56pUEdGdfxhoqw6ykF7TK5uXDiYhrj75jLcJXabeLtKKkct4xAS/tT
	a6/o8vRidt7OFt2lL4SxOX1C7I+x0L4jZD2edytNPe/cPu34IZnnhajEKV3JXYAXEg2aAb2kAUqtO
	bZfCd0FQDODrLlYddI9Mo/rkW34aXbgQq7zIP86Xm6svlNU+RmKPBq9WlzaqViz+Ep/vvoiEit+Nn
	WplHIVnA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sw5Be-0000000031Q-1sUT;
	Wed, 02 Oct 2024 21:39:02 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 4/9] tests: monitor: Run in own netns
Date: Wed,  2 Oct 2024 21:38:48 +0200
Message-ID: <20241002193853.13818-5-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241002193853.13818-1-phil@nwl.cc>
References: <20241002193853.13818-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Have the script call itself prefixed by unshare. This won't prevent
clashing test case contents, but at least leave the host netns alone.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index f1ac790acf80c..214512d269e8d 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -120,6 +120,14 @@ echo_run_test() {
 	return $rc
 }
 
+netns=true
+for arg in "$@"; do
+	[[ "$arg" == "--no-netns" ]] && netns=false
+done
+if $netns; then
+	exec unshare -n $0 --no-netns "$@"
+fi
+
 testcases=""
 while [ -n "$1" ]; do
 	case "$1" in
@@ -131,6 +139,9 @@ while [ -n "$1" ]; do
 		test_json=true
 		shift
 		;;
+	--no-netns)
+		shift
+		;;
 	-H|--host)
 		nft=nft
 		shift
-- 
2.43.0

