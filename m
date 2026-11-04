Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793763184;
	b=PGwbt9Oa0n9pi0IZuk1zaWY/YGZYJRAwavNlctH6e5IT/e5UFh0Fo3tMW3VzD4V8IHUT
	 w6aaX5GeknxhJve9hgwwRK2iaLVIABJUMXW4l4SSTRKufV1BbqgN4D1l2TTbiBVt2nTNx
	 HWuyoDlWRVjCFpNzX/GBbXO5YWfJiz1kkjagIFVY1hl3kqFtaEOfDGiJD7ngYyeMHZo8Y
	 2st4sK4tlBMDEtYXCcbEnpOIpec0hS2fB2ozdVsKk6R4cSgE3GcSpG3CFjP3m5fURwE2W
	 54eNH3rNH3jx+p7UMATVV8SbnZyakznDiSxTzF6TWXAYH7SFK6+qUo79s43SNovnU0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793763184;
	h=DMARC-Filter:X-UUID:X-CID-P-RULE:X-CID-O-INFO:X-CID-META:X-CID-BVR:
	 X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:Received:From:To:Cc:
	 Subject:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 MIME-Version;
	bh=l8VqXxd/sdfHt2LeZCunmDHUpQmLkttaE3civqC/2uc=;
	b=rNTNmTiDp0+peRRfNS55idg+Vqw04fop6GWWpvdvIgZMRhRn5P6R+DabwWWmlLS2cnMs
	 0KLGfYhsDLgOxr+jQkPRbpVTJO2TNgHbEDEM6hB+mq4MJ1iNCZd9ZiZpO5FF7zx6eJyMv
	 0zJa3GES1p43BQApyB78Pe6qIpuLaqkH6kAuxy+xthYD0VPojJzxFJQ02iHEIRs5t10oP
	 XtESeaBYUsVpmubB3r3veYkj5O25vy07Q8uWNXsYaDJzLPox2kxiM6kSd6peJY70jAGPA
	 bPWMJEJCKGHL+Xs8JgwRen9pBBD9PuNVXJwDgQPU52kyAAkP4T4AHli+du9e69L+OhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8684606A31B
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2026 03:33:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8684606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 6c470e5ed80011f19a56ed5b684f684d-20261104
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:c578295c-945f-4d84-8d15-e5ab0e360a6d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:ea64efadd61072fb2bf8b8ab97d23355,BulkI
	D:nil,BulkQuantity:0,SF:82|102|136|865|898,TC:nil,Content:0|15|50|99,EDM:-
	3|-100,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6c470e5ed80011f19a56ed5b684f684d-20261104
X-User: yupeng@kylinos.cn
Received: from [127.0.1.1] [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <yupeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 567319487; Wed, 04 Nov 2026 11:32:55 +0800
From: YuPeng <yupeng@kylinos.cn>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de, phil@nwl.cc, debianyu@163.com
Subject:
 [PATCH v2] extensions: ebt_string: Fix --string-icase using ebt_check_inverse
In-Reply-To: <atXZ1Fc4HOy--Wam@strlen.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-ID: <20261104033301.6fepl06bgAJvMxxLy5Hw1g-x-k6uyig0PqEISfmmPjE@z>

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

Use ebt_check_inverse() instead: it tolerates a NULL optarg and
returns the current ebt_invert state, which the main option loop
resets to 0 after every option, so the flag is set as intended and
the "Unexpected '!'" diagnostic is kept.

This fix was originally carried in the Kylin Linux SRPM since 2022;
the commit message has been rewritten to describe the actual failure
mode observed on current master.

Signed-off-by: YuPeng <yupeng@kylinos.cn>
---
v2: Use ebt_check_inverse() instead of removing the check entirely,
    as suggested by Florian Westphal.  No other changes.

 extensions/ebt_string.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/ebt_string.c b/extensions/ebt_string.c
index 97fbe19..cbbe103 100644
--- a/extensions/ebt_string.c
+++ b/extensions/ebt_string.c
@@ -174,7 +174,7 @@ static int parse(int c, char **argv, int argc, const stru=
ct ebt_u_entry *entry,
 		break;
 	case STRING_ICASE:
 		ebt_check_option2(flags, OPT_STRING_ICASE);
-		if (ebt_check_inverse2(optarg))
+		if (ebt_check_inverse(optarg))
 			ebt_print_error2("Unexpected `!' after --string-icase");
 		info->u.v1.flags |=3D XT_STRING_FLAG_IGNORECASE;
 		break;
--=20
2.39.5

