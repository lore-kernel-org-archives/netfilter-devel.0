Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7D84779A9
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 13:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787059907; cv=none; b=HbMURGF0HC1+OV8n6XFA2azIPGkMAS3zI/X6WWfJlIjQKLHBWxtCIZdaAU1D85bz2gjIAPlfKJSFVVLvjQ1ANMDZ6Ge7PZnljX75pf/E1Hx9I3PnjTbY2NqGvzpPskjYeAATs0ox0MqikV9IokuUmlEoyTqbWVZ5KzWOc6+dZZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787059907; c=relaxed/simple;
	bh=9ksLitU+RMU/Q29jtaln1uT0drIAfpCR5lPImCraH6w=;
	h=Message-ID:Date:Content-Type:MIME-Version:From:To:Cc:Subject; b=fsaYWHddkPcE8sNlJl40wXVe0hsl9sXqwbyKGcG3IF8N2By1yZ32VG67YJLpDPTum0ohXUukcFVK93sISclc80Y6Ybxsx0GDLAxas+2N/t8JakkkaZ2S948FCKbyg6W+8sJu97V1H7re+KHwzp9eWtA/8r9ZXhJhuTRwsvQNK34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W+hepQ4y; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W+hepQ4y"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-76535268562so1218466137.3
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 06:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787059905; x=1787664705; darn=vger.kernel.org;
        h=subject:cc:to:from:content-transfer-encoding:mime-version
         :content-type:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9ksLitU+RMU/Q29jtaln1uT0drIAfpCR5lPImCraH6w=;
        b=W+hepQ4yzJFzLMtKNAzcgAE0reNrMgcFLSkwxfNscYcl8gSgVLePSfEpF1mkyFTM03
         9pXZ8rhB9kY0LgDCOtd2NcCDr6CdvsT/vwhNRPtq1GWvIqSd/f/bKBwcb/Zt472z8kyd
         tezRGlDDGL16nP46Er9cmUFiW56ne2OTollx+XdAJi+5GQAShljnVICEV+viHCSOPaNm
         k2nz3BvvSUQCjSadAVzy5g6iYsexUoFXms1jNep9+UR1tOx6ONXPRF7i1OV+DdPCk2ox
         H8uTBLgeqk6UMNDde83CJjSreqjqHar2Bh0izQetxNMThGFcLbxe7U/x5SV6cz1gsIJe
         SgVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787059905; x=1787664705;
        h=subject:cc:to:from:content-transfer-encoding:mime-version
         :content-type:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9ksLitU+RMU/Q29jtaln1uT0drIAfpCR5lPImCraH6w=;
        b=ngbgQ6hm62FTVP1+tCbBvn96b10SzJUxWofIXqd+AVMAUKjQwWNYPFGK0ENZ+ZY0TW
         O/f6zVqodYaKedyTMOhXToxv0kyPmCJYrKgHKQC529r4/n0qYael6xNzcIWc9c73Rc5q
         qXAZwf+Kj+Bkyy0gdPKYwFTKmydX7aFVpQFu275czpsx8Z6YQwQoUK04WkRP8V5doGVk
         6MO+wrWBHzewz6jPnYFJ5KQdduUK3uvakapeql+tsDKdwE4OoT/ETkTvOZSkfwZeAXCT
         woCafK/eJ34zJqCnrOjjm2erMzUjec0eKRE4RUX6HSt9ZoZSUfwHwrfM5Er9+6/9C4et
         MqkQ==
X-Gm-Message-State: AOJu0YxTwXUe3MZfWJXQ6b7Tu37btftdJOHQIpDwlrQdL+SrEB3E/O4M
	2I3UZ0PKc2BESNS7pnlCLmIE9QePKmqhvjmUMbRg79UARtQGq5YPAE1PjOrijW4FB7w=
X-Gm-Gg: AR+sD11ue1HamSjTHUWCtuj2V+vmmC01DN2n3SpKtUjyGSnOuxyFNJ9gMF/tLtZDP8l
	x6y3KyLMyUtxJ/NxK+YWgAw30v7oqIhddLC6uAto85ZwMiRIzr3RLMLG+WcWY6mCsv5FJU8DEpS
	7C0/4hla4gOCUtQD5E8D4AqKZDLC03OpdyP4qGVWVaylDMu5GS5p+btRNajekXrQ8+HQMzpBct1
	0zT21wsZS1XXqruiwhTSzRqjvPHrZCUgKF8ReJpWzJdLWEtyIdqNXtTgvROMxaaRf9cSA6RrmQM
	IDxzAQOlYComljzHAlaXcg/bEeJ9LY8tFln4EIttT82+3vW4oUCT9fJKj+l8yONl/I3GQCF5C1l
	rak63oarWaO21VdBeCm5SteTjavJ6fbmRJefBnmWSr3zulkBfRK6Fny8IckoLwmCtok5TKKpkat
	I0tTEPi0ab1fS9bgw7czeJ3E+TNZWjgEFRWhDzCdunigGB1Nb44/NxEOebVYm7s59MARUKwNtge
	C7zKx10l5RXyF4Aqvr7vcM5KmVx8MqCvm7EwNCzEUUlIJcbznC7hLPWvfqtWXiuyrONSkSnDPWb
	MbW2eHsO72HOJy0XiIFWa/MZeCOhkISOTCq2ZiBS1aVx3uplVGGMMgM6cy4HIxI/IFro8b/gXjT
	GJ4c59w==
X-Received: by 2002:a05:6102:8089:b0:737:9edc:36f8 with SMTP id ada2fe7eead31-7747aeab567mr2442406137.1.1787059904974;
        Tue, 18 Aug 2026 06:31:44 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa (201-93-31-34.dial-up.telesp.net.br. [201.93.31.34])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-773c3111330sm3715222137.5.2026.08.18.06.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 06:31:43 -0700 (PDT)
Message-ID: <6a845ebf.38c7cd2a.f0cff.2405@mx.google.com>
Date: Tue, 18 Aug 2026 06:31:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
From: Joas Antonio dos Santos <joasantonio108@gmail.com>
To: pablo@netfilter.org, fw@strlen.de
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH net v3] netfilter: nf_conntrack_sip: fix OOB read in sip_skip_whitespace()

c2lwX3NraXBfd2hpdGVzcGFjZSgpIHJldHVybnMgZHB0ciB1bmNoYW5nZWQgd2hlbiBpdHMgb3du
IGxvb3AKZXhoYXVzdHMgdGhlIGJ1ZmZlciAoZHB0ciA9PSBsaW1pdCksIGluc3RlYWQgb2YgTlVM
TCBsaWtlIGl0cyBzaWJsaW5nCnNpcF9mb2xsb3dfY29udGludWF0aW9uKCkgcmV0dXJucyBvbiBp
dHMgb3duICJubyBtb3JlIGRhdGEiIHBhdGguCgpjdF9zaXBfZ2V0X2hlYWRlcigpIG9ubHkgY2hl
Y2tzIGZvciBOVUxMIGFmdGVyIGNhbGxpbmcgaXQ6CgogIGRwdHIgPSBzaXBfc2tpcF93aGl0ZXNw
YWNlKGRwdHIsIGxpbWl0KTsKICBpZiAoZHB0ciA9PSBOVUxMKQogICAgICAgICAgYnJlYWs7CiAg
aWYgKCpkcHRyICE9ICc6JyB8fCArK2RwdHIgPj0gbGltaXQpCiAgICAgICAgICBicmVhazsKCnNv
IGEgcmVjb2duaXplZCBoZWFkZXIgbmFtZSBmb2xsb3dlZCBvbmx5IGJ5IHNwYWNlcy90YWJzIHJ1
bm5pbmcgdG8KdGhlIGV4YWN0IGVuZCBvZiB0aGUgU0lQIHBheWxvYWQsIHdpdGggbm8gY29sb24s
IG1ha2VzIHRoZSB2ZXJ5IG5leHQKc3RhdGVtZW50IHJlYWQgb25lIGJ5dGUgcGFzdCB0aGUgYnVm
ZmVyLgoKTWFrZSBib3RoICJubyBtb3JlIGRhdGEiIG91dGNvbWVzIHJldHVybiBOVUxMLCBtYXRj
aGluZyB0aGUKY29udmVudGlvbiBzaXBfZm9sbG93X2NvbnRpbnVhdGlvbigpIGFscmVhZHkgdXNl
cyBhbmQgdGhhdCBib3RoCmV4aXN0aW5nIGNhbGxlcnMgYWxyZWFkeSBjaGVjayBmb3IuCgpGaXhl
czogZWE0NWYxMmEyNzY2ZCAoIltORVRGSUxURVJdOiBuZl9jb25udHJhY2tfc2lwOiBwYXJzZSBT
SVAgaGVhZGVycyBwcm9wZXJseSIpClNpZ25lZC1vZmYtYnk6IEpvYXMgQW50b25pbyBkb3MgU2Fu
dG9zIDxqb2FzYW50b25pbzEwOEBnbWFpbC5jb20+Ci0tLQpUZXN0aW5nOiA3LWJ5dGUgcmVwcm9k
dWNlciAoIlxyXG5UbyAgICIsIG5vIGNvbG9uLCBidWZmZXIgZW5kcyBvbgp0cmFpbGluZyBzcGFj
ZXMpIG5vIGxvbmdlciBjcmFzaGVzOyA1MDAwMDAtcnVuIGxpYkZ1enplciByZWdyZXNzaW9uCmFn
YWluc3QgYSB1c2Vyc3BhY2UgaGFybmVzcyBsaW5raW5nIHRoZSB1bm1vZGlmaWVkIGV4dHJhY3Rl
ZCBwYXJzaW5nCmZ1bmN0aW9ucyBpcyBjbGVhbiwgbm8gYmVoYXZpb3IgY2hhbmdlIG9uIHRoZSBl
eGlzdGluZyBjb3JwdXMuClJlcHJvZHVjZXIgYnl0ZXMgYXZhaWxhYmxlIG9uIHJlcXVlc3QuCgog
bmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfc2lwLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9uZXQvbmV0ZmlsdGVy
L25mX2Nvbm50cmFja19zaXAuYyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3NpcC5jCmlu
ZGV4IDY4MzBjOWRhMy4uMDAwMDAwMDAwIDEwMDY0NAotLS0gYS9uZXQvbmV0ZmlsdGVyL25mX2Nv
bm50cmFja19zaXAuYworKysgYi9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19zaXAuYwpAQCAt
NDI5LDcgKzQyOSw3IEBAIHN0YXRpYyBjb25zdCBjaGFyICpzaXBfc2tpcF93aGl0ZXNwYWNlKGNv
bnN0IGNoYXIgKmRwdHIsIGNvbnN0IGNoYXIgKmxpbWl0KQogCQlkcHRyID0gc2lwX2ZvbGxvd19j
b250aW51YXRpb24oZHB0ciwgbGltaXQpOwogCQlicmVhazsKIAl9Ci0JcmV0dXJuIGRwdHI7CisJ
cmV0dXJuIGRwdHIgPCBsaW1pdCA/IGRwdHIgOiBOVUxMOwogfQoKIC8qIFNlYXJjaCB3aXRoaW4g
YSBTSVAgaGVhZGVyIHZhbHVlLCBkZWFsaW5nIHdpdGggY29udGludWF0aW9uIGxpbmVzICovCg==
