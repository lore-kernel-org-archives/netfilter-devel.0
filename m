Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F266E2367DF
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Aug 2025 15:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755878004; cv=none; b=CK/oDZ/oMJrmqJRpBJkK7mnf75KJJH7EhxcnKCDHlPL3PXYfRwNy2ZvCnDB2kGJEioBtNnLq1KkqCcA41OVfX88U4gMhtV1yw8+PvsG7/l8JdMk59T74pWmpzA/BmoXMDc6wGNpRFy8rznG3/x02jsbXx1xbMu6azGiWsnjsVmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755878004; c=relaxed/simple;
	bh=i9Egau1/qUTodPEEUXGKM3N9AujI11stn6UNnbB5pk0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Gu2k5PLv3d7d7q3aAAgQJ3AkWOPBg6DMZ3JYO2g/7ZvzUZJGo5r2WZ24iJQrqD2f2SVey+93+EKVgZsQpmKUafVZRVl6UYNjKDd3+n5LUvXeZCINNi1LwoeFWNIOBme5GJyMV1Suk7t98Qbyvp31FqQtsPDs0OGNOApkdqjH7/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=paupiland.net; spf=pass smtp.mailfrom=paupiland.net; arc=none smtp.client-ip=212.27.42.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=paupiland.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paupiland.net
Received: from askadice.com (unknown [82.65.66.232])
	(Authenticated sender: pmsmtplog3@free.fr)
	by smtp3-g21.free.fr (Postfix) with ESMTPSA id 1BA7613F8D5
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Aug 2025 17:53:10 +0200 (CEST)
Date: Fri, 22 Aug 2025 17:52:39 +0200
From: Pierre =?iso-8859-1?Q?Mazi=E8re?= <star+netfilterdevelml@paupiland.net>
To: netfilter-devel@vger.kernel.org
Subject: [ipset] Can't resolve domain names containing an hyphen "-"
Message-ID: <20250822155239.GA30578@askadice.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I might have found a bug in ipset domain name resolving code:


--------------------------------------------------------------
# ipset create testset hash:ip
# ipset add testset hyphen-containing.example.com
ipset v7.2x: Syntax error: cannot parse hyphen: resolving to IPv4 address failed
----------------------------------------------------------------

This is the output of ipset 7.22 in an up-to-date debian testing system as well
as of 7.24 directly compiled from the git repository.

The issue seems to be located in the parse_ipaddr function of
lib/parse.c: the function attempts to find if the string pointed by the str 
argument is a range of IPs containing IPSET_RANGE_SEPARATOR defined in 
include/libipset/parse.h as "-".
If IPSET_RANGE_SEPARATOR is found, it is replaced by '\0' which results
in the truncation of the string pointed by the str argument.
If the string is a domain name then the subsequent attempt to resolve it
fails because it is incomplete compared to what was passed initially to
the parse_ipaddr function.

I don't have any understanding of what is done before or after
this step. Therefore, if you consider this report as valid, I'll leave
to the relevant developer the task to fix this issue in the most secure
and appropriate way.

Many thanks to all involved developers and non developers for their work on 
this very important set of tools that is netfilter !

Pierre

