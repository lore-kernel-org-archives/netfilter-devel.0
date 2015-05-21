From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] cthelper: don't pass up a 0 length queue
Date: Thu, 21 May 2015 15:18:33 +0200
Message-ID: <20150521131833.GA28917@salvia>
References: <1432129850.12119.27.camel@REM-DF8MK12.vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Chas Williams III <Charles.Williams@brocade.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36117 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163AbbEUNNl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 May 2015 09:13:41 -0400
Content-Disposition: inline
In-Reply-To: <1432129850.12119.27.camel@REM-DF8MK12.vyatta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 20, 2015 at 07:50:50AM -0600, Chas Williams III wrote:
> If the user didn't specify a queue length in the configuration file it
> will have a length of 0.  Allow the kernel's default to take precedence
> instead.

Thanks for addressing this. Applied.

BTW, I broke line at 80 chars. We stick to Linux kernel coding style
in userspace as much as possible, no problem just for the next time.
