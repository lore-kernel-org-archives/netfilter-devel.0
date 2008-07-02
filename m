From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/2] Netfilter: Accounting rework: ct_extend + 64bit
 counters (v3)
Date: Wed, 2 Jul 2008 15:57:20 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807021556310.20393@fbirervta.pbzchgretzou.qr>
References: <485a3c49.C0A/tC0/U7AaZp3V%ole@ans.pl> <486114E9.9000809@trash.net> <Pine.LNX.4.64.0806241804340.24680@bizon.gios.gov.pl> <Pine.LNX.4.64.0807021358370.4958@bizon.gios.gov.pl> <486B7D9C.4070501@trash.net> <Pine.LNX.4.64.0807021519330.4958@bizon.gios.gov.pl>
 <486B80F5.7050801@trash.net> <Pine.LNX.4.64.0807021522520.4958@bizon.gios.gov.pl> <486B853A.205@trash.net> <Pine.LNX.4.64.0807021542420.4958@bizon.gios.gov.pl> <486B87FE.90909@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Krzysztof Oledzki <ole@ans.pl>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50433 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYGBN5V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 09:57:21 -0400
In-Reply-To: <486B87FE.90909@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-07-02 15:51, Patrick McHardy wrote:
>> >
>> > Seems you're the first to try module_param_named with a bool :)
>> > Does this help?
>> 
>> It helps but produces a lot of warnings in other places:
>> 
>> kernel/printk.c: In function '__check_time':
>> kernel/printk.c:570: warning: return from incompatible pointer type
>
> Ah I see. You're supposed to use an int for the variable and
> bool only for module_param_named.

Yes but since we have 'bool' type (though only since recently),
module_param_bool should also *take* a bool.
