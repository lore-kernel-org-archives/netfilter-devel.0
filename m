Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=weblib.eu header.i=@weblib.eu header.b="APO5q1JX"
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0117FA0
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 09:10:29 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-50bffb64178so9857392e87.2
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 09:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=weblib.eu; s=google; t=1702573828; x=1703178628; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ypONQvRdAJNNWttIzBjLbVCQ2NR26CJaSbwReWTGte8=;
        b=APO5q1JXSO/oC8k6AY1L6WGrf5w2yUFn+IngJzr0baQzhKL570EQJlCyFSxqfMC8jo
         6zCjVTblc1KPuVGDDZl10MeSpDfWoUhfuH17pDJdhZ9sx40soQGUOUfKuDnxqD9ZpuLm
         6idJkf1XoSJN1J05QJpavtse3z9CXv0d204bnIa2JmjH4wawcG/s+A5WE2/Y747DivM0
         79j4svSFhcmUusrEZNfSjwt5iJW98oIvnuMxBM7xfvEWn1RnODI6ziaNfLivsA4cSndC
         +dC4W9h83/yyvwVn30vjpBS76XJz4SUh4GuW+p+XS0JwfVfKHf2Ph671UCC46l2Su6hQ
         x7cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702573828; x=1703178628;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ypONQvRdAJNNWttIzBjLbVCQ2NR26CJaSbwReWTGte8=;
        b=HPlYhACofFIr4sqjIGlxlUZuGIfQFWAa7+eR+Tel2Ko5vZLIaUlepbqXxZmp5eeBSH
         wwWKrFQoQFnzt/zywVqP2WhF9MqLQzPi/YzgTMLT7l67DTONMtiWL9Z3e4V5ogrkNrSd
         5cvWDotXXRaJtxU6a/ZkeqRbMiCf0zoCygvU0fsrIjf+FiGqDvOFeIOKOBCq0wX/lL1I
         UXLvhXIlbODDKLZFUQV7j+scsxnS5wmS2q3DE8qwSHc0s1L2uWCv89/eGdDpr734amMd
         wC26sgeab4soseVNcy6qt+7v0BWEckzwp+CJXgOZKfH9/vVdGa6tsQ9aQCBP+YufUOTQ
         iiWg==
X-Gm-Message-State: AOJu0Yxd+MoYJAOjQA7i+Xyoe7Sj8yNqNDRrQey/awlK9vFSWMEBditb
	DFPU4oJAAbr+R/CJnOmZgg/tgDXt2jfcGZuPHYG7RZgehxPQFwa4
X-Google-Smtp-Source: AGHT+IF/u+VWHv9HmJxXtceM/dnvGmru1IKG1W1S2ZetBtdglDwSJ9pmJfMW0nZj3zhzbHGU22avbWBKGRW5xw15MZo=
X-Received: by 2002:a05:6512:3e1a:b0:50e:1412:57e7 with SMTP id
 i26-20020a0565123e1a00b0050e141257e7mr1433255lfv.8.1702573827713; Thu, 14 Dec
 2023 09:10:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?Q?G=C3=A9rald_Colangelo?= <gerald.colangelo@weblib.eu>
Date: Thu, 14 Dec 2023 18:10:16 +0100
Message-ID: <CAEqktHuJ7T8R6CmYd-R7tufUPdLBT22S6G3_-_PG9s9c_4t5EA@mail.gmail.com>
Subject: Bug in ulogd2 when destroying a stack that failed to start (with fix attached)
To: netfilter-devel@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000034957c060c7b5cd8"

--00000000000034957c060c7b5cd8
Content-Type: text/plain; charset="UTF-8"

Hello everyone,

While working on a ulogd2 deployment, i built a stack that consists in:
  - A "home-made" INPUT plugin that launchs a pcap capture upon
start() and passes a fd to ulogd2.
  - Some regular ulogd2 filters
  - JSON output plugin that writes to a Unix socket.

Everything works fine, except if unix socket is not available.
In that case, when the stack is started at launch, the JSON output
start() function returns -1 and  ulogd.c consider that it fails
starting the stack and then destroy it.
Unfortunately, ulogd.c only free() the stack context without calling
stop() functions on plugins that were correctly start()-ed.
In my case, it results in my pcap input triggering the stack even if
it was destroyed.
This ends with a segmentation fault for the ulogd process.

I think we should consider calling stop() functions before destroying the stack.
A patch implementing this is attached (for version 2.0.7, but this
part of the code didn't changed on latest).

Best regards,

-- 
Gerald Colangelo

--00000000000034957c060c7b5cd8
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="ulogd2_stop_plugins_before_destroying_stack.patch"
Content-Disposition: attachment; 
	filename="ulogd2_stop_plugins_before_destroying_stack.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lq5gc63f0>
X-Attachment-Id: f_lq5gc63f0

LS0tIHVsb2dkMi0yLjAuNy9zcmMvdWxvZ2QuYwkyMDE4LTA0LTI3IDAxOjEwOjQyLjMxNjg3MjAz
NCArMDIwMAorKysgdWxvZ2QyLTIuMC43LXBhdGNoZWQvc3JjL3Vsb2dkLmMJMjAyMy0xMi0xNCAx
ODowNDowNi45OTQ2NjE3MjIgKzAxMDAKQEAgLTkzMSw3ICs5MzEsNyBAQAogc3RhdGljIGludCBj
cmVhdGVfc3RhY2tfc3RhcnRfaW5zdGFuY2VzKHN0cnVjdCB1bG9nZF9wbHVnaW5zdGFuY2Vfc3Rh
Y2sgKnN0YWNrKQogewogCWludCByZXQ7Ci0Jc3RydWN0IHVsb2dkX3BsdWdpbnN0YW5jZSAqcGk7
CisJc3RydWN0IHVsb2dkX3BsdWdpbnN0YW5jZSAqcGksICpzdG9wOwogCiAJLyogc3RhcnQgZnJv
bSBpbnB1dCB0byBvdXRwdXQgcGx1Z2luICovCiAJbGxpc3RfZm9yX2VhY2hfZW50cnkocGksICZz
dGFjay0+bGlzdCwgbGlzdCkgewpAQCAtOTQ1LDExICs5NDUsMjcgQEAKIAkJCQl1bG9nZF9sb2co
VUxPR0RfRVJST1IsIAogCQkJCQkgICJlcnJvciBzdGFydGluZyBgJXMnXG4iLAogCQkJCQkgIHBp
LT5pZCk7Ci0JCQkJcmV0dXJuIHJldDsKKwkJCQlnb3RvIGNsZWFudXBfZmFpbDsKIAkJCX0KIAkJ
fQogCX0KIAlyZXR1cm4gMDsKK2NsZWFudXBfZmFpbDoKKwlzdG9wID0gcGk7CisJbGxpc3RfZm9y
X2VhY2hfZW50cnkocGksICZzdGFjay0+bGlzdCwgbGlzdCkgeworCQlpZiAocGkgPT0gc3RvcCkK
KwkJCS8qIHRoZSBvbmUgdGhhdCBmYWlsZWQsIHN0b3BzIHRoZSBjbGVhbnVwIGhlcmUgKi8KKwkJ
CWJyZWFrOworCQlpZiAoIXBpLT5wbHVnaW4tPnN0b3ApIAorCQkJY29udGludWU7CisJCXJldCA9
IHBpLT5wbHVnaW4tPnN0b3AocGkpOworCQlpZiAocmV0IDwgMCkgeworCQkJdWxvZ2RfbG9nKFVM
T0dEX0VSUk9SLAorCQkJImVycm9yIHN0b3BwaW5nIGAlcydcbiIsCisJCQlwaS0+aWQpOworCQl9
CisJfQorCXJldHVybiAtMTsKIH0KIAogLyogY3JlYXRlIGEgbmV3IHN0YWNrIG9mIHBsdWdpbnMg
Ki8K
--00000000000034957c060c7b5cd8--
