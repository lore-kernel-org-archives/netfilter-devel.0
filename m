Received: from cornsilk.maple.relay.mailchannels.net (cornsilk.maple.relay.mailchannels.net [23.83.214.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B3433E373
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 23:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.214.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761867867; cv=pass; b=C4/tFIcPAbpAHi3xn3hjs5+Ka/hXEs1iARlcpsZ1FEEjf0+dJrrvMLkjbXTC6xhdjTMoCeFtTyAPdQ7FQ4lxYIuUL/7njsR+QnZmMoJDSCuBibZg6vFJrH8L7+CWyUrK2hhGc9g8exAf5RHy84vU+302BhX5fIrMdbyYI/bLDvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761867867; c=relaxed/simple;
	bh=OUrZLJE7+2qpKZlCdEoahdag7hz7XJ6pkAY8I+HaJOM=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BxdKGhXrQfI8ttIna3YXUhVi5oSjB3QUjfi7b27HCiTag5cLTlPc+mLYPp/61a4kdNz55FrxLXIx/p+vWnmsZSNRx65t98UNPI3vgFn21hm6epkh9UtzI6Y873KIAOAepY9A64doMcIqe2km3pjXxQfqd4vqBjAkSsgapFIrO5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=tjwoXKpy reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.214.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="tjwoXKpy"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 24CEF8208D6
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 23:34:44 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-123-83-250.trex-nlb.outbound.svc.cluster.local [100.123.83.250])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 29F3D820E8E
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 23:34:43 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761867283; a=rsa-sha256;
	cv=none;
	b=oex9I8r8nQNN0MixQAHykCzpMRt06GjWdYc5fLeCGVHopXuKW9gH5sZNMXBcKPuA1JglV+
	xiVSAsRmgGCQOvUzHNl/PlvCyU3jdmwg7x9VLmeKOBuGb3V1FZCVyky56HUyzhweV+c4Xr
	ZE4AkuGdISqqmYetI4UxFesoJtLEljQGs8FEu/c0oVuEpdyYCyqNxBT8OE7wkElO9gkW+q
	mTDwsRSSI62llSPhE6W3WU+jtp4hXe28O/0Gcf8OXx0+zXurMu9L7RRemTqPgi1r8hsF0/
	uVfz93PhDFVATzYgz+OffRIMVGyQEEKFDQEJlSxXdppAiGeKlPcI3+v/8MQn1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761867283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OUrZLJE7+2qpKZlCdEoahdag7hz7XJ6pkAY8I+HaJOM=;
	b=PFSWViaff+fpZKX2ZOPUtQQ+i7w/EoZS/ftCXDpONtnSviJucTfveb9o/xjO+Lc+waZ+aP
	C23yV7eEvX1GUG7B8fbeJO/TD1Kyfd0dxF7olffqn4ZOR8o9XkLZzjmN6x+EpWcTSXQ9Tp
	EOKxJ46AhgHcRC9TpnGae0cKhkEAdxGO3QFJfr/wwzP9m4f8hMx0Q/+OBVol+zZQ+gPgYf
	fWutDGYeq3quxFLVSovwqhNSCxSbJvhc+4k2yBKh0WiP+f/un1mFU0re5FRxnx2WDr0vlj
	Pkn3v0VLh5Bq6fy9eq6rW2XydF8wW4oZ97piyVWev487otEqgYY+kYEglKYtGA==
ARC-Authentication-Results: i=1;
	rspamd-768b565cdb-f949h;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Madly-Tasty: 5309c2b66f2c352d_1761867283722_3565667454
X-MC-Loop-Signature: 1761867283722:1956557880
X-MC-Ingress-Time: 1761867283722
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.123.83.250 (trex/7.1.3);
	Thu, 30 Oct 2025 23:34:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:To:From:
	Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=OUrZLJE7+2qpKZlCdEoahdag7hz7XJ6pkAY8I+HaJOM=; b=tjwoXKpy8fec
	/gp5TiNfqsLvTi83vNia9V/k+QkY46qu93D6I7RwLPk4ruGDdSsXQhNT2+a6oZV9rWk7cqMAq2+LL
	0dxLIaK+NJU162dAKnJ3/VEpCJoZg+s9o8ixkwscvr60VaMud8y/L7cxr5YKpamHEyeQWJms80jHt
	4O4Z2OLEehQgiExGsw45dmnUxgICXrFJgmLShsAN6Ag+GoikOUF9b6DFXRoqR1+vCFe8OzP0rTWF7
	jEYZvnFYvBXWj1tiaZlb4N4HomeMBnPhXgSO0Z3SpAiEqS+RKycHj1ZJswtnEryw3sz2QRXIKiK8f
	ei+zIZuhfRZ7iNFu75SrRg==;
Received: from [212.104.214.84] (port=5529 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1vEcAE-00000009SBI-1hnT
	for netfilter-devel@vger.kernel.org;
	Thu, 30 Oct 2025 23:34:41 +0000
Message-ID: <c569aba64349b4cb665e325a41bbde0abe6f56a6.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH 8/9] tools: flush the ruleset only on an actual
 dedicated unit stop
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Date: Fri, 31 Oct 2025 00:34:39 +0100
In-Reply-To: <20251024023513.1000918-9-mail@christoph.anton.mitterer.name>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
	 <20251024023513.1000918-9-mail@christoph.anton.mitterer.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.56.2-5 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: mail@christoph.anton.mitterer.name

SGV5LgoKSSBndWVzcyBub25lIG9mIHRoZXNlIHBhdGNoZXMgd2lsbCBiZSBtZXJnZWQgYW55d2F5
ICh3aGljaCBpcyBva2F5IGZvcgptZSA6LSkgKS4uLiBidXQganVzdCBpbiBjYXNlIHNvbWV0aGlu
ZyB3b3VsZCBiZSBwaWNrZWQgYWZ0ZXIgYWxsLApwbGVhc2UgcGluZyBtZSBmaXJzdCBhcyBJJ3Zl
IG1hZGUgc2V2ZXJhbCBtaW5vciBjaGFuZ2VzL2ltcHJvdmVtZW50cyBpbgpteSBvd24gdmVyc2lv
biBtZWFud2hpbGUuCgoKSW4gcGFydGljdWxhciwgdGhpcyBwYXRjaCBjb250YWluZWQgYSByYXRo
ZXIgZ3JhdmUgZXJyb3I6CgpPbiBGcmksIDIwMjUtMTAtMjQgYXQgMDQ6MDggKzAyMDAsIENocmlz
dG9waCBBbnRvbiBNaXR0ZXJlciB3cm90ZToKPiArRXhlY1N0b3A9Oi9iaW4vc2ggLWMgJ2pvYl90
eXBlPSIkJCggL3Vzci9iaW4vc3lzdGVtY3RsIHNob3cgLS0KPiBwcm9wZXJ0eSBKb2JUeXBlIC0t
dmFsdWUgIiQkKC91c3IvYmluL3N5c3RlbWN0bCBzaG93IC0tcHJvcGVydHkgSm9iIC0KPiAtdmFs
dWUgJW4pIiApIlxuXAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgY2FzZSAiJCR7am9iX3R5cGV9IiBpblxuXAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgKHN0b3ApXG5cCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIEBzYmluZGlyQC9uZnQgZmx1c2ggcnVsZXNldDs7XG5cCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAocmVzdGFydHx0cnktcmVz
dGFydClcblwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cHJpbnRmIFwnJSVzOiBKb2JUeXBlIGlzIGAlJXNgLCB0aHVzIHRoZSBzdG9wCj4gaXMgaWdub3Jl
ZC5cJyAlbiAiJCR7am9iX3R5cGV9IiA+JjI7O1xuXAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgKCopXG5cCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHByaW50ZiBcJyUlczogVW5leHBlY3RlZCBKb2JUeXBlIGAlJXNg
LlwnICVuCj4gIiQke2pvYl90eXBlfSIgPiYyOyBleGl0IDFcblwKPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGVzYWMnCgoKV2hlbiAnOicgaXMgdXNlZCBhIGV4
ZWN1dGFibGUgcHJlZml4LCAnJCQnIGlzIG5vdCB0aGUgZXNjYXBlZCBmb3JtIG9mCickJyAoYXMg
aXQgaXMgd2l0aG91dCksIGJ1dCByYXRoZXIgc3RheXMgdGhlIGxpdGVyYWwgJyQkJyAod2hpY2gg
aW4gYQpzaGVsbCBvZiBjb3Vyc2UgaXMgdGhlIHNwZWNpYWwgcGFyYW1ldGVyICQgKHRoZSBQSUQg
b2YgdGhlIHNoZWxsKS4KCgpDaGVlcnMsCkNocmlzLgo=

