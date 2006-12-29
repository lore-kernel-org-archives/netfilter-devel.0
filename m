From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Fix small bug in nfnl_subsys_open (uninitialized values)
Date: Fri, 29 Dec 2006 21:43:05 +0100
Message-ID: <45957DD9.9040105@netfilter.org>
References: <200612281958.35720.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Victor Stinner <victor.stinner@inl.fr>
In-Reply-To: <200612281958.35720.victor.stinner@inl.fr>
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

Victor Stinner wrote:
> I found a bug in libnfnetlink, function nfnl_subsys_open(). I attached a patch 
> to fix it.
> 
> The problem is that callback structures weren't initialized. So sometimes, 
> bytes are nul, sometimes... not.

Applied, thanks Victor.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
