From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] info file for ROUTE target
Date: Fri, 10 Dec 2004 09:43:50 +0100
Message-ID: <20041210084350.GB4121@oknodo.bof.de>
References: <1102603380.7528.98.camel@descartes.info.ucl.ac.be>
	<20041209195706.GA4121@oknodo.bof.de>
	<20041209212420.GD591@ti64.telemetry-investments.com>
	<1102667864.11255.2.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@lists.netfilter.org"
	<netfilter-devel@lists.netfilter.org>, Patrick Schaaf <bof@bof.de>,
	"Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Cedric de Launois <delaunois@info.ucl.ac.be>
Content-Disposition: inline
In-Reply-To: <1102667864.11255.2.camel@descartes.info.ucl.ac.be>
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

> > Presumably ip6t_ROUTE.c requires an out-of-line version of ndisc_get_neigh()
> > to be exported.
> 
> Agree.

I'm curious - why aren't such functions EXPORT_SYMBOL_GPLled?
Same question applies to the out-of-line ip_finish_output2 in ROUTE.
Methinks that would be much nicer. Is this a policy, or is it just
a communication problem?

best regards
  Patrick
