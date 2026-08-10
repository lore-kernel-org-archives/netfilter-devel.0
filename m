Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726701A38F9;
	Mon, 10 Aug 2026 03:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786330925; cv=none; b=PaP/Gg+VdEwSk5sGX/bP3yfX0ZoEFGnNVy3oRri3IkD1iGutNlH5wgOj6OcVI0sHclq99Czx40ejj02Kq0dycCu9fgcgeOwKGrY4fIeNlKdpOioHEaOvDtvzWj664ESMgIGfXGoa4x4tS4M4nJC91mWm8EqG50HQjY6FYSQFcY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786330925; c=relaxed/simple;
	bh=ksdh6wyPf0BWarU30unhsM0g+/5W5jnE2e0r3+kZZp8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=aNeViZh/S3UtkrSavNxMlecxTt9+k0ZoJ0PS0WvShNdTZHFrSctF8rVSa+fskycw0KKveHNafb0vvKkaM2R4pa+TSwpZtaO1qarrh61ZgfCOZA466aZc+n+joYG+vKbBbttSn2RrFnhax9t7R/2H0xYAWJQpUj+04Lr6EsgZj1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=mvgGG5zi; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="mvgGG5zi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=ksdh6wyPf0BWarU30unhsM0g+/5W5jnE2e0r3+kZZp8=; b=m
	vgGG5zi0d3S6Bn+2l2y570plNmHJpLPGOZLqyUjNxZIebP9ilBNHLtZa/ZMDhCP9
	HQnN9JDO+uKbmS9osZo7UVulI+34mPcDtJV1KWFla1QdF2cOyR6/vBwUCagOIOxg
	MuayIdaDTKH7N5NkqBAoH70zvTWF7GA8KJvgyIerws=
Received: from fuqingshuang$kylinos.cn ( [116.128.244.169] ) by
 ajax-webmail-wmsvr-40-137 (Coremail) ; Mon, 10 Aug 2026 11:01:09 +0800
 (CST)
Date: Mon, 10 Aug 2026 11:01:09 +0800 (CST)
From: "Qingshuang Fu" <fuqingshuang@kylinos.cn>
To: "Hangbin Liu" <liuhangbin@gmail.com>
Cc: "Pablo Neira Ayuso" <pablo@netfilter.org>,
	"Florian Westphal" <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Fernando Fernandez Mancera" <fmancera@suse.de>
Subject: Re: [PATCH net v2] selftests: netfilter: conntrack_dump_flush:
 remove unused variables and fix typo
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
Sender: fffsqian@163.com
In-Reply-To: <anbMGS9TFOEUUWu-@fedora>
References: <20260807075928.64326-1-fffsqian@163.com>
 <anWgQSbZWK6D2ONg@fedora> <anWyMUFvONx6k1d5@chamomile>
 <anbMGS9TFOEUUWu-@fedora>
X-NTES-SC: AL_Qu2TBP+Yv0At7yCbbekckk4Vhu49Xcq2vvQv34Fec9MFiRvq2ysnRH96GVDLyc6fMh6joje9QD9v6t1IfYBeYNQ0he/sUyMeyFmHKi/F/A==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <72b995d7.271c.19fe99ded3b.Coremail.fuqingshuang@kylinos.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:iSgvCgBnPsH2Pnlq2WUuAA--.1127W
X-CM-SenderInfo: 5iii21xldqqiywtou0bp/xtbC6hbFkGp5PvYDfAAA3N
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CgpBdCAyMDI2LTA4LTA4IDE0OjI2OjMzLCAiSGFuZ2JpbiBMaXUiIDxsaXVoYW5nYmluQGdtYWls
LmNvbT4gd3JvdGU6Cgo+T24gRnJpLCBBdWcgMDcsIDIwMjYgYXQgMTI6MjM6NDVQTSArMDIwMCwg
UGFibG8gTmVpcmEgQXl1c28gd3JvdGU6Cj4+IE9uIEZyaSwgQXVnIDA3LCAyMDI2IGF0IDA1OjA3
OjEzUE0gKzA4MDAsIEhhbmdiaW4gTGl1IHdyb3RlOgo+PiA+IE9uIEZyaSwgQXVnIDA3LCAyMDI2
IGF0IDAzOjU5OjI4UE0gKzA4MDAsIFFpbmdzaHVhbmcgRnUgd3JvdGU6Cj4+ID4gPiBGcm9tOiBR
aW5nc2h1YW5nIEZ1IDxmdXFpbmdzaHVhbmdAa3lsaW5vcy5jbj4KPj4gPiA+IAo+PiA+ID4gUmVt
b3ZlIHVudXNlZCAncnBsbmxoJyBpbiBjb25udHJhY2tfZGF0YV9pbnNlcnQoKSwgYW5kIHJlbW92
ZSB1bnVzZWQKPj4gPiA+ICdycGxubGgnIGFuZCAnbmVzdCcgdmFyaWFibGVzIGluIGNvbm50cmFj
a19jb3VudF96b25lKCkgYW5kCj4+ID4gPiBjb25udHJhY2tfZmx1c2hfem9uZSgpLiBUaGVzZSB2
YXJpYWJsZXMgd2VyZSBkZWNsYXJlZCBidXQgbmV2ZXIgdXNlZAo+PiA+ID4gc2luY2UgdGhlaXIg
aW50cm9kdWN0aW9uLgo+PiA+ID4gCj4+ID4gPiBBbHNvIGZpeCB0eXBvOiByZW5hbWUgbWlzc3Bl
bGxlZCBjb25udHJhY0tfY291bnRfem9uZSgpIHRvCj4+ID4gPiBjb25udHJhY2tfY291bnRfem9u
ZSgpLgo+PiA+ID4gCj4+ID4gPiBSZXZpZXdlZC1ieTogRmVybmFuZG8gRmVybmFuZGV6IE1hbmNl
cmEgPGZtYW5jZXJhQHN1c2UuZGU+Cj4+ID4gPiBTaWduZWQtb2ZmLWJ5OiBRaW5nc2h1YW5nIEZ1
IDxmdXFpbmdzaHVhbmdAa3lsaW5vcy5jbj4KPj4gPiAKPj4gPiA+IC0tLQo+PiA+ID4gdjI6Cj4+
ID4gPiAgIC0gRHJvcCBGaXhlcyB0YWcgYXMgdGhpcyBpcyBhIGNsZWFudXAsIG5vdCBhIGJ1ZyBm
aXgKPj4gPiAKPj4gPiBJZiBub3QgYSBidWcgZml4LCB5b3Ugc2hvdWxkIHRhcmdldCB0byBuZXQt
bmV4dC4KPj4gCj4+IFdlIHdpbGwgaGFuZGxlIHRoaXMgdGhvdWdoIHRoZSBuZi1uZXh0IHRyZWUu
Cj4KPk9oLCBnb29kLiBUaGF0J3MgbW9yZSByZWFzb25hYmxlLgo+CgpUaGFua3MgYWxsIGZvciB0
aGUgcmV2aWV3IGFuZCBjbGFyaWZpY2F0aW9uLgoKQmVzdCByZWdhcmRzLApRaW5nc2h1YW5nIEZ1
Cg==
