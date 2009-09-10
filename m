From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] iptables: expose option to zero packet and byte counters
 for a specific rule using iptables/ip6tables
Date: Thu, 10 Sep 2009 16:26:37 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0909101620240.24353@obet.zrqbmnf.qr>
References: <23915168.171071250704593343.JavaMail.root@tahiti.vyatta.com> <alpine.LSU.2.00.0908192232020.9285@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Mohit Mehta <mohit.mehta@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33101 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786AbZIJO0f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Sep 2009 10:26:35 -0400
In-Reply-To: <alpine.LSU.2.00.0908192232020.9285@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Mohit,


On Wednesday 2009-08-19 22:41, Jan Engelhardt wrote:
>
>>I was able to cleanly apply the attached modified patches to the
>> latest iptables code. Also, below is the code in text if attachment
>> doesn't reach.
>>
>>Subject: [PATCH] expose option to zero packet and byte counters for a specific rule using iptables
>
>
>I wonder what the real-world use of this is, apart from
>rule debugging (for which -j TRACE seems better anyhow).

That was meant to be a question. Could you please let me know why 
exactly -Z # was needed? I guess there was some large value seen in it 
given you were sending it from Vyatta, so I would like to know. If it 
was just an experiment and TRACE and/or quota2 (Xta) was sufficient in 
regards to you accomplishing whatever the intention was to, please also 
let me know so that I can possibly discard the branch with your -Z#
submission.
