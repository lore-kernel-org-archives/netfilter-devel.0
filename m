From: Tom Eastep <teastep@shorewall.net>
Subject: Re: [Patch] ipsec-nat patches for 2.6.9
Date: Tue, 14 Dec 2004 10:47:04 -0800
Message-ID: <1103050024.22667.34.camel@ursa.shorewall.net>
References: <C7150F785DD9414B9F5B74FEBD08A322155891@ma-sv-ex2003.bkvision.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <C7150F785DD9414B9F5B74FEBD08A322155891@ma-sv-ex2003.bkvision.nl>
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

On Mon, 2004-10-25 at 10:19 +0200, Ronald Moesbergen wrote:
> Hi,
>  
> Serveral people have requested updated patches to be able to use NAT
> with ipsec. I have "fixed" the following pom-ng patches so they apply
> (and work) with kernel 2.6.9:
> 
> ipsec-01-output-hooks
> ipsec-02-input-hooks
> ipsec-03-policy-lookup
> ipsec-04-policy-checks
> 
> I hope someone finds them useful.

What is the timeline for getting these patches (and policy match) into
the kernel.org tree? The next major release of Shorewall relies on them
for native 2.6 IPSEC support.  

-Tom
-- 
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key
