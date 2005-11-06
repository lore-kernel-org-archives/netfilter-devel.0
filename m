From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/7] more ctnetlink updates
Date: Sun, 6 Nov 2005 22:40:05 +0100 (CET)
Message-ID: <Pine.LNX.4.62.0511062237270.20192@kaber.coreworks.de>
References: <436BA1A6.4050705@netfilter.org>
	<20051105111828.GW5594@sunbeam.de.gnumonks.org>
	<436C997D.6010205@trash.net> <436D76A8.30605@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@netfilter.org>
In-Reply-To: <436D76A8.30605@netfilter.org>
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

On Sun, 6 Nov 2005, Pablo Neira wrote:

> Patrick McHardy wrote:
>>
>> What about my objections to 3 and 4? 3 at least should not go in.
>
> I don't agree. In the case of patch 3, it's true that sizechecks are
> missing in some parts of the code and I'm going to fix it, but that is a
> different patch that is not related itself with the marking support.

The mark parts are related to the mark patch, aren't they?
Since other places have the same problem, a follow up patch
is fine, but I generally don't like patches that require
immediate fixing afterwards.
