From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: NetFilter unclean modue in 2.6.x kernels
Date: Mon, 24 Jan 2005 10:13:36 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0501241009530.6574@blackhole.kfki.hu>
References: <200501220013.56429.sov.rbsec@gmail.com>
	<20050121233328.GU14460@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.58.0501240922370.6574@blackhole.kfki.hu>
	<20050124085704.GA14460@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Oleg V. Sapon" <sov.rbsec@gmail.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050124085704.GA14460@sunbeam.de.gnumonks.org>
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

Hi Harald,

On Mon, 24 Jan 2005, Harald Welte wrote:

> > If there are plans to submit the unclean match into the kernel, I think
> > something like my port should be considered.
>
> No, I think we're pretty sure that we don't want to have it in the
> kernel again.

As far as I remember, the main concern was due to the ckecking of the
reserved fields, which can cause forward-incompatibility. Was something
else against the match? Just asking :-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
