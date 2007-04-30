From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] Unspecified proto should print as "all" in iptables -L
Date: Mon, 30 Apr 2007 19:25:17 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704301924021.29151@yvahk01.tjqt.qr>
References: <20070428220206.GA26272@linuxace.com>
	<463524E7.60107@netfilter.org>
	<Pine.LNX.4.61.0704301038100.22744@yvahk01.tjqt.qr>
	<20070430171317.GA6904@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070430171317.GA6904@linuxace.com>
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


On Apr 30 2007 10:13, Phil Oester wrote:
>On Mon, Apr 30, 2007 at 10:38:38AM +0200, Jan Engelhardt wrote:
>> Hey btw, how would you go about matching protocol 0 since 0 is unfortunately
>> defined as "all" in iptables?
>
>I suppose you wouldn't, although AFAIK protocol 0 isn't actively
>used.  Have you seen it used in the wild?

/etc/protocols lists ipv6hopbyhop as 0.
But also see
http://lists.netfilter.org/pipermail/netfilter/2007-April/068496.html


Jan
-- 
