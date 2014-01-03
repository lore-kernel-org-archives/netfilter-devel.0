From: James Chapman <jchapman@katalix.com>
Subject: Re: [PATCH v5] netfilter: introduce l2tp match extension
Date: Fri, 03 Jan 2014 14:47:27 +0000
Message-ID: <52C6CD7F.4000109@katalix.com>
References: <1388757711-13712-1-git-send-email-jchapman@katalix.com> <20140103142615.GC28854@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from katalix.com ([82.103.140.233]:46409 "EHLO bert.katalix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbaACOrd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 09:47:33 -0500
In-Reply-To: <20140103142615.GC28854@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/01/14 14:26, Florian Westphal wrote:
> James Chapman <jchapman@katalix.com> wrote:
>> Is there a way in checkentry() to check that a UDP match has also been
>> specified, for the case when L2TP UDP encap is being used? This would
>> ensure that specific UDP ports are matched.
> 
> xt_TCPMSS uses xt_ematch_foreach() in checkentry to verify that -p tcp
> --syn was specified.
> 
I see. Thanks. I'll work on adding it now.

James


