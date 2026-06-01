Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FE24AEEF
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jun 2026 23:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780355141; cv=pass; b=a7RORm2PQ1uxEOEGmaGhIdRW5yi8e1lCpmy8q4kksTubUL7pIm+vI7sVhi7py5NGAF0hNRF83dnHNj74vqLcTQPTXgEMCcFyT4lr+yc2Vq5xs0l1fhwhlJoe8CNneiavHRknJR0PYWY+Dr2Igap8uHxmWpjSuMvnJ/DrHT7h8cQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780355141; c=relaxed/simple;
	bh=D28SndTkkp5FoD9OkrwXtXZNdqkbzj54gMjDYu1H6dQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=bGcGASJ0GR0Y8Oo7yQN14LimbRO5G1vaH15ofyj3aWvTDEWzyyJ2m/zOjLMXtHxVx2ntIen+wl+3BxnXTNFoo9FQHkt5Rgac4617Ux62FSf9hxKrjMoQ5MUrw9qY/L7mIMv7P/NoLSZcldDgSkOkQAhdHN8n5LnJZ7XPZMUY6RU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N49Y2qz7; arc=pass smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N49Y2qz7"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-135e7f4a295so8025752c88.0
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Jun 2026 16:05:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780355139; cv=none;
        d=google.com; s=arc-20240605;
        b=hY+4a9pmgsy7WO2lngUDmh+dAqTpyujt730p8lmYohx32HW9BUWxa5NsW9gGdtjXV1
         HLX33uJLMFUxdnA9VqURDD8ezgUATCoYuiDtrWAjgrx7yycu40oXdatxLlk075kiI046
         CMaepg2xDO6lIx35+Uz1kLH/F0RGw2G/Dz5naPPjH3Lh6GirqmRM9UhniWNrf1Pp5scY
         qHwJZK4gwkY2MReNgn8cntvaASRfOuAIEpeKvYSF6vjBo8PmKpqvsfNDTLXl3RN17ZN8
         PyrHgpDaGcSxBsHl6tTbLqWdVzc4hX3TmdSwl8HNrq0nAwzEt/YwSdxfMA/dRzIQ8zIs
         oKPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=1xBD9YKaSuvrfzuN/o6gFUbo7P/UjPjaEfzktJORN8A=;
        fh=OaCgAXIxADXywgoI2Nl14xF8ACcBIMURvVghuq8Nnio=;
        b=PTraJO/uIK0CgtyC4LbPVKCLYO5j96WfqeSvn1IkqVcuH6NxXebi+C2FDLikpqEOCE
         Wh7SCLm6o4Cf9TAYYsUhO6aQgNqFFgDcjbUQ66KQbJ0UlAcr72/IfkNdL9KZH5GrlZ+y
         PsJYfHeY36lhFqpy1/hCBgcQVWZ7YoWhOCQew+yR7tNIJnnqIkJH+IBPehePSjyDsrO0
         RnikwXHkuV4NQx55hyyIx8ItlNmCBe1YMp4AEza5b3qN2wCOyXwZPIL0WtU0TT5jQMHG
         q/VEt8RKxPPBzDZpin/bbcu444ildqpPrx46aL+1+XfewhWEty4m4PUwW97sfYslRNiG
         aTQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780355139; x=1780959939; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1xBD9YKaSuvrfzuN/o6gFUbo7P/UjPjaEfzktJORN8A=;
        b=N49Y2qz7l1CovY/R5OXrvwvS9aEWQUFnXQezxumsVvfnqp+Wmi9TGWBTSbmYQI1mzB
         YGOWHsfViBhLRADO63bmlvBOGC9l8KZmRQRTq1Ov2+GJgpPHMV8KCoH/mQf5D99FyOoS
         XQM3uhaK8rL8BCE4fPLaG8dWrq2uH1m1QgtoAnQe2BaufQpcoini4vKlwZp9BpxlVxWb
         oE9UNLTRpLyJ/k5AO5Cw3KnPzG9LmfdFARqLPlfmOfdn35Z6GSyqycS7cgzreGWqd+WY
         KF89YxjhNm6yMXk8dGt9VIoBoiTS+PGcheQztTFU/KbF3+pHjGHb0OKZaAf5NKPLQHkD
         MUEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780355139; x=1780959939;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1xBD9YKaSuvrfzuN/o6gFUbo7P/UjPjaEfzktJORN8A=;
        b=JeoZMhyorpKqCJeVTgS9FJIq7jSyQ8Vnuvy07e5enKXaAzfIe8n2NVh9C7kvR0dsID
         As+FBjUccYW5yydhTDsy2vdaI8PEtW0/JpA60ihg/YORRdV9hgGf1Y5spUEdN3hlcNZz
         nGwbesBwn+2OKLVHfwIsaF0aL7qch4+FzdAfYsPAKxyt0SsVrvIdtcu7Ghkm0hoezNns
         0/5aQvWoXN0nJ2DoHgp9BPLb856f3q7BET0pb+3HRJxUYkKFqg5NgOQs46lqIxqegz9B
         n30uyulNXVVoanIJ4xLSEuoftE3vu6u8TVOngW6du5O9y5ATSqmdvdyvfugPIBvbZaWR
         Otgg==
X-Gm-Message-State: AOJu0YyC8fZ+42Y7iVAmG7ohQnhS33ybYE0+OW2UN/XztPH8mC+wwWNW
	xLgSl8pDzPpcmm+MPTOhtgUYLIlICgeP21ddaot1GWab0F9ZtEvzEzDmEmwh3PddK4B5h+kIAxr
	TVVyOl7pL1v1N+rvH9Dz0Dn2v9mP5nVvDc8XgEiaZzBh6
X-Gm-Gg: Acq92OHrzOCC49sE9TY2IAP9cmYToxlLA8T68gAcWp1jKXms8IT/Un82TgRKfGjcHyh
	u3fwzkTGdgd6rPejZ2gA+kVmTHBmP2oFRk0uRpwLUqzVYEWGx9cKNTmMhw1UgtiV1u8ytCqpC3W
	vygvpnHVAwtsdiPLfbLIIVoYKrtgZ24Nq/MoCBieQzOoqssuvmcgqgVSftPgWLA/2xvulblgltL
	o2OlpCS+ORyqW+VL0XD+ICeD48G84rxPksGpOHp/7EpFQszGxSNa3e+tt6QLB7BRCpNZyBemy3s
	hdP/LyypCTqV9YRPqg==
X-Received: by 2002:a05:7022:ba4:b0:12d:c9b6:bbe2 with SMTP id
 a92af1059eb24-137ee08a911mr613672c88.2.1780355138908; Mon, 01 Jun 2026
 16:05:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: boz baba <bababoz943@gmail.com>
Date: Tue, 2 Jun 2026 02:05:27 +0300
X-Gm-Features: AVHnY4I667Ph4FWRmSF-C6WL7pfjkijR40tD6EbTyBjpoyNzSr8Jfp1ppg5IeZc
Message-ID: <CAAB7JCLAzOAZ0CA5CMSkmzwCLY2+DgHSEZe15omAW2-WBTPhbQ@mail.gmail.com>
Subject: [BUG] netfilter: nft_set_pipapo_avx2: rp not reset on goto next_match
 retry after expired/inactive last-field element
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

While auditing the pipapo set lookup in v6.1.133 (the bug is also present
on current mainline as of this writing) I noticed a logic error in the
AVX2 fast path that does not exist in the scalar implementation. The
short version: nft_pipapo_avx2_lookup() retries the entire multi-field
lookup when the matched element in the last field is expired or inactive
in the current genmask, but it does not restore the packet-data pointer
`rp` before the retry. On the second pass, every field's AVX2 helper
reads packet bytes from offsets past the end of the caller-provided key
buffer.

The equivalent scalar code (nft_pipapo_lookup() and pipapo_get()) is not
affected because its `next_match:` label sits inside the field loop and
the retry only re-enters pipapo_refill() on the already-computed last
field bitmap; the key/packet pointer is not consumed on that edge.

Affected file / function
------------------------

  net/netfilter/nft_set_pipapo_avx2.c :: nft_pipapo_avx2_lookup()

Relevant excerpt (line numbers from v6.1.133):

  1137 :  const u8 *rp =3D (const u8 *)key;
  ...
  1175 :  nft_pipapo_avx2_prepare();
  1176 :
  1177 :  next_match:
  1178 :  nft_pipapo_for_each_field(f, i, m) {
  1179 :      bool last =3D i =3D=3D m->field_count - 1, first =3D !i;
  ...
  1188 :      NFT_SET_PIPAPO_AVX2_LOOKUP(8, 1);     /* consumes rp */
  ...
  1223 :      if (ret < 0)
  1224 :          goto out;
  1225 :
  1226 :      if (last) {
  1227 :          *ext =3D &f->mt[ret].e->ext;
  1228 :          if (unlikely(nft_set_elem_expired(*ext) ||
  1229 :                       !nft_set_elem_active(*ext, genmask))) {
  1230 :              ret =3D 0;
  1231 :              goto next_match;            /* <-- restarts loop */
  1232 :          }
  1233 :          goto out;
  1234 :      }
  1235 :
  1236 :      swap(res, fill);
  1237 :      rp +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
  1238 :  }

Trace of `rp` at the moment `goto next_match` is taken
------------------------------------------------------

  initial:                rp =3D key
  end of field 0:         rp =3D key + padded_size(f0)
  end of field 1:         rp =3D key + padded_size(f0) + padded_size(f1)
  ...
  entering last field:    rp =3D key + =CE=A3_{j<N-1} padded_size(fj)

Field N-1 (the last field) does not execute the `rp +=3D ...` at line 1237
because the `if (last)` branch returns or goto's before reaching it. So
when the expired/inactive check fires and we jump back to `next_match:`,
`rp` is exactly where it was on entry to the last field =E2=80=94 i.e. alre=
ady
advanced past every preceding field.

The retry re-enters the loop with i =3D 0 (first =3D true). The very first
AVX2 helper invocation reads pkt[0..] via `rp`, but `rp` now points to
where field 1 (or further) should have been read. Each subsequent field
in the retry pass reads further past the end of the caller-provided key
buffer.

What is and isn't reset on the retry edge
-----------------------------------------

  ret  =3D 0         (explicit, line 1230)
  res  =3D unchanged
  fill =3D unchanged
  rp   =3D NOT RESET   <-- the bug

Why the scalar path is fine
---------------------------

In net/netfilter/nft_set_pipapo.c, both nft_pipapo_lookup() (lines
459=E2=80=93473) and pipapo_get() (lines 566=E2=80=93577) place `next_match=
:` inside
the per-field loop, immediately before pipapo_refill(). The retry just
re-runs pipapo_refill() on the same last-field bitmap to pick the next
candidate set bit. The packet/key pointer is not consumed on that edge,
so the lack of a reset is harmless there.

Impact
------

A successful trigger requires:

  * A pipapo set with two or more fields (more fields =3D larger forward
    shift on the retry pass).
  * The AVX2 lookup path to be taken (irq_fpu_usable() =3D=3D true at
    classification time; the common case on x86_64 servicing softirq).
  * An element whose key matches the lookup key but is either expired
    or not active in nft_genmask_cur(net) (e.g. mid-transaction).

On the retry pass, the AVX2 helpers index into the lookup tables using
bytes from memory adjacent to the caller's on-stack key buffer rather
than the key itself. Concretely, for a typical 4-field IPv6 5-tuple set
with padded field sizes of 16/16/2/2 bytes, `rp` is shifted forward by
36 bytes on the retry =E2=80=94 i.e. wholly past a 36-byte key =E2=80=94 so=
 subsequent
matching decisions are driven by adjacent stack contents.

I have not built a working PoC; reporting the structural defect because
it is clearly a logic error and the comparison to the scalar path is
unambiguous.

Suggested fix
-------------

Two reasonable options:

  (a) Snapshot `rp` before the loop and restore it on the retry edge:

      const u8 *rp_orig =3D (const u8 *)key;
      const u8 *rp =3D rp_orig;
      ...
   next_match:
      rp =3D rp_orig;
      ret =3D 0;
      nft_pipapo_for_each_field(f, i, m) { ... }

      Minimal change, preserves the current control-flow shape.

  (b) Mirror the scalar implementation: do the expired/inactive check
      via a refill-driven inner loop on the last field's bitmap, rather
      than re-walking the full multi-field chain. This matches the
      scalar semantics exactly and avoids the redundant work of redoing
      AVX2 lookups for fields 0..N-2 whose result has not changed.

(b) is cleaner from a semantics-parity standpoint; (a) is a minimal
backport-friendly fix.

Reproduction / verification
---------------------------

The defect is visible by inspection. A runtime check that would surface
it: add a WARN_ON_ONCE in nft_pipapo_avx2_lookup() that compares `rp`
against `(const u8 *)key` immediately after `next_match:` and asserts
they are equal on the first pass but diverge on a retry pass.

Tested against
--------------

  * Linux v6.1.133 source (net/netfilter/nft_set_pipapo_avx2.c)
  * Cross-checked against the scalar lookup and pipapo_get() in
    net/netfilter/nft_set_pipapo.c

Please let me know if a patch in either form would be welcome, and
which tree to base it on. Happy to send one.

Thanks,
boz
