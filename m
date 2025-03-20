Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F201E9B1D
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 18:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742494563; cv=none; b=hkiI5bI8Drt1tcaQyggfuicpDCOaCG3H1FKgVLnLhMe16airPggAzXZdnQ+tqsK3Xy0IsIaLLocVndlhiiJZq5DVwIMQB8Yr+I9spYG6mej8sQSCOSbTKdkmdPqE3it3OPbzfIf9WfehQTHsDqR1NHgjXYxJm71VuNMfo2cjYMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742494563; c=relaxed/simple;
	bh=GWHb5KM0EKbpnAhWXZzod2PxpisGR92kpfyIWRw049w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FPPiNA3wagVByGPp5LXO5DZfBPCjZnoS7iYuXFdwuaU3WWlxCI3Yut3qQG27h34ZteLciqB7VQm/xbqNX1GZ8AcILQfQ4CBbx68yqevOcdx3rF+J0PJeevDrhobUd1i/CwEgHMNvf6egmjEPCCnVoC/HpdGHtG9bjTocIuUAUpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UkPbjaGe; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RMpfencd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UkPbjaGe";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RMpfencd"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 563136054E; Thu, 20 Mar 2025 19:15:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742494554;
	bh=2KzjXEjMa+avuj8T7vgroQCu591s8RGKIT9fRQCvdRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UkPbjaGeb7/XqhhJMGju4fwJICMq6YJLApiqWroE0k2C8xKPXeswNcmECSrf+Eds7
	 g7NW/IemAtb2SsMECiOaaqaBEaUXpMqtUK+9K1QQkC0yg7iAI57u9pJocWtJEWR1DN
	 yJox/OYf6/Ib/e7ak5lvke0FpUwle/VtW/1oChg1VmKStWioxdBI2iawEw0IwhOu7T
	 ooHzi/SH7cQ3LNDY0wIzqlNwAqIE+kw8FfEZhKsbHplU+ckY4A89s/846MInLNTRo7
	 Qb4/OPT1ZFt05+G+tMKFmrNlhIrO81R1/hfQ7LjI1+4VJ9m88kr+CvjZiFRFCWLFyH
	 Hy3OuJGmf3Swg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AEE616054E;
	Thu, 20 Mar 2025 19:15:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742494553;
	bh=2KzjXEjMa+avuj8T7vgroQCu591s8RGKIT9fRQCvdRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RMpfencd78K+WWF2MK6Fawom03kIeORoS3tTc4KBsVSfWc4IxXcog1T7320449S0G
	 5QbG9qp1tBU0eXXSprAxrAOFBAPXCvwLwsqVlIyTfjBveXtzb73B8RUYfYFgWuHb4u
	 14a2zWuvwOu5APpGig5L+2HOc3MLQW6zztwVotvDtpLMin/xoPKj31rxeq1aOYZa1I
	 /2UxiUkm4orelcEDLy/yJXYj2mOeOoipNLvtIEz5hlFNOmCzau61gsXpwNDISonXAw
	 NwO0VnXM4sLW5PHKhaaakDKTE0kf+MY/I7JnRrGMjF8etY8ZxPhZEMetTI4AKHDt/L
	 Y/luvKNig+aaQ==
Date: Thu, 20 Mar 2025 19:15:51 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: fix assertion failure with malformed map
 definitions
Message-ID: <Z9xbV0zU1Q1N-VmU@calendula>
References: <20250320133308.31925-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250320133308.31925-1-fw@strlen.de>

TLDR; patch is fine with me.

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

On Thu, Mar 20, 2025 at 02:33:05PM +0100, Florian Westphal wrote:
> diff --git a/tests/shell/testcases/bogons/nft-f/malformed_map_expr_evaluate_mapping_assert b/tests/shell/testcases/bogons/nft-f/malformed_map_expr_evaluate_mapping_assert
> new file mode 100644
> index 000000000000..c77a9c33e0ad
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-f/malformed_map_expr_evaluate_mapping_assert
> @@ -0,0 +1,6 @@
> +table ip x {
> +        map m {
> +                typeof ct saddr :ct expectation

Longer story: This is declaration is "correct".

Actually, ct saddr is broken because it is ambiguous, it is there in
the parser for "backwards compatibility", IIRC it can be only used
sanely from rules, ie. ct saddr cannot be used from set/map,
ct original ip saddr should be used instead.

The problem with ct saddr is that length depends on the context, and
having a key with variable size is problematic, the assumption here is
that all keys have fixed size.

> +                elements = { * : none}
> +        }
> +}

This variant bails out correctly:

table ip x {
        map m {
                typeof ct original ip saddr : ct expectation
                elements = { * : none}
        }
}

/tmp/k:4:30-30: Error: Could not process rule: No such file or directory
                elements = { * : none}

because "none" ct expectation object does not exist.
