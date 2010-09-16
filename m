From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] netfilter: Use header-y instead of unifdef-y
Date: Thu, 16 Sep 2010 10:30:19 +0200
Message-ID: <4C91D59B.40009@trash.net>
References: <20100823034226.GA29532@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Eric Dumazet <eric.dumazet@gmail.com>
To: Simon Horman <horms@verge.net.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38794 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab0IPIaY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Sep 2010 04:30:24 -0400
In-Reply-To: <20100823034226.GA29532@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 23.08.2010 05:42, schrieb Simon Horman:
> According to Documentation/kbuild/makefiles.txt
> the usage of unifdef is deprecated.
> 
> Signed-off-by: Simon Horman <horms@verge.net.au>

This has already been changed by this commit:

60641aa1f379820e99ac7f45a38b43795670c741
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Sat Aug 14 10:15:12 2010 +0200

    include: replace unifdef-y with header-y

    unifdef-y and header-y has same semantic.
    So there is no need to have both.

    Drop the unifdef-y variant and sort all lines again

    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
