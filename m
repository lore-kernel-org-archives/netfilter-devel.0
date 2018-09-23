From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 1/2] netfilter: nf_tables: add SECMARK support
Date: Sun, 23 Sep 2018 17:41:29 +0200
Message-ID: <20180923154129.ht55keytmgxcnl73@breakpoint.cc>
References: <20180923091611.19815-1-cgzones@googlemail.com>
 <20180923135555.7kwa3kyachwcfy24@breakpoint.cc>
 <CAJ2a_DfCmbFmpTngFnXzYy07gvEzN5UhAhrE8Cd8PowevrLUNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: fw@strlen.de, pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, jmorris@namei.org,
        serge@hallyn.com, selinux <selinux@tycho.nsa.gov>,
        linux-security-module@vger.kernel.org
To: Christian =?iso-8859-15?Q?G=F6ttsche?= <cgzones@googlemail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJ2a_DfCmbFmpTngFnXzYy07gvEzN5UhAhrE8Cd8PowevrLUNw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Christian Göttsche <cgzones@googlemail.com> wrote:
> > Can you change this to:
> >
> > struct nft_secmark {
> >         u32 secid;
> >         char *ctx;
> > };
> 
> Does the nla_policy struct needs an update too? (regarding then .len member)
> 
> +static const struct nla_policy nft_secmark_policy[NFTA_SECMARK_MAX + 1] = {
> +        [NFTA_SECMARK_CTX] = { .type = NLA_STRING, .len =
> NFT_SECMARK_CTX_MAXLEN },
> +}
> 
> NFT_SECMARK_CTX_MAXLEN might be dropped then..

Better keep it, we can always increase this later it if needed.
Given the length matches what xtables uses it should be fine.
