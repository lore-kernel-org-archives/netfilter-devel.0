From: Patrick McHardy <kaber@trash.net>
Subject: Re: Missed any patches? [PATCH] expectation timeouts
Date: Sat, 11 Jun 2005 19:29:22 +0200
Message-ID: <42AB1F72.6030103@trash.net>
References: <42AB1577.5040006@trash.net> <20050611170739.GA5018@linuxace.com>
	<42AB1B05.2060509@trash.net>
	<Pine.LNX.4.61.0506111913540.22504@yvahk01.tjqt.qr>
	<42AB1D48.3020505@trash.net>
	<Pine.LNX.4.61.0506111922060.22504@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Jan Engelhardt wrote:
> NAT reservations, for example, cannot be applied to a 2.6.11, because the 
> expect code changed.
> 
> The ACCOUNT directory in today's (well, yesterday 20050610) POMng tree has a 
> linux.patch with this header:
> --- kernel-2.4.25/include/linux/netfilter_ipv4/ip_tables.h      Mon Apr 12 
> Not exactly 2.6.x at all :)

Harald was working on porting connection tracking and NAT helpers to
2.6.11. For the other patches you have to talk to their authors
or hope for someone else to do it.

Regards
Patrick
