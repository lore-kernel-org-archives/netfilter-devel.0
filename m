Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [67.231.157.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16ED726A0B1
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2025 15:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.157.127
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740668532; cv=none; b=tXNiOlmI8szzR4FA+2rZtpEw8wwM8Hsc7NQp8hYzentv/G9UpDEByPmCVOqY8ARfBiuFg7nYEXYmRQKMHSKfILTa8yqHKMTXVQVOwtfLBtseMnPLvwZrtrSzQeIvj2Os2VlPCDjDWxRnutMihfIfEnxayHKRkwu91HowY3/3PUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740668532; c=relaxed/simple;
	bh=lRhcTaOzgP6izlqA/JkiBKcDFSjvY8FhEgp8nurFHMw=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=JEvhtUGvvqVZ9g9A53rjxw1Ls0USyqPO9CjhnDodtEwKh8w3hdZ8pXAuNNEGpR5BjKJZWpUaxiOIA5rEPowqKYEjTMFoONZm4ALKzAuyDZluU3LYCs+2gslqLtC7b7Pg5gvztWHLwPQ5uu7BBUmS+CViJIPEHnZmgWP9V37Buww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com; spf=pass smtp.mailfrom=akamai.com; dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b=ShES7lKJ; arc=none smtp.client-ip=67.231.157.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=akamai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="ShES7lKJ"
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
	by mx0b-00190b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51R6rq5g018106
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2025 13:32:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=jan2016.eng; bh=lRhcTaOzg
	P6izlqA/JkiBKcDFSjvY8FhEgp8nurFHMw=; b=ShES7lKJ9MC8EYWXGErZE7tKA
	OAg0W9SKm9wvLRusME1smcxJnuvrC6t3u1yWwdav+de8/Lgg4ucBPapQhEzv5me8
	6pW1plCobXvbhK5imU+QHB+MFfxzjBIViCF22lfv1MgRLTIHZ3hlhYVv3rfznbXv
	6RjKD5Uc+cZc23MKMqLG48Ss+ulejO/pLERMnoxcbpaUSxVLi7gQE5hnRGfBznbH
	GLRMG7lPCIIQO/aZbvCi3KNdIdAnM+IQSZ/Cl4PqfRid74MQDLjvviz8ctYU1VAJ
	DuQIYvBaAsiDxiKGQnDTI/OCUPb9mwGXmREdd6zI+yy2IJ92OE8szbjG+cK1Q==
Received: from prod-mail-ppoint7 (a72-247-45-33.deploy.static.akamaitechnologies.com [72.247.45.33] (may be forged))
	by mx0b-00190b01.pphosted.com (PPS) with ESMTPS id 451pu0w4gy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2025 13:32:41 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint7.akamai.com [127.0.0.1])
	by prod-mail-ppoint7.akamai.com (8.18.1.2/8.18.1.2) with ESMTP id 51R9lQku031696
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2025 08:32:41 -0500
Received: from email.msg.corp.akamai.com ([172.27.91.20])
	by prod-mail-ppoint7.akamai.com (PPS) with ESMTPS id 44yat2fs40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2025 08:32:41 -0500
Received: from usma1ex-dag4mb3.msg.corp.akamai.com (172.27.91.22) by
 usma1ex-dag4mb1.msg.corp.akamai.com (172.27.91.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Feb 2025 08:32:34 -0500
Received: from usma1ex-dag4mb3.msg.corp.akamai.com ([172.27.91.22]) by
 usma1ex-dag4mb3.msg.corp.akamai.com ([172.27.91.22]) with mapi id
 15.02.1544.014; Thu, 27 Feb 2025 08:32:34 -0500
From: "Jensen, Nicklas Bo" <njensen@akamai.com>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: [PATCH] Fix bug where garbage collection for nf_conncount is not
 skipped when jiffies wrap around
Thread-Topic: [PATCH] Fix bug where garbage collection for nf_conncount is not
 skipped when jiffies wrap around
Thread-Index: AQHbiRwO5abAGRrVxU6nle6Q7xRfKw==
Date: Thu, 27 Feb 2025 13:32:34 +0000
Message-ID: <EC4CB996-F5A1-4368-AAB7-F77E1B2E6A4D@akamai.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <80399AB0A67EA7498F1F1A9D7E622087@akamai.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_06,2025-02-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502270101
X-Proofpoint-GUID: 8WjbmfyYKKXGQws1knPlwP9B9qtRRiO4
X-Authority-Analysis: v=2.4 cv=WZL2a1hX c=1 sm=1 tr=0 ts=67c06979 cx=c_pps a=3lD5tZmBJQAvN++OlPJl4w==:117 a=3lD5tZmBJQAvN++OlPJl4w==:17 a=Rpp4p_6m9vYA:10 a=IkcTkHD0fZMA:10 a=T2h4t0Lz3GQA:10 a=3HDBlxybAAAA:8 a=X7Ea-ya5AAAA:8 a=QOqsepZb7v-qtPbskfkA:9
 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19 a=QEXdDO2ut3YA:10 a=laEoCiVfU_Unz3mSdgXN:22
X-Proofpoint-ORIG-GUID: 8WjbmfyYKKXGQws1knPlwP9B9qtRRiO4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_06,2025-02-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 mlxlogscore=834 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1011
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2502100000
 definitions=main-2502270103

bmZfY29ubmNvdW50IGlzIHN1cHBvc2VkIHRvIHNraXAgZ2FyYmFnZSBjb2xsZWN0aW9uIGlmIGl0
IGhhcyBhbHJlYWR5IHJ1biBnYXJiYWdlIGNvbGxlY3Rpb24gaW4gdGhlIHNhbWUgamlmZnkuIFVu
Zm9ydHVuYXRlbHksIHRoaXMgaXMgYnJva2VuIHdoZW4gamlmZmllcyB3cmFwIGFyb3VuZCB3aGlj
aCB0aGlzIHBhdGNoIGZpeGVzLg0KDQpUaGUgcHJvYmxlbSBpcyB0aGF0IGxhc3RfZ2MgaW4gdGhl
IG5mX2Nvbm5jb3VudF9saXN0IHN0cnVjdCBpcyBhbiB1MzIsIGJ1dCBqaWZmaWVzIGlzIGFuIHVu
c2lnbmVkIGxvbmcgd2hpY2ggaXMgOCBieXRlcyBvbiBteSBzeXN0ZW1zLiBXaGVuIHRob3NlIHR3
byBhcmUgY29tcGFyZWQgaXQgb25seSB3b3JrcyB1bnRpbCBsYXN0X2djIHdyYXBzIGFyb3VuZC4N
Cg0KU2VlIGJ1ZyByZXBvcnQgaHR0cHM6Ly9idWd6aWxsYS5uZXRmaWx0ZXIub3JnL3Nob3dfYnVn
LmNnaT9pZD0xNzc4IGZvciBtb3JlIGRldGFpbHMuDQoNClNpZ25lZC1vZmYtYnk6IE5pY2tsYXMg
Qm8gSmVuc2VuIDxuamVuc2VuQGFrYW1haS5jb20+DQotLS0NCiBuZXQvbmV0ZmlsdGVyL25mX2Nv
bm5jb3VudC5jIHwgNCArKy0tDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0ZXIvbmZfY29ubmNvdW50LmMg
Yi9uZXQvbmV0ZmlsdGVyL25mX2Nvbm5jb3VudC5jDQppbmRleCA0ODkwYWY0ZGMyNjMuLmViZTM4
ZWQyZTZmNCAxMDA2NDQNCi0tLSBhL25ldC9uZXRmaWx0ZXIvbmZfY29ubmNvdW50LmMNCisrKyBi
L25ldC9uZXRmaWx0ZXIvbmZfY29ubmNvdW50LmMNCkBAIC0xMzIsNyArMTMyLDcgQEAgc3RhdGlj
IGludCBfX25mX2Nvbm5jb3VudF9hZGQoc3RydWN0IG5ldCAqbmV0LA0KICAgICAgICBzdHJ1Y3Qg
bmZfY29ubiAqZm91bmRfY3Q7DQogICAgICAgIHVuc2lnbmVkIGludCBjb2xsZWN0ID0gMDsNCg0K
LSAgICAgICBpZiAodGltZV9pc19hZnRlcl9lcV9qaWZmaWVzKCh1bnNpZ25lZCBsb25nKWxpc3Qt
Pmxhc3RfZ2MpKQ0KKyAgICAgICBpZiAoKHUzMilqaWZmaWVzID09IGxpc3QtPmxhc3RfZ2MpDQog
ICAgICAgICAgICAgICAgZ290byBhZGRfbmV3X25vZGU7DQoNCiAgICAgICAgLyogY2hlY2sgdGhl
IHNhdmVkIGNvbm5lY3Rpb25zICovDQpAQCAtMjM0LDcgKzIzNCw3IEBAIGJvb2wgbmZfY29ubmNv
dW50X2djX2xpc3Qoc3RydWN0IG5ldCAqbmV0LA0KICAgICAgICBib29sIHJldCA9IGZhbHNlOw0K
DQogICAgICAgIC8qIGRvbid0IGJvdGhlciBpZiB3ZSBqdXN0IGRpZCBHQyAqLw0KLSAgICAgICBp
ZiAodGltZV9pc19hZnRlcl9lcV9qaWZmaWVzKCh1bnNpZ25lZCBsb25nKVJFQURfT05DRShsaXN0
LT5sYXN0X2djKSkpDQorICAgICAgIGlmICgodTMyKWppZmZpZXMgPT0gUkVBRF9PTkNFKGxpc3Qt
Pmxhc3RfZ2MpKQ0KICAgICAgICAgICAgICAgIHJldHVybiBmYWxzZTsNCg0KICAgICAgICAvKiBk
b24ndCBib3RoZXIgaWYgb3RoZXIgY3B1IGlzIGFscmVhZHkgZG9pbmcgR0MgKi8NCi0tDQoyLjM0
LjENCg0K
