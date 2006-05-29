From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] set match
Date: Tue, 30 May 2006 00:41:11 +0200
Message-ID: <447B7887.8000802@trash.net>
References: <1148838123.2516.1.camel@scaramouche.combox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Torsten Luettgert <t.luettgert@pressestimmen.de>
In-Reply-To: <1148838123.2516.1.camel@scaramouche.combox.de>
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

Torsten Luettgert wrote:
> Hello,
> 
> here's a simple patch for the set match in pom. It adds the
> new protoff parameter in the match function of ipt_set.c and
> changes struct ipt_ip * to void * in the checkentry function
> of ipt_set.c and ipt_SET.c, so they compile without warnings.

I'm leaving this to Jozsef since I don't which kernel version
he uses for development and I don't want to break stuff under
him :)
