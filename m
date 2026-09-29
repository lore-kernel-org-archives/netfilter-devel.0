Received: from cvsmtppost21.nm.naver.com (cvsmtppost21.nm.naver.com [114.111.35.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03213C2BB0
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 05:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790661266; cv=none; b=Co7VmHKccOrBzrFEaQDVhcUEC3rGICFUYyUJOxJ2FZpwEYOLXVUCPt6tCxvW5e1dpJyB6SJk0XBzqbu4lZWOs5Igw1HVZ2faIk8B6EnqAmgcEpWCPUIFiwXcFLFFHLQ04NAbx089SMYWcEUWFxD5dVyYXHIs7x/xoLw32uY4b2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790661266; c=relaxed/simple;
	bh=TqYzMH4jqMACGLgiHmUygTe4obUenlodMGbclslhzR4=;
	h=MIME-Version:Message-ID:Date:From:To:Cc:Subject:Content-Type; b=OUQLNlpE2nmM7xa21yuTUUnsjCCHpJUpXemDwnhYF0/3dYysaiCvpzPM+Mg009vqBmLIMb0YoKzgh1rmMUiOTFeIJfnD4zmbz3qr29JDry7yyTECiPcgx1KWXs8WVOqH2yw0/gyc+fq/yWFAXdjBWZNb7WMjy5jnmnUrfKBpK9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=nketIrpv; arc=none smtp.client-ip=114.111.35.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="nketIrpv"
X-Works-Smtp-Source: lXYZFoglFqJCpNmXFAMXWHF0
Received: from cvsendbo036.nm ([10.112.24.44])
  by cvsmtppost21.nm.naver.com with ESMTP id OPss2cBQQH++PnHKgDINDQ
  for <multiple recipients>;
  Tue, 29 Sep 2026 05:34:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1790660047; bh=TqYzMH4jqMACGLgiHmUygTe4obUenlodMGbclslhzR4=;
	h=Message-ID:Date:From:To:Subject:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=nketIrpv3VLLaaXkEkRFyeGkHXHwNkAgIxPeKkOwsK8xklUMPu/9X30/uJdScpNBq
	 wjJe4/QSOGaqzRHyWidZDr2CXzjFn7I73ZFBLFh6lZwRIoXLyWki8so+HECuHwu31Q
	 v/yg8Do5PEe/Kirl7neXnN0IhxHQhB7wNtHfXOfdtqwTAJ2qHdDRotWnmc2BCKA71W
	 hSUTI9Jo9Vu6iibHA1NCrTOxDewqT0IrxPEeZBKSsPdEwKfz057HcvS6C9UVmuRUV4
	 bXjiEO+oY2jv2tP2/Jxisi3wGdQRMHKIGEQM/Z+2PbMW6vj+sjfh6b/jrI2sgJgUVb
	 H6q/vEGc7C10g==
X-Session-ID: 6a23e56840a079cfe12f61ed73c1adc349e55037e7b7a703291cdbaf1229c9b3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <622191c6a9b35335b65fdb07f8914b7@cweb016.nm>
Date: Tue, 29 Sep 2026 14:34:07 +0900
From: =?utf-8?B?7ISx67OR7LCs?= <tjdqudcks0424@naver.com>
Importance: normal
To: <netfilter-devel@vger.kernel.org>
Cc: <pablo@netfilter.org>,
	<fw@strlen.de>,
	<phil@nwl.cc>
Subject: =?utf-8?B?W0JVR10gbmV0ZmlsdGVyOiBJUHY2IGNvbm50cmFjayBmcmFnbWVudCByZWFzc2VtYmx5IA==?=
	=?utf-8?B?dHJ1bmNhdGVzIGhlYWRlciBvZmZzZXQ=?=
X-Works-Send-Opt: OPFwpzGdjHmdKHFOMr39Ko3YKHmdjAudFqM9KqMqFxIYkEljxBmwjAg=
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64

SGVsbG8sCgpSZXNlbmRpbmcgaW4gcGxhaW4gdGV4dCBiZWNhdXNlIHRoZSBtYWlsaW5nIGxpc3Qg
cmVqZWN0ZWQgbXkgcHJldmlvdXMKbWVzc2FnZS4KCkkgZm91bmQgYSByZXByb2R1Y2libGUgSVB2
NiBjb25udHJhY2sgZnJhZ21lbnQgcmVhc3NlbWJseSBidWcgaW46CgogIG5ldC9pcHY2L25ldGZp
bHRlci9uZl9jb25udHJhY2tfcmVhc20uYwoKVGVzdGVkIGtlcm5lbDoKCiAgTGludXggdjcuMi44
CiAgY29tbWl0IDlhNjZmZGMwZDdmZDU1ZjU0MjM1NTI0YTczNDM1YWY5OTA1MWU0NmYKICB4ODZf
NjQgd2l0aCBLQVNBTiBlbmFibGVkCgpJbiBmaW5kX3ByZXZfZmhkcigpLCB0aGUgcHJldmlvdXMg
TmV4dCBIZWFkZXIgb2Zmc2V0IGlzIHN0b3JlZCBpbiB1ODoKCiAgdTggcHJldl9uaG9mZiA9IG5l
dG9mZiArIG9mZnNldG9mKHN0cnVjdCBpcHY2aGRyLCBuZXh0aGRyKTsKCkEgdmFsaWQgSVB2NiBl
eHRlbnNpb24taGVhZGVyIGNoYWluIGNhbiBwbGFjZSB0aGlzIGZpZWxkIGF0IG9mZnNldCAyNTYu
ClRoZSB2YWx1ZSBpcyB0aGVuIHRydW5jYXRlZCB0byAwLiBEdXJpbmcgZnJhZ21lbnQgcmVhc3Nl
bWJseSwKbmZfY3RfZnJhZzZfcmVhc20oKSBtb2RpZmllcyBJUHY2IGhlYWRlciBieXRlIDAgaW5z
dGVhZCBvZiB0aGUgTmV4dApIZWFkZXIgZmllbGQgYXQgb2Zmc2V0IDI1Ni4KClJlc3VsdHMgd2l0
aCB0aGUgdW5tb2RpZmllZCBrZXJuZWwsIHJlcHJvZHVjZWQgdHdpY2U6CgogIGNvbnRyb2wgb2Zm
c2V0IDI0ODogZGVsaXZlcmVkCiAgYm91bmRhcnkgb2Zmc2V0IDI1NjogZHJvcHBlZAogIElwNklu
SGRyRXJyb3JzOiBpbmNyZWFzZWQgYnkgMQoKSSBjaGFuZ2VkIHByZXZfbmhvZmYgZnJvbSB1OCB0
byBpbnQgYW5kIHJlcGVhdGVkIHRoZSB0ZXN0IHR3aWNlOgoKICBjb250cm9sIG9mZnNldCAyNDg6
IGRlbGl2ZXJlZAogIGJvdW5kYXJ5IG9mZnNldCAyNTY6IGRlbGl2ZXJlZAogIElwNkluSGRyRXJy
b3JzOiB1bmNoYW5nZWQKCk5vIEtBU0FOIHJlcG9ydCwgbWVtb3J5IGNvcnJ1cHRpb24sIGluZm9y
bWF0aW9uIGRpc2Nsb3N1cmUsIHByaXZpbGVnZQplc2NhbGF0aW9uLCBvciBmaXJld2FsbCBieXBh
c3Mgd2FzIG9ic2VydmVkLiBJIGFtIHJlcG9ydGluZyB0aGlzIGFzIGEKcGFja2V0IGNvcnJ1cHRp
b24vZHJvcCBjb3JyZWN0bmVzcyBidWcuCgpUaGUgc2FtZSB1OCBkZWNsYXJhdGlvbiBhcHBlYXJz
IHRvIHJlbWFpbiBpbiBjdXJyZW50IG1haW5saW5lLgoKSSBoYXZlIGEgbWluaW1hbCBDIHJlcHJv
ZHVjZXIsIGNvbmZpZ3VyYXRpb24sIGxvZ3MsIGFuZCBiZWZvcmUvYWZ0ZXIKcmVzdWx0cyBhdmFp
bGFibGUuCgpSZWdhcmRzLApzdW5nYnllb25nY2hhbg==
