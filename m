From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/2] Handle the routing changes in the MASQUERADE
 target
Date: Fri, 16 Nov 2012 22:38:25 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211162234050.14924@blackhole.kfki.hu>
References: <1352837857-22087-1-git-send-email-kadlec@blackhole.kfki.hu> <1352837857-22087-3-git-send-email-kadlec@blackhole.kfki.hu> <20121115114444.GA31335@1984> <alpine.DEB.2.00.1211151532500.7485@blackhole.kfki.hu> <20121116100914.GB25964@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:38643 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab2KPVi1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:38:27 -0500
In-Reply-To: <20121116100914.GB25964@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Fri, 16 Nov 2012, Pablo Neira Ayuso wrote:

> > Currently I'm trying to find a way to purge just the entries which are 
> > affected by the routing change (for example when there are muliple VPN 
> > tunnels). However that requires a new conntrack extension and it's 
> > nontrivial (at least for me) to figure out the required data from struct 
> > fib_info.
> > 
> > If the conntrack extension is used then of course the status bit is not 
> > required.
> 
> We can register now variable length conntrack extensions. I think we
> can use that feature to extend nf_conn_nat to allocate extra
> information for all working modes of MASQUERADE. It may require
> changing the nf_nat_setup_info interface to pass some new flags.
> 
> Regarding the variable length conntrack extensions, please check
> nf_ct_ext_add_length in net/netfilter/nf_conntrack_helper.c for
> instance.

I realized that there's no point to store the extra information in an 
extension: changing for example the weight of another routing rule may 
effect the conntrack entry. So we have to recheck the routing. Sigh.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
