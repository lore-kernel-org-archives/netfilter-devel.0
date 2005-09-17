From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: git3 build dies at net/built-in.o: undefined __nfa_fill
Date: Sat, 17 Sep 2005 14:59:22 +0200
Message-ID: <432C132A.8020301@gmail.com>
References: <dgfp9f$7i8$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751101AbVIQM7o@vger.kernel.org>
To: sean <seandarcy2@gmail.com>
In-Reply-To: <dgfp9f$7i8$1@sea.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

sean napsal(a):

> On amd64, gcc-4.0.1:
>
> .....
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> net/built-in.o: In function `ip_ct_port_tuple_to_nfattr':
> : undefined reference to `__nfa_fill'
> net/built-in.o: In function `ip_ct_port_tuple_to_nfattr':
> : undefined reference to `__nfa_fill'
> net/built-in.o: In function `tcp_to_nfattr':
> : undefined reference to `__nfa_fill'
> net/built-in.o: In function `icmp_tuple_to_nfattr':
> : undefined reference to `__nfa_fill'
> net/built-in.o: In function `icmp_tuple_to_nfattr':
> : undefined reference to `__nfa_fill'
> net/built-in.o:: more undefined references to `__nfa_fill' follow
> make: *** [.tmp_vmlinux1] Error 1

.config needed
NETFILTER_NETLINK is not selected, maybe.

-- 
Jiri Slaby         www.fi.muni.cz/~xslaby
~\-/~      jirislaby@gmail.com      ~\-/~
241B347EC88228DE51EE A49C4A73A25004CB2A10
