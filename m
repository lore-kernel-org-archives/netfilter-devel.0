From: Patrick McHardy <kaber@trash.net>
Subject: Re: Request: including tproxy patch to official iptables/kernel.
Date: Mon, 16 Oct 2006 07:48:34 +0200
Message-ID: <45331D32.5070209@trash.net>
References: <20061016114331.AF36.TSUNEO.YOSHIOKA@f-secure.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yoshioka Tsuneo <tsuneo.yoshioka@f-secure.com>
In-Reply-To: <20061016114331.AF36.TSUNEO.YOSHIOKA@f-secure.com>
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

Yoshioka Tsuneo wrote:
> Hello netfilter developers
> 
> There is tproxy patch for netfilter(iptables).
> tproxy enables application to set source IP address.
> I think that only tproxy patch can enable transparent proxy keeping
> source IP addresses.
> 
> And, until now, tproxy is developed and is used for long term, and seems
> stable to include official iptables/kernel release. There is also a patch
> for latest kernel.
> 
> So, I would like to suggest to include tproxy patch to official
> iptables/kernel release.
> Can you think about including this patch to official iptables/kernel
> release, if possible ?
> 
>    TPROXY
>        http://www.balabit.com/products/oss/tproxy/
> 
>    patch-o-matic extra repository
>      tproxy - iptables TPROXY target
>        http://www.iptables.org/projects/patch-o-matic/pom-extra.html#pom-extra-tproxy


These look quite old (2.4). The TPROXY developers were working on
a new approach last year at the netfilter workshop, but I don't
know if there was any further progress. Please talk to them directly
and ask them if they want to merge it upstream, and if so to submit
patches.
