From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 3/3] libxtables: avoid returning duplicate address for
 host resolution
Date: Wed, 8 Mar 2017 17:56:43 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1703081753170.6259@n3.vanv.qr>
References: <1488983584-26091-1-git-send-email-pablo@netfilter.org> <20170308162658.5697-1-jengelh@inai.de> <20170308162658.5697-4-jengelh@inai.de> <20170308164502.GA4076@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:45112 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753073AbdCHRH2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 12:07:28 -0500
In-Reply-To: <20170308164502.GA4076@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2017-03-08 17:45, Pablo Neira Ayuso wrote:

>On Wed, Mar 08, 2017 at 05:26:58PM +0100, Jan Engelhardt wrote:
>> A long-standing problem has been that `iptables -s any_host_here`
>> could yield multiple rules with the same address if the DNS was
>> indeed so populated.
>
>When did anyone report this problem out of the localhost case?

It's been a long time. I think the issue was actually that one can 
specify multiple host names, and if those hostnames happen to resolve to 
the same address in the end, iptables would emit two rules of which one 
is essentially redundant.

  iptables -A INPUT -s www2.company.com,www3.company.com
