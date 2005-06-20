From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] update raw patch in POM
Date: Mon, 20 Jun 2005 12:49:24 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0506201248510.28436@yvahk01.tjqt.qr>
References: <42A57FC4.7010508@tac.ch> <42A5B144.3090005@tac.ch>
	<42A625DA.7090807@eurodev.net> <42A6AB19.2040106@tac.ch>
	<42A6E685.3060408@eurodev.net>
	<42AEF774.8060300@tac.ch> <42B67BEC.1090105@tac.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <42B67BEC.1090105@tac.ch>
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


>nf_conntrack_put(struct nf_ct_info *nfct)
>{
>+        if ((((long) nfct) & 0xf8000000) && atomic_read(&nfct->master->use) <= 1

There is not a constant for 0xf8000000, is there?

>)
>+                BUG();
>        if (nfct && atomic_dec_and_test(&nfct->master->use))
>                nfct->master->destroy(nfct->master);
>}

Jan Engelhardt                                                               
--                                                                            
| Gesellschaft fuer Wissenschaftliche Datenverarbeitung Goettingen,
| Am Fassberg, 37077 Goettingen, www.gwdg.de
