From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Google SoC, Optimized netfilter implementation
Date: Fri, 03 Apr 2009 11:50:15 +0200
Message-ID: <878wmikqw8.fsf@basil.nowhere.org>
References: <daf8006b0903311912g2c83d221w68197954d1e08d0d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shreyas Bhatewara <shreyas.bhatewara@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:50466 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762282AbZDCJuV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Apr 2009 05:50:21 -0400
In-Reply-To: <daf8006b0903311912g2c83d221w68197954d1e08d0d@mail.gmail.com> (Shreyas Bhatewara's message of "Tue, 31 Mar 2009 21:12:36 -0500")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shreyas Bhatewara <shreyas.bhatewara@gmail.com> writes:
>
> I am composing a proposal for this project to be submitted at Google
> SoC. Could anyone brief me about what you mean by "dynamic code
> generation" (https://www.linuxfoundation.org/en/Google_Summer_of_Code_2009#Optimized_netfilter_implementation).


I believe it refers to generate machine code for firewall rules.
So instead of interpreting a data structure the dynamically generated
code would just check the rules directly.

This was done by some kernels before, e.g. OSF/Mach had code to compile
BPF rules into machine code.

Doing something like this would be likely interesting, but I expect
it would be far too much general work for a single SoC. So if you wanted
to do anything like that you would need to select a very narrow doable
subset.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
