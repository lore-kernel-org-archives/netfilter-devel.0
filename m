From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft rules processed in wrong network namespace
Date: Wed, 10 Jun 2015 16:01:43 +0200
Message-ID: <20150610140143.GA31977@salvia>
References: <CAASN2uOcjOKkXamC=FkYJKCJDTcA9nQUa5=OSn6YyUJ8SGvRfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Andreas Schultz <aschultz@warp10.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40672 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964841AbbFJN42 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2015 09:56:28 -0400
Content-Disposition: inline
In-Reply-To: <CAASN2uOcjOKkXamC=FkYJKCJDTcA9nQUa5=OSn6YyUJ8SGvRfg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 10, 2015 at 12:07:27PM +0200, Andreas Schultz wrote:
[...]
> I think I have found the root cause why this happends.
> 
> With iptables only the hooks defined by the ipt modules can ever exist and
> they do apply to all namespaces. Thus hooks are registered in the global list
> nf_hooks.

I have an incomplete patchset here to introduce pernet hooks. Will
send this for review at some point.
