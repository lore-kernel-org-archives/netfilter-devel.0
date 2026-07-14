Received: from ns1.suksangroup.com (ns1.suksangroup.com [103.13.31.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BC93264CF
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jul 2026 05:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.13.31.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784006822; cv=none; b=tBdWHGM25dRkOjc12gpQTHuKfC65l+6+XViUrgbcyrbS1Rdv6ankbGiT9wVDhMDI3YEUxSYVN9aTa03bW5Skf7ad6Wx+1lGOUAqN/kzXhXsXhF1HYuHzzoyDNvbeqjR8GmidtNvvGg/RiPCapDwZchon+Vg2KNzGg6xJgmdr2+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784006822; c=relaxed/simple;
	bh=DLqeX2mToppQSWbr5Rp910EkiiV6FhxXZsRdTxjdK/Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UPvXSJou3fq9gTF+PVNJGnXHuv6IZFmpu3xTtFgRBxNGR/o+DykTl1i1viKE2/4giNTS7/pzd1GN+/HqmkA1EMjOge+JPZQrqqhHk0Jlrx+AzRzxOWAOOmBfie0vGmv31seqa/nNf5jX5a5f7rzC2V+YSnHqrsyNmVC5EJD2bbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=inbox.org; spf=fail smtp.mailfrom=inbox.org; dkim=pass (2048-bit key) header.d=suksangroup.co.th header.i=@suksangroup.co.th header.b=aRt5nAb4; arc=none smtp.client-ip=103.13.31.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=inbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suksangroup.co.th header.i=@suksangroup.co.th header.b="aRt5nAb4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=suksangroup.co.th; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:To:From:Reply-To:Sender:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DLqeX2mToppQSWbr5Rp910EkiiV6FhxXZsRdTxjdK/Y=; b=aRt5nAb4lKGnj6srff1PeqkZPn
	Dp+tvQRGCfK8tixA51jnB7dZ+7fUM2Vu5xeD0PdAibOzPCX0RTfxfMY4Kpm8I4qVYjoUqyJEB3qCP
	5EmoyBSGkE/oPQTqLJMMqoqGRYdVfH/Vpew2oOkLz1GmETkAPVlyat5ji4wPQ1HQOCdVr64u9ctsS
	A6LJ09FVuxFXRZcKssgFckFtp49iDt9HDCIzvJQJIVUcYUWxDYw+PATul+hxdH9lNJs5Z7iXZ0hB3
	tysf0CIEFvSHxV9aLmgjMRwTkjQ7MnumXhgNdO075pg/ZD2kN9JnCqc7BIvKT2c7twFjwh9vP97S2
	46on7EFw==;
Received: from [207.189.26.187] (port=64035)
	by ns1.suksangroup.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.4)
	(envelope-from <info@inbox.org>)
	id 1wjVfY-0000000Fytc-03Hu
	for netfilter-devel@vger.kernel.org;
	Tue, 14 Jul 2026 12:26:59 +0700
Reply-To: hanns.schofield@lexcapitalgrowth.com
From: Harry Schofield ESQ <info@inbox.org>
To: netfilter-devel@vger.kernel.org
Subject: Dear netfilter-devel, project info
Date: 14 Jul 2026 00:26:55 -0500
Message-ID: <20260714002655.53747ED8E7225D9F@inbox.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ns1.suksangroup.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - inbox.org
X-Get-Message-Sender-Via: ns1.suksangroup.com: authenticated_id: smtp@suksangroup.co.th
X-Authenticated-Sender: ns1.suksangroup.com: smtp@suksangroup.co.th
X-Source: 
X-Source-Args: 
X-Source-Dir: 


Re:Good day netfilter-devel,

Please let me know if this is best email to send you the project=20
info.

Kind regards,

Harry Schofield, ceMBA


