Received: from mail-ed2-f34.google.com (mail-ed2-f34.google.com [74.125.228.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE39F3546C0
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 04:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790137552; cv=pass; b=NtSRod9cAks3ASVVtdrZkogI3lwoXfTuxnk8aVCApoin5IRm/J5SLC7mHnfjdEigFnF0WHN6J9mAAerZuepCZaMUQAtX05zX5idP5f4/kTd6i7qJCnNydp7aIjBT8TYnCnXq3a11/u/GA0kA9UNgfqG6Hk1JmbXrR8QuORC/1tQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790137552; c=relaxed/simple;
	bh=UUlQ7kIa3uR9VdRaRcoro98M/aH/UEQNwysDzAx2NiY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nPoNQx6+ZLqPm6R13CZztqRVg6KvZMOGuKe4TUZ1FVmYRbarbpAQItPR5BehcSmkgu4+q2KfHEiTkb5/o5ue2cZghZRMOUQJkgVVZtB/6jEZ0Jj1QzTcVG/XVZbxrWvW7vVqr/XC9sLLsXGJLQa8xGLE4s4r4Wy/VmNSdseRWi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mo3IWI/2; arc=pass smtp.client-ip=74.125.228.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mo3IWI/2"
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aab5dae09fso276887a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 21:25:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790137549; cv=none;
        d=google.com; s=arc-20260327;
        b=QjC6NPRBBFVpMB1w3FMKbc4MPFeYMz1+knP8npZNV2Sc8Yl7D8lrUwYrS8e7XxVz2u
         NOJcKlkh74wTU7L8JBMNKbnvCo0ajyL3bFryViuUY3QBtXVl6l6xuQuJ6cxFrG2/xDeD
         QHTiD26x5BCHUPpKtgyAUsTo/xpF/uZT8nqwLLuy9NWJN7NzwbeusWw8Lg8A/yW3/qTM
         z2rkZi7putUIjS70RSDsJbUwDLTRs6e9j3gpQCc88uM8AF+UCJV4pz3R5Lnj1ilgE17d
         ByL0igYjfPXl7RHNZev3MTQW+fcK4Klvh9qSAjm2bXbMMXqQEiNPXqjR05nbdtMyITlO
         7qHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=IeU9yCLPgvxW29W/Wr8abObZICqs4XUk99ozjHOllWU=;
        fh=whjmULzWI0biDCA/VApF1Z/qhwl2qsK+zM0//hyI9UQ=;
        b=QXJdJgpOLDmfMoKor49CyRKDXIv3anvcJkn81NkqDa5/zEiCegSY7tf9SbjJ2xovTF
         u10bJhsuMKvfxsMeKTE/y4gkifc69VV/BthUdo8Vjbexnl6o6smrUQxCYS6yR8KKwGOe
         Mm79a+3pcv8GYPehr+0PHBv+LD9LhmbMiIXnnV8BeQA/tYo9tEePF8ZfSHfULyMTtz6y
         G0RO8HwyEULqg3u06TKzOLWBHAluyP+9HuvP64Uy4BlzWkeGh4qBZeS15VtSpK86BrY9
         CX5udnCHRh50ST/hXbA1hIoSXXMO0N6GfHXbrGHoV8/WT+C9A8uL3xTIeXnv7rZLl+3n
         tUIg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790137549; x=1790742349; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IeU9yCLPgvxW29W/Wr8abObZICqs4XUk99ozjHOllWU=;
        b=mo3IWI/2CZhmThbzZdeqH8cVXrWqWUxSkfn0R/L5g4z1lD7ocJ89TJjwhkJIt3Lm1u
         jYUuz81cjKDnym0c2W3zUfVJI8bbd3VR1I53Wm2eNcajx5Er7QaW76NhUP/w++K9jfiM
         Y8qEogwLrHD33A9Q2eFsIdk/nHdHHfS0AqJeNTHafn+FUg/wcUUbOIHgNHLWw4J9I31G
         HxGdMRzwYm6+vJhqK7L3/ZOcYtmGqeT+/dlMCm+XTePmGZOUoj71VRui7cS/7Ei8HjHe
         u/gywg6NJwx5O4WW7vd5Gf9VWdQOvoCd/6Z7t9Iga3kc9NLKC2GX5zB3HC42JauRZuWm
         dPcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790137549; x=1790742349;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IeU9yCLPgvxW29W/Wr8abObZICqs4XUk99ozjHOllWU=;
        b=lSkRWSphxuS3O75OtWAmdmv6Y3YHVH9nXitFstfNrIzGuszY0xskh5UZNtP2k2yiYB
         iuLqbOOCD81NjpmQ059jgEVs6QAB2qANECEqmEqVufQeJWnoeP3f1RsNHdVUcDwXzt03
         N3GBm4Sr5qgwkjnRDaDD1W8n0BkKKM0N8xBMsGl4x2Ls5ucfVh5bYsiti+CGgMuoLSOx
         Wic4LYfkHTrCpnZqH5VWsEbbcunQOP9njqSsM4R9CxMCHjFR5Vqo/wyUipUBjvjSal3H
         w6ncKMIJlbEi4dqD4lcwclosBTh3uBkaeUfEIt2vKvwyrkbZzi9oN7UO8M7rkBB/Txx7
         Edcg==
X-Forwarded-Encrypted: i=1; AKwUvBxZo0qmQoTHAOYqLGzWmBH5xyo7HN2viiL2d34JpKKVIt/GGYDKfGAH+aVzHUWMsc+ZCJnJLXU3aqMYRdDSzYY=@vger.kernel.org
X-Gm-Message-State: AFuF++nG9X5unxnln1JgfsUl+VY5krNlaI9eSjUikivBt+sURN0L1d0h
	twReoNVWsiuqKukCpAQ1yHFgI3sYiM1pbDfOqGCy9/WXyxapSS97UQ/vm+6VbE7WU7TRytYnIjh
	oy3iviEYBU17uzjYWEDLnMgFWNu0x7NA=
X-Gm-Gg: AYBFou0up6WP8DSV9ztPM5Px4vmtaYIZ6ab8TS+xAkYImHR6xzRWMucnq4nFr57yW0/
	pY+XSlMD20loutltYDD916eOYceZilkIsqUZ4UbZUWbr0EfCSz8eqFRDmpxBCzhjtZ/MhMXoZwC
	77cO+5KQMjdtxV7e5d3TQpHFWQie0Xos+PNKiTlJdwDmWXVfvMPXYRkajnuHDxm3dReEMT/l3Ym
	R2ldc9V3kZiYnOOs+3O66NgHBMYfauivULYLgD36YNBUMj1o3e80CpQrOG5dRQ5Fw6b9OVXNXLV
	APZkk7ieUEwSuSo+Q+BE12+CqIzxhPfApKnLDEjID3yiikmZt5abfJyH
X-Received: by 2002:a05:6402:e08:b0:6a6:58e:f84b with SMTP id
 4fb4d7f45d1cf-6aab3b3290cmr1132004a12.9.1790137548702; Tue, 22 Sep 2026
 21:25:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHeizqHDqx3ue1=0QL92ef+6C63Ur+v1Z=d93smgdD5zTj_-Pw@mail.gmail.com>
In-Reply-To: <CAHeizqHDqx3ue1=0QL92ef+6C63Ur+v1Z=d93smgdD5zTj_-Pw@mail.gmail.com>
From: Subham Pal <subhampal789@gmail.com>
Date: Wed, 23 Sep 2026 09:55:36 +0530
X-Gm-Features: AcwNN1UqOmJcSELMO4KAE7-1VTiKPU7jttoSlNChhRSXoi29Zo5huTYuBczGPCc
Message-ID: <CAHeizqEszi5fr1aEZSr6mhRLaOOsf5aRRcF=-nDLF90RPNRDGQ@mail.gmail.com>
Subject: [PATCH net 2/2] netfilter: nf_conntrack_h323: check extension bitmap
 before decoding components
To: pablo@netfilter.org, fw@strlen.de
Cc: phil@nwl.cc, kaber@trash.net, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000b0c0e0065c1ee0ac"

--000000000000b0c0e0065c1ee0ac
Content-Type: text/plain; charset="UTF-8"

In decode_seq(), the extension components loop iterates through bmp2_len
bits. However, it evaluates whether the component index exceeds the known
upper bound (`i >= f->ub`) and whether it contains a STOP attribute before
checking if the field is actually present in `bmp2`:

    if (i >= f->ub) {
        ...
        len = get_len(bs);
        ...
    }
    if (son->attr & STOP)
        return H323_ERROR_STOP;

    if (!((0x80000000 >> opt) & bmp2))
        continue;

If an unknown extension is marked absent in the bitmap (`bit == 0`), the
parser erroneously attempts to read a non-existent open type length from
the bitstream and advances `bs->cur` by garbage bytes. Furthermore, if a
known field has the STOP attribute but is absent from the transmission,
decoding aborts prematurely.

Move the presence bitmap check to the beginning of the loop body so absent
extensions are skipped immediately before attempting to decode or inspect
attributes. Also append a 'U' suffix to 0x80000000 to prevent signed shift
overflow.

Fixes: f587de0e2feb ("[NETFILTER]: nf_conntrack/nf_nat: add H.323 helper port")
Cc: stable@vger.kernel.org
Signed-off-by: Subham Pal <subhampal789@gmail.com>
---
[Note: Raw patch attached to avoid webmail tab/whitespace corruption]

--000000000000b0c0e0065c1ee0ac
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-netfilter-nf_conntrack_h323-check-extension-bitmap-b.patch"
Content-Disposition: attachment; 
	filename="0002-netfilter-nf_conntrack_h323-check-extension-bitmap-b.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mudlnwuy0>
X-Attachment-Id: f_mudlnwuy0

RnJvbSA0NjgzNTYzMWU2OTQ5ZWQ5MzZhNDRjZDhlNDY0OGIxYWRmNzMwNGVjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdWJoYW0gUGFsIDxzdWJoYW1wYWw3ODlAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDIyIFNlcCAyMDI2IDE2OjM1OjA4ICswNTMwClN1YmplY3Q6IFtQQVRDSCBuZXQg
Mi8yXSBuZXRmaWx0ZXI6IG5mX2Nvbm50cmFja19oMzIzOiBjaGVjayBleHRlbnNpb24gYml0bWFw
CiBiZWZvcmUgZGVjb2RpbmcgY29tcG9uZW50cwoKSW4gZGVjb2RlX3NlcSgpLCB0aGUgZXh0ZW5z
aW9uIGNvbXBvbmVudHMgbG9vcCBpdGVyYXRlcyB0aHJvdWdoIGJtcDJfbGVuCmJpdHMuIEhvd2V2
ZXIsIGl0IGV2YWx1YXRlcyB3aGV0aGVyIHRoZSBjb21wb25lbnQgaW5kZXggZXhjZWVkcyB0aGUg
a25vd24KdXBwZXIgYm91bmQgKGBpID49IGYtPnViYCkgYW5kIHdoZXRoZXIgaXQgY29udGFpbnMg
YSBTVE9QIGF0dHJpYnV0ZSBiZWZvcmUKY2hlY2tpbmcgaWYgdGhlIGZpZWxkIGlzIGFjdHVhbGx5
IHByZXNlbnQgaW4gYGJtcDJgOgoKICAgIGlmIChpID49IGYtPnViKSB7CiAgICAgICAgLi4uCiAg
ICAgICAgbGVuID0gZ2V0X2xlbihicyk7CiAgICAgICAgLi4uCiAgICB9CiAgICBpZiAoc29uLT5h
dHRyICYgU1RPUCkKICAgICAgICByZXR1cm4gSDMyM19FUlJPUl9TVE9QOwoKICAgIGlmICghKCgw
eDgwMDAwMDAwID4+IG9wdCkgJiBibXAyKSkKICAgICAgICBjb250aW51ZTsKCklmIGFuIHVua25v
d24gZXh0ZW5zaW9uIGlzIG1hcmtlZCBhYnNlbnQgaW4gdGhlIGJpdG1hcCAoYGJpdCA9PSAwYCks
IHRoZQpwYXJzZXIgZXJyb25lb3VzbHkgYXR0ZW1wdHMgdG8gcmVhZCBhIG5vbi1leGlzdGVudCBv
cGVuIHR5cGUgbGVuZ3RoIGZyb20KdGhlIGJpdHN0cmVhbSBhbmQgYWR2YW5jZXMgYGJzLT5jdXJg
IGJ5IGdhcmJhZ2UgYnl0ZXMuIEZ1cnRoZXJtb3JlLCBpZiBhCmtub3duIGZpZWxkIGhhcyB0aGUg
U1RPUCBhdHRyaWJ1dGUgYnV0IGlzIGFic2VudCBmcm9tIHRoZSB0cmFuc21pc3Npb24sCmRlY29k
aW5nIGFib3J0cyBwcmVtYXR1cmVseS4KCk1vdmUgdGhlIHByZXNlbmNlIGJpdG1hcCBjaGVjayB0
byB0aGUgYmVnaW5uaW5nIG9mIHRoZSBsb29wIGJvZHkgc28gYWJzZW50CmV4dGVuc2lvbnMgYXJl
IHNraXBwZWQgaW1tZWRpYXRlbHkgYmVmb3JlIGF0dGVtcHRpbmcgdG8gZGVjb2RlIG9yIGluc3Bl
Y3QKYXR0cmlidXRlcy4gQWxzbyBhcHBlbmQgYSAnVScgc3VmZml4IHRvIDB4ODAwMDAwMDAgdG8g
cHJldmVudCBzaWduZWQgc2hpZnQKb3ZlcmZsb3cuCgpGaXhlczogZjU4N2RlMGUyZmViICgiW05F
VEZJTFRFUl06IG5mX2Nvbm50cmFjay9uZl9uYXQ6IGFkZCBILjMyMyBoZWxwZXIgcG9ydCIpCkNj
OiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6IFN1YmhhbSBQYWwgPHN1Ymhh
bXBhbDc4OUBnbWFpbC5jb20+Ci0tLQogbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfaDMyM19h
c24xLmMgfCA2ICsrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19oMzIzX2Fz
bjEuYyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2gzMjNfYXNuMS5jCmluZGV4IDY4MzBj
OWRhMzUwNy4uNTczMTdhMjgyMTJiIDEwMDY0NAotLS0gYS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50
cmFja19oMzIzX2FzbjEuYworKysgYi9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19oMzIzX2Fz
bjEuYwpAQCAtNTk2LDYgKzU5Niw5IEBAIHN0YXRpYyBpbnQgZGVjb2RlX3NlcShzdHJ1Y3QgYml0
c3RyICpicywgY29uc3Qgc3RydWN0IGZpZWxkX3QgKmYsCiAKIAkvKiBEZWNvZGUgdGhlIGV4dGVu
c2lvbiBjb21wb25lbnRzICovCiAJZm9yIChvcHQgPSAwOyBvcHQgPCBibXAyX2xlbjsgb3B0Kyss
IGkrKywgc29uKyspIHsKKwkJaWYgKCEoKDB4ODAwMDAwMDBVID4+IG9wdCkgJiBibXAyKSkJLyog
Tm90IHByZXNlbnQgKi8KKwkJCWNvbnRpbnVlOworCiAJCS8qIENoZWNrIFJhbmdlICovCiAJCWlm
IChpID49IGYtPnViKSB7CS8qIE5ld2VyIFZlcnNpb24/ICovCiAJCQlpZiAobmZfaDMyM19lcnJv
cl9ib3VuZGFyeShicywgMiwgMCkpCkBAIC02MTMsOSArNjE2LDYgQEAgc3RhdGljIGludCBkZWNv
ZGVfc2VxKHN0cnVjdCBiaXRzdHIgKmJzLCBjb25zdCBzdHJ1Y3QgZmllbGRfdCAqZiwKIAkJCXJl
dHVybiBIMzIzX0VSUk9SX1NUT1A7CiAJCX0KIAotCQlpZiAoISgoMHg4MDAwMDAwMCA+PiBvcHQp
ICYgYm1wMikpCS8qIE5vdCBwcmVzZW50ICovCi0JCQljb250aW51ZTsKLQogCQlpZiAobmZfaDMy
M19lcnJvcl9ib3VuZGFyeShicywgMiwgMCkpCiAJCQlyZXR1cm4gSDMyM19FUlJPUl9CT1VORDsK
IAkJbGVuID0gZ2V0X2xlbihicyk7Ci0tIAoyLjQzLjAKCg==
--000000000000b0c0e0065c1ee0ac--
