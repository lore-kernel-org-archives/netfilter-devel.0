From: Patrick McHardy <kaber@trash.net>
Subject: Re: textsearch 08/13: fix Boyer-Moore text search bug
Date: Mon, 07 Jul 2008 14:44:18 +0200
Message-ID: <48720FA2.7050700@trash.net>
References: <20080707120514.4975.88670.sendpatchset@localhost.localdomain> <20080707120524.4975.39989.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Henrik Nordstrom <henrik@henriknordstrom.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59517 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbYGGMoV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:44:21 -0400
In-Reply-To: <20080707120524.4975.39989.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> textsearch: fix Boyer-Moore text search bug
> 
> The current logic has a bug which cannot find matching pattern, if the
> pattern is matched from the first character of target string.
> for example:
> 	pattern=abc, string=abcdefg
> 	pattern=a,   string=abcdefg
> Searching algorithm should return 0 for those things.
> 
> Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> ---
> commit ad089136c547ef33e2375e64dd13a0f09825d4d0
> tree e1ab155181637bf1ad3d39232b9cc2f40094f286
> parent 170f103d11a1e1186e2677fd5f75735b740c025f
> author Joonwoo Park <joonwpark81@gmail.com> Mon, 07 Jul 2008 13:00:17 +0200
> committer Patrick McHardy <kaber@trash.net> Mon, 07 Jul 2008 13:00:17 +0200
> 
>  0 files changed, 0 insertions(+), 0 deletions(-)

Henrik notified my of this mistake. This one is already merged
through net-2.6.git, apparently I forgot to remove it from the
stack. Please ignore.

