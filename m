From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] extensions: restore matching any SPI id by default
Date: Wed, 15 Jul 2015 18:24:42 +0200
Message-ID: <20150715162442.GA22476@salvia>
References: <1436964819-28109-1-git-send-email-jengelh@inai.de>
 <1436964819-28109-3-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45490 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbbGOQTA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 12:19:00 -0400
Content-Disposition: inline
In-Reply-To: <1436964819-28109-3-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 15, 2015 at 02:53:39PM +0200, Jan Engelhardt wrote:
[...]
> diff --git a/extensions/libxt_esp.t b/extensions/libxt_esp.t
> index 008013b..f207def 100644
> --- a/extensions/libxt_esp.t
> +++ b/extensions/libxt_esp.t
> @@ -4,6 +4,7 @@
>  -p esp -m esp --espspi 0:4294967295;-p esp -m esp;OK
>  -p esp -m esp ! --espspi 0:4294967294;=;OK
>  -p esp -m esp --espspi -1;;FAIL
> +-p esp -m esp;-p esp -m esp --espspi 0;FAIL
>  # should fail?
>  -p esp -m esp;=;OK

This line looks very similar to the one above the comment, but it says OK.
