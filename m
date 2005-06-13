From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
Subject: Re: Missed any patches? [PATCH] expectation timeouts
Date: Mon, 13 Jun 2005 14:05:28 +0200
Message-ID: <42AD7688.7030605@gmx.net>
References: <42AB1577.5040006@trash.net>
	<20050611170739.GA5018@linuxace.com>	<42AB1B05.2060509@trash.net>	<Pine.LNX.4.61.0506111913540.22504@yvahk01.tjqt.qr>	<42AB1D48.3020505@trash.net>
	<Pine.LNX.4.61.0506111922060.22504@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0506111922060.22504@yvahk01.tjqt.qr>
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

Jan Engelhardt schrieb:
>>>Is there any chance that all of POMng will get updated? Most of the patches 
>>>still address a 2.6.<10 kernel. I have not tested if they apply correctly (I 
>>>don't need them ... yet), but if they don't, rediff could be wise.
>>
>>Updated how? Which patches are you talking about?
> 
> The ACCOUNT directory in today's (well, yesterday 20050610) POMng tree has a 
> linux.patch with this header:
> --- kernel-2.4.25/include/linux/netfilter_ipv4/ip_tables.h      Mon Apr 12 
> Not exactly 2.6.x at all :)

I have a 2.6 version, but it has to be cleaned up a bit. Will send it
upstream at the end of this week.

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
