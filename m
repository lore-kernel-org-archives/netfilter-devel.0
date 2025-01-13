Received: from queue02b.mail.zen.net.uk (queue02b.mail.zen.net.uk [212.23.3.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B9D16EC19
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2025 10:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.23.3.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736765425; cv=none; b=UbLP4VWkCGA062vDqTPmE0ZObuZuNAiAqk6s4Drkta6LiVHGpxbLOrTVwPOvF4L2+yWadcGkzoq0Ytqq/0gGNmOXDHWb8E406Ty4rSI/5jA/XbnwHhtAOqQTzlMTmavdDsq1l1B3xC4GBYXHeRwnjjwNrint9d9spzo7U8H7hPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736765425; c=relaxed/simple;
	bh=RWtPoQYNLUwv7bP7q4OXTSm/HDmBaF2AS/zvblUU7Lk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fyfWb4UYwYw0s7yTq9SYCobkv9uAg0UzppoyOqHqdEkZcGOpqcPr+V/Z6W/zdvznDaewDR+NAfB89MbSZDOG9qa7B88YdFUNhC/0LBtwxo/HJjjysaJbGEy8dk0yWKMXTYP3JLRBS8AAz7UKu5uv85iQMQGKSzwnF8dcubea6vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dingwall.me.uk; spf=pass smtp.mailfrom=dingwall.me.uk; arc=none smtp.client-ip=212.23.3.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dingwall.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dingwall.me.uk
Received: from [212.23.1.21] (helo=smarthost01b.ixn.mail.zen.net.uk)
	by queue02b.mail.zen.net.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <james@dingwall.me.uk>)
	id 1tXHkn-008S6o-Dn
	for netfilter-devel@vger.kernel.org;
	Mon, 13 Jan 2025 10:33:05 +0000
Received: from [217.155.64.189] (helo=mail0.xen.dingwall.me.uk)
	by smarthost01b.ixn.mail.zen.net.uk with esmtpsa  (TLS1.0) tls TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA
	(Exim 4.95)
	(envelope-from <james@dingwall.me.uk>)
	id 1tXHkg-00Cb89-40
	for netfilter-devel@vger.kernel.org;
	Mon, 13 Jan 2025 10:32:58 +0000
Received: from localhost (localhost [IPv6:::1])
	by mail0.xen.dingwall.me.uk (Postfix) with ESMTP id 7FABABD931E
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2025 10:33:07 +0000 (GMT)
X-Virus-Scanned: Debian amavisd-new at dingwall.me.uk
Received: from mail0.xen.dingwall.me.uk ([IPv6:::1])
	by localhost (mail0.xen.dingwall.me.uk [IPv6:::1]) (amavisd-new, port 10024)
	with ESMTP id 8hseWvGZjed7 for <netfilter-devel@vger.kernel.org>;
	Mon, 13 Jan 2025 10:33:07 +0000 (GMT)
Received: from ghoul.dingwall.me.uk (ghoul.dingwall.me.uk [IPv6:2a02:8010:698e:302::c0a8:1c8])
	by dingwall.me.uk (Postfix) with ESMTP id 4E683BD9319
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2025 10:33:07 +0000 (GMT)
Received: by ghoul.dingwall.me.uk (Postfix, from userid 1000)
	id 8A405326; Mon, 13 Jan 2025 10:33:10 +0000 (GMT)
Date: Mon, 13 Jan 2025 10:33:10 +0000
From: James Dingwall <james@dingwall.me.uk>
To: netfilter-devel@vger.kernel.org
Subject: ulogd: out of bounds array access in ulogd_filter_HWHDR
Message-ID: <Z4Tr5p19Uoc1UEcg@dingwall.me.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="DzHgWEtRad4QP1gM"
Content-Disposition: inline
X-Originating-smarthost01b-IP: [217.155.64.189]
Feedback-ID: 217.155.64.189


--DzHgWEtRad4QP1gM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I've been given an account in the bugzilla but on submitting:

Forbidden

You don't have permission to access this resource.


Here's what I'm trying to report...

Thanks,
James



This report relates to https://bugs.launchpad.net/ubuntu/+source/ulogd2/+bug/2080677.

# apt-cache policy ulogd2
ulogd2:
  Installed: 2.0.8-2build1
  Candidate: 2.0.8-2build1
  Version table:
 *** 2.0.8-2build1 500
        500 http://gb.archive.ubuntu.com/ubuntu noble/universe amd64 Packages
        100 /var/lib/dpkg/status

# lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description: Ubuntu 24.04.1 LTS
Release: 24.04
Codename: noble

It seems that there is an out of bounds array access in ulogd_filter_HWHDR.c
which leads to ulogd2 being terminated with SIGABRT and the following message
when it is compiled with -D_FORTIFY_SOURCE=3:

*** buffer overflow detected ***

The hwac_str array is defined as:

  static char hwmac_str[MAX_KEY - START_KEY][HWADDR_LENGTH];

Which translates to:

  static char hwmac_str[4 - 2][128];

i.e. an array of two elements, valid indexes 0, 1.

Adding a debug print statement in the parse_mac2str function:

  fprintf(stderr, "using hwmac_str index %d\n", okey - START_KEY);

will result in the following message:  

  using hwmac_str index 2

So the for loop attempts to format the mac address in to an invalid index in
hwmac_str.

As a simple test I made the definition of hwmac_str an array of 3 elements
which prevented the crash.  I don't know if it is correct to simply make
the array longer or if the bug is actually in the value of 'okey' passed to
the function.  However based on the final return in interp_mac2str I think
the array definition is too short.  The attached patch allows ulog2 to
run after rebuilding with dpkg-buildpackage.

--DzHgWEtRad4QP1gM
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="ulogd_filter_HWHDR-hwmac_str.patch"

--- filter/ulogd_filter_HWHDR.c.orig	2025-01-13 09:25:18.937977335 +0000
+++ filter/ulogd_filter_HWHDR.c	2025-01-13 09:25:51.337824820 +0000
@@ -109,7 +109,7 @@
 	},
 };
 
-static char hwmac_str[MAX_KEY - START_KEY][HWADDR_LENGTH];
+static char hwmac_str[(MAX_KEY + 1) - START_KEY][HWADDR_LENGTH];
 
 static int parse_mac2str(struct ulogd_key *ret, unsigned char *mac,
 			 int okey, int len)

--DzHgWEtRad4QP1gM--
