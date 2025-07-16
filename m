Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1687D2EF9BA
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 16:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752683748; cv=none; b=T8UEPCFZ0YpP9E+MyFOKoS0YfrvoprqagEcXpoUKVafrzy2Ky6DTOpX2LJrKHSROmf6ym0tLxB1OAvKY7Wtv6r3+lmSL1WUSK9w6XzSSjDJSLQ1cxjs7ZbuD8tThDzq3rx3MnaswOigM8ardYZ/ZkKUPV0Ifr1mKYt/O1VAICMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752683748; c=relaxed/simple;
	bh=f4R5LSVcoD9DwK6ne/+v4xa+ileTGgoO7SMxyYcD0UY=;
	h=Content-Type:Message-ID:Date:MIME-Version:To:From:Subject; b=K7pVtz4b89Hg35YvbiJ08FopQw4oUXoecbDSAAORuC66vUl0Wyh+V3szUeZZysnqycSrNruR31IHce2qH9eXDvNEOe/vevAC7dqWGWMP4XBmJenIFmMwnEukfUMMe4M7+Gn4MfA5CXht5WKeYr+RQFW4sqSg9EQ67tB4fH3ewQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AOzRH8nd; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AOzRH8nd"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-60c93c23b08so13468251a12.3
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 09:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752683745; x=1753288545; darn=vger.kernel.org;
        h=autocrypt:subject:from:content-language:to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=QO0JExGW9/DZJ9TMm35kJesPl4bXCzd5bJ6Wp8RUj+8=;
        b=AOzRH8ndDLSF8p0P5MOdamoR/ooVKvoUBnqvJRdsBSm0zIPr5H4sl0MugLIEYsC9DQ
         wR2224FJ52kLDkU4WVzmwe/Hb8Av3nlIODmzw4uMdNB9OCU2vCcKPkhiDaLM0TXgMG8U
         bmDU/77fach68lTHWJ4WF7EnacfLTxPR6gArruLLV5eJ/NJHOfa6j2hYrmgfQuWXU+/7
         WPbjUTVMTHh/2eqi1xZjlSolZep1zGdE3nyb1TKNWXbLjRreL0UfzkqF3w8IVvVhb7xf
         RrYJ6tfcWT6HS+bxFxjOYAIq/cUB77ko/sQJG7SyKjWUyu0N1uemX3lc1mH6gZjXFlDh
         Tj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752683745; x=1753288545;
        h=autocrypt:subject:from:content-language:to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QO0JExGW9/DZJ9TMm35kJesPl4bXCzd5bJ6Wp8RUj+8=;
        b=r3iJMGVde7XiRTR6pwzoin1rBBlv8qlmGwCf9veH8XHSIpNOxpb/tqN04RpkIs5a2c
         shhYt40wXuIGxIYlD08Oq5MtJxQYkTYd/WcNBe+jke+Nqjlnr/NJsqanTWT6aO/0D7nS
         118yVW1JCYLH11JyW+HsLGAQaz7Vb1amNXCa014FFlW3gJKTmtCIqeqMXvFiYzvbS+fH
         nQ1lZnEQkqEQPsjJXkF/ZGnyxTMiufx0AWt1QwW8BjbDgJVog3ZxL1tP/AVMm7N+f0Yp
         x5b7EDzfzQpj1JQgesszqIlv7tYJ6NLJ/YpuNmqV8RL/ggDShreB8auQq/0Nmb3iz0ts
         TSwQ==
X-Gm-Message-State: AOJu0Yxa8JrHmJjUw2Fg0vUe4RBO2YXWAbQmrbFadMbY8oIGOpUoA1hI
	qA/l81ImTECXuJuj17yF2V+15WdjEw6I3kpRVd1I+1C8G0ztEHPyB/f6LYRJFoVV
X-Gm-Gg: ASbGncun3xlLv7uOVquhXAELAY47mq6rWWQLqpjwRZsL3FaLCi3vYTb5kuVjFScJ17j
	3Bph6ebLZd5c+RJpHGUOL++PsrceN89+JJIjfvnRu7/WVdZUfo2xuHaSG3S2DblDMXA+VL74mS8
	i+NZeDmk0Z0wNTqg1Km6KXygUVUKoh89zMux0sC9ubY5dIg9MlzHxdBBbemsgpelkL7MqH9QcH8
	2HVeOuBnoKFERDpVC5uxHa0znTKMCKVM99JaykU1dSPAqVxVbQEJtfc6ilagXzEdl8bzVy8sW5i
	DOdW0hFGSqpWlbWkT88BzgSYqOaPPwrPrCVy2R7qnnwHkF/wrjtOGjruUKQPtiKxLjhBsDCK/z+
	Mlis4ROguAcXTJZFN2Fdig5nPYyou7gtt
X-Google-Smtp-Source: AGHT+IHB9JIqXO8DLkSp606B4ZZqMZJa7CFK8rVMl4P/aldHnYU2WirTKmqn8zShMlIgQcYryjhPEA==
X-Received: by 2002:a05:6402:520b:b0:608:50ab:7e38 with SMTP id 4fb4d7f45d1cf-61285921da2mr3050423a12.14.1752683745003;
        Wed, 16 Jul 2025 09:35:45 -0700 (PDT)
Received: from [192.168.1.212] ([188.27.87.117])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-611c976d9f7sm8920264a12.54.2025.07.16.09.35.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 09:35:44 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------8AC0m0KS2Fm3XPgd04y0QK0b"
Message-ID: <4239da15-83ff-4ca4-939d-faef283471bb@gmail.com>
Date: Wed, 16 Jul 2025 19:36:13 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Content-Language: en-US
From: Razvan Cojocaru <rzvncj@gmail.com>
Subject: __nf_ct_delete_from_lists crash, with bisected guilty commit found
Autocrypt: addr=rzvncj@gmail.com; keydata=
 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 Hw==

This is a multi-part message in MIME format.
--------------8AC0m0KS2Fm3XPgd04y0QK0b
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I'm attaching a test kernel module that reproduces this crash I'm seeing:

BUG: kernel NULL pointer dereference, address: 0000000000000000
[...]
[ 9120.221368] Call Trace: 
                                                      [ 9120.221530]  <TASK>
[ 9120.221675]  nf_ct_delete.part.0+0xa9/0x220 [nf_conntrack]
[ 9120.222022]  nf_ct_delete+0x21/0x30 [nf_conntrack]
[ 9120.222334]  my_hook.cold+0x6b/0xbd [netfilter_postrouting]
[ 9120.222685]  nf_hook_slow+0x45/0xf0
[ 9120.222920]  ip_output+0x121/0x1b0
[ 9120.223145]  ? path_openat+0x534/0x10a0
[ 9120.223394]  ? ip_finish_output2+0x590/0x590
[ 9120.223668]  __ip_queue_xmit+0x557/0x5b0
[ 9120.223921]  ip_queue_xmit+0x15/0x20
[ 9120.224153]  __tcp_transmit_skb+0xae1/0xcb0
[ 9120.224444]  ? srso_alias_return_thunk+0x5/0x7f

Steps to reproduce:

1. Build the kernel module.
2. insmod it.
3. iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
4. Send a lot of data (I just use iperf -c <IP> -t 300).

It should crash immediately.

Maybe this is what you're trying to fix in "[PATCH nf 0/4] netfilter: 
conntrack: fix obscure confirmed race"?

Thanks,
Razvan
--------------8AC0m0KS2Fm3XPgd04y0QK0b
Content-Type: text/x-csrc; charset=UTF-8; name="netfilter_postrouting.c"
Content-Disposition: attachment; filename="netfilter_postrouting.c"
Content-Transfer-Encoding: base64

I2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgojaW5jbHVkZSA8bGludXgva2VybmVsLmg+CiNp
bmNsdWRlIDxsaW51eC9uZXRmaWx0ZXIuaD4KI2luY2x1ZGUgPGxpbnV4L25ldGZpbHRlcl9p
cHY0Lmg+CiNpbmNsdWRlIDxsaW51eC9pcC5oPgojaW5jbHVkZSA8bGludXgvdGNwLmg+CiNp
bmNsdWRlIDxsaW51eC91ZHAuaD4KI2luY2x1ZGUgPGxpbnV4L3NrYnVmZi5oPgojaW5jbHVk
ZSA8bmV0L25ldGZpbHRlci9uZl9jb25udHJhY2suaD4KCk1PRFVMRV9MSUNFTlNFKCJHUEwi
KTsKTU9EVUxFX0FVVEhPUigiVGVzdCBJbmMuIik7Ck1PRFVMRV9ERVNDUklQVElPTigiTmV0
ZmlsdGVyIHBvc3Qgcm91dGluZyBob29rIik7Ck1PRFVMRV9WRVJTSU9OKCIxLjAiKTsKCi8v
IE1heGltdW0gbnVtYmVyIG9mIHNrYnMgdG8ga2VlcCBpbiB0aGUgbGlzdAojZGVmaW5lIE1B
WF9TS0JfTElTVF9TSVpFIDIwMDAKCnN0YXRpYyBhdG9taWNfdCB3aXBlX2ZsYWcgPSBBVE9N
SUNfSU5JVCgwKTsKCi8vIFN0cnVjdHVyZSB0byBob2xkIHNrYiBjb3B5IGluIFJDVSBsaXN0
CnN0cnVjdCBza2JfbGlzdF9lbnRyeSB7CiAgICBzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7CiAg
ICBzdHJ1Y3QgcmN1X2hlYWQgcmN1OwogICAgc3RydWN0IHNrX2J1ZmYgKnNrYl9jb3B5Owp9
OwoKLy8gUkNVIHByb3RlY3RlZCBsaXN0IGhlYWQgYW5kIGNvbnRyb2wgdmFyaWFibGVzCnN0
YXRpYyBMSVNUX0hFQUQoc2tiX2xpc3QpOwpzdGF0aWMgREVGSU5FX1NQSU5MT0NLKHNrYl9s
aXN0X2xvY2spOwpzdGF0aWMgYXRvbWljX3Qgc2tiX2xpc3Rfc2l6ZSA9IEFUT01JQ19JTklU
KDApOwpzdGF0aWMgYXRvbWljX3Qgc2tiX2NvcGllc19hZGRlZCA9IEFUT01JQ19JTklUKDAp
OwoKLy8gUkNVIGNhbGxiYWNrIGZvciBmcmVlaW5nIHNrYiBsaXN0IGVudHJpZXMKc3RhdGlj
IHZvaWQgZnJlZV9za2JfZW50cnlfcmN1KHN0cnVjdCByY3VfaGVhZCAqaGVhZCkKewogICAg
c3RydWN0IHNrYl9saXN0X2VudHJ5ICplbnRyeSA9IGNvbnRhaW5lcl9vZihoZWFkLCBzdHJ1
Y3Qgc2tiX2xpc3RfZW50cnksIHJjdSk7CgogICAgaWYgKGVudHJ5LT5za2JfY29weSkKICAg
ICAgICBrZnJlZV9za2IoZW50cnktPnNrYl9jb3B5KTsKICAgIGtmcmVlKGVudHJ5KTsKICAg
IGF0b21pY19kZWMoJnNrYl9saXN0X3NpemUpOwp9CgovLyBGdW5jdGlvbiB0byBhZGQgc2ti
IGNvcHkgdG8gUkNVIGxpc3QKc3RhdGljIGludCBhZGRfc2tiX3RvX2xpc3Qoc3RydWN0IHNr
X2J1ZmYgKnNrYikKewogICAgc3RydWN0IHNrYl9saXN0X2VudHJ5ICplbnRyeTsKICAgIHN0
cnVjdCBza2JfbGlzdF9lbnRyeSAqb2xkZXN0X2VudHJ5OwoKICAgIC8vIENoZWNrIGlmIHdl
IG5lZWQgdG8gcmVtb3ZlIG9sZCBlbnRyaWVzCiAgICBpZiAoYXRvbWljX3JlYWQoJnNrYl9s
aXN0X3NpemUpID49IE1BWF9TS0JfTElTVF9TSVpFKSB7CiAgICAgICAgc3Bpbl9sb2NrX2Jo
KCZza2JfbGlzdF9sb2NrKTsKICAgICAgICBpZiAoIWxpc3RfZW1wdHkoJnNrYl9saXN0KSkg
ewogICAgICAgICAgICBvbGRlc3RfZW50cnkgPSBsaXN0X2ZpcnN0X2VudHJ5KCZza2JfbGlz
dCwgc3RydWN0IHNrYl9saXN0X2VudHJ5LCBsaXN0KTsKICAgICAgICAgICAgbGlzdF9kZWxf
cmN1KCZvbGRlc3RfZW50cnktPmxpc3QpOwogICAgICAgICAgICBzcGluX3VubG9ja19iaCgm
c2tiX2xpc3RfbG9jayk7CiAgICAgICAgICAgIGNhbGxfcmN1KCZvbGRlc3RfZW50cnktPnJj
dSwgZnJlZV9za2JfZW50cnlfcmN1KTsKICAgICAgICB9IGVsc2UgewogICAgICAgICAgICBz
cGluX3VubG9ja19iaCgmc2tiX2xpc3RfbG9jayk7CiAgICAgICAgfQogICAgfQoKICAgIC8v
IEFsbG9jYXRlIG5ldyBlbnRyeQogICAgZW50cnkgPSBrbWFsbG9jKHNpemVvZihzdHJ1Y3Qg
c2tiX2xpc3RfZW50cnkpLCBHRlBfQVRPTUlDKTsKICAgIGlmICghZW50cnkpIHsKICAgICAg
ICBwcmludGsoS0VSTl9FUlIgIlBPU1RfUk9VVElORzogRmFpbGVkIHRvIGFsbG9jYXRlIG1l
bW9yeSBmb3Igc2tiIGVudHJ5XG4iKTsKICAgICAgICByZXR1cm4gLUVOT01FTTsKICAgIH0K
CiAgICAvLyBDcmVhdGUgc2tiIGNvcHkKICAgIGVudHJ5LT5za2JfY29weSA9IHNrYl9jb3B5
KHNrYiwgR0ZQX0FUT01JQyk7CgogICAgaWYgKCFlbnRyeS0+c2tiX2NvcHkpIHsKICAgICAg
ICBrZnJlZShlbnRyeSk7CiAgICAgICAgcHJpbnRrKEtFUk5fRVJSICJQT1NUX1JPVVRJTkc6
IEZhaWxlZCB0byBjb3B5IHNrYlxuIik7CiAgICAgICAgcmV0dXJuIC1FTk9NRU07CiAgICB9
CgogICAgLy8gSW5pdGlhbGl6ZSBlbnRyeQogICAgSU5JVF9MSVNUX0hFQUQoJmVudHJ5LT5s
aXN0KTsKCiAgICAvLyBBZGQgdG8gUkNVIGxpc3QKICAgIHNwaW5fbG9ja19iaCgmc2tiX2xp
c3RfbG9jayk7CiAgICBsaXN0X2FkZF90YWlsX3JjdSgmZW50cnktPmxpc3QsICZza2JfbGlz
dCk7CiAgICBzcGluX3VubG9ja19iaCgmc2tiX2xpc3RfbG9jayk7CgogICAgYXRvbWljX2lu
Yygmc2tiX2xpc3Rfc2l6ZSk7CgogICAgcmV0dXJuIDA7Cn0KCi8vIEZ1bmN0aW9uIHRvIGNs
ZWFudXAgYWxsIGVudHJpZXMgaW4gdGhlIGxpc3QKc3RhdGljIHZvaWQgY2xlYW51cF9za2Jf
bGlzdCh2b2lkKQp7CiAgICBzdHJ1Y3Qgc2tiX2xpc3RfZW50cnkgKmVudHJ5LCAqdG1wOwoK
ICAgIHNwaW5fbG9ja19iaCgmc2tiX2xpc3RfbG9jayk7CiAgICBsaXN0X2Zvcl9lYWNoX2Vu
dHJ5X3NhZmUoZW50cnksIHRtcCwgJnNrYl9saXN0LCBsaXN0KSB7CiAgICAgICAgbGlzdF9k
ZWxfcmN1KCZlbnRyeS0+bGlzdCk7CiAgICAgICAgY2FsbF9yY3UoJmVudHJ5LT5yY3UsIGZy
ZWVfc2tiX2VudHJ5X3JjdSk7CiAgICB9CiAgICBzcGluX3VubG9ja19iaCgmc2tiX2xpc3Rf
bG9jayk7Cn0KCi8qCiAqIFdpcGUgY29ubnRyYWNrIG9mZiBvZiBza2IgYW5kIGRlbGV0ZSBp
dAogKi8Kc3RhdGljIGlubGluZSB2b2lkIHdpcGVfY29ubnRyYWNrKHN0cnVjdCBza19idWZm
ICpza2IpCnsKICAgIGVudW0gaXBfY29ubnRyYWNrX2luZm8gY3RpbmZvOwogICAgc3RydWN0
IG5mX2Nvbm4gKmN0ID0gbmZfY3RfZ2V0KHNrYiwgJmN0aW5mbyk7CgogICAgaWYgKGN0KSB7
CiAgICAgICAgcHJpbnRrKCJuZl9jdF9pc19jb25maXJtZWQoKTogJWQsIGN0OiAlcFxuIiwK
ICAgICAgICAgICAgICAgIG5mX2N0X2lzX2NvbmZpcm1lZChjdCksIGN0KTsKICAgICAgICBp
ZiAobmZfY3RfaXNfY29uZmlybWVkKGN0KSkKICAgICAgICAgICAgbmZfY3RfZGVsZXRlKGN0
LCAwLCAwKTsKICAgICAgICBuZl9yZXNldF9jdChza2IpOwogICAgfQp9CgpzdGF0aWMgdm9p
ZCB3aXBlX2Nvbm50cmFja19mcm9tX3NrYl9saXN0KHZvaWQpCnsKICAgIHN0cnVjdCBza2Jf
bGlzdF9lbnRyeSAqZW50cnk7CgogICAgaW50IG9sZCA9IGF0b21pY19jbXB4Y2hnKCZ3aXBl
X2ZsYWcsIDAsIDEpOwoKICAgIGlmIChvbGQgIT0gMCkKICAgICAgICByZXR1cm47CgogICAg
cmN1X3JlYWRfbG9jaygpOwogICAgbGlzdF9mb3JfZWFjaF9lbnRyeV9yY3UoZW50cnksICZz
a2JfbGlzdCwgbGlzdCkgewogICAgICAgIGlmIChlbnRyeS0+c2tiX2NvcHkpCiAgICAgICAg
ICAgIHdpcGVfY29ubnRyYWNrKGVudHJ5LT5za2JfY29weSk7CiAgICB9CiAgICByY3VfcmVh
ZF91bmxvY2soKTsKCiAgICBhdG9taWNfc2V0KCZ3aXBlX2ZsYWcsIDApOwp9CgovLyBIb29r
IGZ1bmN0aW9uIHByb3RvdHlwZQpzdGF0aWMgdW5zaWduZWQgaW50IG15X2hvb2sodm9pZCAq
cHJpdiwgc3RydWN0IHNrX2J1ZmYgKnNrYiwgY29uc3Qgc3RydWN0IG5mX2hvb2tfc3RhdGUg
KnN0YXRlKTsKCi8vIE5ldGZpbHRlciBob29rIG9wZXJhdGlvbnMgc3RydWN0dXJlCnN0YXRp
YyBzdHJ1Y3QgbmZfaG9va19vcHMgcG9zdF9yb3V0aW5nX29wcyA9IHsKICAgIC5ob29rID0g
bXlfaG9vaywKICAgIC5ob29rbnVtID0gTkZfSU5FVF9QT1NUX1JPVVRJTkcsCiAgICAucGYg
PSBORlBST1RPX0lQVjQsCiAgICAucHJpb3JpdHkgPSBORl9JUF9QUklfRklSU1QsCn07Cgoj
ZGVmaW5lIFdJUEVfVEhSRVNIT0xEIDUwMAoKLy8gSG9vayBmdW5jdGlvbiBpbXBsZW1lbnRh
dGlvbgpzdGF0aWMgdW5zaWduZWQgaW50IG15X2hvb2sodm9pZCAqcHJpdiwgc3RydWN0IHNr
X2J1ZmYgKnNrYiwgY29uc3Qgc3RydWN0IG5mX2hvb2tfc3RhdGUgKnN0YXRlKQp7CiAgICAv
LyBBZGQgc2tiIGNvcHkgdG8gUkNVIGxpc3QKICAgIGlmIChhZGRfc2tiX3RvX2xpc3Qoc2ti
KSAhPSAwKQogICAgICAgIHByaW50ayhLRVJOX0VSUiAiUE9TVF9ST1VUSU5HOiBGYWlsZWQg
dG8gYWRkIHNrYiB0byBsaXN0XG4iKTsKCiAgICBpZiAoYXRvbWljX2luY19yZXR1cm4oJnNr
Yl9jb3BpZXNfYWRkZWQpICUgV0lQRV9USFJFU0hPTEQgPT0gMCkgewogICAgICAgIHByaW50
aygiJWQgc2tiIGNvcGllcyBhZGRlZCwgd2UnbGwgd2lwZSB0aGVpciBjb25udHJhY2tzXG4i
LCBXSVBFX1RIUkVTSE9MRCk7CiAgICAgICAgd2lwZV9jb25udHJhY2tfZnJvbV9za2JfbGlz
dCgpOwogICAgfQoKICAgIC8vIEFjY2VwdCB0aGUgcGFja2V0IChsZXQgaXQgY29udGludWUp
CiAgICByZXR1cm4gTkZfQUNDRVBUOwp9CgovLyBNb2R1bGUgaW5pdGlhbGl6YXRpb24gZnVu
Y3Rpb24Kc3RhdGljIGludCBfX2luaXQgbmV0ZmlsdGVyX3Bvc3Rfcm91dGluZ19pbml0KHZv
aWQpCnsKICAgIGludCByZXQ7CiAgICAKICAgIHByaW50ayhLRVJOX0lORk8gIk5ldGZpbHRl
ciBwb3N0IHJvdXRpbmcgaG9vayBtb2R1bGUgbG9hZGVkXG4iKTsKICAgIAogICAgLy8gUmVn
aXN0ZXIgdGhlIGhvb2sKICAgIHJldCA9IG5mX3JlZ2lzdGVyX25ldF9ob29rKCZpbml0X25l
dCwgJnBvc3Rfcm91dGluZ19vcHMpOwogICAgaWYgKHJldCA8IDApIHsKICAgICAgICBwcmlu
dGsoS0VSTl9FUlIgIkZhaWxlZCB0byByZWdpc3RlciBuZXRmaWx0ZXIgaG9vazogJWRcbiIs
IHJldCk7CiAgICAgICAgcmV0dXJuIHJldDsKICAgIH0KICAgIAogICAgcHJpbnRrKEtFUk5f
SU5GTyAiUG9zdCByb3V0aW5nIGhvb2sgcmVnaXN0ZXJlZCBzdWNjZXNzZnVsbHlcbiIpOwog
ICAgcmV0dXJuIDA7Cn0KCi8vIE1vZHVsZSBjbGVhbnVwIGZ1bmN0aW9uCnN0YXRpYyB2b2lk
IF9fZXhpdCBuZXRmaWx0ZXJfcG9zdF9yb3V0aW5nX2V4aXQodm9pZCkKewogICAgLy8gVW5y
ZWdpc3RlciB0aGUgaG9vawogICAgbmZfdW5yZWdpc3Rlcl9uZXRfaG9vaygmaW5pdF9uZXQs
ICZwb3N0X3JvdXRpbmdfb3BzKTsKCiAgICAvLyBDbGVhbiB1cCBhbGwgZW50cmllcyBpbiB0
aGUgUkNVIGxpc3QKICAgIGNsZWFudXBfc2tiX2xpc3QoKTsKICAgIAogICAgLy8gV2FpdCBm
b3IgYWxsIFJDVSBjYWxsYmFja3MgdG8gY29tcGxldGUKICAgIHJjdV9iYXJyaWVyKCk7Cgog
ICAgcHJpbnRrKEtFUk5fSU5GTyAiTmV0ZmlsdGVyIHBvc3Qgcm91dGluZyBob29rIG1vZHVs
ZSB1bmxvYWRlZFxuIik7Cn0KCi8vIFJlZ2lzdGVyIG1vZHVsZSBlbnRyeSBhbmQgZXhpdCBw
b2ludHMKbW9kdWxlX2luaXQobmV0ZmlsdGVyX3Bvc3Rfcm91dGluZ19pbml0KTsKbW9kdWxl
X2V4aXQobmV0ZmlsdGVyX3Bvc3Rfcm91dGluZ19leGl0KTsK
--------------8AC0m0KS2Fm3XPgd04y0QK0b
Content-Type: text/plain; charset=UTF-8; name="Makefile"
Content-Disposition: attachment; filename="Makefile"
Content-Transfer-Encoding: base64

b2JqLW0gKz0gbmV0ZmlsdGVyX3Bvc3Ryb3V0aW5nLm8KS0RJUiA6PSAvbGliL21vZHVsZXMv
JChzaGVsbCB1bmFtZSAtcikvYnVpbGQKCmFsbDoKCW1ha2UgLUMgJChLRElSKSBNPSQoUFdE
KSBtb2R1bGVzCgpjbGVhbjoKCW1ha2UgLUMgJChLRElSKSBNPSQoUFdEKSBjbGVhbgo=

--------------8AC0m0KS2Fm3XPgd04y0QK0b--
