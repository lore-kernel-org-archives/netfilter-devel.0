From: Octavio / Super <alvarezp@octavio.ods.org>
Subject: Re: microsoft messenger protocol helper
Date: Sat, 15 Mar 2003 13:21:14 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.2.0.9.0.20030315132103.00bbc9c0@192.168.0.1>
References: <000001c2eb36$0c2aad40$0301a8c0@viper>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
In-Reply-To: <000001c2eb36$0c2aad40$0301a8c0@viper>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Try compiling with -DMODULE and -D__KERNEL__. I don't know if -DMODVERSIONS should be used or not. Do not ask for a linked file, just compiled, like this:

gcc -DMODULE -D__KERNEL__ -c source.c -o output.o

At least that's what I was trying to use. I had several other errors because I had a problem with my distro, but I wish you luck.

Octavio.

At 10:01 p.m. 15/03/2003 +0100, Silvester Verdonskchot wrote:
>Hi All,
>
>I want to make a connection tracking helper / nat helper for the
>Microsoft messenger protocol. I read the netfilter hacking guide.
>There's one thing that's not clear to me.
>How do I get my new module compiled with the rest of netfilter? I tried
>compiling it separately and I get warnings about not using certain
>include files outside the kernel.
>
>Can anybody help me with this?
>
>Thanks
>
>Silvester

---
/**************************************************
Octavio Alvarez (aka: Super, Doogie)
ICQ# 42020731. MSN_ID: alvarezp2000@h0tmail.com
**************************************************/
