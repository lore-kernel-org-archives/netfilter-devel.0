Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67750469D
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 00:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748393205; cv=none; b=oIjVdCZPWGPk32ofRvmk6cq5O072Hipe9t9hdyYiIdcXPkINhdR6eNXCfbs8cUoKgzqHib/r/oyoqY0zz38cluT/9anIzCfep0GXvSIGQZDzS3IY/37cFjZmzEEU7WIDSsXVOVFeK0VO0zWeVcKk4Fc3Ka/yGprM4CKF+qnD6cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748393205; c=relaxed/simple;
	bh=yFrq2WpJVeFBTw6GEKHeN3lnJBAvkKudgnFxJ0jIOfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QygMIKlUrFRVPf1b1vPH7fPINm/XABCFvGMTdrNx7V5AedsPunow9/Vf2oRFN+7DuDHmO40xtf6KH3XPQgURjgFJRTmx1weMgoXz3oww7+Of6/FTvEa/682MqRiekiA9OUwnIU5X+k1e8p9b0q9PHuiFFTgm/yeF/HdA8U1tl8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F28A66043E; Wed, 28 May 2025 02:46:40 +0200 (CEST)
Date: Wed, 28 May 2025 02:46:02 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/7 nft] tunnel: add erspan support
Message-ID: <aDZcyv8zZJh-fpzB@strlen.de>
References: <cover.1748374810.git.fmancera@suse.de>
 <ae88d3525c46a523e1b8a0b97450225804033014.1748374810.git.fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae88d3525c46a523e1b8a0b97450225804033014.1748374810.git.fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> This patch extends the tunnel metadata object to define erspan tunnel
> specific configurations:
> 
>  table netdev x {
>         tunnel y {
>                 id 10
>                 ip saddr 192.168.2.10
>                 ip daddr 192.168.2.11
>                 sport 10
>                 dport 20
>                 ttl 10
>                 erspan {
>                         version 1
>                         index 2
>                 }
>         }
>  }

Would it make sense to make this

tunnel erspan y {
                 id 10
                 ip saddr 192.168.2.10
                 ip daddr 192.168.2.11
                 sport 10
                 dport 20
                 ttl 10
                 version 1
                 index 2
}

Or was the sub-section intentional to cleanly separate the common parts
from the tunnel specific knobs?

In that case, maybe 'tunnel y {
	...
	type erspan { ... '?

Or do you think its unecessarily verbose?

I think it might be good to make it clear that this is an either-or thing
and multiple 'type' declarations aren't permitted.

Or are there plans to support

table netdev x {
       tunnel y {
               id 10
               ip saddr 192.168.2.10
               ip daddr 192.168.2.11
               sport 10
               dport 20
               ttl 10
               erspan {
                       version 1
                       index 2
	       }
	       geneve {
		...
?
