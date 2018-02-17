From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH RFC 0/4] net: add bpfilter
Date: Sat, 17 Feb 2018 13:33:39 +0100
Message-ID: <20180217123339.GK7843@nataraja>
References: <20180216134023.15536-1-daniel@iogearbox.net>
 <20180216145727.GC32618@breakpoint.cc>
 <20180216161408.GA3776@breakpoint.cc>
 <9182f7b2-da9c-765e-028f-8b9e5c5d4716@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        alexei.starovoitov@gmail.com
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9182f7b2-da9c-765e-028f-8b9e5c5d4716@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Daniel,

On Fri, Feb 16, 2018 at 09:44:01PM +0100, Daniel Borkmann wrote:
> We started out with the
> iptables part in the demo as the majority of bigger infrastructure projects
> all still rely heavily on it (e.g. docker, k8s to just name two big ones).

docker is exec'ing the iptables command line program.  So one could simply
offer a syntactically compatible userspace replacement that does the compilation
in userspce and avoid the iptables->libiptc->setsockopt->userspace roundtrip
and the associated changes to the kernel module loader you introduced.

kubernetes is using iptables-restore, which is part of iptables and
again has the same syntax.  However, it aovids the per-rule fork+exec
overhead, which is why the netfilter project has been recommending it to
be used in such situations.

Do you have a list of known projects that use the legacy sockopt-based
iptables uapi directly, without using code from the iptables.git
codebase (e.g. libiptc, iptables or iptables-restore)?  IMHO only
those projects would benefit from the approach you have taken vs. an
approach that simply offers a compatible commandline syntax.

> Usually they have their requests to iptables baked into their code directly
> which probably won't change any time soon, so thought was that they could
> benefit initially from it once there would be sufficient coverage.

If the binary offeers the same syntax (it could even be a fork/version
of the iptables codebase, only using the parsing without the existing
backend generating the ruleS), the same goal could be achieved.

The above of course assumes that you have a 100% functional replacement
(for 100% of the features that your use cases use) underneath the
"iptables command syntax" compatibility.  But you need that in both
cases, whether you use the existing userspace api or not.

Regards,
	Harald
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
