From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] netfilter: implement TCPMSS target for IPv6
Date: Tue, 16 Jan 2007 14:34:14 +0100
Message-ID: <45ACD456.6010200@trash.net>
References: <20070114192011.GA6270@clipper.ens.fr> <45ABCB29.7080600@trash.net>
	<87ac0jl1az.fsf@boz.loft.chdir.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Arnaud Ebalard <arno@natisbad.org>
In-Reply-To: <87ac0jl1az.fsf@boz.loft.chdir.org>
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

Arnaud Ebalard wrote:
> Sorry for the late post. Just to say that i also _had_ to implement  
> that (2.6.19.1 and iptables 1.3.7). I was testing it before pushing
> it ;-) too late. Anyway, patch is below for reference.

Thanks, I've applied the ip6tables TCPMSS extension to SVN.

> Question : I made a specific case for AH (even if deprecated) protected
> traffic to avoid clamping of that packets.  ipv6_skip_exthdr() simply
> does not verify that and it seems there is no check against that. Can
> you take a look at find_tcp_hdr in the patch below and tell me if i'm
> wrong ? (function is based on ipv6_find_hdr(), ipv6_prepare(),
> nf_ct_ipv6_skip_exthdr() and ipv6_skip_exthdr() code).

Mhh .. that makes sense, but I tend to prefer to let users take care
of that using their ruleset.
