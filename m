From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2 v2] iptables-restore/ip6tables-restore: add
 --version/-V argument
Date: Fri, 14 Apr 2017 01:05:14 +0200
Message-ID: <20170413230514.GA6713@salvia>
References: <1491255160.5423.16.camel@redhat.com>
 <20170408220418.GA8524@salvia>
 <1491707416.27302.1.camel@redhat.com>
 <20170410115356.GC2155@salvia>
 <1491845516.28450.3.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Dan Williams <dcbw@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54154 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752040AbdDMXFZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 19:05:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1D334C108C
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:05:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C056DA86D
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:05:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5BBD0DA7E9
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:05:24 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491845516.28450.3.camel@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 10, 2017 at 12:31:56PM -0500, Dan Williams wrote:
> Prints program version just like iptables/ip6tables.

Applied, thanks.
