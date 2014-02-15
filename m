From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH] netfilter: nf_tables: add new write expression
Date: Sat, 15 Feb 2014 13:43:00 +0000
Message-ID: <d65fdb3e-2d66-4b78-8600-10f70361fcd0@email.android.com>
References: <1392470242-4515-1-git-send-email-nikolay@redhat.com> <20140215133613.GB28751@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Florian Westphal <fw@strlen.de>,
	Nikolay Aleksandrov <nikolay@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63086 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbaBONn4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Feb 2014 08:43:56 -0500
In-Reply-To: <20140215133613.GB28751@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15. Februar 2014 13:36:13 GMT+00:00, Florian Westphal <fw@strlen.de> wrote:
>Nikolay Aleksandrov <nikolay@redhat.com> wrote:
>> The new "write" expression can be used to manipulate packet data.
>
>Thanks.  This is very useful feature (needed also for TCPMSS mangling
>for instance).
>
>General question: How are/should packet checksums be handled after
>packet
>content was altered?

Good question indeed. I guess we need to make this dependant on the payload base and protocols involved. LuckIly in most cases we can rely on checksum offload to take care of this.

Maybe we can have userspace specify the necessary parameters such as the checksum position and whether a pseudo header is used.

