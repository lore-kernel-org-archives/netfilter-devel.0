From: Nikolay Aleksandrov <nikolay@redhat.com>
Subject: Re: [RFC PATCH] netfilter: nf_tables: add new write expression
Date: Sat, 15 Feb 2014 14:38:21 +0100
Message-ID: <52FF6DCD.6090509@redhat.com>
References: <1392470242-4515-1-git-send-email-nikolay@redhat.com> <20140215133613.GB28751@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbaBONjA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Feb 2014 08:39:00 -0500
In-Reply-To: <20140215133613.GB28751@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/15/2014 02:36 PM, Florian Westphal wrote:
> Nikolay Aleksandrov <nikolay@redhat.com> wrote:
>> The new "write" expression can be used to manipulate packet data.
> 
> Thanks.  This is very useful feature (needed also for TCPMSS mangling
> for instance).
> 
> General question: How are/should packet checksums be handled after packet
> content was altered?
> 
hehe very good question, right now I do it with a hacked version of this
patch, but I think we can add some more generic checksum op where you can
choose which checksum to recompute. I've also thought about making the
destination (where to write the checksum) variable for some corner cases,
but this is a stretch.

Cheers,
 Nik
