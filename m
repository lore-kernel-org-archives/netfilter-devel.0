From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xt_LOG
Date: Thu, 23 Nov 2006 14:13:52 +0100
Message-ID: <45659E90.8020407@trash.net>
References: <Pine.LNX.4.64.0611142108260.1683@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.64.0611142108260.1683@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> Hi,
> 
> Attached is the xt_LOG module with a few IPv6 related fixes compared to 
> the original ip6t_LOG.c:
> 
> - paren could be left unclosed at printing IPv6 extension headers
> - MAC header printing of sit tunnels was wrong
> 
> Because IPv6 has got extension headers and not options, the string
> "OPT" was changed to "EXT", which implies backward-incompatibility.
> But the fixed extension header printing is already incompatible with 
> ip6t_LOG ;-). (If you disagree, it can be reverted back to "OPT" of 
> course.)


The unification is a nice thing, but I have some reservations
introducing incompatibilities after so many years, especially
considering it so far is the only option for IPv6 logging so
people probably will notice. Since its obsoleted by nfnetlink_log
anyway I doubt its worth fixing these purely cosmetical bugs.
