From: Patrick McHardy <kaber@trash.net>
Subject: Re: [iptables PATCH trunk7285 1/7] manpage fixes
Date: Tue, 29 Jan 2008 14:25:08 +0100
Message-ID: <479F2934.5090106@trash.net>
References: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net> <20080127182503.15959.60931.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54913 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933171AbYA2NlG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:41:06 -0500
In-Reply-To: <20080127182503.15959.60931.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> ---
> 
>  extensions/libipt_REDIRECT.man |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/extensions/libipt_REDIRECT.man b/extensions/libipt_REDIRECT.man
> index 93e2982..72f1d4d 100644
> --- a/extensions/libipt_REDIRECT.man
> +++ b/extensions/libipt_REDIRECT.man
> @@ -7,8 +7,7 @@ and
>  chains, and user-defined chains which are only called from those
>  chains.  It redirects the packet to the machine itself by changing the
>  destination IP to the primary address of the incoming interface
> -(locally-generated packets are mapped to the 127.0.0.1 address).  It
> -takes one option:
> +(locally-generated packets are mapped to the 127.0.0.1 address).

Applied.
