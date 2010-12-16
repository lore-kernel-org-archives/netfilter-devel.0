From: Thomas Graf <tgraf@infradead.org>
Subject: Re: Xtables2 Netlink spec
Date: Thu, 16 Dec 2010 09:05:37 -0500
Message-ID: <20101216140537.GA23297@canuck.infradead.org>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr>
 <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu>
 <4D00C6A4.6090305@netfilter.org>
 <alpine.LNX.2.01.1012140257430.7384@obet.zrqbmnf.qr>
 <4D08C892.3080704@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D08C892.3080704@netfilter.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Dec 15, 2010 at 02:54:26PM +0100, Pablo Neira Ayuso wrote:
> > BTW, can response messages - all those leading up to NLMSG_DONE -
> > have different nlmsg_type, or not?
> 
> They all have the same type.

This is not a MUST. It is perfectly legal to f.e.:

 -> FOO_GET (seq=1, NLM_F_REQUEST)
 <- FOO_DEL (seq=1, NLM_F_MULTI)
 <- FOO_ADD (seq=1, NLM_F_MULTI)
 <- NLMSG_DONE (seq=1)
