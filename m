From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.20-rc6-mm1 (build)
Date: Sun, 28 Jan 2007 13:17:57 -0800
Message-ID: <20070128131757.90f5cfa4.randy.dunlap@oracle.com>
References: <20070127234928.64d8e437.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070127234928.64d8e437.akpm@osdl.org>
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

On Sat, 27 Jan 2007 23:49:28 -0800 Andrew Morton wrote:

> 
> Temporarily at
> 
> 	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm1/
> 
> will appear one day at
> 
> 	ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm1/


allyesconfig on x86_64 does not build for me:

drivers/built-in.o: In function `sis_init_one':
sata_sis.c:(.text.sis_init_one+0x1a1): undefined reference to `sis_info133'
sata_sis.c:(.text.sis_init_one+0x1ab): undefined reference to `sis_info133'
net/built-in.o: In function `q931_help':
nf_conntrack_h323_main.c:(.text.q931_help+0x6ad): undefined reference to `ip6_route_output'
nf_conntrack_h323_main.c:(.text.q931_help+0x6c3): undefined reference to `ip6_route_output'

Adrian Bunk has sent a patch for the sis_info133 problem.

---
~Randy
