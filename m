From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] proto: fix VLAN header definition
Date: Fri, 27 Nov 2015 10:49:58 +0100
Message-ID: <20151127094958.GB15392@breakpoint.cc>
References: <1448615614-16510-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38608 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754436AbbK0JuB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 04:50:01 -0500
Content-Disposition: inline
In-Reply-To: <1448615614-16510-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> The VID is located after Priority and CFI.

With this patch matching on vlan id does not work for me anymore
on x86-64.

With trace-patch nft but without this patch:

table bridge filter {
chain input {
   type filter hook input priority -200; policy accept;
   vlan id 4094 counter packets 827 bytes 63839

With this patch, the counters remain at zero:

unknown unknown & 0xfff [invalid type] == 0xffe [invalid type] counter packets 850 bytes 65375
vlan id 4094 counter packets 0 bytes 0

(The 'unknown unknown' line is the 'old' vlan rule added by unpatched
 nft binary, the 'vlan id' is the one added with the patched one).
