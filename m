Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83701BCA0F
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Apr 2025 17:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745169649; cv=none; b=RM/IucGUKy/DdiVpO3S3PThP+9qQHbbb2e0oM8sE2koAZaIyUB8ajO2s/lb2GwC/R37ma7Zrxug2vwtTE0C0zjQo9VfNXl8o9Sx+o+RlX3LOr9t2dSdAwCnfBPYccoQALYHvBGKQ+th1XYsDhqyBxDLbrFTNzymvd+mgjLXVfH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745169649; c=relaxed/simple;
	bh=afQHsmekYo7R4OkXwDmNPPdpS1ULP3MZbbhw+ycl34w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPZE8ryfqD6IIoAzLONJvcNq12lurAje4UxgaLyN8tU4Rmkjh4buHFJhpNPFE5hQOqv6MyzdYguJvY+jm11ASXuj1SrlUWQbRiSl5aIaoZqAbnq/+lOtnCen7hVRSg0KSQw2If5bvVqXOY0eL6m5rQA+JTeX3+idp6TTUuUnrM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=SRgVRkI7; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="SRgVRkI7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Pd6zySBcJ/7MBBNtHFMmVCI0ftu/JmymRxa2swE87fI=; b=SRgVRkI74z94wRp4XOpnWONBjr
	bpBC31sf5/qt9foFIPlW2V14sZf7ySKXruGn1R7ym1PVf8sI9pKrcNP+38VzhqsZI33QDfJmMYzcs
	P3IduFnIqVIRJzeRjqolsJLkjgv7Ircbv8HJJK8wO3i4Josb/KK+e8gwlNAKfnsF8Ip+m2cXFrFZF
	LXI4HWZlI/qdw/qbo1NPl+G279YwSvGC6tMa+rkAtXzuQKkuOwgk4e5Hg1+z38H3h1TCa9ZFPQOlG
	CfxME2mBwbmOaVD2Hehitq7iUc4D8zGJVaQFdVVq3rDQysWDyciVp6S2sR+8q3KMhpKvjnp358oU6
	/gPwdyrw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1u6YLO-005Uip-0D;
	Sun, 20 Apr 2025 18:20:38 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc: Slavko <linux@slavino.sk>
Subject: [PATCH ulogd2 1/6] IP2STR: correct address buffer size
Date: Sun, 20 Apr 2025 18:20:20 +0100
Message-ID: <20250420172025.1994494-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250420172025.1994494-1-jeremy@azazel.net>
References: <20250420172025.1994494-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

The elements of the `ipstr_array` array are `IPADDR_LENGTH` bytes long where
`IPADDR_LENGTH` is a local macro defined as 128.  However, this is the number of
bits in an IPv6 address, but the elements of `ipstr_array` only need to be big
enough to be used for the output of `inet_ntop`.  Use the standard
`INET6_ADDRSTRLEN` macro instead.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_IP2STR.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/filter/ulogd_filter_IP2STR.c b/filter/ulogd_filter_IP2STR.c
index 4d0536817b6c..c52824b79e65 100644
--- a/filter/ulogd_filter_IP2STR.c
+++ b/filter/ulogd_filter_IP2STR.c
@@ -28,8 +28,6 @@
 #include <ulogd/ulogd.h>
 #include <netinet/if_ether.h>
 
-#define IPADDR_LENGTH 128
-
 enum input_keys {
 	KEY_OOB_FAMILY,
 	KEY_OOB_PROTOCOL,
@@ -137,7 +135,7 @@ static struct ulogd_key ip2str_keys[] = {
 	},
 };
 
-static char ipstr_array[MAX_KEY - START_KEY + 1][IPADDR_LENGTH];
+static char ipstr_array[MAX_KEY - START_KEY + 1][INET6_ADDRSTRLEN];
 
 static int ip2str(struct ulogd_key *inp, int index, int oindex)
 {
-- 
2.47.2

