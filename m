From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: libiptc ... and matches , seg fault
Date: Fri, 15 Jul 2005 10:12:38 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0507151008050.20435@yvahk01.tjqt.qr>
References: <42D6AD2C.5070304@fastwebnet.it>
	<Pine.LNX.4.63.0507142117170.29183@localhost.localdomain>
	<42D76E84.7080906@fastwebnet.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: primero <primero@fastwebnet.it>
In-Reply-To: <42D76E84.7080906@fastwebnet.it>
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

> each libipt_MATCH has to call a register_match() in his init function passing
> an "iptables_match" structure has argument that is referred as "me" inside the
> register_match function.
>
> in my particular case me->version is equal to IPTABLES_VERSION (check out the
> libipt_tcp.c).

me->version might just be null, surprise, surprise.

I only see a 'me' member in the kernel interface, e.g. struct ipt_match, and 
'me' is a struct module *. And the "version" member of struct module * is set 
by MODULE_VERSION() macro AFAICG.


Jan Engelhardt
-- 
