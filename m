Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D2B48167F
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 14:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786630271; cv=pass; b=k1N6OjCNK5QAvO3QCTZ99v9oQKUQKI+zGqgvUuRwEr5uiB9Z/9b3EEKjgxcTwWeYkczdGXxKzz0IrzEY2/uw5iYbSc4DSA1STWbpCvAm5Yt1WsLt4IUfMcLgmLyXTUogDdEhrt/njkvlfiBI62bm42u6KUamcRb96mBFNk27Esk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786630271; c=relaxed/simple;
	bh=7U/xRix2aKJEMbGdqw3Mfly21pQ6JJNFgSsks5u0ErQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=YCUFzGdOI3gOGrrqiNKBrsC7gLD758Z3+/wT6WQpN3DuG+3EV6T5llDyFLtLrwL3yeievFAh9x1j1r8EciOrhneJaE2w5g+4hER8oktOXmhqwSc/odGVI2kVSPaqIlqX43lLr3EjP/Naeb2qPdrNrmyxZdYaiiyHaQMv6M3gm+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hNJVwkN6; arc=pass smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hNJVwkN6"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cc73e322dbso9545875ad.1
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 07:11:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786630266; cv=none;
        d=google.com; s=arc-20260327;
        b=FnWzO5Zx3lF7Ypaf946VP+G503/XGlf5OQyC1QDaIkt9ngeCTKysY4HLgJniy/xE9L
         G0ytPoZe105CfnI3zjqsvpjJBqqvgOsGDHz8shq4xY9o9bTOF3koHcxwSXO5G0L2Jciq
         e1l8yyVnXDO13K/v/5ivINhuu/KJN4nesk9T2jexLPWucntpPNBzita5WstWHWKV66PI
         TYM/cFavyqCM3TL9pb63Gg6aAFA7fcYDO61md0u3K79tFAfyiZClhwUxEmrZhvhp/k72
         Z1k27YPuQSBjJ6xggYvP7nukg315AsUDUtR0HZ8bgCT0x4Y8h1UjOSGl6jAyj2BiNmN7
         MJvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=2HA4BiS9+atfAICgj+MRSjdj9ok3zhEwjvrHa3RiJbI=;
        fh=RyrZosgWaWfSBUhpAELpKTJn1ucDXR3lZMdPtm2ozd4=;
        b=bgexFUWvlnukkIWxKY/RjYXbLEYJoFu2QpSHOrMh+161XF9nkq68riSMTwI905mOl4
         VPeLd7VkmM8hS0UtHyo1Nwr9AaFqmzlfIhUgtMms2qyvWIygf5Sn1j+AQ3m1r/WKvFfJ
         Gp4B0b10pd2PqhRhaySACIhFGEtdL6DBdUg2Q8FFYgV/wN/0uR2lJWK6LF7so4umVmeJ
         AQ8670OOa9LqYuB9ELFQUbbwOhTSZhdpFKK0C+9/O0U5C3IDZn1H1s72Q3MU4exHLXMN
         w0yg3yVWwe0pHzNG9mE0rpqgIv1AuaBF8aFsbfXMF1Ohexv77j009v/MID+cly0KPt/K
         NQgg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786630266; x=1787235066; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2HA4BiS9+atfAICgj+MRSjdj9ok3zhEwjvrHa3RiJbI=;
        b=hNJVwkN6Lc3P7DSOG2vHrTZdN7yOy55vgofTgeMzRv8rGe/LZZp/Kiz/IGYvsMrtz2
         3JzMF8FR4Ft/jZ573ivbzOcKGMp93LGne1DdP7flFJjn//CGzblkyjtFb3bkhK5GC88B
         2OpZZlN54b084p2w6oJqiuqWJtGwpBmxXHcINIm96ug8W8nWqRFdwuWmc9PlNb4wmtN0
         +uQk8NfYowINbF/CnOV7Tzl9y/4dJ8Dho3wIlxbqpsURY/UB6tbcJxkjEoaZcJhERN49
         IVKWvrE2YeCNfAqCcgHJs2s8+T11PrBR3BGsJqmZ+P10foZw3e7/ZKI1FpPqXBLqG/X0
         zomQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786630266; x=1787235066;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2HA4BiS9+atfAICgj+MRSjdj9ok3zhEwjvrHa3RiJbI=;
        b=LW1Q9B/X3RPHY1W+SuxkL2lPzSmpVKT+D99aIL7pqtpFqgkAV0jFZ1jvq/VTy8bvWk
         steg2Nwi3o1IsECnLXzxoRMThiY1HXfxytZcXid24MFmEPGsVgH8MgPi7mV71eY+NjK+
         UzO/cIru2PLH6ppz0AhNY9eZK5bhFXaG0NHCPd0whZHxnWoSosgwZavkWLowFHQNAY78
         2AaVSXBSUwuLqKJJSfTFnAwUt+1bTJkDkLRUs77tcRehOLIq1zTkJ0Vg9MtFJqaNQve/
         RRojKNqem+2N7iuP2fQA8SjjALErCy/vrLclXq24Zq8ZnNearZ08n7CciB42S1OigrC7
         RRXg==
X-Gm-Message-State: AOJu0YyynJ0U9qVArr2dN8TD+OPdc6pXUrI070bsbsr0kRlmqmD3JqFg
	39DKynHGPvkNfnsZmoyWE07Nz5ahEeOs+SPK9o8TTm3hDDE8CW7gSg82gcxsJ3DwFbmWPLT/qQE
	g4aNQmATMiUga0OJEFBy8M/M/9oesIGAp4Kak45nmEwcpKi4=
X-Gm-Gg: AR+sD11Rw7p4vzLpvfMke+0UpgZj8CAJPSR0rNJ/IfSaTR3bc6Um2VqOTgH/3llRWqH
	btO1jJ/RQhFisDErR+xocLCIb+JBvfwlgMuyuT2WSUGp+nqfJj4PkYydchdL603xfKH/mjD4VWB
	2LQHkDswaLnxLoi+IycHH7J5obCgOZbluZZI2gLjfQu+1W86RA4gxp9PRrCV4GLV1RkTzsAqY6F
	R/5a+dXHmVHIEOUNG80C8wvFb7BTpXhLBCAMtAssK3nIemexkA82P6QX/k4keX+twGis94Hb+q4
	HP2rCKa8OWic4X7VFNUVtD7KMnppihDVtdjY5THjzWQ9igabfrewF5oV+osZ1K/bBj8HpWzul8B
	SE/13Q7W3ZuQSPwAYKqTop4WOzAaBMsF6QA==
X-Received: by 2002:a17:902:db11:b0:2c9:cf62:6f61 with SMTP id
 d9443c01a7336-2d37e86ae4emr58688695ad.17.1786630265752; Thu, 13 Aug 2026
 07:11:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Joas Antonio <joasantonio108@gmail.com>
Date: Thu, 13 Aug 2026 11:10:54 -0300
X-Gm-Features: AUfX_mx32WLsAgKgA1jFSFbIge2BEu_3fuQCUzwn_SnWOltfCi-WTexC-8AHweE
Message-ID: <CAOCBhwFzYNuxGQtjRNaisQt_aTNgst_u+FX5PCjWT0mcGqbKDQ@mail.gmail.com>
Subject: [PATCH] netfilter: nf_conntrack_h323: fix OOB read in get_bitmap()
To: pablo@netfilter.org, fw@strlen.de
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: multipart/mixed; boundary="00000000000055f1790658ee4604"

--00000000000055f1790658ee4604
Content-Type: text/plain; charset="UTF-8"

Summary: get_bitmap() in net/netfilter/nf_conntrack_h323_asn1.c performs
an out-of-bounds 1-byte read when decoding a PER bitmap whose total bit
position (bs->bit + b) is an exact multiple of 8 in the range 16..24.
The preceding boundary check, nf_h323_error_boundary(), underestimates
the required byte count by one in exactly this case, so the OOB read is
not caught. Reachable remotely through an H.323 RAS message (UDP/1719)
processed by the nf_conntrack_h323 netfilter helper, when that helper
is loaded for a connection. Confirmed with a reproducer and a proposed
fix, both tested.

Affected version: Linux mainline, commit 3d6d817622b0a9721e3cc404df
3469171582be13 (2026-08-12), i.e. current as of this report. Verified
present in that exact commit; no prior fix exists upstream.

File / function: net/netfilter/nf_conntrack_h323_asn1.c, get_bitmap()
(around line 211), called from decode_seq() (around line 587-591).

Impact: out-of-bounds read of 1 byte past the end of the packet buffer
(heap-buffer-overflow / global-buffer-overflow depending on allocator
placement of the skb/linear buffer). Confirmed by AddressSanitizer in a
userspace harness linking the unmodified kernel source file. The read
value is masked out of get_bitmap()'s return value in all cases (see
"Details" below), so there is no information disclosure through this
path; the impact is a potential crash (denial of service) if the byte
read falls on an unmapped page, plus the OOB access itself as a defect
regardless of whether it is currently mapped.

Conditions: requires the nf_conntrack_h323 helper to be loaded and
attached to a UDP/1719 (RAS) flow (not loaded by default on most
distributions, but is the documented attack surface for the related
CVE-2026-23455 / CVE-2026-23456 / CVE-2026-43233, all in the same
parser). No authentication or established call state is required; the
first RAS packet is decoded via DecodeRasMessage() before any session
is validated.

Reproducer: an 8-byte input triggers the bug via DecodeRasMessage()
directly. Tested against the exact kernel source file
(net/netfilter/nf_conntrack_h323_asn1.c) compiled unmodified into a
small userspace harness with -fsanitize=address,fuzzer; also confirmed
independently in a plain non-fuzzer harness. AddressSanitizer reports:

  heap-buffer-overflow, READ of size 1
  #0 get_bitmap    nf_conntrack_h323_asn1.c:232
  #1 decode_seq    nf_conntrack_h323_asn1.c:594
  #2 decode_choice nf_conntrack_h323_asn1.c:816
  #3 decode_seq    nf_conntrack_h323_asn1.c:576
  #4 decode_seq    nf_conntrack_h323_asn1.c:576
  #5 decode_choice nf_conntrack_h323_asn1.c:816
  #6 DecodeRasMessage nf_conntrack_h323_asn1.c:835

The reproducer bytes are not attached to this message; available on
request.

Details: nf_h323_error_boundary(bs, bytes, bits) computes required
bytes as ceil((bits + bs->bit) / 8). get_bitmap(bs, b), with
l = bs->bit + b, reads (l >> 3) bytes in a loop, then for l < 32
unconditionally reads one more byte via *bs->cur to fold in any
leftover bits. When l is an exact multiple of 8, there are no
leftover bits, nf_h323_error_boundary()'s ceil() computes exactly
l >> 3 bytes (no "+1" since the remainder is 0), but get_bitmap()
still performs the extra read. This mismatch is the root cause.
It is also provable that this extra byte never contributes to the
returned value in that case (shift = 24 - l after the loop is always
below the mask window 0xffffffff << (32 - b) kept at the end of
get_bitmap()), so removing it changes no observable behavior for any
valid input -- confirmed by running the proposed fix through 200000
libFuzzer iterations against DecodeRasMessage / DecodeQ931 /
DecodeMultimediaSystemControlMessage with zero new failures and
identical decode outcomes on the existing reproducer corpus.

Proposed fix (tested: reproducer no longer crashes under ASAN;
200000-iteration fuzz regression run clean): only perform the extra
byte read when l has leftover bits (l & 7 != 0):

--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -228,7 +228,8 @@ static unsigned int get_bitmap(struct bitstr *bs,
unsigned int b)
  v |= (unsigned int)(*bs->cur++) << shift;

  if (l < 32) {
- v |= (unsigned int)(*bs->cur) << shift;
+ if (l & 7)
+ v |= (unsigned int)(*bs->cur) << shift;
  v <<= bs->bit;
  } else if (l > 32) {
  v <<= bs->bit;

Fixes: 5e35941d9901 ("[NETFILTER]: Add H.323 conntrack/NAT helper")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>

Related: this parser has had three CVEs in the same file in 2026
(CVE-2026-23455, CVE-2026-23456, CVE-2026-43233); this is an
independent, fourth defect in the same decoder, not yet fixed
upstream.

--00000000000055f1790658ee4604
Content-Type: text/plain; charset="US-ASCII"; name="REPORT_h323_getbitmap_PLAINTEXT.txt"
Content-Disposition: attachment; 
	filename="REPORT_h323_getbitmap_PLAINTEXT.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_msrlfvv01>
X-Attachment-Id: f_msrlfvv01

PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09ClRFTVBPUkFSWSBTRUNUSU9OIC0gUkVNT1ZFIEJFRk9SRSBTRU5ESU5HCihy
ZXF1aXJlZCBieSBEb2N1bWVudGF0aW9uL3Byb2Nlc3Mvc2VjdXJpdHktYnVncy5yc3QgZm9yIEFJ
LWFzc2lzdGVkCnJlcG9ydHMgLSBzZW5kZXIgbXVzdCByZXZpZXcgYW5kIGRlbGV0ZSB0aGlzIHNl
Y3Rpb24pCgpSZWNpcGllbnRzICh2aWEgc2NyaXB0cy9nZXRfbWFpbnRhaW5lci5wbCk6CiAgVG86
ICBQYWJsbyBOZWlyYSBBeXVzbyA8cGFibG9AbmV0ZmlsdGVyLm9yZz4KICAgICAgIEZsb3JpYW4g
V2VzdHBoYWwgPGZ3QHN0cmxlbi5kZT4KICBDYzogIG5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5l
bC5vcmcKICAgICAgIGNvcmV0ZWFtQG5ldGZpbHRlci5vcmcKCkRvIG5vdCBzZW5kIHRvIHNlY3Vy
aXR5QGtlcm5lbC5vcmc6IHRoaXMgYnVnIHdhcyBmb3VuZCB3aXRoIEFJCmFzc2lzdGFuY2UsIGFu
ZCBzZWN1cml0eS1idWdzLnJzdCBtYW5kYXRlcyB0cmVhdGluZyBpdCBhcyBwdWJsaWMKZnJvbSB0
aGUgc3RhcnQgKCJpZiB5b3UgcmVzb3J0ZWQgdG8gQUkgYXNzaXN0YW5jZSB0byBpZGVudGlmeSBh
CmJ1ZywgeW91IG11c3QgdHJlYXQgaXQgYXMgcHVibGljIikuCgpEbyBub3QgaW5jbHVkZSBvc3Mt
c2VjdXJpdHlAbGlzdHMub3BlbndhbGwuY29tIG9uIHRoaXMgZmlyc3QKbWVzc2FnZS4gVGhhdCBs
aXN0IGlzIGZvciBkaXN0cm8gY29vcmRpbmF0aW9uIEFGVEVSIG1haW50YWluZXJzCmFjY2VwdCBh
IGZpeCAoRG9jdW1lbnRhdGlvbi9wcm9jZXNzL3NlY3VyaXR5LWJ1Z3MucnN0LCBzZWN0aW9uCiJD
b29yZGluYXRpb24gd2l0aCBvdGhlciBncm91cHMiKSwgbm90IGZvciB0aGUgaW5pdGlhbCByZXBv
cnQuCgpCZWZvcmUgc2VuZGluZywgY2hlY2sgeW91ciBtYWlsIGNsaWVudCdzIHNldHRpbmdzIChk
byBub3QgbGV0IGl0CnJlZm9ybWF0IGFzIEhUTUwgb3IgbWFuZ2xlIGxpbmUgd3JhcHBpbmcpIC0g
c2VlCkRvY3VtZW50YXRpb24vcHJvY2Vzcy9lbWFpbC1jbGllbnRzLnJzdC4KCkZpeGVzOiB0YWcg
Y29uZmlybWVkIGFnYWluc3QgYSBmdWxsLWhpc3RvcnkgY2xvbmUgb2YKdG9ydmFsZHMvbGludXgg
KGdpdCBibGFtZSAtTCAyMTEsMjQ2IC0tCm5ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2gzMjNf
YXNuMS5jKTogdGhlIGJ1Z2d5IGdldF9iaXRtYXAoKQpsb2dpYyBpcyB1bmNoYW5nZWQgc2luY2Ug
dGhlIGZpbGUncyBvcmlnaW5hbCBjb21taXQsCjVlMzU5NDFkOTkwMTIzZjE1NWIwMmQ1NjYzZTUx
YTI0ZjgxNmI2ZjMsICJbTkVURklMVEVSXTogQWRkIEguMzIzCmNvbm50cmFjay9OQVQgaGVscGVy
IiAoSmluZyBNaW4gWmhhbywgMjAwNi0wMy0yMCkuCgpBdHRhY2hlZCBwYXRjaCBhbHJlYWR5IGZp
bGxlZCBpbjogSm9hcyBBbnRvbmlvIGRvcyBTYW50b3MKPGpvYXNhbnRvbmlvMTA4QGdtYWlsLmNv
bT4sIDEzIEF1ZyAyMDI2LCBGaXhlczogNWUzNTk0MWQ5OTAxLgo9PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KClN1Ympl
Y3Q6IFtQQVRDSF0gbmV0ZmlsdGVyOiBuZl9jb25udHJhY2tfaDMyMzogZml4IE9PQiByZWFkIGlu
IGdldF9iaXRtYXAoKQoKU3VtbWFyeTogZ2V0X2JpdG1hcCgpIGluIG5ldC9uZXRmaWx0ZXIvbmZf
Y29ubnRyYWNrX2gzMjNfYXNuMS5jIHBlcmZvcm1zCmFuIG91dC1vZi1ib3VuZHMgMS1ieXRlIHJl
YWQgd2hlbiBkZWNvZGluZyBhIFBFUiBiaXRtYXAgd2hvc2UgdG90YWwgYml0CnBvc2l0aW9uIChi
cy0+Yml0ICsgYikgaXMgYW4gZXhhY3QgbXVsdGlwbGUgb2YgOCBpbiB0aGUgcmFuZ2UgMTYuLjI0
LgpUaGUgcHJlY2VkaW5nIGJvdW5kYXJ5IGNoZWNrLCBuZl9oMzIzX2Vycm9yX2JvdW5kYXJ5KCks
IHVuZGVyZXN0aW1hdGVzCnRoZSByZXF1aXJlZCBieXRlIGNvdW50IGJ5IG9uZSBpbiBleGFjdGx5
IHRoaXMgY2FzZSwgc28gdGhlIE9PQiByZWFkIGlzCm5vdCBjYXVnaHQuIFJlYWNoYWJsZSByZW1v
dGVseSB0aHJvdWdoIGFuIEguMzIzIFJBUyBtZXNzYWdlIChVRFAvMTcxOSkKcHJvY2Vzc2VkIGJ5
IHRoZSBuZl9jb25udHJhY2tfaDMyMyBuZXRmaWx0ZXIgaGVscGVyLCB3aGVuIHRoYXQgaGVscGVy
CmlzIGxvYWRlZCBmb3IgYSBjb25uZWN0aW9uLiBDb25maXJtZWQgd2l0aCBhIHJlcHJvZHVjZXIg
YW5kIGEgcHJvcG9zZWQKZml4LCBib3RoIHRlc3RlZC4KCkFmZmVjdGVkIHZlcnNpb246IExpbnV4
IG1haW5saW5lLCBjb21taXQgM2Q2ZDgxNzYyMmIwYTk3MjFlM2NjNDA0ZGYKMzQ2OTE3MTU4MmJl
MTMgKDIwMjYtMDgtMTIpLCBpLmUuIGN1cnJlbnQgYXMgb2YgdGhpcyByZXBvcnQuIFZlcmlmaWVk
CnByZXNlbnQgaW4gdGhhdCBleGFjdCBjb21taXQ7IG5vIHByaW9yIGZpeCBleGlzdHMgdXBzdHJl
YW0uCgpGaWxlIC8gZnVuY3Rpb246IG5ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2gzMjNfYXNu
MS5jLCBnZXRfYml0bWFwKCkKKGFyb3VuZCBsaW5lIDIxMSksIGNhbGxlZCBmcm9tIGRlY29kZV9z
ZXEoKSAoYXJvdW5kIGxpbmUgNTg3LTU5MSkuCgpJbXBhY3Q6IG91dC1vZi1ib3VuZHMgcmVhZCBv
ZiAxIGJ5dGUgcGFzdCB0aGUgZW5kIG9mIHRoZSBwYWNrZXQgYnVmZmVyCihoZWFwLWJ1ZmZlci1v
dmVyZmxvdyAvIGdsb2JhbC1idWZmZXItb3ZlcmZsb3cgZGVwZW5kaW5nIG9uIGFsbG9jYXRvcgpw
bGFjZW1lbnQgb2YgdGhlIHNrYi9saW5lYXIgYnVmZmVyKS4gQ29uZmlybWVkIGJ5IEFkZHJlc3NT
YW5pdGl6ZXIgaW4gYQp1c2Vyc3BhY2UgaGFybmVzcyBsaW5raW5nIHRoZSB1bm1vZGlmaWVkIGtl
cm5lbCBzb3VyY2UgZmlsZS4gVGhlIHJlYWQKdmFsdWUgaXMgbWFza2VkIG91dCBvZiBnZXRfYml0
bWFwKCkncyByZXR1cm4gdmFsdWUgaW4gYWxsIGNhc2VzIChzZWUKIkRldGFpbHMiIGJlbG93KSwg
c28gdGhlcmUgaXMgbm8gaW5mb3JtYXRpb24gZGlzY2xvc3VyZSB0aHJvdWdoIHRoaXMKcGF0aDsg
dGhlIGltcGFjdCBpcyBhIHBvdGVudGlhbCBjcmFzaCAoZGVuaWFsIG9mIHNlcnZpY2UpIGlmIHRo
ZSBieXRlCnJlYWQgZmFsbHMgb24gYW4gdW5tYXBwZWQgcGFnZSwgcGx1cyB0aGUgT09CIGFjY2Vz
cyBpdHNlbGYgYXMgYSBkZWZlY3QKcmVnYXJkbGVzcyBvZiB3aGV0aGVyIGl0IGlzIGN1cnJlbnRs
eSBtYXBwZWQuCgpDb25kaXRpb25zOiByZXF1aXJlcyB0aGUgbmZfY29ubnRyYWNrX2gzMjMgaGVs
cGVyIHRvIGJlIGxvYWRlZCBhbmQKYXR0YWNoZWQgdG8gYSBVRFAvMTcxOSAoUkFTKSBmbG93IChu
b3QgbG9hZGVkIGJ5IGRlZmF1bHQgb24gbW9zdApkaXN0cmlidXRpb25zLCBidXQgaXMgdGhlIGRv
Y3VtZW50ZWQgYXR0YWNrIHN1cmZhY2UgZm9yIHRoZSByZWxhdGVkCkNWRS0yMDI2LTIzNDU1IC8g
Q1ZFLTIwMjYtMjM0NTYgLyBDVkUtMjAyNi00MzIzMywgYWxsIGluIHRoZSBzYW1lCnBhcnNlciku
IE5vIGF1dGhlbnRpY2F0aW9uIG9yIGVzdGFibGlzaGVkIGNhbGwgc3RhdGUgaXMgcmVxdWlyZWQ7
IHRoZQpmaXJzdCBSQVMgcGFja2V0IGlzIGRlY29kZWQgdmlhIERlY29kZVJhc01lc3NhZ2UoKSBi
ZWZvcmUgYW55IHNlc3Npb24KaXMgdmFsaWRhdGVkLgoKUmVwcm9kdWNlcjogYW4gOC1ieXRlIGlu
cHV0IHRyaWdnZXJzIHRoZSBidWcgdmlhIERlY29kZVJhc01lc3NhZ2UoKQpkaXJlY3RseSAoYnl0
ZXM6IDViIDViIDA1IDA1IDM5IDAwIDEwIDA0KS4gVGVzdGVkIGFnYWluc3QgdGhlIGV4YWN0Cmtl
cm5lbCBzb3VyY2UgZmlsZSAobmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfaDMyM19hc24xLmMp
IGNvbXBpbGVkCnVubW9kaWZpZWQgaW50byBhIHNtYWxsIHVzZXJzcGFjZSBoYXJuZXNzIHdpdGgK
LWZzYW5pdGl6ZT1hZGRyZXNzLGZ1enplcjsgYWxzbyBjb25maXJtZWQgaW5kZXBlbmRlbnRseSBp
biBhIHBsYWluCm5vbi1mdXp6ZXIgaGFybmVzcy4gQWRkcmVzc1Nhbml0aXplciByZXBvcnRzOgoK
ICBoZWFwLWJ1ZmZlci1vdmVyZmxvdywgUkVBRCBvZiBzaXplIDEKICAjMCBnZXRfYml0bWFwICAg
IG5mX2Nvbm50cmFja19oMzIzX2FzbjEuYzoyMzIKICAjMSBkZWNvZGVfc2VxICAgIG5mX2Nvbm50
cmFja19oMzIzX2FzbjEuYzo1OTQKICAjMiBkZWNvZGVfY2hvaWNlIG5mX2Nvbm50cmFja19oMzIz
X2FzbjEuYzo4MTYKICAjMyBkZWNvZGVfc2VxICAgIG5mX2Nvbm50cmFja19oMzIzX2FzbjEuYzo1
NzYKICAjNCBkZWNvZGVfc2VxICAgIG5mX2Nvbm50cmFja19oMzIzX2FzbjEuYzo1NzYKICAjNSBk
ZWNvZGVfY2hvaWNlIG5mX2Nvbm50cmFja19oMzIzX2FzbjEuYzo4MTYKICAjNiBEZWNvZGVSYXNN
ZXNzYWdlIG5mX2Nvbm50cmFja19oMzIzX2FzbjEuYzo4MzUKClRoZSByZXByb2R1Y2VyIGJ5dGVz
IGFyZSBub3QgYXR0YWNoZWQgdG8gdGhpcyBtZXNzYWdlOyBhdmFpbGFibGUgb24KcmVxdWVzdCAo
a2VybmVsIEFJLWFzc2lzdGVkLXJlcG9ydCBwb2xpY3kpLgoKRGV0YWlsczogbmZfaDMyM19lcnJv
cl9ib3VuZGFyeShicywgYnl0ZXMsIGJpdHMpIGNvbXB1dGVzIHJlcXVpcmVkCmJ5dGVzIGFzIGNl
aWwoKGJpdHMgKyBicy0+Yml0KSAvIDgpLiBnZXRfYml0bWFwKGJzLCBiKSwgd2l0aApsID0gYnMt
PmJpdCArIGIsIHJlYWRzIChsID4+IDMpIGJ5dGVzIGluIGEgbG9vcCwgdGhlbiBmb3IgbCA8IDMy
CnVuY29uZGl0aW9uYWxseSByZWFkcyBvbmUgbW9yZSBieXRlIHZpYSAqYnMtPmN1ciB0byBmb2xk
IGluIGFueQpsZWZ0b3ZlciBiaXRzLiBXaGVuIGwgaXMgYW4gZXhhY3QgbXVsdGlwbGUgb2YgOCwg
dGhlcmUgYXJlIG5vCmxlZnRvdmVyIGJpdHMsIG5mX2gzMjNfZXJyb3JfYm91bmRhcnkoKSdzIGNl
aWwoKSBjb21wdXRlcyBleGFjdGx5CmwgPj4gMyBieXRlcyAobm8gIisxIiBzaW5jZSB0aGUgcmVt
YWluZGVyIGlzIDApLCBidXQgZ2V0X2JpdG1hcCgpCnN0aWxsIHBlcmZvcm1zIHRoZSBleHRyYSBy
ZWFkLiBUaGlzIG1pc21hdGNoIGlzIHRoZSByb290IGNhdXNlLgpJdCBpcyBhbHNvIHByb3ZhYmxl
IHRoYXQgdGhpcyBleHRyYSBieXRlIG5ldmVyIGNvbnRyaWJ1dGVzIHRvIHRoZQpyZXR1cm5lZCB2
YWx1ZSBpbiB0aGF0IGNhc2UgKHNoaWZ0ID0gMjQgLSBsIGFmdGVyIHRoZSBsb29wIGlzIGFsd2F5
cwpiZWxvdyB0aGUgbWFzayB3aW5kb3cgMHhmZmZmZmZmZiA8PCAoMzIgLSBiKSBrZXB0IGF0IHRo
ZSBlbmQgb2YKZ2V0X2JpdG1hcCgpKSwgc28gcmVtb3ZpbmcgaXQgY2hhbmdlcyBubyBvYnNlcnZh
YmxlIGJlaGF2aW9yIGZvciBhbnkKdmFsaWQgaW5wdXQgLS0gY29uZmlybWVkIGJ5IHJ1bm5pbmcg
dGhlIHByb3Bvc2VkIGZpeCB0aHJvdWdoIDIwMDAwMApsaWJGdXp6ZXIgaXRlcmF0aW9ucyBhZ2Fp
bnN0IERlY29kZVJhc01lc3NhZ2UgLyBEZWNvZGVROTMxIC8KRGVjb2RlTXVsdGltZWRpYVN5c3Rl
bUNvbnRyb2xNZXNzYWdlIHdpdGggemVybyBuZXcgZmFpbHVyZXMgYW5kCmlkZW50aWNhbCBkZWNv
ZGUgb3V0Y29tZXMgb24gdGhlIGV4aXN0aW5nIHJlcHJvZHVjZXIgY29ycHVzLgoKUHJvcG9zZWQg
Zml4ICh0ZXN0ZWQ6IHJlcHJvZHVjZXIgbm8gbG9uZ2VyIGNyYXNoZXMgdW5kZXIgQVNBTjsKMjAw
MDAwLWl0ZXJhdGlvbiBmdXp6IHJlZ3Jlc3Npb24gcnVuIGNsZWFuKTogb25seSBwZXJmb3JtIHRo
ZSBleHRyYQpieXRlIHJlYWQgd2hlbiBsIGhhcyBsZWZ0b3ZlciBiaXRzIChsICYgNyAhPSAwKToK
Ci0tLSBhL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2gzMjNfYXNuMS5jCisrKyBiL25ldC9u
ZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2gzMjNfYXNuMS5jCkBAIC0yMjgsNyArMjI4LDggQEAgc3Rh
dGljIHVuc2lnbmVkIGludCBnZXRfYml0bWFwKHN0cnVjdCBiaXRzdHIgKmJzLCB1bnNpZ25lZCBp
bnQgYikKIAkJCQl2IHw9ICh1bnNpZ25lZCBpbnQpKCpicy0+Y3VyKyspIDw8IHNoaWZ0OwoKIAkJ
aWYgKGwgPCAzMikgewotCQkJdiB8PSAodW5zaWduZWQgaW50KSgqYnMtPmN1cikgPDwgc2hpZnQ7
CisJCQlpZiAobCAmIDcpCisJCQkJdiB8PSAodW5zaWduZWQgaW50KSgqYnMtPmN1cikgPDwgc2hp
ZnQ7CiAJCQl2IDw8PSBicy0+Yml0OwogCQl9IGVsc2UgaWYgKGwgPiAzMikgewogCQkJdiA8PD0g
YnMtPmJpdDsKCkZ1bGwgcGF0Y2ggaW4gZ2l0IGZvcm1hdC1wYXRjaCBmb3JtIGF0dGFjaGVkIHNl
cGFyYXRlbHkKKDAwMDEtbmV0ZmlsdGVyLW5mX2Nvbm50cmFja19oMzIzLWZpeC1vb2ItcmVhZC1p
bi1nZXRfYml0LnBhdGNoKS4KCkZpeGVzOiA1ZTM1OTQxZDk5MDEgKCJbTkVURklMVEVSXTogQWRk
IEguMzIzIGNvbm50cmFjay9OQVQgaGVscGVyIikKClJlbGF0ZWQ6IHRoaXMgcGFyc2VyIGhhcyBo
YWQgdGhyZWUgQ1ZFcyBpbiB0aGUgc2FtZSBmaWxlIGluIDIwMjYKKENWRS0yMDI2LTIzNDU1LCBD
VkUtMjAyNi0yMzQ1NiwgQ1ZFLTIwMjYtNDMyMzMpOyB0aGlzIGlzIGFuCmluZGVwZW5kZW50LCBm
b3VydGggZGVmZWN0IGluIHRoZSBzYW1lIGRlY29kZXIsIG5vdCB5ZXQgZml4ZWQKdXBzdHJlYW0u
Cg==
--00000000000055f1790658ee4604
Content-Type: application/octet-stream; 
	name="0001-netfilter-nf_conntrack_h323-fix-oob-read-in-get_bit.patch"
Content-Disposition: attachment; 
	filename="0001-netfilter-nf_conntrack_h323-fix-oob-read-in-get_bit.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_msrlflhy0>
X-Attachment-Id: f_msrlflhy0

RnJvbTogSm9hcyBBbnRvbmlvIGRvcyBTYW50b3MgPGpvYXNhbnRvbmlvMTA4QGdtYWlsLmNvbT4K
RGF0ZTogVGh1LCAxMyBBdWcgMjAyNiAwMDowMDowMCArMDAwMApTdWJqZWN0OiBbUEFUQ0hdIG5l
dGZpbHRlcjogbmZfY29ubnRyYWNrX2gzMjM6IGZpeCBPT0IgcmVhZCBpbiBnZXRfYml0bWFwKCkK
CmdldF9iaXRtYXAoKSBkZWNvZGVzIGIgPD0gMzIgUEVSIGJpdHMgc3RhcnRpbmcgYXQgYnMtPmN1
ci9icy0+Yml0LgpMZXQgbCA9IGJzLT5iaXQgKyBiLiBGb3IgOCA8IGwgPCAzMiBpdCByZWFkcyAo
bCA+PiAzKSBmdWxsIGJ5dGVzIGluCnRoZSBsb29wLCB0aGVuIHVuY29uZGl0aW9uYWxseSBwZWVr
cyBvbmUgbW9yZSBieXRlOgoKCWZvciAoYnl0ZXMgPSBsID4+IDMsIHNoaWZ0ID0gMjQsIHYgPSAw
OyBieXRlczsKCSAgICAgYnl0ZXMtLSwgc2hpZnQgLT0gOCkKCQl2IHw9ICh1bnNpZ25lZCBpbnQp
KCpicy0+Y3VyKyspIDw8IHNoaWZ0OwoKCWlmIChsIDwgMzIpIHsKCQl2IHw9ICh1bnNpZ25lZCBp
bnQpKCpicy0+Y3VyKSA8PCBzaGlmdDsgICAvKiB1bmNvbmRpdGlvbmFsIHBlZWsgKi8KCQl2IDw8
PSBicy0+Yml0OwoJfQoKV2hlbiBsIGlzIGFuIGV4YWN0IG11bHRpcGxlIG9mIDggKGwgPT0gMTYg
b3IgbCA9PSAyNCksIHRoZSBsb29wCmFscmVhZHkgY29uc3VtZWQgZXZlcnkgYml0IHRoYXQgd2Fz
IHJlcXVlc3RlZDogdGhlcmUgYXJlIG5vIGxlZnRvdmVyCmJpdHMgaW4gYSBuZXh0IGJ5dGUsIGFu
ZCBicy0+Yml0IGlzIHNldCB0byBsICYgMHg3ID09IDAgcmlnaHQgYWZ0ZXIuClRoZSBwZWVrIGF0
ICpicy0+Y3VyIGluIHRoYXQgY2FzZSByZWFkcyBvbmUgYnl0ZSBwYXN0IHdoYXQgdGhlCmJpdHN0
cmVhbSBhY3R1YWxseSBjb250YWlucyBmb3IgdGhpcyBmaWVsZC4KClRoYXQgZXh0cmEgYnl0ZSBp
cyBhbHNvIHByb3ZhYmx5IG5ldmVyIG9ic2VydmVkIGJ5IGFueSBjYWxsZXI6IHdpdGgKbCBhIG11
bHRpcGxlIG9mIDgsIHNoaWZ0IGFmdGVyIHRoZSBsb29wIGVxdWFscyAyNCAtIGwsIHdoaWNoIGlz
CmFsd2F5cyA8PSAzMiAtIGIgLSAxIChzaW5jZSBsID49IGIpLCBpLmUuIHN0cmljdGx5IGJlbG93
IHRoZSBtYXNrCndpbmRvdyBrZXB0IGJ5IHRoZSBmaW5hbDoKCgl2ICY9IDB4ZmZmZmZmZmYgPDwg
KDMyIC0gYik7CgpzbyB0aGUgcGVla2VkIGJ5dGUncyBiaXRzIGFyZSBhbHdheXMgbWFza2VkIG91
dCBvZiB0aGUgcmV0dXJuZWQKdmFsdWUuIFRoZSByZWFkIGlzIGEgcHVyZSBvdXQtb2YtYm91bmRz
IGFjY2VzcyB3aXRoIG5vIGVmZmVjdCBvbgpnZXRfYml0bWFwKCkncyByZXN1bHQgZm9yIGFueSB2
YWxpZCBpbnB1dDsgcmVtb3ZpbmcgaXQgY2hhbmdlcyBubwpvYnNlcnZhYmxlIGJlaGF2aW9yLgoK
VGhlIGJ1ZyBpcyByZWFjaGFibGUgZnJvbSBkZWNvZGVfc2VxKCkgd2hlbiBkZWNvZGluZyBhIFNF
UVVFTkNFCmV4dGVuc2lvbiBiaXRtYXA6CgoJaWYgKG5mX2gzMjNfZXJyb3JfYm91bmRhcnkoYnMs
IDAsIDcpKQoJCXJldHVybiBIMzIzX0VSUk9SX0JPVU5EOwoJYm1wMl9sZW4gPSBnZXRfYml0cyhi
cywgNykgKyAxOyAgICAgICAgICAgICAvKiBhdHRhY2tlciBjb250cm9sbGVkLCAxLi4xMjggKi8K
CWlmIChuZl9oMzIzX2Vycm9yX2JvdW5kYXJ5KGJzLCAwLCBibXAyX2xlbikpCgkJcmV0dXJuIEgz
MjNfRVJST1JfQk9VTkQ7CglpZiAoYm1wMl9sZW4gPiAzMikKCQlyZXR1cm4gSDMyM19FUlJPUl9S
QU5HRTsKCWJtcDIgPSBnZXRfYml0bWFwKGJzLCBibXAyX2xlbik7CgpuZl9oMzIzX2Vycm9yX2Jv
dW5kYXJ5KCkgY29tcHV0ZXMgdGhlIHJlcXVpcmVkIGJ5dGUgY291bnQgYXMKY2VpbCgoYml0cyAr
IGJzLT5iaXQpIC8gOCksIGkuZS4gZXhhY3RseSBsID4+IDMgYnl0ZXMgd2hlbiBsIGlzIGEKbXVs
dGlwbGUgb2YgOCAtLSBpdCBkb2VzIG5vdCBrbm93IGFib3V0IGdldF9iaXRtYXAoKSdzIGV4dHJh
IHBlZWssCnNvIHRoZSBib3VuZGFyeSBjaGVjayB1bmRlcmVzdGltYXRlcyBieSBvbmUgYnl0ZSBh
bmQgdGhlIE9PQiByZWFkCmlzIG5vdCBjYXVnaHQuCgpSZWFjaGFibGUgcmVtb3RlbHkgdmlhIFJh
c01lc3NhZ2UgKFJBUy9VRFAgMTcxOSksIGRlY29kZWQgdGhyb3VnaApEZWNvZGVSYXNNZXNzYWdl
KCkgLT4gZGVjb2RlX2Nob2ljZSgpIC0+IGRlY29kZV9zZXEoKSAobmVzdGVkKSAtPgpkZWNvZGVf
Y2hvaWNlKCkgLT4gZGVjb2RlX3NlcSgpIC0+IGdldF9iaXRtYXAoKSwgd2hlbmV2ZXIgYW4KZXh0
ZW5zaW9uIGJpdG1hcCBsZW5ndGggcGxhY2VzIGwgPSBicy0+Yml0ICsgYm1wMl9sZW4gYXQgMTYg
b3IgMjQuCkNvbmZpcm1lZCB3aXRoIGEgdXNlcnNwYWNlIGhhcm5lc3MgbGlua2luZyB0aGlzIGZp
bGUgdW5tb2RpZmllZAooQVNBTiwgOC1ieXRlIGlucHV0LCBSQVMgbWVzc2FnZSBwYXRoKTsgc2Vl
IHJlcG9ydCBmb3IgZGV0YWlscy4KCkZpeDogb25seSBwZXJmb3JtIHRoZSBwZWVrIHdoZW4gdGhl
cmUgYXJlIGFjdHVhbGx5IGxlZnRvdmVyIGJpdHMgaW4KdGhlIG5leHQgYnl0ZSAobCAmIDcgIT0g
MCkuIEZvciBsIGEgbXVsdGlwbGUgb2YgOCwgYnMtPmN1ciBhbHJlYWR5CnBvaW50cyBhdCB0aGUg
Y29ycmVjdCBuZXh0IHVucmVhZCBieXRlIGFuZCBicy0+Yml0IGlzIGNvcnJlY3RseSAwOwpubyBy
ZWFkIG9mIHRoYXQgYnl0ZSBpcyBuZWVkZWQgb3Igc2FmZSB0byBwZXJmb3JtIGhlcmUuCgpGaXhl
czogNWUzNTk0MWQ5OTAxICgiW05FVEZJTFRFUl06IEFkZCBILjMyMyBjb25udHJhY2svTkFUIGhl
bHBlciIpClNpZ25lZC1vZmYtYnk6IEpvYXMgQW50b25pbyBkb3MgU2FudG9zIDxqb2FzYW50b25p
bzEwOEBnbWFpbC5jb20+Ci0tLQogbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfaDMyM19hc24x
LmMgfCAzICsrLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQoKZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2gzMjNfYXNuMS5jIGIv
bmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfaDMyM19hc24xLmMKaW5kZXggM2Q2ZDgxNy4uMDAw
MDAwMCAxMDA2NDQKLS0tIGEvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfaDMyM19hc24xLmMK
KysrIGIvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfaDMyM19hc24xLmMKQEAgLTIyOCw3ICsy
MjgsOCBAQCBzdGF0aWMgdW5zaWduZWQgaW50IGdldF9iaXRtYXAoc3RydWN0IGJpdHN0ciAqYnMs
IHVuc2lnbmVkIGludCBiKQogCQkJCXYgfD0gKHVuc2lnbmVkIGludCkoKmJzLT5jdXIrKykgPDwg
c2hpZnQ7CgogCQlpZiAobCA8IDMyKSB7Ci0JCQl2IHw9ICh1bnNpZ25lZCBpbnQpKCpicy0+Y3Vy
KSA8PCBzaGlmdDsKKwkJCWlmIChsICYgNykKKwkJCQl2IHw9ICh1bnNpZ25lZCBpbnQpKCpicy0+
Y3VyKSA8PCBzaGlmdDsKIAkJCXYgPDw9IGJzLT5iaXQ7CiAJCX0gZWxzZSBpZiAobCA+IDMyKSB7
CiAJCQl2IDw8PSBicy0+Yml0OwotLQpbVkVSU0FPLUdJVF0K
--00000000000055f1790658ee4604--
