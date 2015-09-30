From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: nfnetlink_queue: rename related
 to nfqueue attaching conntrack info
Date: Thu, 1 Oct 2015 00:03:18 +0200
Message-ID: <20150930220318.GA14844@salvia>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
 <20150910000615.GB5734@salvia>
 <20150911030530.GA7380@gmail.com>
 <20150911030748.GB7380@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41911 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbbI3V4X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Sep 2015 17:56:23 -0400
Content-Disposition: inline
In-Reply-To: <20150911030748.GB7380@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 11, 2015 at 12:07:48PM +0900, Ken-ichirou MATSUZAWA wrote:
> The idea of this series of patch is to attach conntrack information to
> nflog like nfqueue has already done. nfqueue conntrack info attaching
> basis is generic, rename those names to generic one, glue.

Looks good, please rebase on top of my two patches (unless you find
any problem on them) and resubmit this on top of them.

Thanks.

