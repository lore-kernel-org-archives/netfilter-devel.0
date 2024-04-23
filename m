Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3968B1C687
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Apr 2024 03:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713843443; cv=none; b=H20F22Z4hXrjxAPCU095O1AaTF2xSh1pzE4m1dia4/YACmLDEef+gbhm4Jd0NIpsCGOF/AFccFaa2g6cGLfXYjeuq9Sm/hGmAp87uiYFmrZGGthS7Lb8jLRqKKJBNPByO7Inv964gxfVQJVHn8sDosbiZq63jkK+esmS5ZQv9HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713843443; c=relaxed/simple;
	bh=lRnLjcLsfDOXD3Hw3LG1Gr9LKIv5ly9M6T2eQ89sp1Y=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=TdYq9C0lXEJhRfmPMqHJxRRyhGM0KVoCHA/6yjUMN2+N9shLch+rsBzGAsgx+mYFA7f4t+xKhzh4KnNrGFB/5KwQHnGa4DCPCBwQ7HJsuuf4g5G2YvqbxLmzIUUV0n3oDzMzvRuW03wOLkNrii4qt9EIMSVBc0KtzTThjbBUvbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=lLinVOvL; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="lLinVOvL"
Received: from juju-98d295-prod-launchpad-3.localdomain (appserver-2.lp.internal [10.131.215.183])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 2EE3B4009D
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Apr 2024 03:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1713842879;
	bh=16lM24CP7gMwtt7mrPoRPq1sjDnfhlnqfx1GSE2cpw0=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=lLinVOvLf9G/olBqgmBaKA9GcPyStG7ySQn/VirWltH1otYYuIlc/BZOpJt9UR2Wy
	 DLIWC0sMXos34JUBVi9gIRu81fR2ziL5xBrqxSul8nk1QSuj+elDYOYuldUCIq948f
	 1abd99T1/1nwbMK2pD6SruDtfpOWaRv6D73SpmDWLG5tMm+60RmD+USkbKpFAob24m
	 /FvGvWhnMnoA8JvovRjYfuPAEjb62jUfXDjF148/8yu/zTXI+Tmu+QJOqejMx+SVeI
	 tg2y131MHj6Blt7ISLHlY0A1mKkoRtQXBi41sng8QN5cZPebexllHecQQRbqWhjeZv
	 Y5clC7Mftq73Q==
Received: from [10.131.215.183] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-3.localdomain (Postfix) with ESMTP id 918717E073
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Apr 2024 03:27:57 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@vger.kernel.org
From: Launchpad Email Validator <noreply@launchpad.net>
Subject: Launchpad: Validate your team's contact email address
Message-Id: <171384287753.2756066.4441350662136305957.launchpad@juju-98d295-prod-launchpad-3>
Date: Tue, 23 Apr 2024 03:27:57 -0000
Reply-To: Launchpad Email Validator <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
X-Generated-By: Launchpad (canonical.com); Revision="67d34a19aaa1df7be4dd8bf498cbc5bbd785067b"; Instance="launchpad-appserver"
X-Launchpad-Hash: fb4e05796b3f617e425432ef412230561e50c745


Hello

The Launchpad user named 'Peter J. Mello (roguescholar)' requested the
registration of 'netfilter-devel@vger.kernel.org' as the contact email addr=
ess
of team 'Xtables-addons Development'. This request can only be made by a te=
am
owner/administrator, so if this change request was unexpected or was
not requested by one of the team's administrators, please contact
system-error@launchpad.net.

If you want to make this email address the contact email of
'Xtables-addons Development', please click on the link below and follow the
instructions.

    https://launchpad.net/token/QdhB85kK4gFkDh0Z5Wkq

Thanks,

The Launchpad Team


