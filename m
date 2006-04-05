From: Patrick McHardy <kaber@trash.net>
Subject: Re: fix kbuild warning in iptable_nat.o
Date: Thu, 06 Apr 2006 00:00:04 +0200
Message-ID: <44343DE4.70500@trash.net>
References: <1143719875.8469.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: kernel Janitors <kernel-janitors@lists.osdl.org>,
	"Randy.Dunlap" <rdunlap@xenotime.net>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Darren Jenkins" <darrenrjenkins@gmail.com>
In-Reply-To: <1143719875.8469.14.camel@localhost.localdomain>
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

Darren Jenkins\ wrote:
> G'day list
> 
> There are a couple of Kbuild warnings in net/ipv4/netfilter/ that would
> be nice to get rid of.
> 
> WARNING: net/ipv4/netfilter/ip_conntrack.o - Section mismatch: reference
> to .init.text:ip_conntrack_init from .text between 'init_or_cleanup' (at
> offset 0x7ea) and '__hash_conntrack'
> WARNING: net/ipv4/netfilter/iptable_nat.o - Section mismatch: reference
> to .init.text:ip_nat_rule_init from .text between 'init_or_cleanup' (at
> offset 0x455) and 'nat_decode_session'
> 
> I have a patch for the 'iptable_nat.o' warning below, and I was just
> wanting to check in and see if any of you netfilter guys had a problem
> with this patch, or with me doing a similar patch for the
> 'ip_canntrack.o' warning.
> 
> 
> Any input would be welcome, thanks in advance :). 

I have a patch queued that just splits the init/cleanup parts.
