From: Gergely Madarasz <gorgo@broadband.hu>
Subject: Re: conntrack oops
Date: Mon, 2 Aug 2004 09:36:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040802073601.GV1703@thunderchild.debian.net>
References: <20040724093955.GC1703@thunderchild.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040724093955.GC1703@thunderchild.debian.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, Jul 24, 2004 at 11:39:55AM +0200, Gergely Madarasz wrote:
> Code;  c02416d5 <init_conntrack+30d/3dc>
> 00000000 <_EIP>:
> Code;  c02416d5 <init_conntrack+30d/3dc>   <=====
>    0:   83 78 18 00               cmpl   $0x0,0x18(%eax)   <=====
> Code;  c02416d9 <init_conntrack+311/3dc>
>    4:   74 15                     je     1b <_EIP+0x1b>
> Code;  c02416db <init_conntrack+313/3dc>
>    6:   8d 43 2c                  lea    0x2c(%ebx),%eax
> Code;  c02416de <init_conntrack+316/3dc>
>    9:   50                        push   %eax
> Code;  c02416df <init_conntrack+317/3dc>
>    a:   e8 1c ea ed ff            call   ffedea2b <_EIP+0xffedea2b>
> Code;  c02416e4 <init_conntrack+31c/3dc>
>    f:   89 c2                     mov    %eax,%edx
> Code;  c02416e6 <init_conntrack+31e/3dc>
>   11:   83 c4 04                  add    $0x4,%esp

It seems I didn't give enough information about this bug... :(

I guess there is a race condition somewhere, the oops occurs at:

        if (expected
            && expected->expectant->helper->timeout
            && ! del_timer(&expected->timeout))
                expected = NULL;

I added some debugging code around it. The problem seems to be triggered
by a tftp connection. Currently I have _lots_ of tftp requests going
through this firewall, about 2-3/sec, and ip_conntrack_tftp is loaded. The
oops occurs because expected->expectant->helper is NULL at the time of the
crash. It is an SMP machine btw. 

-- 
Madarasz Gergely   
gorgo@broadband.hu
