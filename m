From: Josue Alvarez <jalvarez@toulouse.viveris.com>
Subject: Re: nfacct: setting quotas does not seem to work.
Date: Thu, 18 Aug 2016 09:34:04 +0200
Message-ID: <b1ea3731-9745-dd6c-c281-692b09d5bced@toulouse.viveris.com>
References: <59114b3a-5fff-4099-e2f7-d749be4e1511@toulouse.viveris.com>
 <20160817224457.GA5647@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.toulouse.viveris.com ([212.99.125.10]:46552 "EHLO
	mailS.toulouse.viveris.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066AbcHRHfE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Aug 2016 03:35:04 -0400
In-Reply-To: <20160817224457.GA5647@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18/08/2016 00:44, Pablo Neira Ayuso wrote:
> Probably using an old kernel version with no quota support? 

I found out that the issue came from libnetfilter_acct, from which I had 
one package installed (1.0.2) and some binaries from the git version 
installed with 'make install' from the sources. The linking happened on 
the 1.0.2, which does not seem to support quotas (nfacct_attr_set and 
nfacct_attr_get do not handle the cases NFACCT_ATTR_QUOTA and 
NFACCT_ATTR_FLAGS).
After removing that package it worked well.

By the way, there's actually no release of libnetfilter_acct with quota 
support, am I wrong ?
That's not a problem for me, but it could be for other users.
