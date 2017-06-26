From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] bump version to 1.0.3
Date: Mon, 26 Jun 2017 19:22:04 +0200
Message-ID: <20170626172204.GA11493@salvia>
References: <20170621211846.20630-1-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Richard Weinberger <richard@nod.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44756 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750763AbdFZRWR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2017 13:22:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 74CFDE7B80
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 19:22:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65E791B404D
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 19:22:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4273E1B4044
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 19:22:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170621211846.20630-1-richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 21, 2017 at 11:18:46PM +0200, Richard Weinberger wrote:
> Time to make a new version such that distros can pick this version.
> Many distros ship only 1.0.2 which is almost five years old and
> does not support recent netfilter features such as NFQA_CT.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
> Hi!
> 
> As discussed with Florian on IRC, it is time for a new version.
> I think we don't have to change the API version, so just increment
> the release version.

Applied, thanks.
