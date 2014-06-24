From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 1/2 libnetfilter_conntrack] qa: update cmp ATTR_ZONE
 size mark and zone
Date: Tue, 24 Jun 2014 17:23:36 +0200
Message-ID: <20140624152336.GC6328@breakpoint.cc>
References: <20140617120405.GA24712@gmail.com>
 <20140619151611.GC13029@breakpoint.cc>
 <20140623101235.GA29052@gmail.com>
 <20140623101519.GB29052@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53190 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754104AbaFXPXi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:23:38 -0400
Content-Disposition: inline
In-Reply-To: <20140623101519.GB29052@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> ---
>  qa/test_api.c | 102 ++++++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 78 insertions(+), 24 deletions(-)

[ ATTR_ZONE test cases with all flag combinations ]

Thanks, this should indeed cover all the possible combinations of
attr states and compare flags.

I've merged this patch with the test_api change from patch 2/2 and
pushed the result.
