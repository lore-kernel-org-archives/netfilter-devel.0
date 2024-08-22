Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F26C1C9429
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Aug 2024 12:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724330746; cv=none; b=c6U40Q6lGGZDeTmSmKdYHt1ACeKG3613Ks1HkM1r93a9R2nuWryZB+PdrZC4irUcdJfU5KMtifG0WRuTAqMOEeqis4pC7Dof/snz57KZjz7FpwA3FNQnlb+qqbBYntBzwDz2BiHA9Scf6+CPOf49zMMD1LYHOSPtBDBdyQES4MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724330746; c=relaxed/simple;
	bh=eNkcw5f455DtEXqF2GXQ9H0Q2Cc8prRopoGjm5X2cWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hu+cb8rKsWxSiarPqkqsd5fO6iFgKVuXBGN0E/baG5L2MBcOyrTHNjSgqzwrWDfMlRcSc5vZXGYdQ7bNZNT2FFTeBecyzJXsFMKhdwV7v62O5xlakGC2wa2R3z93TvIDK7mi04mOUobQdzvi5VDGW9rmCb/2a1BI7HSaHfKOYH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-533462b9428so1283180e87.3
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Aug 2024 05:45:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724330743; x=1724935543;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XXjUvWDLFGNFcuNESt6IbmwSzazSW9wUZAitsWCeVDY=;
        b=ZxFN+k2d5T/JZK1ZD5VT6Viis7Mm5XZQk6gEKw+fEkzb2RdZTLqEzH45AYDDSchuHF
         WqhuSzNh8BcY3d+DvJCeDySUSdRkFPP/dxIIaP0lO7ANZHhPnscW7/CNA99OtWVulqv8
         wt03OJCwW/6iLixNaUQv5xqVAVgiTd1Gl3SKRQsWd4CEUmMxKAxukx8zrQ4hZXOWyJ3/
         3+WY2Arf+maqKucpQSseuvGclEU/kWfLuPU7oNI+C8RwbWlWL1SrNFfEUFjDE8Aepv+q
         +RIOiwVz6thnopmK+L7J7RmJuMfoxnK7BnJD1w+GhTgu/vSTSfwmt/f5rZimE9UUN0dS
         EHvg==
X-Forwarded-Encrypted: i=1; AJvYcCWKqq1bMvixQEUY5WL+vykjewIGqL9uMfk5q1X3g0OGiXo/qhjAzwl3oI3550OzevDvo3XrOOK3zEZQlUURG8k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgsTyv6jKHKdzXCfhW59vMRLUVStlTNuwfOk3O64p/6UbDLXwm
	9ZviLz5WI23j8ODCiTeHtVsf+LaDgQZbq23pArxPyzBhnGlBrm0e
X-Google-Smtp-Source: AGHT+IHODAsMXrfbqrWDm9zpp79FA6/iTVBKPmzLAW4D4yuohPq+db7aQVBybTnMurm8xkiS8SF+kA==
X-Received: by 2002:a05:6512:3051:b0:533:4785:82ab with SMTP id 2adb3069b0e04-5334fae3daamr1349490e87.1.1724330741998;
        Thu, 22 Aug 2024 05:45:41 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-001.fbsv.net. [2a03:2880:30ff:1::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f2200f3sm116382966b.45.2024.08.22.05.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2024 05:45:41 -0700 (PDT)
Date: Thu, 22 Aug 2024 05:45:39 -0700
From: Breno Leitao <leitao@debian.org>
To: Florian Westphal <fw@strlen.de>
Cc: rbc@meta.com, netfilter-devel@vger.kernel.org
Subject: Re: netfilter: Kconfig: IP6_NF_IPTABLES_LEGACY old =y behaviour
 question
Message-ID: <Zscy83HM2TlwkSDq@gmail.com>
References: <Zsb+YHrLklrTCrly@gmail.com>
 <20240822112339.GA21472@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822112339.GA21472@breakpoint.cc>

Hello Florian,

On Thu, Aug 22, 2024 at 01:23:39PM +0200, Florian Westphal wrote:
> Breno Leitao <leitao@debian.org> wrote:
> > Hello Florian,
> > 
> > I am rebasing my workflow in into a new kernel, and I have a question
> > that you might be able to help me. It is related to
> > IP6_NF_IPTABLES_LEGACY Kconfig, and the change in a9525c7f6219cee9
> > ("netfilter: xtables: allow xtables-nft only builds").
> > 
> > In my kernel before this change, I used to have ip6_tables "module" as
> > builtin (CONFIG_IP6_NF_IPTABLES=y), and all the other dependencies as
> > modules, such as IP6_NF_FILTER=m, IP6_NF_MANGLE=m, IP6_NF_RAW=m.
> > 
> > After the mentioned commit above, I am not able to have ip6_tables set
> > as a builtin (=y) anymore, give that it is a "hidden" configuration, and
> > the only way is to change some of the selectable dependencies
> > (IP6_NF_RAW for insntance) to be a built-in (=y).
> > 
> > That said, do you know if I can keep the ip6_tables as builtin without
> > changing any of the selectable dependencies configuration. In other
> > words, is it possible to keep the old behaviour (ip6_table builtin and
> > the dependenceis as modules) with the new IP6_NF_IPTABLES_LEGACY
> > configuration?
> 
> No.  But why would you need it?

In certain environments, iptables needs to run, but there is *no*
permission to load modules.

For those cases, I have CONFIG_IP6_NF_IPTABLES configured as y in
previous kernels, and now it becomes a "m", which doesn't work because
iptables doesn't have permission to load modules, returning:

	$ ip6tables -L
	modprobe: FATAL: Module ip6_tables not found in directory /lib/modules/....
	ip6tables v1.8.10 (legacy): can't initialize ip6tables table `filter': Table does not exist (do you need to insmod?)
	Perhaps ip6tables or your kernel needs to be upgraded.

> You could make a patch for nf-next that exposes those symbols as per description
> in a9525c7f6219cee9284c0031c5930e8d41384677, i.e. with 'depends on'
> change.

Sure, I am happy to do it, but I would like to understand a bit better
before. Does it mean we make IP_NF_IPTABLES_LEGACY selectable by the
user, and changes the dependable configs from "selects" to "depends on"?
Something as the following (not heavily tested)?

Thanks for the quick answer!
--breno

Author: Breno Leitao <leitao@debian.org>
Date:   Thu Aug 22 05:35:41 2024 -0700
    netfilter: Make IP_NF_IPTABLES_LEGACY selectable
    
    This option makes IP_NF_IPTABLES_LEGACY user selectable, giving
    users the option to configure iptables without enabling any other
    config.
    
    Suggested-by: Florian Westphal <fw@strlen.de>
    Signed-off-by: Breno Leitao <leitao@debian.org>

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 1b991b889506..b5ff14a5272a 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -12,7 +12,11 @@ config NF_DEFRAG_IPV4
 
 # old sockopt interface and eval loop
 config IP_NF_IPTABLES_LEGACY
-	tristate
+	tristate "Legacy IP tables support"
+	default	n
+	select NETFILTER_XTABLES
+	help
+	  iptables is a general, extensible packet identification legacy framework.
 
 config NF_SOCKET_IPV4
 	tristate "IPv4 socket lookup support"
@@ -177,7 +181,7 @@ config IP_NF_MATCH_TTL
 config IP_NF_FILTER
 	tristate "Packet filtering"
 	default m if NETFILTER_ADVANCED=n
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  Packet filtering defines a table `filter', which has a series of
 	  rules for simple packet filtering at local input, forwarding and
@@ -217,7 +221,7 @@ config IP_NF_NAT
 	default m if NETFILTER_ADVANCED=n
 	select NF_NAT
 	select NETFILTER_XT_NAT
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  This enables the `nat' table in iptables. This allows masquerading,
 	  port forwarding and other forms of full Network Address Port
@@ -258,7 +262,7 @@ endif # IP_NF_NAT
 config IP_NF_MANGLE
 	tristate "Packet mangling"
 	default m if NETFILTER_ADVANCED=n
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
 	  iptables(8).  This table is used for various packet alterations
@@ -293,7 +297,7 @@ config IP_NF_TARGET_TTL
 # raw + specific targets
 config IP_NF_RAW
 	tristate  'raw table support (required for NOTRACK/TRACE)'
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `raw' table to iptables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
@@ -305,9 +309,7 @@ config IP_NF_RAW
 # security table for MAC policy
 config IP_NF_SECURITY
 	tristate "Security table"
-	depends on SECURITY
-	depends on NETFILTER_ADVANCED
-	select IP_NF_IPTABLES_LEGACY
+	depends on SECURITY && NETFILTER_ADVANCED && IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `security' table to iptables, for use
 	  with Mandatory Access Control (MAC) policy.
