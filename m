From: Arnaud Ebalard <arno@natisbad.org>
Subject: Re: [patch] netfilter: implement TCPMSS target for IPv6
Date: Tue, 16 Jan 2007 15:22:52 +0100
Message-ID: <87hcurjbk3.fsf@boz.loft.chdir.org>
References: <20070114192011.GA6270@clipper.ens.fr>
	<45ABCB29.7080600@trash.net> <87ac0jl1az.fsf@boz.loft.chdir.org>
	<45ACD456.6010200@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


On 16 Jan 2007, Patrick McHardy wrote:
> > Question : I made a specific case for AH (even if deprecated) protected
> > traffic to avoid clamping of that packets.  ipv6_skip_exthdr() simply
> > does not verify that and it seems there is no check against that. Can
> > you take a look at find_tcp_hdr in the patch below and tell me if i'm
> > wrong ? (function is based on ipv6_find_hdr(), ipv6_prepare(),
> > nf_ct_ipv6_skip_exthdr() and ipv6_skip_exthdr() code).
> 
> Mhh .. that makes sense, but I tend to prefer to let users take care
> of that using their ruleset.

ok but:

  o They should at least be aware of that unexpected behavior because  
this will break AH protected TCP-connections in the _default_ case

  o mangling of such packet is equivalent to a drop for them, except  
that it will be a mess to debug at the other side (packet will flow,  
but will be invalid)

anyway, who uses AH ? ;)

a+
