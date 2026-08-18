Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E322DC32E
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 13:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787058187; cv=none; b=E63Y2nlNOZyu82OMrA4wepAMQAdTfnEjAMP/KcU9t00PBaJcxh92J1Yra1SEGb03ztdduOfml7jJmtjfVipMSazHAZW8n+QGLmCG0RVUrYinXmxiD123bMzKDAtuZDkdJRSv8LHgl19RKE34go3k5R5YGozvsfHjIVvSY7Sq/K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787058187; c=relaxed/simple;
	bh=Ka2CS8pJdpTPnGzmBJmAC2l5a9ta18uIxpM1C6+YD0s=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Z/765ffvrPVx8tuFGkVK4YYg/uaBmanUiwHfNlyd90iQ/tcPkbSRLlVuyI4+C4vNiJpmAWJYA2osHMMHGLCuYxWKLhoVaZT/3A6SSbzIFHU1XgFIruqn4mVpPu297+qK0QjwhjdlRUugQDzAapu6dAWc0OQvtNR5RFAe7ccRYjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 23A5A1003C512E; Tue, 18 Aug 2026 14:55:35 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 235D41100AF012;
	Tue, 18 Aug 2026 14:55:35 +0200 (CEST)
Date: Tue, 18 Aug 2026 14:55:35 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: netfilter-devel@vger.kernel.org, fw@strlen.de, fmancera@suse.de
Subject: Re: [PATCH nf-next 3/4] netfilter: x_tables: do not print specified
 table
In-Reply-To: <20260818122741.1329660-3-pablo@netfilter.org>
Message-ID: <8q4r3s01-nr0n-5on1-1s49-n37p56q00327@vanv.qr>
References: <20260818122741.1329660-1-pablo@netfilter.org> <20260818122741.1329660-3-pablo@netfilter.org>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Tuesday 2026-08-18 14:27, Pablo Neira Ayuso wrote:

>This is defensive, possibly this string has been already been sanitized
>but simply print that this match/target extension can only be used for a
>given table.

>@@ -95,8 +95,7 @@ static int rpfilter_check(const struct xt_mtchk_param *par)
> 
> 	if (strcmp(par->table, "mangle") != 0 &&
> 	    strcmp(par->table, "raw") != 0) {
>-		pr_info_ratelimited("only valid in \'raw\' or \'mangle\' table, not \'%s\'\n",
>-				    par->table);
>+		pr_info_ratelimited("only valid in \'raw\' or \'mangle\' table\n");
> 		return -EINVAL;
> 	}

You have now robbed the user of information where the problem
originated from (and thus removed an avenue on further diagnosis /
remediation), which is one of the classic UI/UX sins[1].

(There should be countless webpages out there that can explain
better than me what's a good and what's a bad error message.)

The table names were historically static, and always valid. The only
requirement is that the string is \0-terminated. That should be true
even for nftables. The use of NLA_STRING for NFTA_TABLE_NAME should
enforce this at the netlink level already.

(Ironically, since C lacks a managed type like std::string, there is
less incentive to even have {ptr, len}-type string objects/views.)
