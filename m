From: Michael Rash <mbr@cipherdyne.com>
Subject: Re: string match -> new option
Date: Sat, 1 Mar 2003 10:47:03 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030301104703.A479@orthanc.gambrl01.md.comcast.net>
References: <15760529186.20030301025308@yahoo.es> <20030301063948.GF24025@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: macadanet@yahoo.es,
	netfilter devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20030301063948.GF24025@oknodo.bof.de>; from bof@bof.de on Sat, Mar 01, 2003 at 07:39:48AM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mar 01, 2003, Patrick Schaaf wrote:

> > If some package includes the string: GET ???????8????????? HTTP
> > the system will write in log file.
> 
> > What do people think? Is a good idea?
> 
> 1) it is mostly a bad idea to use the string match at all, as it does
>    not reassemble a TCP stream, and thus strings that happen to be
>    broken up in two TCP segments, are not matchable. This is a
>    fundamental limitation, making any security you get out of
>    such a rule dubious, best-effort, only-in-good-weather pseudo
>    security.

Agreed, if the expectation is that doing string matching is going to
act as a full-blown NIDS (which, as you point out, it certainly
can't).

Having string matching is nice though since allows me to detect
_some_ signatures without having to run a full-blown NIDS, and I can
do it directly within iptables itself.  Being able to reject (or at
least log) the latest Code xxx packets traversing my iptables
interfaces with a single rule is useful.

--Mike

Michael Rash
http://www.cipherdyne.com
Key fingerprint = 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F
