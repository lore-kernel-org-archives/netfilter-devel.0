From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Build fixes for old Linuxes
Date: Fri, 18 Jan 2013 03:06:03 +0100
Message-ID: <20130118020603.GA25887@1984>
References: <1358274002-6042-1-git-send-email-jengelh@inai.de>
 <20130118004455.GA20537@1984>
 <alpine.LNX.2.01.1301180228250.14064@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43724 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab3ARCGI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jan 2013 21:06:08 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1301180228250.14064@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 18, 2013 at 02:29:43AM +0100, Jan Engelhardt wrote:
[...]
> So, what is the minimum {kernel, userspace} configuration that
> we should require from users and which to put into INSTALL?
> Do we still care about 2.4.x?

As long as it is maintained, 2.4.x matters. Same thing with maintained
third party library dependencies.
