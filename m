From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: About a patch to unclean module.
Date: Fri, 21 Jun 2002 21:00:04 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.21.0206212050210.23485-100000@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I may say now, that I have finished writing the module, updating the
lipipt_unclean.c, I have created the patches to the netfilter tree.

But, suppose, Harald applies the patch. It will change libipt_unclean.c
in a way, that withougt running patch-o-matic it will not compile, because
it uses an include file
KERNEL_DIR/include/linux/netfilter_ipv4/ipt_unclean.h which will be only
available after patching the kernel tree.

So how do we solve that?
I see it by adding ipt_unclean.h to the netfilter tree.

Or maybe I am missing something or forgetting about something, some simple
solution.


Regards,
Maciej Soltysiak
