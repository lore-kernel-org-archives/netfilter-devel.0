From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_conntrack_get ip_conntrack_put assymetry
Date: Mon, 03 Jul 2006 20:28:39 +0200
Message-ID: <44A961D7.5030204@trash.net>
References: <e80p74$nhi$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <e80p74$nhi$1@sea.gmane.org>
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

Amin Azez wrote:
> How is it that ip_conntrack_put does an nf_conntrack_put, but
> ip_conntrack_get does not do nf_conntrack_get or otherwise increase the
> ref count.
> 
> This asymmetry is likely to be confusing, or am I already confused?

I don't like it either, a lot of the conntrack code really wants some
cleanup. The general inconsisteny in function naming (and names like
ip_conntrack_find_get) are not very pretty either.
