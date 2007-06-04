From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/4] Use bools for xt_match
Date: Mon, 04 Jun 2007 17:33:45 +0200
Message-ID: <466430D9.70006@trash.net>
References: <Pine.LNX.4.61.0706041707410.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706041729030.20829@yvahk01.tjqt.qr>
	<46643007.7040902@trash.net>
	<Pine.LNX.4.61.0706041733500.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706041733500.20829@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> On Jun 4 2007 17:30, Patrick McHardy wrote:
> 
>>Jan Engelhardt wrote:
>>
>>>Hi, this one slipped by (I am just going through some more cleanups), 
>>>hence, an extra 5th patch on the bools stuff.
>>
>>Folded into 2/4, thanks. If you have more corrections please include
>>which patch they belong to.
> 
> 
> If you use an SCM (rather than floating patches), then folding is impossible
> is not it? (Unless you use extra SCM trickery like "git reset".)


stgit. Saves huge amounts of time when trying to keep a clean history.
