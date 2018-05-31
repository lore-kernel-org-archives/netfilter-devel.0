From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] netfilter: properly initialize xt_table_info structure
Date: Thu, 31 May 2018 18:25:30 +0200
Message-ID: <20180531162530.GA20226@kroah.com>
References: <alpine.LSU.2.20.1805171232210.30649@n3.vanv.qr>
 <20180517132012.GA29160@kroah.com>
 <20180518092756.odlyvxcpgbuistqq@breakpoint.cc>
 <20180526145449.GA10379@kroah.com>
 <CANZU63WyNL4qUJx2eS3gokPMBJLn5=C4-bnOSEF5trX3jGngUA@mail.gmail.com>
 <20180531082436.ffd6gkbuk6xpm47y@breakpoint.cc>
 <20180531085116.GA17729@kroah.com>
 <CANZU63VE7fWNL+PJrLp7-5PBS6R6RQPvhw2QgqAK8NhX4uQc9Q@mail.gmail.com>
 <20180531113215.sbqqjip2gxvhl2eg@unicorn.suse.cz>
 <20180531115557.sxfbgtgzy5gh5ldl@unicorn.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: peter pi <tiangangpi@gmail.com>, Florian Westphal <fw@strlen.de>,
        Jan Engelhardt <jengelh@inai.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Hackmann <ghackmann@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: Michal Kubecek <mkubecek@suse.cz>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180531115557.sxfbgtgzy5gh5ldl@unicorn.suse.cz>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, May 31, 2018 at 01:55:57PM +0200, Michal Kubecek wrote:
> On Thu, May 31, 2018 at 01:32:16PM +0200, Michal Kubecek wrote:
> > I think I start to understand the problem. IPT_SO_GET_ENTRIES leads to
> > calling copy_entries_to_user() which copies the entries as they are to
> > user provided buffer. It also copies instances of struct xt_entry_match
> > and struct xt_entry_target which contain kernel pointers. We then
> > rewrite them with match/target name for userspace but the layout looks
> > (on x86_64) like this
> > 
> > /* offset    |  size */  type = struct xt_entry_match {
> > /*    0      |    32 */    union {
> > /*                32 */        struct {
> > /*    0      |     2 */            __u16 match_size;
> > /*    2      |    29 */            char name[29];
> > /*   31      |     1 */            __u8 revision;
> > 
> >                                    /* total size (bytes):   32 */
> >                                } user;
> > /*                16 */        struct {
> > /*    0      |     2 */            __u16 match_size;
> > /* XXX  6-byte hole  */
> > /*    8      |     8 */            struct xt_match *match;
> > 
> >                                    /* total size (bytes):   16 */
> >                                } kernel;
> > /*                 2 */        __u16 match_size;
> > 
> >                                /* total size (bytes):   32 */
> >                            } u;
> > /*   32      |     0 */    unsigned char data[];
> > 
> >                            /* total size (bytes):   32 */
> >                          }
> > 
> > 
> > so that if match name is no longer than five characters (which is often
> > the case), writing to .u.user.name leaves .u.kernel.match untouched. The
> > same problem exists in struct xt_entry_target.
> 
> And this should no longer happen since the series
> 
>  f32815d21d4d ("xtables: add xt_match, xt_target and data copy_to_user functions")
>  f77bc5b23fb1 ("iptables: use match, target and data copy_to_user helpers")
>  e47ddb2c4691 ("ip6tables: use match, target and data copy_to_user helpers")
>  244b531bee2b ("arptables: use match, target and data copy_to_user helpers")
>  b5040f6c33a5 ("ebtables: use match, target and data copy_to_user helpers")
>  4915f7bbc402 ("xtables: use match, target and data copy_to_user helpers in compat")
>  ec2318904965 ("xtables: extend matches and targets with .usersize")
> 
> changed the logic in 4.11-rc1.

Thank you so much for the detailed description.  And sorry for digging
up this old issue.  Peter, if you could verify that you do not see this
issue on a kernel newer than 4.11, that would be wonderful.

Michal, do you think it is worth backporting those commits to the 4.9.y
and 4.4.y stable kernels to remove this problem there?

thanks,

greg k-h
