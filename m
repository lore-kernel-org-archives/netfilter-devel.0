From: Patrick McHardy <kaber@trash.net>
Subject: Re: Guided option parser
Date: Tue, 12 Apr 2011 16:11:12 +0200
Message-ID: <4DA45D80.8030301@trash.net>
References: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51153 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab1DLOL0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:11:26 -0400
In-Reply-To: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06.04.2011 13:31, Jan Engelhardt wrote:
> This is a staggered submit, with 10 patches in the first submission.
> See 01/10 for a description.
> 
> Currently, the entire set of 64 has a diffstat of
> 
>  74 files changed, 2845 insertions(+), 4062 deletions(-)
> 
> this is roughly a third of the entire work, and it is expected this
> to linearly continue until ~200 patches. But I felt I needed to flush
> the queue now.
> 
> ===
> The following changes since commit a239728ec064666025de2723997d87b176d57fd6:
> 
>   mark newly opened fds as FD_CLOEXEC (close on exec) (2011-04-04 15:30:32 +0200)
> 
> are available in the git repository at:
>   git://dev.medozas.de/iptables opts
> 
> Jan Engelhardt (10):
>       extensions: add missing checks for specific flags (2)
>       libxtables: guided option parser
>       libxt_CHECKSUM: use guided option parser
>       libxt_socket: use guided option parser
>       libxtables: provide better final_check
>       libxt_CONNSECMARK: use guided option parser
>       libxtables: XTTYPE_UINT32 support
>       libxt_cpu: use guided option parser
>       libxtables: min-max option support
>       libxt_cluster: use guided option parser

Looks good to me. Pulled, thanks Jan.
