Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B9C3C09E5;
	Thu,  1 Oct 2026 19:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790882360; cv=none; b=FwgTvad8moG3Jpxm8us8ImNdY0iay1T2uqoX+teBUh34PjBx08rzPMBJH5L/qiSmscsiBOpdsui+hsrA7TqipkUHeEcW+pWjFCiphozY6QYRX24y4HP3J7KZ3VwfL50wgj+8CWtogaDdpy7tzj54v0M2CBPIs1R+ncFLQyh2fM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790882360; c=relaxed/simple;
	bh=zxLNp3mpFiQY+PN5X+F69Oy4UM3t/0mELZnPzN+fOTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eJEhlBFyGJJrc9aFw8SQho//D3WbCeZKzw4hEDjd+lMa2Cah84/HTj5/xeIgoqRyHOwf8snoS4UR/yf3vYmZzdfejplS/OrW70+BOrw4GtMGc3vz2foWrZ4EcFC3LVKPftVvd1GWLPRrpuWOgwrMMEBJkJ+aHyfsOu+VtjMFOlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8A1F860640; Thu, 01 Oct 2026 21:19:15 +0200 (CEST)
Date: Thu, 1 Oct 2026 21:19:15 +0200
From: Florian Westphal <fw@strlen.de>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: pablo@netfilter.org, phil@nwl.cc, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net] netfilter: conntrack: avoid recursive master
 destruction
Message-ID: <ar6yM0h2zdVUU4rt@strlen.de>
References: <20261001180224.1018290-1-4ncienth@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001180224.1018290-1-4ncienth@gmail.com>

Daehyeon Ko <4ncienth@gmail.com> wrote:
> Conntrack entries created through ctnetlink can reference another
> confirmed entry as their master.  There is no limit on the resulting
> chain depth.

I don't think this should be allowed.  I.e. (totally untested):

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2359,6 +2359,12 @@ ctnetlink_create_conntrack(struct net *net,
                        goto err2;
                }
                master_ct = nf_ct_tuplehash_to_ctrack(master_h);
+               if (master_ct->master) {
+                       nf_ct_put(master_ct);
+                       err = -EOPNOTSUPP;
+                       goto err2;
+               }
+
                __set_bit(IPS_EXPECTED_BIT, &ct->status);
                ct->master = master_ct;
