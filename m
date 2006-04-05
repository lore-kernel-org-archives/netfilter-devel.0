From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ip_conntrack section mismatch warning fix
Date: Wed, 05 Apr 2006 16:30:46 +0200
Message-ID: <4433D496.2090706@trash.net>
References: <20060404113233.4de507d3@dxpl.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen Hemminger <shemminger@osdl.org>
In-Reply-To: <20060404113233.4de507d3@dxpl.pdx.osdl.net>
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

Stephen Hemminger wrote:
> This is a bit of a hack. It eliminates the section mismatch warning from
> latest linker. What happens is the init_or_cleanup code gets called
> from cleanup() hook and the linker thinks it will reference __initdata
> because of it's limited static analysis.  By asking compiler to
> inline, it can eliminate that dead code. It does the __init text
> section to grow, but then the space can be reclaimed.

I think this might still fail without forced inlining. Our init
functions look like crap anyway, and the reason mostly seems to
be mass-registration of hooks, so I guess I'll clean that up
with a small helper function and then just split them.
