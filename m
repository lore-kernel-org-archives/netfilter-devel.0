From: Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH v2] netfilter: properly initialize xt_table_info structure
Date: Thu, 31 May 2018 13:32:16 +0200
Message-ID: <20180531113215.sbqqjip2gxvhl2eg@unicorn.suse.cz>
References: <a8fadcf4-c2dd-7465-9b41-189eb97a3dd2@gmail.com>
 <20180517100908.GA3150@kroah.com>
 <alpine.LSU.2.20.1805171232210.30649@n3.vanv.qr>
 <20180517132012.GA29160@kroah.com>
 <20180518092756.odlyvxcpgbuistqq@breakpoint.cc>
 <20180526145449.GA10379@kroah.com>
 <CANZU63WyNL4qUJx2eS3gokPMBJLn5=C4-bnOSEF5trX3jGngUA@mail.gmail.com>
 <20180531082436.ffd6gkbuk6xpm47y@breakpoint.cc>
 <20180531085116.GA17729@kroah.com>
 <CANZU63VE7fWNL+PJrLp7-5PBS6R6RQPvhw2QgqAK8NhX4uQc9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Westphal <fw@strlen.de>,
        Jan Engelhardt <jengelh@inai.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Hackmann <ghackmann@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: peter pi <tiangangpi@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANZU63VE7fWNL+PJrLp7-5PBS6R6RQPvhw2QgqAK8NhX4uQc9Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, May 31, 2018 at 05:40:40PM +0800, peter pi wrote:
> 
> My test method is very simple:
> 1, In copy_to_user, add a function call like my_examine(from, n) to check
> every 8 bytes. There is an kernel function called  virt_addr_valid which
> can check if the value is a address value.
> 2, Print a kernel log when there is a leak detected in function my_examine
> 3, Run iptables-save or ip6tables-save in shell, it will hit the kernel
> code path of the problem

I think I start to understand the problem. IPT_SO_GET_ENTRIES leads to
calling copy_entries_to_user() which copies the entries as they are to
user provided buffer. It also copies instances of struct xt_entry_match
and struct xt_entry_target which contain kernel pointers. We then
rewrite them with match/target name for userspace but the layout looks
(on x86_64) like this

/* offset    |  size */  type = struct xt_entry_match {
/*    0      |    32 */    union {
/*                32 */        struct {
/*    0      |     2 */            __u16 match_size;
/*    2      |    29 */            char name[29];
/*   31      |     1 */            __u8 revision;

                                   /* total size (bytes):   32 */
                               } user;
/*                16 */        struct {
/*    0      |     2 */            __u16 match_size;
/* XXX  6-byte hole  */
/*    8      |     8 */            struct xt_match *match;

                                   /* total size (bytes):   16 */
                               } kernel;
/*                 2 */        __u16 match_size;

                               /* total size (bytes):   32 */
                           } u;
/*   32      |     0 */    unsigned char data[];

                           /* total size (bytes):   32 */
                         }


so that if match name is no longer than five characters (which is often
the case), writing to .u.user.name leaves .u.kernel.match untouched. The
same problem exists in struct xt_entry_target.

Unless there are other kernel pointers leaked, the solution should be
simple: explicitly zero the copy of .u.kernel.match (.u.kernel.target)
before we copy the name. I haven't checked yet if compat_ code path
suffers from the same problem.

Michal Kubecek
