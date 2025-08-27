Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396032F0671
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 17:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756314772; cv=none; b=j3tgc5z8bF29awTv9ZOupMnSpDdkw0LGbsJ+yCrnQXQ6M14KfXKvKsZs2QGgwA1h+eTtualVUICHQErwXzNGephbWOHs4esWx2zo6IE/iCnb/cHFNpBpW24eqrgHP0olONVe0hTBoQoJSS4YaDfSRzthrwqFMRR0Nh8VjE3+pTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756314772; c=relaxed/simple;
	bh=ZWogo6P6XewIVL/kBzbMWVvqadBYKy2VRfLH5laLl2U=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=aojxftZgCbvd8UpC/NryRvKkyG4n7EMhIqwlE/M2/7lZqLC+t87RH5oKbHRM7Y38LMqYO/IljAui5CZYW+VxPKvBq0w67+gqtINO3pelBxvQoEI44IYni+GonQGkz6vREbxrID2JApzgzj1qAY7JbQn/6eCI8leV2gxu5Mm3d6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6AC8760224; Wed, 27 Aug 2025 19:12:41 +0200 (CEST)
Date: Wed, 27 Aug 2025 19:12:36 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: nftables monitor json mode is broken
Message-ID: <aK88hFryFONk4a6P@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

as subject says, 'nft monitor -j' is broken.
Example:

./run-tests.sh -j testcases/object.t
monitor: running tests from file object.t
monitor output differs!
--- /tmp/tmp.emU4zIN8UT/tmp.C4TeyO6xYk  2025-08-27 19:05:08.039619097 +0200
+++ /tmp/tmp.emU4zIN8UT/tmp.jBOL3aIrp5  2025-08-27 19:05:09.062551248 +0200
@@ -1 +1 @@
-{"delete": {"quota": {"family": "ip", "name": "q", "table": "t", "handle": 0, "bytes": 26214400, "used": 0, "inv": false}}}
+{"delete": {"quota": {"family": "ip", "name": "q", "table": "t", "handle": 0, "bytes": 0, "used": 0, "inv": false}}}
monitor output differs!
--- /tmp/tmp.emU4zIN8UT/tmp.C4TeyO6xYk  2025-08-27 19:05:10.095619097 +0200
+++ /tmp/tmp.emU4zIN8UT/tmp.Guz55knY19  2025-08-27 19:05:11.117393075 +0200
@@ -1 +1 @@
-{"delete": {"limit": {"family": "ip", "name": "l", "table": "t", "handle": 0, "rate": 1, "per": "second", "burst": 5}}}
+{"delete": {"limit": {"family": "ip", "name": "l", "table": "t", "handle": 0, "rate": 0, "per": "error"}}}

I did notice this weeks ago but thought it was a problem on my end
and then didn't have time to investigate closer.

But its in fact broken on kernel side, since

netfilter: nf_tables: Reintroduce shortened deletion notifications

In short, unlike the normal output, json output wants to dump
everything, but the notifications no longer include the extra data, just
the bare minimum to identify the object being deleted.

As noone has complained so far I am inclinded to delete the
tests and rip out json support from monitor mode, it seems noone
uses it or even runs the tests for it.

Alternatives i see are:
1. implement a cache and query it
2. rework the json mode to be forgiving as to what is set
   and what isn't in the object.

Object here also means any object reported in any delete kind,
not just NFT_MSG_DELOBJ.  This applies to set elements etc. too,
json expects the full info, but the kernel notifications no longer
provide this.

Alternative options?

Thanks.
