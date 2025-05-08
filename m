Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF281E22E9
	for <netfilter-devel@vger.kernel.org>; Thu,  8 May 2025 21:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746740852; cv=none; b=r/q2YlSpRiC+vV9lfI6v/kaIM6YGy/Xn6Z998SAP3g958r+jOKm8RYWj2VGOvZRQhQC4d7orQ57aBM9r3DuZJhiyjhrz/rUi8R4RjIAxcNVfYIu75Cr4YXTuJ3PoQrtHVfdRRJK+8jfV7Kkzhqe6LYAgDNs41vwDi0oGXN1ynUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746740852; c=relaxed/simple;
	bh=uLv1CIwHLBYzQzQsRElb0KZoJwIH1BQUGteHCRiDDtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HU7VGdPxKPlBIeGx6TZyxA1efPADA3QQjBlAGt5hqAUJprtMBkvULrKZcPBEUa+afeSsxC/5+C93FxAP3QV3YomNn+NZEUr1Bc1998zpSY/3WZeXfEnTlSe7fHlq+rLARBpmk262acYssogk4uAnvQUHkn066gWlHxuYKH+7YE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PRJxFJEE; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PRJxFJEE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=G/FzAYQgFnpjfa3wCsISza8Y3t0ir/XkyAzqqTxupn8=; b=PRJxFJEE/1eV+IHtA+Cqwxpx7o
	oCC61/kW2V3+VHGPjAsvewFA/u7XVzTuuIvl0ER37tRowqg6yBKyyTUuD5ZgE/wJnNbE04oCvSz/x
	yYD8Ca/VDeetTQY4DTqV3JxZEJ1hPKFgrukEmXovFAQfSXZO6eLg2dUvq9ceOWIhHl2UwSxLT4c2y
	MEH496E8STc9GvjcwRfy9nOvjsNxGIoY4szPgTgIGACokPcAPoqW6Ro2T6bstoW4zd1R4ix0k5gRI
	/ihXd1E8ubGGVmKfZr/1OjARar9vZCONK9wNhnVEC83wMlMDzVjUR3Kiu1lcQgIFtrvDqfeOpUmCM
	Twp4mA7A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uD95U-000000000mn-1ety;
	Thu, 08 May 2025 23:47:28 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/6] json: Print single fib flag as non-array
Date: Thu,  8 May 2025 23:47:19 +0200
Message-ID: <20250508214722.20808-4-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250508214722.20808-1-phil@nwl.cc>
References: <20250507222830.22525-1-phil@nwl.cc>
 <20250508214722.20808-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check array size and reduce the array if possible.

The zero array length check is dead code here due to the surrounding 'if
(flags)' block, but it's a common idiom one could replace by a shared
routine later.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/json.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/src/json.c b/src/json.c
index 6b27ccb927017..a8b0abeba6396 100644
--- a/src/json.c
+++ b/src/json.c
@@ -939,7 +939,15 @@ json_t *fib_expr_json(const struct expr *expr, struct output_ctx *octx)
 		}
 		if (flags)
 			json_array_append_new(tmp, json_integer(flags));
-		json_object_set_new(root, "flags", tmp);
+
+		if (json_array_size(tmp) > 1) {
+			json_object_set_new(root, "flags", tmp);
+		} else {
+			if (json_array_size(tmp))
+				json_object_set(root, "flags",
+						json_array_get(tmp, 0));
+			json_decref(tmp);
+		}
 	}
 	return json_pack("{s:o}", "fib", root);
 }
-- 
2.49.0

