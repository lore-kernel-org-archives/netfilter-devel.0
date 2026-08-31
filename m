Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70ED3905E7
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2026 14:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788187787; cv=none; b=f83jdNPPIMQVBqz4fetouwTHOFFj/GBL+jSq1EsOHfdITMiJR0mjMdmT16v5FqciAT8trqn5YfxO61+8a1ckBaO2MqVP5XE/7C4qkxI0Kd4G0Z/XM0Kf1+2/d9Ako9XMjQDvxI+H8bvczsgVs30RGXKPB4T5ofFohkx6f54v74E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788187787; c=relaxed/simple;
	bh=ZUW+KCOdszvbx9Ej8rERt+SSqAAHX2bCSSPRqja00D0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=plbieDY1EJkviFLjtzUnYJRETWk7jRJr6fePZbEBnn8oCIzdICz8d5e5fKfvU9CZlluQvuO2V2dobuhH+4EfdQF5kwXCJiRCHp91zpLhcHFocAcKE8rFwAlpxvRwhcUniNT2sQYJvWJBUSYLQcKTaAGDplQhOGfKlWpNBxvofIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AC2EF602F5; Mon, 31 Aug 2026 16:49:36 +0200 (CEST)
Date: Mon, 31 Aug 2026 16:49:34 +0200
From: Florian Westphal <fw@strlen.de>
To: Nikolay Aleksandrov <razor@blackwall.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf] netfilter: disable br_netfilter in user namespaces
Message-ID: <apWUfi8yTkf1_nJ1@strlen.de>
References: <20260827181431.21720-1-fw@strlen.de>
 <347de812-4502-4f40-9d8e-028ec8ea35c1@blackwall.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <347de812-4502-4f40-9d8e-028ec8ea35c1@blackwall.org>

Nikolay Aleksandrov <razor@blackwall.org> wrote:
> The patch looks good, thanks!
> 2 minor nits:
> BROPT_NF_CALL_IPTABLES is per bridge, not per port. Also please update the
> Netfilter section of Documentation/networking/bridge.rst that it won't work
> in non-init ns and is scheduled for removal.

This sound good to you?

 The bridge netfilter module is a legacy feature that allows to filter bridged
-packets with iptables and ip6tables. Its use is discouraged. Users should
-consider using nftables for packet filtering.
+packets with iptables and ip6tables. This feature is scheduled for removal and
+not available in user namespaces. Consider using nftables for packet filtering
+instead.

Thanks!
