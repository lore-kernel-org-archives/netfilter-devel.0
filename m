From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Thu, 26 Aug 2004 18:14:43 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040826161443.GA26828@sch.bme.hu>
References: <1092407190.2402.120.camel@nienna.balabit>
	<20040819110646.GJ3921@sunbeam.de.gnumonks.org>
	<1092917551.2425.28.camel@nienna.balabit>
	<Pine.LNX.4.58.0408261015001.16945@blackhole.kfki.hu>
	<1093518747.2447.16.camel@nienna.balabit>
	<Pine.LNX.4.58.0408261333510.17019@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0408261333510.17019@blackhole.kfki.hu>
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

On Thu, Aug 26, 2004 at 01:39:33PM +0200, Jozsef Kadlecsik wrote:
> Because the so far unregistered H.323 helper were registered, that would
> be fully ct_sync compatible, without the need to modify anyting in
> ct_sync. The core/ct_sync should be modified for the expectn only and
> that's a general requirement, independent of the H.323 helper.

  In fact, ct_sync would not require any modifications, so I'd prefer this
solution.

-- 
 KOVACS Krisztian
