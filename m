From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: change large file support handling
Date: Wed, 4 Oct 2017 16:14:58 +0200
Message-ID: <20171004141458.GA28637@salvia>
References: <201709281059.45061.jbe@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Juergen Borleis <jbe@pengutronix.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:50421 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752029AbdJDOPH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2017 10:15:07 -0400
Content-Disposition: inline
In-Reply-To: <201709281059.45061.jbe@pengutronix.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Juergen,

On Thu, Sep 28, 2017 at 10:59:44AM +0200, Juergen Borleis wrote:
> The configure script handles the "--*-largefile" parameter badly. It
> defaults to large file support if not given and always disables largefile
> support if given (and it doesn't matter if 'enable' or 'disable' was used)

It seems the default behaviour for a while has been to enable
largefile by default.

Then, someone came in to add this --disable-largefile configure time
option, see:

commit 967cb7106f0f61cd7b8fbb10bc2451a3f7372a43
Author: Karl Hiramoto <karl@hiramoto.org>
Date:   Mon May 10 17:50:41 2010 +0200

    iptables: optionally disable largefile support

So I would just fix --enable-* --disable-*.

Would you follow up on this? Let me know, thanks.
