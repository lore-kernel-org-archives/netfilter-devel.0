From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [CTNETLINK] Rework conntrack fields dumping logic on events
Date: Wed, 15 Nov 2006 08:43:37 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0611150838001.2638@blackhole.kfki.hu>
References: <4553D3D5.40408@netfilter.org>
	<Pine.LNX.4.64.0611102151300.26087@blackhole.kfki.hu>
	<4557B157.6010205@netfilter.org>
	<Pine.LNX.4.64.0611142055130.1650@blackhole.kfki.hu>
	<20061114205008.GA7114@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>, Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Schuster <schuster.sven@gmx.de>
In-Reply-To: <20061114205008.GA7114@zion.homelinux.com>
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

On Tue, 14 Nov 2006, Sven Schuster wrote:

> >  	list_for_each_entry(h, &helpers, list) {
> > -		if (nf_ct_tuple_mask_cmp(tuple, &h->tuple, &h->mask))
> > -			return h;
> > +		if (nf_ct_tuple_mask_cmp(tuple, &h->tuple, &h->mask)) {
> > +			/* Ignore dynamic helpers: we should log it */
> > +			if (h->tuple.src.u)
> > +				return h;
> > +			else
> > +				return NULL
> 
> missing a ';'??

Yes! I should have compiled the patched kernel. :-(

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
