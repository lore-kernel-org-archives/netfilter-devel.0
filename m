From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_reject: remove unused variable
Date: Wed, 8 Mar 2017 19:03:06 +0100
Message-ID: <20170308180306.GA30941@salvia>
References: <20170307130250.16693-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35096 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753825AbdCHStw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 13:49:52 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B95DA2470B
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 19:03:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AB4E4DA81A
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 19:03:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 862E4DA7E9
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 19:03:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170307130250.16693-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 07, 2017 at 10:02:50PM +0900, Taehee Yoo wrote:
> variable oiph is not used.

Applied, thanks.
