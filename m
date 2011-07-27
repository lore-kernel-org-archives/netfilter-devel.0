From: Patrick McHardy <kaber@trash.net>
Subject: Re: CONFIG_NF_CT_ACCT is deprecated
Date: Wed, 27 Jul 2011 17:32:45 +0200
Message-ID: <4E302F9D.10905@trash.net>
References: <A8D937F560604292AD4B589CCF3D72BF@poweredge1800>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: "Julio A. Romero" <julioarr@fisica.uh.cu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43260 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1G0Pcs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:32:48 -0400
In-Reply-To: <A8D937F560604292AD4B589CCF3D72BF@poweredge1800>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.07.2011 19:55, Julio A. Romero wrote:
> Messages produced during the boot sequence of my debian system
> (squeeze, linux-image-2.6.32-5-amd64      2.6.32-35)
> syslog:
> 
> 
> Jul 26 11:47:16 firewall kernel: [   11.465366] ip6_tables: (C)
> 2000-2006 Netfilter Core Team
> Jul 26 11:47:16 firewall kernel: [   11.563280] ip_tables: (C) 2000-2006
> Netfilter Core Team
> Jul 26 11:47:16 firewall kernel: [   11.621776] nf_conntrack version
> 0.5.0 (3846 buckets, 15384 max)
> Jul 26 11:47:16 firewall kernel: [   11.622349] CONFIG_NF_CT_ACCT is
> deprecated and will be removed soon. Please use
> Jul 26 11:47:16 firewall kernel: [   11.622354] nf_conntrack.acct=1
> kernel parameter, acct=1 nf_conntrack module option or
> Jul 26 11:47:16 firewall kernel: [   11.622357] sysctl
> net.netfilter.nf_conntrack_acct=1 to enable it.
> 
> 
> What's that? and What should I do at respect?

Exactly what it says in the message, use the module parameter or sysctl
to enable conntrack accounting.
