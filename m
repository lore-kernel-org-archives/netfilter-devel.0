From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: Initialize struct stmt in _match and _target
 functions.
Date: Thu, 24 Aug 2017 16:12:53 +0200
Message-ID: <20170824141253.GA2422@salvia>
References: <20170820045512.3232-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:57579 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751197AbdHXONS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 10:13:18 -0400
Content-Disposition: inline
In-Reply-To: <20170820045512.3232-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 20, 2017 at 10:25:12AM +0530, Varsha Rao wrote:
> Initialize structure stmt with stmt_alloc in netlink_parse_target and
> netlink_parse_match functions. This patch fixes the warning:
> 
> ‘stmt’ may be used uninitialized in this function.

Applied, thanks Varsha.
