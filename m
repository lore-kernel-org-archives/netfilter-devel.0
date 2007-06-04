From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH 5/4] Use bools for xt_match
Date: Mon, 4 Jun 2007 17:43:42 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706041742350.20829@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706041707410.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706041729030.20829@yvahk01.tjqt.qr>
	<46643007.7040902@trash.net>
	<Pine.LNX.4.61.0706041733500.20829@yvahk01.tjqt.qr>
	<466430D9.70006@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <466430D9.70006@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


On Jun 4 2007 17:33, Patrick McHardy wrote:
>>>
>>>Folded into 2/4, thanks. If you have more corrections please include
>>>which patch they belong to.
>> 
>> If you use an SCM (rather than floating patches), then folding is impossible
>> is not it? (Unless you use extra SCM trickery like "git reset".)
>
>stgit. Saves huge amounts of time when trying to keep a clean history.

But that only works until merge, does not it? (I for my part use
quilt on top of git (tracking only), I tell ya, that's fun ;-)


	Jan
-- 
