Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=weblib.eu header.i=@weblib.eu header.b="lNXOtlRm"
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59C410A
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 09:52:24 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2cc49101044so5527681fa.1
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 09:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=weblib.eu; s=google; t=1702576342; x=1703181142; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BfHbuPnwUDC8TtVbPO8ONYMuT9tPnt+O41UrkiC1HI8=;
        b=lNXOtlRmOnynnbQ7sJC1/ZML4XoUqpZ/FWj/t1e2JWkyDU287TRcTGKverXxVVI/T1
         RACFTrwHJtF0o8KSrKf1SACXcxCJc3S+jtFekvLDCipca0MyymWlJ1Sp/0P2wKah4T7S
         WQLiQy7SGiS18TKHKIZxs9RxB1cb1Rd3Qu3MuP8mGXMlGgNrnE5u0n7ZC9Oi1biVesEx
         6FDa0Kus25UipouG2o/EZerNLroTbkDPQhGtqi3ymhUSgh8WbG+2qIEaOxkBmqa+FHuM
         N52Qm2ByDZQUr4vB3fbOImRPQYBqpg5r9JgFJItaSlG5AiLQUseFl/aAbC+NQ/3fYUdi
         ciJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702576342; x=1703181142;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BfHbuPnwUDC8TtVbPO8ONYMuT9tPnt+O41UrkiC1HI8=;
        b=mqhxipxiP1J+rEicACgHGE0cpKWPijxgRX6ImlD2AueaHgpklKD3W4ckqFQtRZMMye
         9ZCxIyXlyolrxMi30ANE4CoiV/azJIBrkBoDx4AIJBpqCwNledtTqVLecPOmllg9NwmO
         veqy39QIhhB6ZFKF1EEVUsqDHEjQYiozBY/YByoOA1em/XJeNrkzoUmzZZGzr9wWR9I2
         M8d5sjLl3Du6YvKMWeN4S06YGGDgbCrhw6yPYL5wwjn0zvH3SdB0wNDHPbbfzahQeGYq
         QpSkPZf6Yyhe8Y5huMeurnuWuzULJz48KOU5MczvMD9EuVfrw1G1Gogp3xhSX0haa3e+
         B9cg==
X-Gm-Message-State: AOJu0Yx8T4Zqh0xqB0GHThKCEDA0N5R6BD5UTnRgo8GlbySimHHj25mx
	ECextb4eUPqtAL+VX0R0jPL0AyrQNJwg4kQZ9BfHrXMWVbvWEW1/
X-Google-Smtp-Source: AGHT+IEKz7B+xGVrJySegmzivoO6Zitdjm+R8vPwbrYB0VdmtxIS952IpXBmIrLpJcG6N6ZUEd9HcKZmdxv2MkZ0Xgg=
X-Received: by 2002:ac2:5589:0:b0:50b:fb07:ccde with SMTP id
 v9-20020ac25589000000b0050bfb07ccdemr2014318lfg.51.1702576342280; Thu, 14 Dec
 2023 09:52:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?Q?G=C3=A9rald_Colangelo?= <gerald.colangelo@weblib.eu>
Date: Thu, 14 Dec 2023 18:52:10 +0100
Message-ID: <CAEqktHujVnjWhdvttjmQWMSHb8mXwhV=Fz2en-6amijbHHR0pw@mail.gmail.com>
Subject: ulogd / JSON output / enhancement proposal
To: netfilter-devel@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000015df11060c7bf278"

--00000000000015df11060c7bf278
Content-Type: text/plain; charset="UTF-8"

Hello everyone,

To complete my previous message, here is a patch for
ulogd_output_JSON.c (latest version) that implements a "softfail"
configuration option.
If set to 1, error while connecting to unix socket are ignored during
startup and plugin will attempt to connect next time it will be
triggered.
This may be helpful when the software that must listen on unix socket
takes too long to launch.

Best regards,
-- 
Gerald Colangelo

--00000000000015df11060c7bf278
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="ulogd_output_JSON_softfail_option.patch"
Content-Disposition: attachment; 
	filename="ulogd_output_JSON_softfail_option.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lq5hy6mn0>
X-Attachment-Id: f_lq5hy6mn0

NTFhNTIKPiAjZGVmaW5lIHNvZnRmYWlsX2NlKHgpICAgKHgtPmNlc1tKU09OX0NPTkZfU09GVEZB
SUxdKQo1M2E1NSw1Nwo+IAo+IHN0YXRpYyBpbnQganNvbl9pbml0X2Nvbm5lY3Qoc3RydWN0IHVs
b2dkX3BsdWdpbnN0YW5jZSAqdXBpKTsKPiAKNjFhNjYsNjcKPiAJaW50IHN0YXJ0ZWQ7Cj4gCWlu
dCBzb2Z0ZmFpbDsKODFjODcsODgKPCAJSlNPTl9DT05GX01BWAotLS0KPiAJSlNPTl9DT05GX1NP
RlRGQUlMLAo+IAlKU09OX0NPTkZfTUFYLAoxNDBhMTQ4LDE1Mwo+IAkJW0pTT05fQ09ORl9TT0ZU
RkFJTF0gPSB7Cj4gCQkJLmtleSA9ICJzb2Z0ZmFpbCIsCj4gCQkJLnR5cGUgPSBDT05GSUdfVFlQ
RV9JTlQsCj4gCQkJLm9wdGlvbnMgPSBDT05GSUdfT1BUX05PTkUsCj4gCQkJLnUgPSB7IC52YWx1
ZSA9IDAgfSwKPiAJCX0sCjI4M2EyOTcsMzEzCj4gCWlmIChvcGktPnNvZnRmYWlsID09IDEgJiYg
b3BpLT5zdGFydGVkID09IDApIHsKPiAJCWludCBzdGF0ZTsKPiAJCXN0YXRlID0ganNvbl9pbml0
X2Nvbm5lY3QodXBpKTsKPiAJCS8qIE5vdCBjb25uZWN0ZWQgYnV0IHNvZnRmYWlsLCBza2lwIHBh
Y2tldCAqLwo+IAkJaWYgKHN0YXRlID09IDEpIHsKPiAJCQl1bG9nZF9sb2coVUxPR0RfREVCVUcs
ICJ1bmFibGUgdG8gY29ubmVjdCB0byBqc29uIGJ1dCBzb2Z0YWlsPTEsIHBhY2tldCB3aWxsIGJl
IGlnbm9yZWQuXG4iKTsKPiAJCQlyZXR1cm4gVUxPR0RfSVJFVF9PSzsKPiAJCX0KPiAJCWVsc2Ug
aWYgKHN0YXRlID09IDApIHsKPiAJCQl1bG9nZF9sb2coVUxPR0RfREVCVUcsICJzdWNjZXNzZnVs
bHkgY29ubmVjdGVkIGpzb24gZW5kcG9pbnQhXG4iKTsKPiAJCX0KPiAJCWVsc2Ugewo+IAkJCXVs
b2dkX2xvZyhVTE9HRF9GQVRBTCwgIm5vdCBzdXBwb3NlZCB0byBoYXBwZW4gIVxuIik7Cj4gCQkJ
cmV0dXJuIFVMT0dEX0lSRVRfU1RPUDsKPiAJCX0KPiAJfQo+IAo1MDBhNTMxLDUzNQo+IAlpZiAo
IHNvZnRmYWlsX2NlKHVwaS0+Y29uZmlnX2tzZXQpLnUudmFsdWUgIT0gMCApCj4gCQlvcC0+c29m
dGZhaWwgPSAxOwo+IAllbHNlCj4gCQlvcC0+c29mdGZhaWwgPSAwOwo+IAo1NDJhNTc4LDYwOQo+
IAo+IC8qCj4gICAgcmV0dXJuIHZhbHVlOgo+ICAgICAwOiBjb25uZWN0aW9uIGlzIE9LLgo+ICAg
ICAxOiBjb25uZWN0aW9uIGlzIEtPIGJ1dCBzb2Z0ZmFpbD0xIChyZXRyeSBsYXRlcikuCj4gICAg
IC0xOiBjb25uZWN0aW9uIGlzIEtPIGFuZCBzb2Z0ZmFpbD0wIChmYWlsKS4KPiAqLwo+IHN0YXRp
YyBpbnQganNvbl9pbml0X2Nvbm5lY3Qoc3RydWN0IHVsb2dkX3BsdWdpbnN0YW5jZSAqdXBpKQo+
IHsKPiAJc3RydWN0IGpzb25fcHJpdiAqb3AgPSAoc3RydWN0IGpzb25fcHJpdiAqKSAmdXBpLT5w
cml2YXRlOwo+IAlpbnQgcmV0Owo+IAlyZXQgPSAwOwo+IAlpZiAob3AtPm1vZGUgPT0gSlNPTl9N
T0RFX0ZJTEUpCj4gCQlyZXQgPSBqc29uX2luaXRfZmlsZSh1cGkpOwo+IAllbHNlCj4gCQlyZXQg
PSBqc29uX2luaXRfc29ja2V0KHVwaSk7Cj4gCj4gCS8qIGZhaWxlZCBzdGFydGluZyBhbmQgc29m
dGZhaWxfc3RhcnQgIT0gMCAqLwo+IAlpZiAocmV0ICE9IDApIHsKPiAJCWlmKG9wLT5zb2Z0ZmFp
bCA9PSAxKSB7Cj4gCQkJdWxvZ2RfbG9nKFVMT0dEX0lORk8sICJjYW4ndCBpbml0IG91dHB1dCwg
YnV0IHNvZnRmYWlsPTEuIFdpbGwgcmV0cnkgbGF0ZXIuXG4iKTsKPiAJCQlvcC0+c3RhcnRlZCA9
IDA7Cj4gCQkJcmV0dXJuIDE7Cj4gCQl9IGVsc2Ugewo+IAkJCXVsb2dkX2xvZyhVTE9HRF9GQVRB
TCwgImNhbid0IGNvbm5lY3QgYW5kIHNvZnRmYWlsPTAsIGZhdGFsIGVycm9yLlxuIik7Cj4gCQkJ
cmV0dXJuIC0xOwo+IAkJfQo+IAl9Cj4gCW9wLT5zdGFydGVkID0gMTsKPiAJcmV0dXJuIDA7Cj4g
fQo+IAo1NjEsNTY0YzYyOAo8IAlpZiAob3AtPm1vZGUgPT0gSlNPTl9NT0RFX0ZJTEUpCjwgCQly
ZXR1cm4ganNvbl9pbml0X2ZpbGUodXBpKTsKPCAJZWxzZQo8IAkJcmV0dXJuIGpzb25faW5pdF9z
b2NrZXQodXBpKTsKLS0tCj4gICAgIHJldHVybiBqc29uX2luaXRfY29ubmVjdCh1cGkpID09IC0x
ID8gLTEgOiAwOwo=
--00000000000015df11060c7bf278--
