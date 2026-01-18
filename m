Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E812D5B5AB
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Jan 2026 12:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768738982; cv=none; b=dXRzuNAoQ+xytD7cII6yn0hSFX6sZJDewH3ZYKLtf5F7NuZlt4e8wHrYmsDKU9yoFZtW8WvIoHAtVavJi4FtyhYSAOVUDm8hRNPpTh8jIpgfXFyfuWXo/rJaIwCpEQBMcbidTviB0G6Rjove6uhXvNOZf14tWiPVIrTUVvtzFkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768738982; c=relaxed/simple;
	bh=Xtdw1DTIXFEjtQI2XQ4YU77Oyub6RShFfRvuYY69yfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=igKothTXphcBThbHzNPEZ29Cg42tMwcqo9hpe70TVobEe9kdHadc0TIljQzkfEiGpwX2G3SBLEGjpjH+8xcQ6RORMjG6UIHbld18hITdVp37Tm6Dn8J7C6jxu8SQsPCedOzNFH6ogTKbSv+9ozD2/qSsuOgudMFXYygZva5N5xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 58D50602D9; Sun, 18 Jan 2026 13:22:57 +0100 (CET)
Date: Sun, 18 Jan 2026 13:22:56 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, phil@nwl.cc,
	Michal Slabihoudek <michal.slabihoudek@gooddata.com>
Subject: Re: [PATCH nf-next] netfilter: nf_conncount: fix tracking of
 connections from localhost
Message-ID: <aWzQoFTl6Cf4Vt3T@strlen.de>
References: <20260118111316.4643-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260118111316.4643-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> Since commit be102eb6a0e7 ("netfilter: nf_conncount: rework API to use
> sk_buff directly"), we skip the adding and trigger a GC when the ct is
> confirmed. For connections originated from local to local it doesn't
> work because the connection is confirmed from a early stage, therefore
> tracking is always skipped.

Alternative:

@@ -415,7 +415,7 @@ insert_tree(struct net *net,
                        if (ret && ret != -EEXIST)
                                count = 0; /* hotdrop */
                        else
-                               count = rbconn->list.count;
+                               count = rbconn->list.count ? rbconn->list.count : 1;

?

connlimit for localhost connections only works correctly in output or
postrouting, even before any of your changes.

As you say; for local connections, confirmation happens in postrouting,
i.e., before prerouting rules are evaluated.

Hence, even before any of your changes, the conntrack limit is never
effective because the connections are confirmed before.
In the reported example, its no problem to create 1000k connections,
500 will go through, rest will eventually time out.  But they are
created.

AFAICS the problem is erroneous trigger of "hotdrop" mode.  First
connection attempt allocates new node, with count == 1.

Subsequent attempt encounter -EEXIST check instead of add, then
return list length with is 0, not 1  so packet gets dropped.

Without your patches, connections won't complete once reaching
the limit, but the conntrack entries can be allocated and are confirmed
regardless of "-m connlimit".

Thus I'm not sold on this use case, it doesn't limit connections,
it only limits established ones.

If its legit case, then we should have a test case for this in
iptables.git .

That said, the patch looks correct to me.
