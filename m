From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 12/24] [NETFILTER]: xt_recent: IPv6 support
Date: Thu, 03 Apr 2008 15:24:33 +0200
Message-ID: <47F4DA91.2080108@trash.net>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <2719780f6463107cf0a6097799f042d5d4062d59.1207134547.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34499 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758739AbYDCNYi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:24:38 -0400
In-Reply-To: <2719780f6463107cf0a6097799f042d5d4062d59.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> This updates xt_recent to support IPv6 handling. It is sort of a flag
> day, as the new control directory is /proc/net/xt_recent with a new,
> more strict protocol (the string you ought to write into
> /proc/net/xt_recent/LIST). But on the other hand, I kept the binary
> interface towards iptables (which is quite memory consuming I must
> say) to keep the patch small.

No flag days please, either keep ipt_recent as compat interface
(in case you want to share lists) or do something like hashlimit
and add one file per family, but no xt_recent file.



