From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] convert mport to multiport
Date: Mon, 27 Sep 2004 03:44:29 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4157707D.8010901@eurodev.net>
References: <415748E8.60000@eurodev.net>
	<41574F5E.1020409@eurodev.net>	<41575282.4030006@trash.net>
	<415755BC.8000706@eurodev.net> <41576D0A.9080103@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <41576D0A.9080103@eurodev.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira wrote:

> Attached the new patches, they respect userspace compatibility. I 
> tested them and they work for me.
>
> - Iptables patch is mport version (by Andreas Feber) with some broken 
> indentation fixed and a var renamed.
> - Kernel patch is mport with flags defined in a different way.


Hm, but old binary with new kernel and new binary with old kernel 
compatibilities are still broken anyway... mport also modifies the 
layout... so putting multiport and mport together without breaking 
things is not obvious. Oh, time to sleep...

regards,
Pablo
