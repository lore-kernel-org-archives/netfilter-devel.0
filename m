From: Hans Schillstrom <hans.schillstrom@ericsson.com>
Subject: Re: [rfc v2.1 03/10] ipvs network name space aware: conn
Date: Wed, 27 Oct 2010 07:37:53 +0200
Message-ID: <201010270737.54553.hans.schillstrom@ericsson.com>
References: <20101026223653.GC2270@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Julian Anastasov <ja@ssi.bg>,
	Daniel Lezcano <daniel.lezcano@free.fr>,
	Wensong Zhang <wensong@linux-vs.org>
To: Simon Horman <horms@verge.net.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:48843 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab0J0Fh5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Oct 2010 01:37:57 -0400
In-Reply-To: <20101026223653.GC2270@verge.net.au>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 27 October 2010 00:36:54 Simon Horman wrote:
> This patch just contains ip_vs_conn.c
> and does the normal
>  - moving to vars to struct ipvs
>  - adding per netns init and exit
>
> proc_fs required some extra work with adding/chaning private data to get the net ptr.
>
> Signed-off-by: Hans Schillstrom <hans.schillstrom@ericsson.com>
>
> ---
>
> * v2
>   Rebase against current nf-next-2.6 (Simon Horman)
>
> * v2.1
>   Fix patch-brokenness in v2 (Simon Horman)
>

Thanx Simon
I'll rework the patch set now so it will survive a bisect.
It will take a week or so.

--
Regards
Hans Schillstrom <hans.schillstrom@ericsson.com>
