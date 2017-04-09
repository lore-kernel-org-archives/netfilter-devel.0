From: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] iptables-restore/ip6tables-restore: add --version/-V
 argument
Date: Sat, 08 Apr 2017 22:10:16 -0500
Message-ID: <1491707416.27302.1.camel@redhat.com>
References: <1491255160.5423.16.camel@redhat.com>
         <20170408220418.GA8524@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47498 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751348AbdDIDKT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Apr 2017 23:10:19 -0400
In-Reply-To: <20170408220418.GA8524@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 2017-04-09 at 00:04 +0200, Pablo Neira Ayuso wrote:
> On Mon, Apr 03, 2017 at 04:32:40PM -0500, Dan Williams wrote:
> > Prints program version just like iptables/ip6tables.
> 
> Applied, thanks.
> 
> You sent us a chunk for the manpage?

I did not, but I will.  I noticed there wasn't one for the iptables-
restore --wait changes either, was Lorenzo going to send one?  Mine
would probably conflict with that.

Dan
