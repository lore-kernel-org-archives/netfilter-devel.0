From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [libnftnl PATCH] Rename xfree() to libnftnl_xfree() to avoid
 symbol naming conflict
Date: Wed, 20 Aug 2014 14:07:05 +0200
Message-ID: <20140820140705.26f64dbb@free-electrons.com>
References: <1408196389-15559-1-git-send-email-thomas.petazzoni@free-electrons.com>
	<20140819220236.GA7136@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:36828 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753447AbaHTMHI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:07:08 -0400
In-Reply-To: <20140819220236.GA7136@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear Pablo Neira Ayuso,

On Wed, 20 Aug 2014 00:02:36 +0200, Pablo Neira Ayuso wrote:

> > To solve this, this patch renames the libnftnl xfree() function to
> > libnftnl_xfree().
> 
> Would this small patch solve your problem too?

Yes, I believe this would work as well, as long as this definition
doesn't get exposed to public headers of the library.

Thanks!

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
