From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/7] autotools conversion: include the header 'config.h'
 in every C source file.
Date: Thu, 10 Jul 2014 12:04:09 +0200
Message-ID: <20140710100409.GA13741@macbook.localnet>
References: <1404742796-8039-1-git-send-email-giorgio.nicole@arcor.de>
 <1404742796-8039-5-git-send-email-giorgio.nicole@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43652 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaGJKES (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:04:18 -0400
Content-Disposition: inline
In-Reply-To: <1404742796-8039-5-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 07, 2014 at 04:19:28PM +0200, Giorgio Dal Molin wrote:
> Added an #include <config.h> to all the C source files so that the results
> of the tests in the configure script are available to all the compilation
> units.
> 
> We could have added the include also to 'yacc_parser.y' and 'scanner.l'
> but we don't, because it is not strictly needed and to avoid to define
> the variable 'VERSION' two times.

> --- a/src/cli.c
> +++ b/src/cli.c
> @@ -11,6 +11,9 @@
>   *
>   * Development of this code funded by Astaro AG (http://www.astaro.com/)
>   */
> +#ifdef HAVE_CONFIG_H
> +#include <config.h>
> +#endif

Do we really need those ifdefs?
