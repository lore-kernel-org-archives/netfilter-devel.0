Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2291E25F7
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Mar 2025 21:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741469304; cv=none; b=Pi8UrR+KZ+PnqUMfRDlpspZKNe757cnU1HFBYP6ZeRvT+AcByfelvMHQuccM069DORoBCcxQuZx9vOttys2Df4vuKPzWaTR+KYDRPwnFXqwW/UK69JbGylr6i+0aPMP6kQCvH00c47UEG01TQyCaX6M2eA1wqkcdfnoYlQIjLmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741469304; c=relaxed/simple;
	bh=IVt/8sAGEnRgIYg8H+n7ZhZsF7vb83EwDYuf0O1f9ss=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=e3xEF8S2BrN2PHw59H4vNC21tn+byB+Fi1QCmSJetw7RVvhp53frhEaWeSYO3+8aRnNtE2jlfsniLy50w3T6mg1Zw6LLZI9gixGtnroj1Lfd6zkkAVRs37KDFilGQ+S61u2ztwFc2vR4ZPNk69ICEUneQDMq9hp0muflbWd5ZME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=JZr7MWqj; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="JZr7MWqj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741469300; x=1742074100; i=corubba@gmx.de;
	bh=3f95kFp4adpSXA68CoNeGJ9UPuQ545q0IxIcp1vRu90=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:From:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=JZr7MWqj0yxEq2Rprexe7T9JzKEVUdXJTzM9E2ETXr14S7yP0dMrK4oG9ncQftK0
	 3tCH9ppR2LQ4OD4XTxHIhRuoHpUw9XvSGROKc/3qbMuFHAyXx4sd7TtuZmAvB6fz4
	 QuSt/nbErdUjulXoR8eyNJf5biJYvDwurcV7v7mlVufeAMW3kzETRgwz1/BAn9iy+
	 jSaktJB08nBPwGvnlHg/4CkIOAYqHhSKJ3HPV/i0AAIDrY4QcB1rq/QldBD/F7lEp
	 hJb/FH8occqnEWY3ZsmNJIvNKGb2H6j3p/WGH0XYJMPldcYipFLIM4UQ7G+QBPyCX
	 CBj0AgVIgOCaaFgfpg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.164]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M3UZG-1trZgM077q-00Dx9T for
 <netfilter-devel@vger.kernel.org>; Sat, 08 Mar 2025 22:28:20 +0100
Message-ID: <2710a46a-f5d9-4b0a-853c-4a53d68e3486@gmx.de>
Date: Sat, 8 Mar 2025 22:27:56 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: de-CH
To: netfilter-devel@vger.kernel.org
From: Corubba Smith <corubba@gmx.de>
Subject: [PATCH ulogd2 1/2] nfct: fix calloc argument order
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:H8Yzn27lDuK56+sBClSVG+A25MyuQLWHAVzpcG2Lrz7MpWf0pN4
 8Vqf4hw6EP/OVlcWJis4Rkn9gheu30OwpIJ6blStkTh8kd8T+l7d6vQCNvfLqmhgQkUE7Jj
 olQhLeWFo1aYD8q5bVkTzB88KBRrKr0zbvDETmQFGCpkLUVwRJ5QV5iS5A9b0KeyV2/BES6
 N5lnRBD2SswvQGK0zMPaw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:sl7wCBuEJbk=;NQl5O4Mian8K+b5OVrFNJZhKHXg
 UTIcjDxvbHeMlKn15g7nE9xSoz0m689g9PguYqq07qY7FVXcB1KeO3fjczqhyiaGMKY/CozsX
 xK5gW6Bg4xM1MDkmNm2cMoHl1b0f4IJAqIhb+5TAz56eWpGQ7hPkxEnijvQvZ51XAroG037UM
 wtqywVFtEyfo2sviICzhUwx3IG+vCA1B02CpTxXHNlkJQGJKMjFTcvCzocbcLVFMG8iD9bHoc
 zVMqyasowah7Prpm2wu4FvVIz2fDnUFZfXuNc3ZEv7ezQe6Hsjtcl1WzmkZB9d0G6XP8qK/fM
 W4zR23x0J15i82nrpeZjuzVNHcKycjMiA2oIjI7XHnrL+t/IEDRwhO12e7JDBlkvFU9Q0O66s
 kt9qfFEuZQbYUBhoKFxIrtnjrxtGZ1nXUs9B8gIgzacYv91c+GlwDON3hXuzpLihR0e+d6IKe
 w6ToYbMIsS1VR34qiVwfHoUkLQwBe3MeBa2Q8usO/wTJa4mVBHT7yPkDa3jlQvWlKXyYBckK0
 pfnsk+JPme/bUoOdgQu3R9N7p8b7j4XKdUcJiFMVlwgdaNbgLu/1YtEwFgpeeUTJwPGc/aHPN
 TkJkoeKwuF0hQwo8JbaSp5T+V0NPkwJKO2xil04wXLQdga/LdxNu3JbwRPT6kYn1xJcLxKPey
 nDlv4u9xetXHeft2BbZMUJ9p7O9H+EcaStDLg2iAKFU2VX5WI6TUYO2OHbBFubniqoRGl3XRg
 XmFaWp4dZbSQhteWXFyqVEjQgIQs/upDoA0CjsMoI+hmjgeosWWgy+hYHS4g6JyJMeNgXUp/q
 5egiLztpdzVBnjtdQhHtDNhZ/fdOZw/ZWwhtrWv3vU6NKYwyjENEQMKN8ecW0aDF/D1l0Mkjo
 CPIpoUg1+nscv9OrXiS7LBjRSl/kohJE/e8DDzsCL2iyPGPdmG/RK84THR+kao52KT2XCJt5l
 pYrX51g4VowXOIy+Z6mNgUXd6NoDnAcNkg0Wop80gpkzFVgO57oNvE0qYIqXS2qAtD9sFqAs8
 RnAsl4HTfhTc7Z9Dwra0aDs0eLzPpa+jgD5RXdV0FOepHCjrf1tjdKeU95+X0tSXmparDYOVu
 07ejYd60zBhfZVNSso7fTr8tmZ0DY5fVjhOkZu3fiDR2NI6wrA5cfzaCNmt8V6Q5ZhEgPl56R
 GicAbmVQJOhlt8i9pZr3b7GnrHiwDZplCJ0HDY7ttTC8GG4TAgsN/Db9kYzhq3aha96/Hl20k
 bQDHTg1gX4KMVXnr+ugjP6E3mEVi3r2PJ2LhTzkK2Nebg3Y7UdbnSiHsIZw4Zl/N+J2t18jHs
 oY/FJ5BX678zGQPPI01J7STkk66zJQr/iAzsnuA7thcdxa7bnW/5teMrZDJDk8sTMrVGs3ObC
 v31ntEaalVRyeX6csNjMUVKiVj0FtitvAW0nvDiOrZ0srs7QnQ+dRvaSym

The first argument to calloc() is the number of elements, the second is
the size of a single element. Having the arguments switched shouldn't
make any difference during runtime, but GCC warns about it when using
-Wcalloc-transposed-args [0].

[0] https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#index-Wcalloc-=
transposed-args

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 input/flow/ulogd_inpflow_NFCT.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NF=
CT.c
index 899b7e3..5ac24e5 100644
=2D-- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -660,7 +660,7 @@ event_handler_hashtable(enum nf_conntrack_msg_type typ=
e,

 	switch(type) {
 	case NFCT_T_NEW:
-		ts =3D calloc(sizeof(struct ct_timestamp), 1);
+		ts =3D calloc(1, sizeof(struct ct_timestamp));
 		if (ts =3D=3D NULL)
 			return NFCT_CB_CONTINUE;

@@ -681,7 +681,7 @@ event_handler_hashtable(enum nf_conntrack_msg_type typ=
e,
 		if (ts)
 			nfct_copy(ts->ct, ct, NFCT_CP_META);
 		else {
-			ts =3D calloc(sizeof(struct ct_timestamp), 1);
+			ts =3D calloc(1, sizeof(struct ct_timestamp));
 			if (ts =3D=3D NULL)
 				return NFCT_CB_CONTINUE;

@@ -771,7 +771,7 @@ polling_handler(enum nf_conntrack_msg_type type,
 		if (ts)
 			nfct_copy(ts->ct, ct, NFCT_CP_META);
 		else {
-			ts =3D calloc(sizeof(struct ct_timestamp), 1);
+			ts =3D calloc(1, sizeof(struct ct_timestamp));
 			if (ts =3D=3D NULL)
 				return NFCT_CB_CONTINUE;

@@ -908,7 +908,7 @@ static int overrun_handler(enum nf_conntrack_msg_type =
type,
 	ts =3D (struct ct_timestamp *)
 		hashtable_find(cpi->ct_active, ct, id);
 	if (ts =3D=3D NULL) {
-		ts =3D calloc(sizeof(struct ct_timestamp), 1);
+		ts =3D calloc(1, sizeof(struct ct_timestamp));
 		if (ts =3D=3D NULL)
 			return NFCT_CB_CONTINUE;

@@ -971,7 +971,7 @@ dump_reset_handler(enum nf_conntrack_msg_type type,
 		if (ts)
 			nfct_copy(ts->ct, ct, NFCT_CP_META);
 		else {
-			ts =3D calloc(sizeof(struct ct_timestamp), 1);
+			ts =3D calloc(1, sizeof(struct ct_timestamp));
 			if (ts =3D=3D NULL)
 				return NFCT_CB_CONTINUE;

=2D-
2.48.1
