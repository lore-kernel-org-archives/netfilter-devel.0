From: Amin Azez <azez@ufomechanic.net>
Subject: Hacking iptables 1.3.5 for 2.6.17
Date: Fri, 30 Jun 2006 10:10:50 +0100
Message-ID: <e82pqq$3es$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Whats the official way to add extra extensions targets extensions/Makefile?

I generally patch extensions/Makefile to add to PF_EXT_SLIB, like
PF_EXT_SLIB+=new_extension

but then I get complaints about it being listed twice. Is there a neater
way to express extra extensions to the Makefile?

Also;

I don't think this problem is specific to iptables, but general to
building anything against a kernel.

If a kernel is built with the -O=dir option to place build files outside
of the source tree, then version.h, autoconf.h and compile.h are written
to dir/include/linux instead of src/include/linux

This means that
make KERNEL_DIR=src
is not enough, as dir also needs to be in the search path (or dir/include)

Probably it needs to be before KERNEL_DIR in the search path.



Sam
