From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] Netfilter: Accounting rework: ct_extend + 64bit counters
 (v3)
Date: Wed, 02 Jul 2008 15:51:58 +0200
Message-ID: <486B87FE.90909@trash.net>
References: <485a3c49.C0A/tC0/U7AaZp3V%ole@ans.pl> <486114E9.9000809@trash.net> <Pine.LNX.4.64.0806241804340.24680@bizon.gios.gov.pl> <Pine.LNX.4.64.0807021358370.4958@bizon.gios.gov.pl> <486B7D9C.4070501@trash.net> <Pine.LNX.4.64.0807021519330.4958@bizon.gios.gov.pl> <486B80F5.7050801@trash.net> <Pine.LNX.4.64.0807021522520.4958@bizon.gios.gov.pl> <486B853A.205@trash.net> <Pine.LNX.4.64.0807021542420.4958@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38400 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYGBNwA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 09:52:00 -0400
In-Reply-To: <Pine.LNX.4.64.0807021542420.4958@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
> On Wed, 2 Jul 2008, Patrick McHardy wrote:
> 
>> Krzysztof Oledzki wrote:
>>> (...)
>>> bool nf_ct_acct __read_mostly = NF_CT_ACCT_DEFAULT;
>>> (...)
>>> module_param_named(acct, nf_ct_acct, bool, 0644);        <- line 28
>>> (...)
>>>
>>> net/netfilter/nf_conntrack_acct.c: In function '__check_acct':
>>> net/netfilter/nf_conntrack_acct.c:28: warning: return from 
>>> incompatible pointer type
>>
>> Seems you're the first to try module_param_named with a bool :)
>> Does this help?
> 
> It helps but produces a lot of warnings in other places:
> 
> kernel/printk.c: In function '__check_time':
> kernel/printk.c:570: warning: return from incompatible pointer type
> 
> arch/x86/kernel/cpu/mtrr/generic.c: In function '__check_show':
> arch/x86/kernel/cpu/mtrr/generic.c:46: warning: return from incompatible 
> pointer type
> 
> kernel/irq/spurious.c: In function '__check_noirqdebug':
> kernel/irq/spurious.c:230: warning: return from incompatible pointer type
> 
> (...)
> 
> How about keeping it int currently and then issuing a cleanup patch that 
> touches all variables used in module_param/module_param_named(..., bool, 
> ...)?

Ah I see. You're supposed to use an int for the variable and
bool only for module_param_named.

