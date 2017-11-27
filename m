From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] doc: nft.8 Syslog level is introduced by "level" not
 "syslog-level"
Date: Mon, 27 Nov 2017 12:01:58 +0100
Message-ID: <20171127110158.GA17275@salvia>
References: <20171126233029.4059-1-duncan_roe@optusnet.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Duncan Roe <duncan_roe@optusnet.com.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42908 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751982AbdK0LDq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Nov 2017 06:03:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 674491C442E
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Nov 2017 12:03:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56435DA804
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Nov 2017 12:03:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171126233029.4059-1-duncan_roe@optusnet.com.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 27, 2017 at 10:30:29AM +1100, Duncan Roe wrote:
> The log synopsis line correctly documents that keyword "level" introduces
> "syslog-level", but the keyword table entry did not.
> 
> Discovered on trying to use "syslog-level" in a script.

Applied, thanks Duncan.
