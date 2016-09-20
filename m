From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Re: rate limit not working ?
Date: Tue, 20 Sep 2016 13:14:14 +0200
Message-ID: <eb5fc335-baaa-852e-0d56-24909d87eec6@c-s.fr>
References: <a6f9f673-8c5b-4a95-ea38-4fb8b39d4dc8@c-s.fr>
 <20160920081341.GA2328@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:12521 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752924AbcITLOR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Sep 2016 07:14:17 -0400
In-Reply-To: <20160920081341.GA2328@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Le 20/09/2016 à 10:13, Pablo Neira Ayuso a écrit :
> On Fri, Sep 16, 2016 at 06:50:22PM +0200, Christophe Leroy wrote:
>> Hi
>>
>> I tried to limit ping flooding by setting the following rule:
>>
>> nft add rule filter input icmp type echo-request limit rate 10/second accept
>
> This is matching packets under the rate, so packets under the rate are
> accepted.
>
> Your next rule, or default policy, should drop, so packets over the
> rate are dropped.
>
> You can invert this logic via:
>
>  # nft add rule filter input icmp type echo-request limit rate over 10/second drop
>

That didn't work either, but in fact I found the issue: I have a rule 
'ct state established, related accept' earlier in the ruleset, so only 
the first ping packet reached the rate limitation rule.

Putting the rate limitation rules before that ct state rule, it works as 
expected.

Thanks for your help

Christophe
