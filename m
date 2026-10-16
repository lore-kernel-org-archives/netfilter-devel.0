Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ED7283FC4
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 03:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792121100; cv=none; b=hZywAS4h7Ul3e95Oy/zFqJMRNSUdmbtoVHcaF5Q/yBF3z9BecNLSZqdGv8qPjw43tnaR+QlrIgJKuDvRoro7WCVmfzReIJjgWB7QyGW7PmB1l6A0TlowqM+opOoXqj+m7ysgMBLGSUtZD5CUmbSwj8jNEXaQQYM8jZQaWXKQy08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792121100; c=relaxed/simple;
	bh=VAYw88I+9VaH/VE5jLaVfKqISjAXRKl1BsTI072NjBo=;
	h=From:To:Cc:Subject:Content-Type:MIME-Version; b=HZw4FWU9QDZ+m6k2YHlgR5X2DTeMufTz110nogYIYSQzml8aVTQd/AZM2y2gaRT8kTZ5wuHbreIRL2bcbOLxmWPH1zlTK4CtYlqMYgsc3Wk0R6hwEUStpGAfhDZ2DvDryhZ/OAWngTchND4vPDAPGF8mTfG6DETUezBbb2g/6dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 26fa4ea4c91111f19a56ed5b684f684d-20261016
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:e99a3753-6991-4277-b2ee-7ff55e409373,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:7db8b62,CLOUDID:8924c9f4fdca0f80d0ba0e61f374d9df,BulkI
	D:nil,BulkQuantity:0,SF:102|136|865|898,TC:nil,Content:0|15|50|99,EDM:-3|-
	100,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
	,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 26fa4ea4c91111f19a56ed5b684f684d-20261016
X-User: yupeng@kylinos.cn
Received: from [127.0.1.1] [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <yupeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 898783022; Fri, 16 Oct 2026 11:24:53 +0800
From: YuPeng <yupeng@kylinos.cn>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de, phil@nwl.cc, debianyu@163.com
Subject: [PATCH] extensions: ebt_string: Remove spurious inverse check for
 --string-icase
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <20261016032457.aGsnigsngplFaMnyoCZR-AVxNmI_dNbq-9j77nd7-w8@z>

--string-icase is registered as a no_argument option, so getopt_long
always sets optarg to NULL when it is parsed.  The ebt_check_inverse2()
macro contains a mandatory-argument guard:

	if (!optarg) {
		__ebt_print_error("Option without (mandatory) argument");
		return -1;
	}

so every use of --string-icase aborts parsing with the misleading error
"Option without (mandatory) argument." and XT_STRING_FLAG_IGNORECASE
can never be set.  The option has been broken since it was added in
commit b1cdae8 ("extensions: Add string filter to ebtables").

Reproducer (no privileges required):

  $ ebtables-legacy --string-icase
  Option without (mandatory) argument.

The inverse check makes no sense for a flag option that takes no
argument, so simply remove it.

This fix was originally carried in the Kylin Linux SRPM since 2022;
the commit message has been rewritten to describe the actual failure
mode observed on current master.

Signed-off-by: YuPeng <yupeng@kylinos.cn>
---
 extensions/ebt_string.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/extensions/ebt_string.c b/extensions/ebt_string.c
index 97fbe19..74a1bfa 100644
--- a/extensions/ebt_string.c
+++ b/extensions/ebt_string.c
@@ -174,8 +174,6 @@ static int parse(int c, char **argv, int argc, const stru=
ct ebt_u_entry *entry,
 		break;
 	case STRING_ICASE:
 		ebt_check_option2(flags, OPT_STRING_ICASE);
-		if (ebt_check_inverse2(optarg))
-			ebt_print_error2("Unexpected `!' after --string-icase");
 		info->u.v1.flags |=3D XT_STRING_FLAG_IGNORECASE;
 		break;
 	case STRING:
--=20
2.39.5
