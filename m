From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables: expose option to zero packet and byte counters
 for a specific rule using iptables/ip6tables
Date: Wed, 18 Feb 2009 19:40:35 +0100
Message-ID: <499C5623.7060902@trash.net>
References: <4994336.27091234914681076.JavaMail.root@tahiti.vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Mohit Mehta <mohit.mehta@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59996 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbZBRSki (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:40:38 -0500
In-Reply-To: <4994336.27091234914681076.JavaMail.root@tahiti.vyatta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Mohit Mehta wrote:
> iptc_zero_counter/ip6tc_zero_counter are functions available in libiptc to zero counters for a rule in a given chain. However, this is not exposed in iptables/ip6tables. The patch below exposes the underlying function to the user to zero out packet and byte counters for a specific rule.

Exposing this seems useful, the patch doesn't apply to the
current git version though:

8 out of 9 hunks FAILED -- saving rejects to file ip6tables.c.rej
8 out of 9 hunks FAILED -- saving rejects to file iptables.c.rej

Please rediff your patch against the current tree.
