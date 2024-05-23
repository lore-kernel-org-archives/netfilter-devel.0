Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F1B5227
	for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 14:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716475865; cv=none; b=lNjPPin0fUW8Gbf+ooUZ7Eb+HyogYOBvM2Q/ohLGyXiULwOyPLkx6KNV8dD8hAYogN2B3XAXnp/PKhP068tGNvZRdSbJtv6ig22JAQ5njib6kW3/QzxLvwxuLIxsy69OzU250iK1Mg/eivE52RcBhGDMKwK/+qsBa38DTquVwZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716475865; c=relaxed/simple;
	bh=kqq/9o+TWUR6z151UEqkkoRlxX+H5n7OeKNBmIuru5g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bFUg1YeGKWUZFDRCHDg+pFuD3Q2FLn9y8XhThdD7zoE75R0m5vKO7RXEDVXY1+6tWCxCL/H25lsemiKUkkZSkforXLGI7LOV2pAPTIBpopW4YXrO552IUnwPqyLxJdtPNvAbZz7gMOpNnOfVWu+Yahpap1pJJ0iuhXQuBcTXINA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=michaelestner@web.de header.b=Ok6sgi2L; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=michaelestner@web.de header.b="Ok6sgi2L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1716475860; x=1717080660; i=michaelestner@web.de;
	bh=1fNvdjn92tRx5geA2KgLSCcIcfcdwQ73S6qAkK9o0aw=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-Id:
	 MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Ok6sgi2Ln0jSa0Kk8+cKVPsosN27y2L6plMgkVSLjYQwwzZqOClING8W2HHBaGK0
	 nIgiexxoYBnfQFRo3NA5ZOmZ0XtrGwcs70T65DCmlP23ge8qYLbhig8QpBK4qu7S2
	 Qv52bQ+RHJYH4Px2UdX1lvtNWlvy18p3E8Uj3d7VVI48eMkP6Wl7KSd9JKVsNwTTe
	 NPbHOG+0/4YLb/aAdfI4USCswh9lJJHKKvpn+pdnvRewzvmdqJtfRR9uykeSGhGus
	 dRdSJ2FoeJOCvHGpsfJrOS2btJ5CZ2frC2NibACjzp4I9AVXSINqPplg8LSuR+XRj
	 3PfpLaWl44C813ruOw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from del01453.ebgroup.elektrobit.com ([213.95.148.172]) by
 smtp.web.de (mrweb106 [213.165.67.124]) with ESMTPSA (Nemesis) id
 1Mm9Zi-1ssKEm0izg-00iBpv; Thu, 23 May 2024 16:51:00 +0200
From: Michael Estner <michaelestner@web.de>
To: netfilter-devel@vger.kernel.org
Cc: Michael Estner <michaelestner@web.de>
Subject: [PATCH] iptables: cleanup FIXME
Date: Thu, 23 May 2024 16:50:58 +0200
Message-Id: <20240523145058.747280-1-michaelestner@web.de>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:dtGqS2SmVeh10NdtLqynS717IIW/Vf8zKd9CoDQFFgEXFnvmSLW
 tCfW6NFfF6uYrf7kQVEbxr5EMdEx77QdKw2IRjWuDEtQ03wsp5fb9/Ha94FsshklfzU2eYk
 OfuYXkTzJtCM+LHkBzVDM3c9WrvApSOBxpHlmgzBZKTGn+o5FFMR+NtxYD21xxM0uWc/fhz
 3rWrQW+dS6i+5mL4V/Fng==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:d6K6zBcojLw=;SIKdL8h3tzPdc8Bp2nD8hnDnCuP
 H/OFd3jqVbI8YA29ISyfv0M7/1WkueA0Gnv23UzJw/vMJ7klB9FItQUTZrs9Ra/OC21/6Vqk0
 +db4DvGyYQK0Yhp+7bB/BJjfrWvV7DZeS+UVnG1HZqje5nE/n94Wod/lns8mGT0Vbz8rW3spH
 KCjqsjiUcycdC49i+bGe1lS9p+UlPRKq132VRbuBOjBsU631qJ0rVe7iGnUHk8/9cN882on3o
 HRHy78JkFmKkywOEL1YUuUR9g79OxWWhqT9r08PpO6879T1b4uLhJUyTHGp/xP0T0oDP6Re8N
 87HnchqDlDolQBmeIlOvP4GygygWRa3ghAgJm6tooHdcqFa5x2/+BS9kWRPk7y0Ee4qgpv0EE
 UeTdAcO5jI/nwnuBZwiWN3SA5NhsIqRg7Jq23WCG85Rkti1UUdVQSUSN6UZgj5m0RNRWGezeW
 BYYprGQzhk7CK5Cwuy5Rx9X4zo8BxmODBs2BFiFEe5iA7ekpenzP7vGAKPk9Mb6EHal9u3vSA
 ltVDk4lz06lI4mfl3iF9W0Y3/pgGWJuvQpkICUjIHvIl5VrZTZ5JAhRfrBYCGU1xm3px/CdcL
 2B562IPBk3ij5u12d/T1zls5oKsQ/mpIxhWgOoYc75B/c9jt1coeK412hOtZU4mdRyEIuz1sq
 LhzbM+MgY6QTZagul/bmYQ3oycCOySkzM5oiZIRZn/mE/ZWsj/3qSrSZwOEpuh19gu/mQqHOi
 NV4GSX58g/feRKHEg1MjzmMnD3QUpS/Br/cxrYtQH7NQrGRL2kApBNQ9aci2R7KcE9dJzhrTk
 tJout591zUYlgGE7f688DHBb9LGk4D+eXK5C0jPfNB+BE=

Remove obsolet FIXME since struct ebt_entry has no flags var.
Update the debug output.

Signed-off-by: Michael Estner <michaelestner@web.de>
=2D--
 iptables/nft-bridge.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 922ce983..f5deaa93 100644
=2D-- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -373,9 +373,8 @@ static bool nft_bridge_is_same(const struct iptables_c=
ommand_state *cs_a,
 	int i;

 	if (a->ethproto !=3D b->ethproto ||
-	    /* FIXME: a->flags !=3D b->flags || */
 	    a->invflags !=3D b->invflags) {
-		DEBUGP("different proto/flags/invflags\n");
+		DEBUGP("different proto/invflags\n");
 		return false;
 	}

=2D-
2.25.1

