From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix CONNMARK mask value demolition
Date: Tue, 15 Jan 2008 08:04:42 +0100
Message-ID: <478C5B0A.0@trash.net>
References: <4780454E.3050803@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63170 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbYAOHEx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 02:04:53 -0500
In-Reply-To: <4780454E.3050803@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Peter Warasin wrote:
> This patch fixes the problem that the CONNMARK mask value
> has been set to 0 whenever the CONNMARK target options has not
> been the last options to be processed.

 > @@ -64,13 +64,12 @@
 >  	struct xt_connmark_target_info *markinfo
 >  		= (struct xt_connmark_target_info *)(*target)->data;
 >
 > -	markinfo->mask = 0xffffffffUL;
 > -
 >  	switch (c) {
 >  		char *end;
 >  	case '1':
 >  		markinfo->mode = XT_CONNMARK_SET;
 >
 > +		markinfo->mask = 0xffffffffUL;

Good catch, but don't we also need set the mask for --save-mark
and --restore-mark? I would suggest to move the initialzation
to a ->init() function.

