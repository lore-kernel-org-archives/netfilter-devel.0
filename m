From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables pull request
Date: Tue, 5 May 2009 01:54:56 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905050116060.5938@fbirervta.pbzchgretzou.qr>
References: <1241380473-22262-1-git-send-email-jengelh@medozas.de> <49FEEC5A.3080409@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60705 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZEDXy6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 May 2009 19:54:58 -0400
In-Reply-To: <49FEEC5A.3080409@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2009-05-04 15:23, Pablo Neira Ayuso wrote:
>Jan Engelhardt wrote:
>> Please pull from:
>>         git://dev.medozas.de/iptables  master
>> 
>> to receive 1 external submission, 1 manpage completion, and 7 code
>> transformations intended for the 1.4.4 'branch'.
>
>There are several API changes in this changeset, could you justify the
>benefits of it? I think that they may break binary compatibility. I
>think that the idea was to provide a stable API for things like jamal's
>ipt, not to change it quite so often just to replace int by bool.

The benefit, though smaller here, is correctness. Note the kernel has 
received similar changes in v2.6.22-600-ge1931b7. I plan to materialize 
more thoughts into code, as 1.4.4 should be away some months (if it 
follows the usual pattern...), or at least weeks, yet.

I do not think we planned for a stable API - but feel free to ask Jamal. 
The main target was ABI, because... - I am not sure how m_ipt did it, 
but I seem to remember that despite version checks (ie. struct 
xtables_match->version) it provided an iptables-like API that was not 
actually that from the respective iptables version. Or something.

I am not sure what m_ipt did previously w.r.t. checks, but there are now 
various mechanisms in place to ensure ABIs do not get mixed up 
erroneously:

- soversion. m_ipt now links against, say, libxtables.so.2. If the 
latter changes incompatibly, it becomes libxtables.so.3, and the 
runtime linker ld.so will take care of it -- by throwing a "file not 
found" error, or by actually loading a still-existing .so.2.

- libxtables will not load extensions that have a mismatching soversion 
string

- lastly, we could make it so that every extension is backlinked to 
libxtables.so.$version as an added measure but I had not yet given 
thought of the impact that it causes for running iptables directly from 
the source directory.

