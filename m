From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re[2]: REJECT target
Date: Thu, 26 Jun 2003 12:14:51 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0306261214300.14851@dns.toxicfilms.tv>
References: <Pine.LNX.4.33.0306260830550.10452-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: DarKRaveR <DarKRaveR@habitat-b.de>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0306260830550.10452-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > I understood that, the question is why ? I got a scenarion, where I
> > would need it in the PREROUTING chain of the nat table, instead of
> > just dropping the packets ... Is there any reason, why it is only
> > available in the filter table. I mean, it's for filtering okay, but
> > maybe I want to reject connections properly at other places (like nat
> > table, prerouting) instead of plain stupid
> > dropping them and waiting at the client software to time out.
>
> Thy users of netfilter do not filter packets in the nat or mangle tables.
>
> [Check out the mailing list archive and the documentation if you do not
> know why. We discussed it countless times.]
Shouldn't it be in the FAQ then ?

Regards,
Maciej
