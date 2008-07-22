From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/7] netfilter: Export ip6t_mh.h and xt_quota.h for
 iptables build
Date: Tue, 22 Jul 2008 10:55:18 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807221054430.23410@fbirervta.pbzchgretzou.qr>
References: <E1KKl4I-00068B-LW@swissweb.swissdisk.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Tim Gardner <tim.gardner@canonical.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44258 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbYGVIzU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:55:20 -0400
In-Reply-To: <E1KKl4I-00068B-LW@swissweb.swissdisk.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-01-02 16:57, Tim Gardner wrote:

>Export ip6t_mh.h and xt_quota.h for        
>          iptables build
>
>CC: netfilter-devel@vger.kernel.org
>Signed-off-by: Soren Hansen <soren@ubuntu.com>
>Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
>Signed-off-by: Ben Collins <ben.lcollins@canonical.com>


They are not needed for iptables, which has its own copy of
the headers.
