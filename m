From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH RFC 0/2] icmpv6: match any ICMPv6 error/informational type
Date: Fri, 5 Apr 2013 21:19:50 +0200
Message-ID: <20130405191941.GA2064@imap.eitzenberger.org>
References: <20130403142729.484857089@eitzenberger.org>
 <20130405160903.GA5293@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:56601 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162530Ab3DETTx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 15:19:53 -0400
Content-Disposition: inline
In-Reply-To: <20130405160903.GA5293@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Please, add a new revision. The ABI will not be broken, but people
> using new iptables versions with old kernels will not get any specific
> error report telling that what they specify will not work.

Thanks Pablo, will do.
