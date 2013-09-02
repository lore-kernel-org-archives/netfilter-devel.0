From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [nftables tool PATCH 2/5] src: Wrap netfilter hooks around human
 readable strings
Date: Mon, 02 Sep 2013 08:03:20 +0300
Message-ID: <52241C18.1090906@linux.intel.com>
References: <1377678791-7616-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1377678791-7616-3-git-send-email-tomasz.bursztyka@linux.intel.com> <20130830220557.GB5905@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1337 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab3IBFDX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Sep 2013 01:03:23 -0400
In-Reply-To: <20130830220557.GB5905@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> This can be done better by checking this in the evaluation step, in
> chain_evaluate (you can reach the family via ctx).

Ok, a step before indeed.
At first I was planning to do that at parsing stage but couldn't reach 
the chain's family.

> Moreover, you can store the hook as string in the parser. Then, in the
> evaluation step you validate that it is correct and convert it to
> numeric value. That will require two fields in the chain, one for the
> hookstr and one for hooknum.

Makes sense, though the struct chain will grow a bit then.
I will still validate the string at parsing stage to keep the error 
reporting on that particular place.

Tomasz
