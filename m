From: "Tobias Koeck" <tobias.koeck@gmail.com>
Subject: Re: hooks
Date: Thu, 18 Dec 2008 02:05:29 +0100
Message-ID: <379e30200812171705w3ebb59ffse29e0a948cd88294@mail.gmail.com>
References: <379e30200812171531v506beaccsdfb5c103ec0671d3@mail.gmail.com>
	 <alpine.LNX.1.10.0812180125510.7014@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:64132 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbYLRBFb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2008 20:05:31 -0500
Received: by bwz14 with SMTP id 14so696103bwz.13
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Dec 2008 17:05:29 -0800 (PST)
In-Reply-To: <alpine.LNX.1.10.0812180125510.7014@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan

For instance I can use

tron:/home/joblack/rarqos/iptables/iptables-1.4.0# iptables -t mangle
-A FORWARD -j RARQOS
iptables: Invalid argument

and I have the same output in the syslog file.

---
I don't have additional arguments ... strange behaviour.

Greetings
tobias

On Thu, Dec 18, 2008 at 1:27 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Thursday 2008-12-18 00:31, Tobias Koeck wrote:
>>
>>I'm programing  module and in the register function I've included
>>
>>       .hooks          = (1 << NF_INET_FORWARD),
>>
>>If I want to append a rule with iptables I get the following error
>>message in /var/log/syslog:
>>
>>tron kernel: ip_tables: RARQOS target: bad hook_mask 4/16
>>What could be the problem?
>
> In the invocation of the iptables command.
> You are trying to use your target in the POSTROUTING chain (16)
> but you only allow it to be used in FORWARD (4).
>
