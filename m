From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: Re: Kernel compile error with ROUTE-ipv6 patch
Date: Mon, 27 Oct 2003 08:50:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1067241037.13397.29.camel@descartes>
References: <6068024.1067030166937.JavaMail.Administrator@pumbaa>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Internet Protocol version Six <inet6@mail.be>
In-Reply-To: <6068024.1067030166937.JavaMail.Administrator@pumbaa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le ven 24/10/2003 a 23:16, Internet Protocol version Six a ecrit :
> Hi all, I get an error with ROUTE-ipv6 enabled:
> 
> [...]
> net/network.o: In function `init':
> net/network.o(.text.init+0x19c0): undefined reference to `ip6t_register_target'
> make: *** [vmlinux] Error 1
> 
> If I disable this in menuconfig and then recompile, it compiles fine
> so it must be ROUTE-ipv6 that's causing this. How can I get this to
> compile? 

The only possible reason I see is that you probably compiled the
IP6 tables support as a module while the IPv6 ROUTE target
is (and must be) statically compiled inside the kernel.

The solution could be to simply say 'Y' instead of 'M' for the
IP6 tables support.

-- Cedric
