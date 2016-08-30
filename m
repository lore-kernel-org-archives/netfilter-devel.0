From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] meta: fix memory leak in tc classid parser
Date: Tue, 30 Aug 2016 12:43:45 +0200
Message-ID: <20160830104345.GA2205@salvia>
References: <1472373382-20104-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53400 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753282AbcH3Knv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 06:43:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C042C12A690
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:43:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFA37100A59
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:43:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34491114D60
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:43:47 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472373382-20104-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 28, 2016 at 04:36:22PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> We forgot to free the str which was allocated by xstrdup,
> so memory leak will happen.

Applied, thanks.
