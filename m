From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables-restore: renames --test to --dry-run
Date: Thu, 08 Nov 2007 00:26:52 +0100
Message-ID: <473249BC.2020406@trash.net>
References: <47322D4A.3090201@endian.com> <20071107230852.GA3206@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Peter Warasin <peter@endian.com>, netfilter-devel@vger.kernel.org
To: =?ISO-8859-15?Q?Herv=E9_Eychenne?= <rv@wallfire.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42715 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbXKGX1P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 18:27:15 -0500
In-Reply-To: <20071107230852.GA3206@eychenne.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Herv=E9 Eychenne wrote:
> I wish I had the courage and the time to go through my old big patch
> and extract the things that are still relevant today.
> I had asked at that time to this list if someone knew a patch splitte=
r
> GUI, that would enable to split a patch into several (sub)patches by
> graphically selecting which changes would go to each (sub)patch.
> Maybe there has been some progress on this, or some new well-informed
> readers?


I'm not aware of such a thing, but what works pretty well for me is
to use stgit and selectively pull chunks to patches earlier in the
series and merge the top again.

So its something like:

- do lots of changes, commit on top of stack
- open in editor, pop patch
- create new patch, copy stuff from open editor
- commit
- go to top of stack again, merge
- repeat from step 2 until patch at top is empty

Its works quite fast since the merging goes really painlessly.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
