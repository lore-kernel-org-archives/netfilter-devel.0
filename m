Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF6A1DDC19
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jan 2025 17:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738170411; cv=none; b=ILt4eUaxcsJxTSA1YlhMHEu+yxp03tAkoM2xuvk04wdDri6rk1maAnLOl+0WEm/kPrIOmaNxskRBERS1lbrFmkzkiavVowIEm8A9HsdX17h+HvQhPW3ciMCZgWVimkNKcIqic8gDaKSsUbUJNLBgwu8DQrNxhdqajZ9kwRKjdBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738170411; c=relaxed/simple;
	bh=DbAd1Uis6CG1O8BAj6UDkFHPnmyKhw3sSvJa/aemteE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jrcxi4YHE8Ov71hM2D7jDZYm968YPH3yUg7FWw5MDB9p8XN0G677P24AkBn2sXStbCnCxGVLmb2Z7Iv8EKbGaEKtg8B0bY9nmfViDoytuJDjMPqhROGCKrQoMhTWHWE5FIUrSlYxhRwk0WapO62wpkVKPtTQbzXum/5UxOPXDlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=clip-os.org; spf=pass smtp.mailfrom=clip-os.org; dkim=pass (2048-bit key) header.d=clip-os.org header.i=@clip-os.org header.b=WOHHk8q/; arc=none smtp.client-ip=217.70.183.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=clip-os.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=clip-os.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=clip-os.org header.i=@clip-os.org header.b="WOHHk8q/"
Received: by mail.gandi.net (Postfix) with ESMTPSA id 6513A4434F;
	Wed, 29 Jan 2025 17:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=clip-os.org; s=gm1;
	t=1738170407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gPmmrpyO6I8uCE/baq8eRGrnJPLd3G7FD07J04259Fs=;
	b=WOHHk8q/oEyPIcWTS4/PErkRKwvI6KWk7E5MtiYwzmifPu1Raow6GtezQaTlZp7Drn9AQY
	0Dk0QYkTXcf6ZCba/r89U7B3sBQtcjTWZrSWPf+qGjT8xIMW/m8CVxskbYSVlgJWzGJTHp
	CfYwR586QDB6+mohdWYsnjFYzjPhRsK+U4vlwuoatIQ4kssP2Sz6XJNfdS6zf/Eg0xoGZF
	zo1n1kX9Cf0DrWPvYKnVG4kCk2VlQS+6lgpp48sIgRD/WksMGniwE3FJtNMELwsHPTozz4
	jvjMN617hCblgii1I1JeTPSc1W7Xy3YPh4RMAUkwMu5xNh2Uk37JulCANRhH9A==
From: nicolas.bouchinet@clip-os.org
To: netfilter-devel@vger.kernel.org
Cc: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: [PATCH v2] netfilter: conntrack: Bound nf_conntrack sysctl writes
Date: Wed, 29 Jan 2025 18:06:30 +0100
Message-ID: <20250129170633.88574-1-nicolas.bouchinet@clip-os.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdefheeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpehnihgtohhlrghsrdgsohhutghhihhnvghtsegtlhhiphdqohhsrdhorhhgnecuggftrfgrthhtvghrnhepkeeihfefheelueettdejueehudeltdehleekgefgleeiuefhgedvkeffjeeggedunecuffhomhgrihhnpehnvghtfhhilhhtvghrrdhnfhdpkhgvrhhnvghlrdhorhhgnecukfhppeeltddrieefrddvgeeirddukeejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepledtrdeifedrvdegiedrudekjedphhgvlhhopegrrhgthhhlihhnuhigrddrpdhmrghilhhfrhhomhepnhhitgholhgrshdrsghouhgthhhinhgvthestghlihhpqdhoshdrohhrghdpnhgspghrtghpthhtohepgedprhgtphhtthhopehnvghtfhhilhhtvghrqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepnhhitgholhgrshdrsghouhgthhhinhgvthesshhsihdrghhouhhvrdhfrhdprhgtphhtthhopehprggslhhosehnvghtfhhilhhtvghrrdhorhhgpdhrtghpthhtohepkhgrughlvggtsehnvghtfhhilhhtvghrrdhor
 hhg
X-GND-Sasl: nicolas.bouchinet@clip-os.org

From: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>

nf_conntrack_max and nf_conntrack_expect_max sysctls were authorized to
be written any negative value, which would then be stored in the
unsigned int variables nf_conntrack_max and nf_ct_expect_max variables.

While the do_proc_dointvec_conv function is supposed to limit writing
handled by proc_dointvec proc_handler to INT_MAX. Such a negative value
being written in an unsigned int leads to a very high value, exceeding
this limit.

Moreover, the nf_conntrack_expect_max sysctl documentation specifies the
minimum value is 1.

The proc_handlers have thus been updated to proc_dointvec_minmax in
order to specify the following write bounds :

* Bound nf_conntrack_max sysctl writings between SYSCTL_ZERO
  and SYSCTL_INT_MAX.

* Bound nf_conntrack_expect_max sysctl writings between SYSCTL_ONE
  and SYSCTL_INT_MAX as defined in the sysctl documentation.

With this patch applied, sysctl writes outside the defined in the bound
will thus lead to a write error :

```
sysctl -w net.netfilter.nf_conntrack_expect_max=-1
sysctl: setting key "net.netfilter.nf_conntrack_expect_max": Invalid argument
```

Signed-off-by: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>

---

Changes since v1:
https://lore.kernel.org/all/20250127142014.37834-1-nicolas.bouchinet@clip-os.org/

* Detatched the patch from the patchset
* Squashed patches 1/9 and 2/9
* Reworded the commit message to make it more clear.

---
 net/netfilter/nf_conntrack_standalone.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 7d4f0fa8b609d..3ea60ff7a6a49 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -619,7 +619,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.data		= &nf_conntrack_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	[NF_SYSCTL_CT_COUNT] = {
 		.procname	= "nf_conntrack_count",
@@ -655,7 +657,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.data		= &nf_ct_expect_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	[NF_SYSCTL_CT_ACCT] = {
 		.procname	= "nf_conntrack_acct",
@@ -948,7 +952,9 @@ static struct ctl_table nf_ct_netfilter_table[] = {
 		.data		= &nf_conntrack_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 };
 
-- 
2.48.1

