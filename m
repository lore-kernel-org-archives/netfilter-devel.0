Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793291835;
	b=ZU2uaAWPXPuhw2ZopmpTXuGdTNl3gx6YcAs23C+qM1n6siniPCpG8AcGg8d0P2vt75C4
	 mA/vcKKzMtZd6Z77ds6PnXGsEFapBkeNHlzSS8ClumQVNkb0cKT9CrjCSCxppHZSsM1bn
	 xrY/9V7MJXzC+MAE3kc9ZPf7NWnJ2nD4YSvvxHeJtMEAfI12D6pa9U0OfSL72HBmxeXlW
	 qlc2/JuK8+oyY/PgFyIwmX1Rw0HRKp3QaHo4if6jIRL81w5YRGI5kEr1RmQcbir5G49jy
	 T+C4waUzJvZYJA20KlxNPubDcKWhfaMNjh/IaQ4Lfhwinmw8it2FXZCVu5gHOzw/Y+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793291835;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=b7QZH0lCvs1/q0R6dN0R1hS8XbvhslJdHIN9oLMr40M=;
	b=p5zQduYfsqCLCrCw8WoQn4UhnC+l83suEudaC963+RN9IXf/Fplc1ydody4q9WVNWy/Q
	 ovgfzNSANWmgAguB0tXow+0HYR5yinUyTK1XcmZQutXtfKgJ1gZeMCROBZjBBLyfzO3Bz
	 8jtQalOiQZKj40Bvr7+sf4qsFqcgszJfn69aOyVF8hIWdMP9rYrr1dtWfc/YRmV0PJYyb
	 V8yljd6GkEhFxhzcP+EbA6dgUTD8k2FXZw5UXf0ZBsGt39pBa4QZ1PmhywYrkJe+j1A2P
	 7weGY5l6JtMsdEG/3MWscGykgMlLM3wMPTAWtJLr6ND1ITRIywulpF1j9Tl5f/Rpw/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=boIS3vQl;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42C4606A31C
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 16:37:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B42C4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=boIS3vQl
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=b7QZH0lCvs1/q0R6dN0R1hS8XbvhslJdHIN9oLMr40M=; b=boIS3vQlT1bZbwz2hSGssrf8W4
	qgmiFRiPUJazsSZwmCFkg62Czu0s5TCCxAEgd1+WcAwcsAYX4G8Q8eC4lOzmFrO3SW1bn9y4f7TgG
	ssENi6F7g2V3CIL+UNQcwdH0rQ/XIwDvb5O8lf6WCG0JFtgvhv95v1GvX94vAbBmlOZwU8l55gmzY
	KwAvl/qPLFNcOFChYY0Bu9BKkI6l2FrqYBfngd9BfYrT/YE5zask5oRMuYSXW0pkbZpWykQhf9SNT
	7JvCK5BPR1isFzY+gcMApEQymyrXkABdqFEUyWasowamnHt1+fBiisKt3oawpkQmpuRcriUJoCsvp
	gSAMFlEg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xMT7n-000000001oB-284W
	for netfilter-devel@vger.kernel.org;
	Thu, 29 Oct 2026 17:37:11 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/2] tests: shell: Fix packetpath/meta_time on slow systems
Date: Thu, 29 Oct 2026 17:37:05 +0100
Message-ID: <20261029163706.3243948-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A system so slow that the whole shell test suite run takes 20min fails
this test, probably because the last non-matching rule's range starting
10s ahead is not sufficient. Move that time range into the past, so the
test may take up to 2min to complete and still pass.

Fixes: b5145809b1bb8 ("tests: shell: add packetpath test for meta time expression.")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/packetpath/meta_time | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/testcases/packetpath/meta_time b/tests/shell/testcases/packetpath/meta_time
index 67b37f4e1073c..9bddccbd80cee 100755
--- a/tests/shell/testcases/packetpath/meta_time
+++ b/tests/shell/testcases/packetpath/meta_time
@@ -40,7 +40,7 @@ gen_in_range_time()
 
 gen_out_of_range_time()
 {
-	echo \"$(date -d "+10 seconds" +%G-%m-%d" "%H:%M:%S)\"-\"$(date -d "+20 seconds" +%G-%m-%d" "%H:%M:%S)\"
+	echo \"$(date -d "-20 seconds" +%G-%m-%d" "%H:%M:%S)\"-\"$(date -d "-10 seconds" +%G-%m-%d" "%H:%M:%S)\"
 }
 
 $NFT -f - <<-EOF
-- 
2.54.0

