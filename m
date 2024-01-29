Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06A4B152DE7
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2024 14:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706539908; cv=none; b=VAgr1C5rjpHx8F2a5ihSzH0TLDwVKJ8295gahX6qHeL0+EpQ7UH8lhuhwFnF+LyhBwS6x9Q+3L0l9A161YfgyjulDWP9mOBe7pFmc2A21VzwFjPk6S9gEyP1KS02qXeNecww3T0UlHFs6YjRqQsXYheIucptyMCy5v69aps3/D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706539908; c=relaxed/simple;
	bh=lAtOdTUTMsdPPHs3RsMXV+Clfm1w2DoEBbArAIWmf2I=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=rcMo4Ns9KsqqMVmb4KioYA6rzlZyW5tmm4ZiXQAxEf/wSZ7FqIa3++M1ixmF3CKZV2QzeTIDc5PTltA75zqIeViUsSbZOb9kjudQIA6GPopmp96nJl9L5MxPcBFZ2RGofTaddl2T/5GfgaOFkBG/PFB2MNx5Rjm3dGvuOMEOSr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] datatype: display 0s time datatype
Date: Mon, 29 Jan 2024 15:51:38 +0100
Message-Id: <20240129145138.139214-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise, nothing is printed in case that time is 0 seconds.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/datatype.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 099e7580bd6c..3205b214197f 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1090,6 +1090,7 @@ const struct datatype icmpx_code_type = {
 void time_print(uint64_t ms, struct output_ctx *octx)
 {
 	uint64_t days, hours, minutes, seconds;
+	bool printed = false;
 
 	if (nft_output_seconds(octx)) {
 		nft_print(octx, "%" PRIu64 "s", ms / 1000);
@@ -1108,16 +1109,29 @@ void time_print(uint64_t ms, struct output_ctx *octx)
 	seconds = ms / 1000;
 	ms %= 1000;
 
-	if (days > 0)
+	if (days > 0) {
 		nft_print(octx, "%" PRIu64 "d", days);
-	if (hours > 0)
+		printed = true;
+	}
+	if (hours > 0) {
 		nft_print(octx, "%" PRIu64 "h", hours);
-	if (minutes > 0)
+		printed = true;
+	}
+	if (minutes > 0) {
 		nft_print(octx, "%" PRIu64 "m", minutes);
-	if (seconds > 0)
+		printed = true;
+	}
+	if (seconds > 0) {
 		nft_print(octx, "%" PRIu64 "s", seconds);
-	if (ms > 0)
+		printed = true;
+	}
+	if (ms > 0) {
 		nft_print(octx, "%" PRIu64 "ms", ms);
+		printed = true;
+	}
+
+	if (!printed)
+		nft_print(octx, "0s");
 }
 
 enum {
-- 
2.30.2

