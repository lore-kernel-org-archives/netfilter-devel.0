Received: from mail.redfish-solutions.com (mail.redfish-solutions.com [50.20.195.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8331D296BCC
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2026 21:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=50.20.195.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509553; cv=none; b=d+XxGh9/oxlrDYDGBE1KjImMx4x/PYV5CVFRCnzVe/9vqys1tpOqM37LQkolEpVKWrXiYbvfh6WXIxcBPA3D3B6yG1Jl3keZSTB3hL0FzdkSFWFUPY8jB7nc+uMsR+8KMe7XPTL4mTFxlfcmyyw6TsHrEOFZgtGswVt1hfu4c7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509553; c=relaxed/simple;
	bh=eL5EA8pH5NHV8W4mewFKTI+mx5+fb/Jd8ZA9sWQux4I=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=Uo2jrl6tmOUgrSHa8Fd2H9pLoxXas0qRIVXF8YH17Ajx+EoE6ISmFP3oU+/B1N8KPNB+rzsG2qnBqjKm1UD0UyktyHTVDqLljwvIXYJ8Z3JZJ4mpHj0SqJ2EQxmMsZikTbYrfLetrbTjxNhhM9NPVE9peGiRepsy8V0LSSscdPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redfish-solutions.com; spf=pass smtp.mailfrom=redfish-solutions.com; arc=none smtp.client-ip=50.20.195.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redfish-solutions.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redfish-solutions.com
Received: from smtpclient.apple (macbook4.redfish-solutions.com [192.168.3.6])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.18.2/8.18.2) with ESMTPSA id 65QLO5GA044261
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2026 15:24:06 -0600
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: OpenWRT bounty for strong host behavior
Message-Id: <98897A5C-14E5-4827-A347-56B45C021250@redfish-solutions.com>
Date: Fri, 26 Jun 2026 15:23:54 -0600
To: netfilter-devel@vger.kernel.org
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Scanned-By: MIMEDefang 3.6

Anyone interested in working on this?

It's been pointed out that pbr and mwan3 provide this functionality, but =
if you ask me it should be part of the core functionality of networking =
and/or the firewall since it relates to NATting (you want the ingress =
packet matching the NATting of the egress packet and vice versa).

https://github.com/openwrt/firewall4/issues/93

If you want to work on it, contact me for terms.

Thanks.

