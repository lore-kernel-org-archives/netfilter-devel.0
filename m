From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] proto: fix VLAN header definition
Date: Fri, 27 Nov 2015 09:54:24 +0000
Message-ID: <20151127095424.GF4263@macbook.localdomain>
References: <1448615614-16510-1-git-send-email-kaber@trash.net>
 <20151127094958.GB15392@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44922 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbbK0Jy3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 04:54:29 -0500
Content-Disposition: inline
In-Reply-To: <20151127094958.GB15392@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27.11, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > The VID is located after Priority and CFI.
> 
> With this patch matching on vlan id does not work for me anymore
> on x86-64.
> 
> With trace-patch nft but without this patch:
> 
> table bridge filter {
> chain input {
>    type filter hook input priority -200; policy accept;
>    vlan id 4094 counter packets 827 bytes 63839
> 
> With this patch, the counters remain at zero:
> 
> unknown unknown & 0xfff [invalid type] == 0xffe [invalid type] counter packets 850 bytes 65375
> vlan id 4094 counter packets 0 bytes 0
> 
> (The 'unknown unknown' line is the 'old' vlan rule added by unpatched
>  nft binary, the 'vlan id' is the one added with the patched one).

Odd, since it decodes correctly. Could you send the output of
nft --debug=netlink with and without the patch?
