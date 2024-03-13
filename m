Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB26947A55
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 15:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710342127; cv=none; b=VNR4X/9JV7mhsU2q1s60HfrWmT6c1nhs6oOVkCgX/DqXZ/piO8/5D9rYAxkqxVcSXAn2FURO0y3itktjxp4b++tBrVzz89/akK+C7bbaRnBhPHKobytnFGIqqMl1XuF44ORz6Q9cc17GWy5Rk3Om2REYsbRy0N8hAF8PebgNU6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710342127; c=relaxed/simple;
	bh=LfBUZwMv7k0+STqXUJ28zpyi4A9Qg2ljWDnAGL3OJrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j4xLkaE6CqHZnqAJahqcNay0bgWlIG6XjXtCvPZtZsHzYuvs2fr6hH+zab1CgaUFlS4GyO07BIlK6Dqs68CHfKVlctn3Ytx4TbzIwXvU+bL28d5EmWpltdC783sdQKlqcdG1TdaAi3PTwB7WlqirZ7xkofTFQXMwmmN+C54NmSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rkQ7H-00007Y-2X; Wed, 13 Mar 2024 16:02:03 +0100
Date: Wed, 13 Mar 2024 16:02:03 +0100
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: Sven Auhagen <sven.auhagen@voleatech.de>,
	netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: Flowtable race condition error
Message-ID: <20240313150203.GE2899@breakpoint.cc>
References: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
 <20240313145557.GD2899@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240313145557.GD2899@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> No idea, but it was intentional, see
> b6f27d322a0a ("netfilter: nf_flow_table: tear down TCP flows if RST or FIN was seen")

Maybe:

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -28,10 +28,8 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
 		return 0;
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
-	if (unlikely(tcph->fin || tcph->rst)) {
-		flow_offload_teardown(flow);
+	if (unlikely(tcph->fin || tcph->rst))
 		return -1;
-	}
 
 	return 0;
 }

?

This will let gc step clean the entry from the flowtable.
