From: Andreas Schultz <aschultz@tpip.net>
Subject: Re: [PATCH RFC nf-next 0/3] named expressions for nf_tables
Date: Mon, 11 Apr 2016 17:27:59 +0200
Message-ID: <570BC27F.9080409@tpip.net>
References: <1459961493-7494-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:57011 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905AbcDKPdL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Apr 2016 11:33:11 -0400
In-Reply-To: <1459961493-7494-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On 04/06/2016 06:51 PM, Pablo Neira Ayuso wrote:
> Hi,
>
> This patchset introduces the named stateful expressions for nf_tables,
> that allows userspace to set a name for the stateful expression for
> several reasons:
>
>   * Provide a unique identifier to fetch and reset it internal state.
>   * Allow to update of their parameters and internal state.
>   * Allow to fetch and reset its internal state.
>   * Refer to the same stateful expression from one or more rules.

Would this support to have rules based on the value of a counter and/or
the current rate (like quotas in nfacct)?

something like this:

nft add rule filter tcp-chain counter name tcp-counter bytes > 10000 jump deny

A more realistic setup might more look like:

table ip filter {
          counter counter-user1234 {
                  packets 6086 bytes 6278052
          }

          chain chain-user1234 {
                  counter name counter-user1234
		 counter name counter-user1234 > 10000000 goto chain-user1234-overlimit
		 counter name counter-user1234 > 500000 goto rate-limit
		 accept
          }

          chain chain-user1234-overlimit {
                  do-once notify userspace somehow
		 reject
          }
}

As far as I know there is currently no mechanism in nft that could do
the "do-once notify userspace somehow", or is there???

The other issue I have with such a scheme that it requires lots of chains per
client and might limit the number of clients that could be supported.

Regards
Andreas
