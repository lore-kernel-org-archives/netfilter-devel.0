From: Fabrice MARIE <fabrice@celestix.com>
Subject: Re: About a patch to unclean module.
Date: Sat, 22 Jun 2002 22:51:10 +0800
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206222251.10087.fabrice@celestix.com>
References: <Pine.LNX.4.21.0206212050210.23485-100000@dns.toxicfilms.tv>
Reply-To: fabrice@celestix.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>,
	netfilter-devel@lists.samba.org
In-Reply-To: <Pine.LNX.4.21.0206212050210.23485-100000@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello Maciej,

On Saturday 22 June 2002 03:00, Maciej Soltysiak wrote:
> Hello,
> I may say now, that I have finished writing the module, updating the
> lipipt_unclean.c, I have created the patches to the netfilter tree.
> But, suppose, Harald applies the patch. It will change libipt_unclean.c
> in a way, that withougt running patch-o-matic it will not compile, because
> it uses an include file
> KERNEL_DIR/include/linux/netfilter_ipv4/ipt_unclean.h which will be only
> available after patching the kernel tree.
> So how do we solve that?

The easiest way is to use the userspace patching facility of patch-o-matic.
Just look at extra/ipt_REJECT-fake-source.patch and especially
extra/ipt_REJECT-fake-source.patch.userspace for an example of userspace
patching.

> I see it by adding ipt_unclean.h to the netfilter tree.
> Or maybe I am missing something or forgetting about something, some simple
> solution.
> Regards,
> Maciej Soltysiak

Have a nice day,

Fabrice.
--
Fabrice MARIE
Senior R&D Engineer
Celestix Networks
http://www.celestix.com/

"Silly hacker, root is for administrators"
       -Unknown
