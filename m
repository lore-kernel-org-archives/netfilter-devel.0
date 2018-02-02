From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: xt_hashlimit: do not allow empty names
Date: Fri, 2 Feb 2018 12:49:38 +0100
Message-ID: <20180202114938.jxsaun6w3hnfedfz@salvia>
References: <1517154099.3715.77.camel@gmail.com>
 <1517162045.3715.78.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517162045.3715.78.camel@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, Jan 28, 2018 at 09:54:05AM -0800, Eric Dumazet wrote:
> On Sun, 2018-01-28 at 07:41 -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > Syzbot reported a WARN() in proc_create_data() [1]
> > 
> > Issue here is that xt_hashlimit does not check that user space provided
> > an empty table name.
> 
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > ---
> >  net/netfilter/xt_hashlimit.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
> > index 5da8746f7b88ff4c9446f256e542e823a6a561b0..eae732e013df92a364b500645360d4606c283a75 100644
> > --- a/net/netfilter/xt_hashlimit.c
> > +++ b/net/netfilter/xt_hashlimit.c
> > @@ -894,6 +894,8 @@ static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
> >  			return -ERANGE;
> >  	}
> >  
> > +	if (!name[0])
> > +		return -EINVAL;
> >  	mutex_lock(&hashlimit_mutex);
> >  	*hinfo = htable_find_get(net, name, par->family);
> >  	if (*hinfo == NULL) {
> 
> I wonder if we should also check if name includes a '/' ?
> 
> if (!name[0] || strchr(name, '/'))
>     return -EINVAL;

We can probably add our own variant of dev_valid_name?

bool nf_valid_name(const char *name, size_t len)
{
        if (*name == '\0')
                return false;
        if (strlen(name) >= len)
                return false;
        if (!strcmp(name, ".") || !strcmp(name, ".."))
                return false;

        while (*name) {
                if (*name == '/' || *name == ':' || isspace(*name))
                        return false;
                name++;
        }
        return true;
}

Or place this in the core, something like:

bool net_valid_name(const char *name, size_t len)
{
        ...
}

then use it from dev_valid_name()

bool dev_valid_name(const char *name)
{
        return net_valid_name(name, IFNAMSIZ);
}

@Eric, I can give it a shot here to this, just let me know. Thanks!
