From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH] netfilter: nf_ct_sctp: validate vtag for new conntrack
 entries
Date: Thu, 10 Dec 2015 11:16:04 -0200
Message-ID: <56697B14.3010909@gmail.com>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1449579256.git.marcelo.leitner@gmail.com>
 <20151210120233.GA2084@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>, mkubecek@suse.cz
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:34046 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbbLJNQK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Dec 2015 08:16:10 -0500
In-Reply-To: <20151210120233.GA2084@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Em 10-12-2015 10:02, Pablo Neira Ayuso escreveu:
> Hi Marcelo,
>
> On Tue, Dec 08, 2015 at 11:11:10AM -0200, Marcelo Ricardo Leitner wrote:
>> Commit d7ee35190427 ("netfilter: nf_ct_sctp: minimal multihoming
>> support") allowed creating conntrack entries based on the heartbeat
>> exchange, so that we can track secondary paths too.
>>
>> This patch adds a vtag verification to that. That is, in order to allow
>> a HEARTBEAT or a HEARTBEAT_ACK through, the tuple (src port, dst port,
>> vtag) must be already known.
>
> This infrastructure that you're adding in this patch looks very
> similar to me to conntrack expectations.
>
> Did you evaluate this possibility?

Yes,

> The idea would be to add the vtag to the tuples since it allows us to
> uniquely identify the SCTP flow. Then, if you see the hearbeat, you
> can register an expectation for the tuple (any-src-ip, any-dst-ip,
> sctp, specific-sport, specific-dport, specific-vtag-value).
>
> Then, any secondary STCP flow matching that expectation in the future
> will be accepted as RELATED traffic.

When I first evaluated using expectations, I was going to track all 
addresses that the association was announcing. This would mean we would 
have to add expectations for all address combinations that might have 
been possible. This was the main reason that I didn't use expectations. 
  Yet this req changed when I realized that we can't process ASCONF 
chunks without validating the AUTH chunk first, which we just can't just 
when in the middle of the communication.

After that went down it's just two other:
- by removing the addresses from it, we have the possibility that a host 
may use multiple addresses but not for a single sctp association, but 
like running two distinct assocs, one using each IP address, but same 
ports, and same vtags. It could happen.. it would cause a clash as the 
expectation would be the same but for different masters.

- adding vtag to it increases nf_conntrack_tuple by 4 bytes, so 8 bytes 
per nf_conn, while this feature will be off for the majority of the 
installations.

The possibility of using RELATED is very attractive, though. Would make 
more sense, I think. The extra bytes, we might do it, but for that 
conflict, only if we require the usage of conntrack zones in such cases. 
It would work for me..

   Marcelo

