From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl 2/3] set: fix set nlmsg desc parsing
Date: Thu, 18 Sep 2014 20:43:34 +0200
Message-ID: <20140918184334.GA5518@salvia>
References: <1411064300-4433-1-git-send-email-arturo.borrero.glez@gmail.com>
 <1411064300-4433-2-git-send-email-arturo.borrero.glez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50233 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424AbaIRSmf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:42:35 -0400
Content-Disposition: inline
In-Reply-To: <1411064300-4433-2-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 18, 2014 at 08:18:19PM +0200, Arturo Borrero Gonzalez wrote:
> In commit [ff62959](set: add support for set mechanism selection) the
> support for parsing the nested attribute (NFTA_SET_DESC) was invalid.

Applied this little fix, thanks Arturo.
