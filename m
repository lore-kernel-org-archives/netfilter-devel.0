Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6A739E177
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2026 06:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791269603; cv=pass; b=PDutzxMvrv56rHlyySxssI5HF+lC4AfYxaxD9fHJ2mnZ+0RhzQ2H1xXn0K7pLiOZkrUFP2mzOYp49k0p9zRxoaX8F9a1arCCbZm8BVOlb3u9SuGlC0NG3VLvBYGjOvJM9vy6QXRErYXm653SSExkkUlc1BzI3krs8B3I8llTyW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791269603; c=relaxed/simple;
	bh=toGYYJRgYl4Jn0jtq/t2zfzNqu9gDW6XWc+8Tl8KZ0w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lFnnKfOOpgdx82gKScC7OzsP20b4jvNaAMQVLYjqRNt4OWT+VUgQHW+/j2n5KMOFmyjPiW5XHRuIMEc5jmsTNj5qTx+0vg0VkDtSghceb1aX33YDVo3gRTNBPh8sIyxhKrg0Iq+oR4IcUSgmHGbWAmnuNqhGbpezSasNrjEZOfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZoR+iuQ8; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZoR+iuQ8"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6aa850436d3so3139118a12.2
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Oct 2026 23:53:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791269600; cv=none;
        d=google.com; s=arc-20260327;
        b=M84fRKRtDGgnFi4KeuRxMZfIO2dzBby13FNcdc3NhCCSRypg6SdEeS8JzNhG/SELxx
         B7JIgiBi14ru4JoRoMsjsAu7InkpSF2JiuUcSZxUO2SOe7NS3Isb7fgnr0IVpkiXNJug
         7X2hVmTcuXnCJR4iaPc2ny/iAfi7uQbZwqiH1dSNZ3cpqlgSwfwfUvoKpp+JZ6CFvfQJ
         BYBwEqRx6el0gzrmIhqemmh9wg7EiG7dQk61ocKaIe3/JlCm9lJpfQHTFPd/48H5ACS1
         g3BZ+DjLz8UJ2XcV5Vg2gV+f1YiXQ1WqBU5s/06XSpVnNFb4On2DtdLsZPO8LyyLR5y/
         gZ7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=NelSkx7eit6x0eGV92u4q4AGrpGs0hhxi1nSOyGwJNA=;
        fh=PiJTrYGywfJruQP7FdAEEusmmWKNSnLwPDJlTj4EqQc=;
        b=cMfpfF/8DSE2MpHsi8CB07cTZM5IThyadPJSZFKTfSVuiow8JlnlkmyA1r0Hu+hxgD
         24clMUlEcK83CKZYu+MpuFkSY0uNtPY+wMSV/Gha8042e1Gm37xJaVVsReUlS56f8p6f
         fzX43IGRP51NAtVWvG6G+q6tJfEwhgix5CrDDnLWLsUBsOt/Bcq2QCihQz3R3slk2CQe
         RTOw0NPPkE5d3u2O7bjOa9QS2YujykhPsjBULAIoiLT/GrvjPR55JzqJ0PRluLA1HtIe
         5FJj9qPaZZJWk/RLYp6ooc3oNCbs5MktUUSgCfUM9cHnu+Eh+ff0HrasJzaCKMzgaR6H
         8afA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791269600; x=1791874400; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NelSkx7eit6x0eGV92u4q4AGrpGs0hhxi1nSOyGwJNA=;
        b=ZoR+iuQ85WvOKPfGvDHiRhzSzTJLTrAbhcZEQdnEFJFpRnVW5hUZYQDldcADflnRCn
         FVM/cf5LEL8ObOEGRmdOHc3cRb+pMOcDmrTwtIY5mqP/MZyR84eJeBxlPEIQKWVW3wz1
         PykOr+hUHh1uwVJC3nUK4EBD5LMUhiywXD4X+CXnvJT2jN6jWGBNAa1tX9Zm4iZHspBE
         dYMyTtgRTkJ5NuZXAlVVm4pKZCimZc6eOzJaZTksl+C6/0FPOR8cle8J68I2TGwSJKYQ
         BO4U/KpuAVzzYjQr+32ws+pvUBP9xhkOv9TOG14KsXWJILUJ9A6JR2PkkiLDqNsj2eOw
         p+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791269600; x=1791874400;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NelSkx7eit6x0eGV92u4q4AGrpGs0hhxi1nSOyGwJNA=;
        b=YglfUvhUDGAEH1igT3hNeThMh3OesXZv/mKEWN5be6bC2pzOACmMXAKQteZ4zvMjbL
         iZGJK8+aKngyKQBn8bRH50XdMUka9s+WB0F53ZT2N+2AJi/zwOGZrfPX/O0rsEUHMWhG
         tpRPefNjIFSdl+8BYC9LY9Jtl/lXxuzC3U+1rUakEN4SpehOGfov0okEIcvNJFhkQWNH
         6/MpB+kKyTwGsjqyogcpZQ6kWzsesrITxUjnoZLC6Xlk5yATQIaT0z4WIfWmSRzw2Lze
         5ixeNHK9HtDQ80kBP7LsmUgAw8WJFHd3cMsSn8xGWdWsp1rSF62qPJA5vOfbhv8GcLyj
         iHIA==
X-Forwarded-Encrypted: i=1; AKwUvBwook3zCxb7M942j9QIt+CYHhpj7tNAzrtRsxnD+nruhegfz2WVHe6VTTG9kTLh5Wv/jgpjocHWlR1Pu6Ai3hI=@vger.kernel.org
X-Gm-Message-State: AFq9FYLbo24bUNu4ly8MY2RbQvOa8JRWfE5bpo7OKpGUEjLTxWN2YhUo
	/jz5HMcKjk9rI/RoJG6LntYYO6kFX/fX6o2qJ6R2D+lPSNxm/MabolvyHAV0ujWcmROJwEx+wNk
	Ac4xhCUxXjDABiCEY3RGxFXJCeJH7zQo=
X-Gm-Gg: AYBFou1IQ6DSexzr9BDoUKMSw4D5YxBUps1YUa/K/xp8s3O6JJLj+Te7gXm/g7Tr8sZ
	u3uiuw/laKSzIYfGp6hkF19IxqxXhwjQ92sx2jpzE74h17hnEtNmpPb9qvJ+5rhftQTIWESNyIi
	LThla4D2Wqy3sQP9gE1uYIpA6WkHaNDtr5mx2v2I86Iisw9NNrOkYLd9JD9rPVLAB7BtCETgiGz
	FYZWnFaIlN3WzX8qOInWMr9FWA22ge16U7gu17PpGnrnv8pfw2YBGPdOXehKGiJtQ5aDjJpLykQ
	ccEx8PwC1Mf4oGhVeSvjfVFbw02+CQPnlkO+yppGos74W4IAJ3O98F/T
X-Received: by 2002:a05:6402:4345:b0:6a7:ee56:6168 with SMTP id
 4fb4d7f45d1cf-6afe29e848bmr408852a12.42.1791269599619; Mon, 05 Oct 2026
 23:53:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHeizqGJ6WpknaU=WE+PB2A09jWi==-sUUgmc36qgStVDRdSLQ@mail.gmail.com>
In-Reply-To: <CAHeizqGJ6WpknaU=WE+PB2A09jWi==-sUUgmc36qgStVDRdSLQ@mail.gmail.com>
From: Subham Pal <subhampal789@gmail.com>
Date: Tue, 6 Oct 2026 12:23:07 +0530
X-Gm-Features: AclHuK-bNoquXtxCw96zx8ET1JZzjQYfuZ0UmZWGCH9W-pnuytIWX4H2oXvtGtk
Message-ID: <CAHeizqG-P8rAwYP+FnrTrNmY5h7pVbZ-yHPPJzwVUKrCQvsB1g@mail.gmail.com>
Subject: [PATCH nf-next v2 1/2] netfilter: nf_conntrack_h323: do not bypass
 NAT helpers when tuple source matches reply destination
To: Pablo Neira Ayuso <pablo@netfilter.org>, fw@strlen.de
Cc: phil@nwl.cc, kaber@trash.net, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	stable@vger.kernel.org, Subham Pal <subhampal789@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000002ee19e065d267495"

--0000000000002ee19e065d267495
Content-Type: text/plain; charset="UTF-8"

The expectation helpers (expect_h245, expect_rtp_rtcp, expect_t120, and
expect_callforwarding) test whether NAT is required by comparing the
forward source IP against the reverse destination IP:

    memcmp(&ct->tuplehash[dir].tuple.src.u3,
           &ct->tuplehash[!dir].tuple.dst.u3,
           sizeof(ct->tuplehash[dir].tuple.src.u3))

This check is broken for multiple reasons:

1. It incorrectly evaluates to 0 in the reply direction
   (dir == IP_CT_DIR_REPLY) even under SNAT, because tuplehash[REPLY].src
   and tuplehash[ORIGINAL].dst both represent the remote peer's address.
2. In Destination NAT (DNAT) and hairpin setups, the sender's source IP
   is never modified, causing this check to evaluate to false even though
   NAT payload rewriting is necessary.

As a result, NAT payload mangling is bypassed, leaving internal addresses
untranslated inside the signaling packets and leading to call setup and
media stream failures.

Remove the redundant memcmp() checks across all four expectation helpers.
Verifying that nathook is present and that ct->status matches IPS_NAT_MASK
is sufficient to determine whether NAT handling should execute.

Fixes: f587de0e2feb ("[NETFILTER]: nf_conntrack/nf_nat: add H.323 helper port")
Cc: stable@vger.kernel.org
Signed-off-by: Subham Pal <subhampal789@gmail.com>
---
[Note: Raw patch attached to avoid webmail tab/whitespace corruption]

--0000000000002ee19e065d267495
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-netfilter-nf_conntrack_h323-do-not-bypass-NAT-helper.patch"
Content-Disposition: attachment; 
	filename="0001-netfilter-nf_conntrack_h323-do-not-bypass-NAT-helper.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_muwbn39c0>
X-Attachment-Id: f_muwbn39c0

RnJvbSBlYjc4NzQ4Y2MzY2I2MDMyNTY2YTY0OWNlZWFkZjk5Yzc4OGY0NTczIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdWJoYW0gUGFsIDxzdWJoYW1wYWw3ODlAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDIyIFNlcCAyMDI2IDE2OjE5OjA1ICswNTMwClN1YmplY3Q6IFtQQVRDSCBuZi1u
ZXh0IHYyIDEvMl0gbmV0ZmlsdGVyOiBuZl9jb25udHJhY2tfaDMyMzogZG8gbm90IGJ5cGFzcwog
TkFUIGhlbHBlcnMgd2hlbiB0dXBsZSBzb3VyY2UgbWF0Y2hlcyByZXBseSBkZXN0aW5hdGlvbgoK
VGhlIGV4cGVjdGF0aW9uIGhlbHBlcnMgKGV4cGVjdF9oMjQ1LCBleHBlY3RfcnRwX3J0Y3AsIGV4
cGVjdF90MTIwLCBhbmQKZXhwZWN0X2NhbGxmb3J3YXJkaW5nKSB0ZXN0IHdoZXRoZXIgTkFUIGlz
IHJlcXVpcmVkIGJ5IGNvbXBhcmluZyB0aGUKZm9yd2FyZCBzb3VyY2UgSVAgYWdhaW5zdCB0aGUg
cmV2ZXJzZSBkZXN0aW5hdGlvbiBJUDoKCiAgICBtZW1jbXAoJmN0LT50dXBsZWhhc2hbZGlyXS50
dXBsZS5zcmMudTMsCiAgICAgICAgICAgJmN0LT50dXBsZWhhc2hbIWRpcl0udHVwbGUuZHN0LnUz
LAogICAgICAgICAgIHNpemVvZihjdC0+dHVwbGVoYXNoW2Rpcl0udHVwbGUuc3JjLnUzKSkKClRo
aXMgY2hlY2sgaXMgYnJva2VuIGZvciBtdWx0aXBsZSByZWFzb25zOgoKMS4gSXQgaW5jb3JyZWN0
bHkgZXZhbHVhdGVzIHRvIDAgaW4gdGhlIHJlcGx5IGRpcmVjdGlvbgogICAoZGlyID09IElQX0NU
X0RJUl9SRVBMWSkgZXZlbiB1bmRlciBTTkFULCBiZWNhdXNlIHR1cGxlaGFzaFtSRVBMWV0uc3Jj
CiAgIGFuZCB0dXBsZWhhc2hbT1JJR0lOQUxdLmRzdCBib3RoIHJlcHJlc2VudCB0aGUgcmVtb3Rl
IHBlZXIncyBhZGRyZXNzLgoyLiBJbiBEZXN0aW5hdGlvbiBOQVQgKEROQVQpIGFuZCBoYWlycGlu
IHNldHVwcywgdGhlIHNlbmRlcidzIHNvdXJjZSBJUAogICBpcyBuZXZlciBtb2RpZmllZCwgY2F1
c2luZyB0aGlzIGNoZWNrIHRvIGV2YWx1YXRlIHRvIGZhbHNlIGV2ZW4gdGhvdWdoCiAgIE5BVCBw
YXlsb2FkIHJld3JpdGluZyBpcyBuZWNlc3NhcnkuCgpBcyBhIHJlc3VsdCwgTkFUIHBheWxvYWQg
bWFuZ2xpbmcgaXMgYnlwYXNzZWQsIGxlYXZpbmcgaW50ZXJuYWwgYWRkcmVzc2VzCnVudHJhbnNs
YXRlZCBpbnNpZGUgdGhlIHNpZ25hbGluZyBwYWNrZXRzIGFuZCBsZWFkaW5nIHRvIGNhbGwgc2V0
dXAgYW5kCm1lZGlhIHN0cmVhbSBmYWlsdXJlcy4KClJlbW92ZSB0aGUgcmVkdW5kYW50IG1lbWNt
cCgpIGNoZWNrcyBhY3Jvc3MgYWxsIGZvdXIgZXhwZWN0YXRpb24gaGVscGVycy4KVmVyaWZ5aW5n
IHRoYXQgbmF0aG9vayBpcyBwcmVzZW50IGFuZCB0aGF0IGN0LT5zdGF0dXMgbWF0Y2hlcyBJUFNf
TkFUX01BU0sKaXMgc3VmZmljaWVudCB0byBkZXRlcm1pbmUgd2hldGhlciBOQVQgaGFuZGxpbmcg
c2hvdWxkIGV4ZWN1dGUuCgpGaXhlczogZjU4N2RlMGUyZmViICgiW05FVEZJTFRFUl06IG5mX2Nv
bm50cmFjay9uZl9uYXQ6IGFkZCBILjMyMyBoZWxwZXIgcG9ydCIpCkNjOiBzdGFibGVAdmdlci5r
ZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6IFN1YmhhbSBQYWwgPHN1YmhhbXBhbDc4OUBnbWFpbC5j
b20+Ci0tLQp2MSAtPiB2MjoKICAtIFJldGFyZ2V0ZWQgdG8gbmYtbmV4dCBwZXIgbWFpbnRhaW5l
ciByZXF1ZXN0LgogIC0gTm8gZnVuY3Rpb25hbCBjaGFuZ2VzLgoKIG5ldC9uZXRmaWx0ZXIvbmZf
Y29ubnRyYWNrX2gzMjNfbWFpbi5jIHwgMjQgKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZp
bGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19oMzIzX21haW4uYyBiL25ldC9uZXRmaWx0ZXIv
bmZfY29ubnRyYWNrX2gzMjNfbWFpbi5jCmluZGV4IDRjYjE2NjViYmEwMi4uMGMyYWE2MDhhZTYw
IDEwMDY0NAotLS0gYS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19oMzIzX21haW4uYworKysg
Yi9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19oMzIzX21haW4uYwpAQCAtMjUwLDEyICsyNTAs
OSBAQCBzdGF0aWMgaW50IGV4cGVjdF9ydHBfcnRjcChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1
Y3QgbmZfY29ubiAqY3QsCiAJCQkgIElQUFJPVE9fVURQLCBOVUxMLCAmcnRjcF9wb3J0KTsKIAog
CW5hdGhvb2sgPSByY3VfZGVyZWZlcmVuY2UobmZjdF9oMzIzX25hdF9ob29rKTsKLQlpZiAobWVt
Y21wKCZjdC0+dHVwbGVoYXNoW2Rpcl0udHVwbGUuc3JjLnUzLAotCQkgICAmY3QtPnR1cGxlaGFz
aFshZGlyXS50dXBsZS5kc3QudTMsCi0JCSAgIHNpemVvZihjdC0+dHVwbGVoYXNoW2Rpcl0udHVw
bGUuc3JjLnUzKSkgJiYKLQkJICAgbmF0aG9vayAmJgotCQkgICBuZl9jdF9sM251bShjdCkgPT0g
TkZQUk9UT19JUFY0ICYmCi0JCSAgIGN0LT5zdGF0dXMgJiBJUFNfTkFUX01BU0spIHsKKwlpZiAo
bmF0aG9vayAmJgorCQluZl9jdF9sM251bShjdCkgPT0gTkZQUk9UT19JUFY0ICYmCisJCWN0LT5z
dGF0dXMgJiBJUFNfTkFUX01BU0spIHsKIAkJLyogTkFUIG5lZWRlZCAqLwogCQlyZXQgPSBuYXRo
b29rLT5uYXRfcnRwX3J0Y3Aoc2tiLCBjdCwgY3RpbmZvLCBwcm90b2ZmLCBkYXRhLCBkYXRhb2Zm
LAogCQkJCQkgICAgdGFkZHIsIHBvcnQsIHJ0cF9wb3J0LCBydHBfZXhwLCBydGNwX2V4cCk7CkBA
IC0zMTAsMTAgKzMwNyw3IEBAIHN0YXRpYyBpbnQgZXhwZWN0X3QxMjAoc3RydWN0IHNrX2J1ZmYg
KnNrYiwKIAlleHAtPmZsYWdzID0gTkZfQ1RfRVhQRUNUX1BFUk1BTkVOVDsJLyogQWNjZXB0IG11
bHRpcGxlIGNoYW5uZWxzICovCiAKIAluYXRob29rID0gcmN1X2RlcmVmZXJlbmNlKG5mY3RfaDMy
M19uYXRfaG9vayk7Ci0JaWYgKG1lbWNtcCgmY3QtPnR1cGxlaGFzaFtkaXJdLnR1cGxlLnNyYy51
MywKLQkJICAgJmN0LT50dXBsZWhhc2hbIWRpcl0udHVwbGUuZHN0LnUzLAotCQkgICBzaXplb2Yo
Y3QtPnR1cGxlaGFzaFtkaXJdLnR1cGxlLnNyYy51MykpICYmCi0JICAgIG5hdGhvb2sgJiYKKwlp
ZiAobmF0aG9vayAmJgogCSAgICBuZl9jdF9sM251bShjdCkgPT0gTkZQUk9UT19JUFY0ICYmCiAJ
ICAgIGN0LT5zdGF0dXMgJiBJUFNfTkFUX01BU0spIHsKIAkJLyogTkFUIG5lZWRlZCAqLwpAQCAt
NjQzLDEwICs2MzcsNyBAQCBzdGF0aWMgaW50IGV4cGVjdF9oMjQ1KHN0cnVjdCBza19idWZmICpz
a2IsIHN0cnVjdCBuZl9jb25uICpjdCwKIAlyY3VfYXNzaWduX3BvaW50ZXIoZXhwLT5hc3NpZ25f
aGVscGVyLCBuZl9jb25udHJhY2tfaGVscGVyX2gyNDVfcHRyKTsKIAogCW5hdGhvb2sgPSByY3Vf
ZGVyZWZlcmVuY2UobmZjdF9oMzIzX25hdF9ob29rKTsKLQlpZiAobWVtY21wKCZjdC0+dHVwbGVo
YXNoW2Rpcl0udHVwbGUuc3JjLnUzLAotCQkgICAmY3QtPnR1cGxlaGFzaFshZGlyXS50dXBsZS5k
c3QudTMsCi0JCSAgIHNpemVvZihjdC0+dHVwbGVoYXNoW2Rpcl0udHVwbGUuc3JjLnUzKSkgJiYK
LQkgICAgbmF0aG9vayAmJgorCWlmIChuYXRob29rICYmCiAJICAgIG5mX2N0X2wzbnVtKGN0KSA9
PSBORlBST1RPX0lQVjQgJiYKIAkgICAgY3QtPnN0YXR1cyAmIElQU19OQVRfTUFTSykgewogCQkv
KiBOQVQgbmVlZGVkICovCkBAIC03NzAsMTAgKzc2MSw3IEBAIHN0YXRpYyBpbnQgZXhwZWN0X2Nh
bGxmb3J3YXJkaW5nKHN0cnVjdCBza19idWZmICpza2IsCiAJcmN1X2Fzc2lnbl9wb2ludGVyKGV4
cC0+YXNzaWduX2hlbHBlciwgbmZfY29ubnRyYWNrX2hlbHBlcl9xOTMxX3B0clswXSk7CiAKIAlu
YXRob29rID0gcmN1X2RlcmVmZXJlbmNlKG5mY3RfaDMyM19uYXRfaG9vayk7Ci0JaWYgKG1lbWNt
cCgmY3QtPnR1cGxlaGFzaFtkaXJdLnR1cGxlLnNyYy51MywKLQkJICAgJmN0LT50dXBsZWhhc2hb
IWRpcl0udHVwbGUuZHN0LnUzLAotCQkgICBzaXplb2YoY3QtPnR1cGxlaGFzaFtkaXJdLnR1cGxl
LnNyYy51MykpICYmCi0JICAgIG5hdGhvb2sgJiYKKwlpZiAobmF0aG9vayAmJgogCSAgICBuZl9j
dF9sM251bShjdCkgPT0gTkZQUk9UT19JUFY0ICYmCiAJICAgIGN0LT5zdGF0dXMgJiBJUFNfTkFU
X01BU0spIHsKIAkJLyogTmVlZCBOQVQgKi8KLS0gCjIuNDMuMAoK
--0000000000002ee19e065d267495--
