From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH 2/4] ipt_set: fix a typo in the manpage
Date: Thu, 20 Aug 2009 09:47:32 -0700
Message-ID: <20090820164732.GA27954@linuxace.com>
References: <1250780978-14013-1-git-send-email-jengelh@medozas.de> <1250780978-14013-3-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:56431
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754884AbZHTQyM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2009 12:54:12 -0400
Content-Disposition: inline
In-Reply-To: <1250780978-14013-3-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 20, 2009 at 05:09:36PM +0200, Jan Engelhardt wrote:
> From: Trent W. Buck <trentbuck@gmail.com>
> 
> References: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=539101
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  extensions/libipt_set.man |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/extensions/libipt_set.man b/extensions/libipt_set.man
> index 6df6b29..455706c 100644
> --- a/extensions/libipt_set.man
> +++ b/extensions/libipt_set.man
> @@ -1,4 +1,4 @@
> -This modules macthes IP sets which can be defined by ipset(8).
> +This modules matches IP sets which can be defined by ipset(8).

While in there, modules should be singular.  

Phil
