From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] ct_sync 0.15 (corrected)
Date: Thu, 26 Aug 2004 13:39:33 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0408261333510.17019@blackhole.kfki.hu>
References: <1092407190.2402.120.camel@nienna.balabit>
	<20040819110646.GJ3921@sunbeam.de.gnumonks.org>
	<1092917551.2425.28.camel@nienna.balabit>
	<Pine.LNX.4.58.0408261015001.16945@blackhole.kfki.hu>
	<1093518747.2447.16.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1093518747.2447.16.camel@nienna.balabit>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Thu, 26 Aug 2004, KOVACS Krisztian wrote:

> > We could add the expect function to the ip_conntrack_helper structure and
> > identify it by the helper name in the update messages. The unregistered
> > helper in the H.323 conntrack/nat module could be registered with an
> > invalid, never matching port and let the expect function handle it as
> > before (because the real port is dynamic). I think that'd be sufficient in
> > solving the replication problem.
>
>   Sounds good. This way the could replicate the expectfn function along
> with the conntrack helper structure, and the unregistered helpers could
> be handled as well. Although this might be a bit more complicated than
> the current solution, but if we have to do some evil magic to handle
> H.323, we should do that in a ct_sync compatible manner if possible...

Because the so far unregistered H.323 helper were registered, that would
be fully ct_sync compatible, without the need to modify anyting in
ct_sync. The core/ct_sync should be modified for the expectn only and
that's a general requirement, independent of the H.323 helper.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
