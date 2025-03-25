Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B27A93D
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 00:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742862276; cv=none; b=F7tcjaMkPfEdYtts9N/c7QeTlPq1l2uUhwgjMS1zNV74cuk3H0+hfyCNLgg7naICFcI7Y257Up8RChAUB/ftBhFNWZzmGRveTddHnRjZW0dp/M/IIRsqBo4ug7QRQGNOLRqJUZc0EflmjPmIk5ZZYGEtN4UZIIlvHQ6OZ8QHbDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742862276; c=relaxed/simple;
	bh=EG7u97szhWHQ02zf7lj9SCk64uOzu8SmZ6N4wzmoVgQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=QOKCGqeL6iGUXse/oh0jShmy59SyMMbxF4o9FwgBrB+19Dd/eTo/YJADqK3GV5THGvDnN+zdoYUJKI5KqzZVfq8Z42hJa6oR4Mj6X7Nhftvg9HDJy4cnD02yxzWo6RlgGZK9AmMpNns15KrBCwR7hja764rQkH+zK2E48Ux+PnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=CItlw93f; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="CItlw93f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1742862272; x=1743467072; i=corubba@gmx.de;
	bh=CP4XlK7/YSRvxB/RsdmJubiIemHUWc0oGaZ1VNY6dhc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:From:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=CItlw93fbeFbXE1pt6i184kUIxinSx/vTNCBNb8kZ/E7MgMPGNAXfBlVS6OUpW0m
	 iw2hGZVF150bXNxGrSHWVkAGCOGfRLqKUQzqvy3lvKyvBK/cpturhB6oP6vmo4Tlh
	 9PxQ6ozJv1zR/N0hpdkR1OlXWfdFmx2JHZhbfmFZ7wHwAgXkdZBGnPEegxZIhwLgf
	 3L6lxo/DKtrZ0KxRs/q8e3CpYIapDIs5LZBIhNsYWlce/7bcrAgisG+ijlCperALd
	 E1Q/eQdMiy/bZHqC1OflFfTAXEiPRNS5fnO7i+XyqMrDP7qwNGo7nCrj39oYhXmJQ
	 PFrZ1sfovc/nAMKLmQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from 127.0.0.1 ([83.135.90.83]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MYeMt-1tb1ZD0dO7-00JT8k for
 <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 01:24:32 +0100
Message-ID: <ef47491d-5535-466a-a77b-37c04a8b5d43@gmx.de>
Date: Tue, 25 Mar 2025 01:24:04 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Language: de-CH
To: netfilter-devel@vger.kernel.org
From: Corubba Smith <corubba@gmx.de>
Subject: [PATCH ulogd2] nfct: fix counter-reset without hashtable
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:CCM0IWYQZ/ndQgSsOEdjhouX0bKQ09Usu9fJ9eyClm6PEsQ5Y96
 mNJ146pekYPsMud2Eys/dFra5CIqG3PtbVNOwdTv+rJk654oNm50S5u/KlDgXmQK6BrtL6T
 ZH5OIyY3DOJNulrz6O7fYy12n/bwNrMdhRyMiBhCCS4eY4xnQ033dNlfEweYhkQ3KpI8ECj
 04erqWXIfiqo9zY/XXY9A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:j1a1U/w47zU=;nfL0DxdIqcqJh6IK6tXrQFBgNQI
 3zWjxIcgEreG9jc4XEG0dRP3VVlHXDr+/WbFkt1QBGEYXnI+z5f7daxmhOPXF3XahtgcqLlH4
 Kp5DlsBBPCeSi+1k6wxboUOvEYFrmD1PrxeOQxDg/+aFpdx/g5Mddn+BCWSPDXWW2ltLgAaMK
 H9N+aWwCzHRS42Nppi1Is2LGDdMYJyw8pR6jCr1Mi+o9kdzkmAW37ref5POqa34nq7CupMHhi
 zyZ6zP2WGuCo6JygbjGQ6/TQ+C/jwzsbHlhaRjuy4RRJ84XbJ8PeBlBkd7JS/HLG560PGpIah
 r/jhMOAGvNtGfSLz2QrGQOBizLIKS+O4xkqm9ESV1+Vd0eICUJ/qHQWh4Tg/zt4ElJLUbp86V
 QzQr2UDv4FBHkkKnrgy3ktVDVA95hBcJ3JzTGGIGuqf8syPPJzfkvVU6E6AFqkoLyWdbxkmJ1
 iMSDii7+8dxd2dD8kAjfzExMamhe0LMg59v+N8DEmu0uDP3M9x456Llv+cmS4lq6UG7lRzUfL
 UUqtrMcipAG3yEya6aMcFHKTYqJZTrLoOhUrlepGbrRN8RS/WOjrhaQZkOLMagMya1z4WObG1
 PKyHQ4asZxl0X5uICAK5TNe6dMVwq7oHMQsmeInBsIExtiGjwhkBzta7QlCwD0XJpa7AIK0ud
 sO0lVumjGgE0wHunp+zKbGWsNYxza3DAV/Hx05WW1MXkonjAFCJIHOOoFUJMWnvQZrp+417jq
 786PwZ9luHfRcoRXnzjEcgaJv9jVXCoBcFq46FyO+raoMyIHzsMSQtXs88MCBeeZE3LyqJtwu
 TQGKhc/X+ipEhcIQfvjFjR8du/UL3qEXQH8dNifWXkkaoIYd8vzrC5chlwyKFCoEe5wTlhkXE
 D1y8E24snCiQ0wtrZNj65Sws5CdPphob2O8hCqPi8qSY1wt1ydqN8soBowFubb4PTVlefkfFW
 I+chp9whtbeRpL+ybHlTtgmvGVMlrEHXcIuns70kCNlzNlvsedTURCPnv3Ht7ip+xja8JhOVD
 IjOcWkuT8cIMZqAzJ9HPuSv/3/merOYRI+uu7kLnniYe2v0vl27JXZzGS6nLmPcC1C4IIVi6T
 gDXuM0kJDJZwN2mIZzKsIQ1lM16cPs4KPlQ03T0pEG/8SIZG7tL5AV+mIrjB4SlCw2PxBWQZI
 5MPpCxyQKY7xbRDcrjhXuQ1rp0o5QJf4Fus63eQUJZWl9bIq99hmaM9wOB5FKK8vo88RTjLxQ
 vfCJeZZL9UiZyaJLJkPLEGlTmrVBH+PkSYOUYcXdbEYgT8fdbQEHIptdfZyWcShAvLKM9jfyp
 mBy+WlqFI4tBYQ/touxZSS+cLsXAdE8WCN4v6Y7obxpTXMXwDdhbUEpn19guCU1iNFRlUgGbq
 in5gnxi797mXS9rttll1uVeL0HXwg/9HLdjgVRhAw5lohmGPpuDij6cO/4HEJxMDV7WeQFSGD
 rkeHtnNZA/DBz3pMUghZGa9GrMds=

The dump_reset_handler will try to update the hashtable regardless of
whether it is used (and thus initialized), which results in a segfault
if it isn't. Instead just short-circuit the handler, and skip any
further result processing because it's not used in this case anyway.
All flow counters in conntrack are reset regardless of the return value
of the handler/callback.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 input/flow/ulogd_inpflow_NFCT.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NF=
CT.c
index 93edb76..cdda741 100644
=2D-- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -989,6 +989,9 @@ dump_reset_handler(enum nf_conntrack_msg_type type,
 	int ret =3D NFCT_CB_CONTINUE, rc, id;
 	struct ct_timestamp *ts;

+	if (!cpi->ct_active)
+		return NFCT_CB_STOP;
+
 	switch(type) {
 	case NFCT_T_UPDATE:
 		id =3D hashtable_hash(cpi->ct_active, ct);
=2D-
2.49.0
