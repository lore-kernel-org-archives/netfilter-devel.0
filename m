From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] info file for ROUTE target
Date: Thu, 9 Dec 2004 20:57:07 +0100
Message-ID: <20041209195706.GA4121@oknodo.bof.de>
References: <1102603380.7528.98.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Cedric de Launois <delaunois@info.ucl.ac.be>
Content-Disposition: inline
In-Reply-To: <1102603380.7528.98.camel@descartes.info.ucl.ac.be>
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

Hi Cedric,

> This little patch is to allow the ROUTE target to be applied by pom-ng
> on kernel >= 2.6.0. The patch just removes the "Requires: linux < 2.6.0"
> line from the ROUTE/info file.

Funny, I didn't notice anything strange applying to 2.6.10-rc1,
recently, without that modification. Is runme broken somehow?
Maybe I overlooked something.

A propos overlooked (hi list at large :) - I made two postings on
netfilter-devel recently, which were pure bugfixes for ROUTE,
and nobody seemed to care. Any idea why that was so?

https://lists.netfilter.org/pipermail/netfilter-devel/2004-November/017485.html
https://lists.netfilter.org/pipermail/netfilter-devel/2004-November/017514.html

I also made a new contribution, my --tee extension to ROUTE, which also
went completely uncommented.

https://lists.netfilter.org/pipermail/netfilter-devel/2004-November/017515.html

and finally, unrelated to ROUTE, but equally ignored:

https://lists.netfilter.org/pipermail/netfilter-devel/2004-November/017540.html

I DEMAND IMMEDIATE ATTENTION TO THESE IMPORTANT MATTERS!!!111111111111!!!!!

:)
  Patrick
