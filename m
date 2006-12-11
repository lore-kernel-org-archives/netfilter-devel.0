From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: iptables extension removal
Date: Mon, 11 Dec 2006 21:40:52 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0612112133460.11534@yvahk01.tjqt.qr>
References: <457DAF95.2050203@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <457DAF95.2050203@trash.net>
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


On Dec 11 2006 20:20, Patrick McHardy wrote:
>Subject: iptables extension removal

nth
random
 + don't say delete: it's just superceded by "statistic":

libipt_dstlimit.c		delete
 + obsoleted by hashlimit

libipt_mport.c			delete
 + obsoleted by multiport

ROUTE			move to pom
TARPIT			move to pom
 + this is already in pom(-ng)
