From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] autotools conversion: include the header 'config.h' in
 every C source file.
Date: Thu, 10 Jul 2014 16:54:26 +0200
Message-ID: <20140710145426.GA23419@localhost>
References: <20140710125245.GA10007@macbook.localnet>
 <1405001313-12902-1-git-send-email-giorgio.nicole@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39806 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaGJOye (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:54:34 -0400
Content-Disposition: inline
In-Reply-To: <1405001313-12902-1-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 10, 2014 at 04:08:08PM +0200, Giorgio Dal Molin wrote:
> Added an #include <config.h> to all the C source files so that the results
> of the tests in the configure script are available to all the compilation
> units.

I think we can avoid this by passing the configuration options to the
compiler via -D instead of via config.h file.

https://www.gnu.org/software/autoconf/manual/autoconf-2.65/html_node/Configuration-Headers.html

Any reason not to do it that way?

Thanks.
