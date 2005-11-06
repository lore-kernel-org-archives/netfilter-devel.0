From: Pablo Neira <pablo@netfilter.org>
Subject: Re: [PATCH 0/7] more ctnetlink updates
Date: Sun, 06 Nov 2005 04:21:12 +0100
Message-ID: <436D76A8.30605@netfilter.org>
References: <436BA1A6.4050705@netfilter.org>
	<20051105111828.GW5594@sunbeam.de.gnumonks.org>
	<436C997D.6010205@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <436C997D.6010205@trash.net>
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

Patrick McHardy wrote:
> Harald Welte wrote:
>>On Fri, Nov 04, 2005 at 07:00:06PM +0100, Pablo Neira wrote:
>>>Here follows more ctnetlink updates. There are no critical bug here so
>>>these should go in 2.6.15, just some minor fixes and new features.
>>
>>applied 2-5 and 7 unmodified, backed out '6' and applied a modified
>>version of '1' (see separate mails)
> 
> What about my objections to 3 and 4? 3 at least should not go in.

I don't agree. In the case of patch 3, it's true that sizechecks are
missing in some parts of the code and I'm going to fix it, but that is a
different patch that is not related itself with the marking support.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
