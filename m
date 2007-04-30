From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] Unspecified proto should print as "all" in iptables -L
Date: Mon, 30 Apr 2007 10:38:38 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704301038100.22744@yvahk01.tjqt.qr>
References: <20070428220206.GA26272@linuxace.com>
	<463524E7.60107@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@lists.netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <463524E7.60107@netfilter.org>
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


On Apr 30 2007 01:06, Pablo Neira Ayuso wrote:
>Phil Oester wrote:
>> In fixing bug #446 [1], the output for unspecified proto was changed
>> from "all" to "0".  This reverts to the original behaviour, and
>> closes bugzilla #543.
>
>Applied a similar patch to ip6tables.c, thanks Phil. You're doing a nice
>work closing open bugs in bugzilla.

Hey btw, how would you go about matching protocol 0 since 0 is unfortunately
defined as "all" in iptables?


Jan
-- 
