Received: from mail.jubileegroup.co.uk (host-83-67-166-33.static.as9105.net [83.67.166.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C066A2C9A
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2025 14:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.67.166.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743170478; cv=none; b=XmnLQjNqDXWR7Nc9rj7AtApHAlYqeaMvnHbm9Tp7gjLjwARd7bPlivz7x/YlCRrB+EDkVVy9A5p/042o3ZYf8kJf/Yq1x7RBK+4+XZdFIuOonj6AiaCv+jMzANltemxSMgYTrF0K2FESr4rKimGWKD04+YeP15bxhvwlfQ2NDi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743170478; c=relaxed/simple;
	bh=NTdL5kIDEpJnODqdmKCg+BqKxPZYSuHPxzh0eypF31c=;
	h=Date:From:To:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=KvtTRoIWiPDcENsdscPtIkqXrGhbenD6DAEiiqIYBly+OrsOo80s9SrpRRotdCRXQKA2DUVW4X/klbg2OA1Px4gd8A7NcIyGC3Va2i5tMAKZO7Ln6Xlh0TyZzOdBpb9I6wwX8hW6gKCI+TXy8LANaCRHsopB4YSTDUnBynDm7yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jubileegroup.co.uk; spf=pass smtp.mailfrom=jubileegroup.co.uk; arc=none smtp.client-ip=83.67.166.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jubileegroup.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jubileegroup.co.uk
Received: from piplus.local.jubileegroup.co.uk (piplus.local.jubileegroup.co.uk [192.168.44.5])
	by mail6.jubileegroup.co.uk (8.16.0.48/8.15.2/Debian-14~deb10u1) with ESMTPS id 52SDtBJY027148
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2025 13:55:13 GMT
Date: Fri, 28 Mar 2025 13:55:11 +0000 (GMT)
From: "G.W. Haywood" <netfilter@jubileegroup.co.uk>
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Documentation oddity.
In-Reply-To: <Z9EoA1g/USRbSufZ@slk15.local.net>
Message-ID: <f87285a5-f381-bb1f-3d31-97ef214946dd@jubileegroup.co.uk>
References: <9190a743-e6ac-fa2a-4740-864b62d5fda7@jubileegroup.co.uk> <bda3eb41-742f-a3c3-f23e-c535e4e461fd@blackhole.kfki.hu> <4991be2e-3839-526f-505e-f8dd2c2fc3f3@jubileegroup.co.uk> <Z899IF0jLhUMQLE4@slk15.local.net> <99edfdb-3c85-3cce-dcc3-6e61c6268a77@jubileegroup.co.uk>
 <Z9EoA1g/USRbSufZ@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-AS-Number: AS0 ([] [--] [192.168.44.5])
X-Greylist-Delay: WHITELISTED Local IP, transport not delayed by extensible-milter-7.178s

Hi there,

In the document at

https://netfilter.org/projects/libnetfilter_queue/doxygen/html/group__tcp.html#ga66fd94158867c63be8e4104d84050ac4

1. At the top of the page it mentions a diagram, but I don't see anything
in my browsers.  Have I missed something?

2. Each section covering a function mentions the function name three times.

Except in the section for the function

nfq_tcp_snprintf

which at the third attempt actually calls it

nfq_pkt_snprintf_tcp_hdr

and which had me confused for a while.

3. It also spells "human" as "humnan". :/

-- 

73,
Ged.
