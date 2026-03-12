Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2736C377EA7
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 14:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773326993; cv=none; b=cNUZOs7d2ilgiCFnzNY80iyiA+zPIFfvt/XHYm9AjhUMHmoWnzyEl9jpjKAjc2GegTZaHbgUBIEK89Ja6OmNtzji+4/lMUm0/pNR7Y1unmbBDfXqRmhBGa7ZrvZLqEVXlXei6KpiQmz7eiW6kjkAAejtv2kqgsC876BLHIuqsZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773326993; c=relaxed/simple;
	bh=tpnNUk5lKsh4OHO+YqurhE7A+1J8DAFdowvh9NwrrFo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=PkikZo7HEKlc6YtGqI+Sa2Q3o1ZfC5zEikmsEthr0zS6fx2STMihhAI0XuSqRvvMUdu1Nlgq24kwQNrHdaGwHAXAkltkFHs4N8kQLBrzkxRHZmbtRtZvDhBOlI4ie+bzCZqqBZ+5hq7cAYjUQXvUkLQlDXKv3whCN3YJruh005g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RHy4BHZq; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RHy4BHZq"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cd7ecedf2cso111804485a.3
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 07:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773326991; x=1773931791; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=17O/ecF2h4C2gm8PezAL6nUDylm6DtrQfxmj7CwKvs0=;
        b=RHy4BHZqA7syaRS5178Aq19Q5fWBoQ25YUSQ3vU3jrzIgRA0q+LjCTDRtZ7OQjcJOJ
         lSuIAE2HnB6SsrzoYSUbp6CLQviygTYBPhtc0yd4iR+b7e/wNqBkFrv7ezDgfEmWJ7Xp
         DfrLg9wDBHiO3ZIalfyKwl2V/w8JNMjthPHaY1kPpLg2Wd0WVACoxAaHo+STC71hQX8+
         a4dYjOif3QvkC9WW4winaIbqZgvwvJBi79ySPov/kf9+jlPnfJqMqpVf9vc0fXBVYLIk
         5/XsPhGVbjG7OVf4Dts3ThLXq/YLTJxDNODninsb+/ieaMTX3DujiHwcu6DaJxjOfcGq
         EjSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773326991; x=1773931791;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=17O/ecF2h4C2gm8PezAL6nUDylm6DtrQfxmj7CwKvs0=;
        b=enUQe0DnJI9vsL5uYP5PUvUzSVOuJ/iUj1ia8LAZD0lm2IV31+9atxzRhQKZ1aSQSY
         6xLo8MY3/DLj7Ghl712YR2X7IGZFzQSSAzpO/Ko4V55AMNnuWxkAgmQRP2Ey6lYkYsuN
         3UrxtXwAAGkJjjZi3QSf9quY2RF/mlNamkhUk0+K+fE2D3WwWV5rXR9fTY/cICxzfNs5
         qaS84nJLfUAhtUkXRUdr6gTqvdzM9qaua7aAol3bcINJNPdmMCyF+tyDlweziUt5R8uC
         upxcFz4cNQFDw/g7wH2FgWF5vdEPqnWcHY8d/Oa9KX4+FpN6ZxZ4yzC+NHrRHjyqp8l7
         +VSg==
X-Gm-Message-State: AOJu0Yx3i75yul0eh2W1uhnutxNA0aCeXglfGw7Nh5qMu2+Pk79iBL66
	DI95FvJQ5TVcoyDNPIMGhvUbexVnzjBnNPDxBVQ68Xe/wXt7qrUgUXft
X-Gm-Gg: ATEYQzxk3YnYxrXG1wwy4+ci+XBhLR/bQ+BM7LkzL3BlN06l+K2SYNEmejKpTt8vA4z
	UGm6vglZpUBakXRToUGpPnIxnX+0bCT9IpZY3r/7bGK2ZueCxQhzt1xPeU4orpU3YAcLvoYERBK
	vXW2XJYvKMPLcchEH0U7jKO7yUajI3DSzM/pkWQjKg/+uMb3XwOqsnIMpjFxTh6f3iQ7BBE+qMh
	fN/+6YJBAITivTJmmd4ixAavxJQ9dPguQm7DwX0i7XKQRj+6MUv7eFToHBMBySFDxEp5D34RCdd
	+REmmxmz5J2QuRet/fkYzCoPVuQCZdq46k6f91FLchbUBxFIRNhxsVGus5+C2yb36cUOU7jSYXo
	1hxnCS6kY+wHBOzGeQrbAhRFTPLYNiXMJ5qpquUcuxvwnp4MPxP+yEcq3vLypIX+3JcBlBfAJE4
	JxQUqPJkclpF3nlAu1CLqwMQqc6oNMXx/5pw==
X-Received: by 2002:a05:622a:11d4:b0:509:2032:d23e with SMTP id d75a77b69052e-5093a185e33mr86398311cf.38.1773326991053;
        Thu, 12 Mar 2026 07:49:51 -0700 (PDT)
Received: from 192-222-50-213.ll.local ([192.222.50.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5093a0e9658sm40132671cf.21.2026.03.12.07.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 07:49:50 -0700 (PDT)
From: Jenny Guanni Qu <qguanni@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	fw@strlen.de,
	klaudia@vidocsecurity.com,
	dawid@vidocsecurity.com,
	Jenny Guanni Qu <qguanni@gmail.com>
Subject: [PATCH] netfilter: nf_conntrack_h323: check for zero length in DecodeQ931()
Date: Thu, 12 Mar 2026 14:49:50 +0000
Message-Id: <20260312144950.711809-1-qguanni@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In DecodeQ931(), the UserUserIE code path reads a 16-bit length from
the packet, then decrements it by 1 to skip the protocol discriminator
byte before passing it to DecodeH323_UserInformation(). If the encoded
length is 0, the decrement wraps to -1, which is then passed as a
large value to the decoder, leading to an out-of-bounds read.

Add a check to ensure len is positive after the decrement.

Fixes: 5e35941d9901 ("[NETFILTER]: Add H.323 conntrack/NAT helper")
Reported-by: Klaudia Kloc <klaudia@vidocsecurity.com>
Reported-by: Dawid Moczadło <dawid@vidocsecurity.com>
Tested-by: Jenny Guanni Qu <qguanni@gmail.com>
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 540d97715bd2..ca103c946190 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -922,6 +922,8 @@ int DecodeQ931(unsigned char *buf, size_t sz, Q931 *q931)
 				break;
 			p++;
 			len--;
+			if (len <= 0)
+				break;
 			return DecodeH323_UserInformation(buf, p, len,
 							  &q931->UUIE);
 		}
-- 
2.34.1

