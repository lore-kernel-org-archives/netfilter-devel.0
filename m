From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] netfilter: nf_ct_helper: warn when not applying
 default helper assignment
Date: Wed, 25 Jan 2017 11:13:03 -0800
Message-ID: <CA+55aFxiM=GscZtvGkWnSfo3L4MTK0J6OFR5VbisZ1feTCBW9g@mail.gmail.com>
References: <alpine.LSU.2.20.1701240038080.25515@cbobk.fhfr.pm>
 <CA+55aFyDbDxcT+OjcxLxJ87MsFgNi0WWNoBSzZvWgA+yuQSXkg@mail.gmail.com>
 <20170124012859.GA6375@salvia> <alpine.LSU.2.20.1701240827240.25515@cbobk.fhfr.pm>
 <alpine.LSU.2.20.1701241115050.25515@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        info@jablonka.cz, eric@regit.org
To: Jiri Kosina <jikos@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.20.1701241115050.25515@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jan 24, 2017 at 2:17 AM, Jiri Kosina <jikos@kernel.org> wrote:
> +       if (!helper) {
> +               if (unlikely(!net->ct.sysctl_auto_assign_helper &&
> +                               !net->ct.auto_assign_helper_warned &&
> +                               __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple))) {
> +                       pr_info("nf_conntrack: default automatic helper assignment "
> +                               "has been turned off for security reasons "
> +                               "and CT-based firewall rule not found. Use the "
> +                               "iptables CT target to attach helpers instead.\n");
> +                       net->ct.auto_assign_helper_warned = true;
> +               } else {
> +                       helper = __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
> +                       if (unlikely(!net->ct.auto_assign_helper_warned && helper &&
> +                                       !net->ct.auto_assign_helper_warned)) {
>                         pr_info("nf_conntrack: automatic helper "
>                                 "assignment is deprecated and it will "
>                                 "be removed soon. Use the iptables CT target "
>                                 "to attach helpers instead.\n");
>                         net->ct.auto_assign_helper_warned = true;
> +                       }
>                 }
>         }

I don't disagree that this kind of warning might be useful, but that
code makes my eyes bleed, and is really really hard to follow.

Please make it a helper function. And don't have crazy conditionals
with else statements and other crazy conditionals. With random
likely/unlikely things that are not necessariyl even true.

For example, you can rewrite the logic something like

    static struct nf_conntrack_helper *find_auto_helper(struct nf_conn *ct)
    {
            return __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple;
    }

    static struct nf_conntrack_helper *ct_lookup_helper(struct nf_conn
*ct, struct net *net)
    {
        struct nf_conntrack_helper *ret;

        if (!net->ct.sysctl_auto_assign_helper) {
                if (net->ct.auto_assign_helper_warned)
                        return NULL;
                if (!find_auto_helper(ct))
                        return NULL;

                .. warn about helper existing but not used ..

                net->ct.auto_assign_helper_warned = 1;
                return NULL;
        }

        ret = find_auto_helper(ct);
        if (!ret || net->ct.auto_assign_helper_warned)
                return ret;

        ... warn about helper existing but automatic helpers deprecated..

        net->ct.auto_assign_helper_warned = 1;
        return ret;
    }

and now each particular case is a lot easier to follow. Then you just have

        if (!helper) {
                helper = ct_lookup_helper(ct, net);
                if (!helper) {
                        if (help)
                                RCU_INIT_POINTER(help->helper, NULL);
                        return 0;
                }
         }

in __nf_ct_try_assign_helper()

All of the above is entirely untested and just written in my email
client. It may be garbage. It's not meant to be used, it's meant to
just illustrate avoiding complex nested conditionals. It's a few more
lines, but now each part has simple logic and is much more
understandable.

                       Linus
