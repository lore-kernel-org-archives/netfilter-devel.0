From: =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: Re: [PATCH] netfilter: nf_tables: add SECMARK support
Date: Thu, 20 Sep 2018 11:32:59 +0200
Message-ID: <CAJ2a_DfGCRXaH9BkBj=0R1Cr3jiHQHgq-pU2HGuWudvWCSKLQg@mail.gmail.com>
References: <20180919231402.4482-1-cgzones@googlemail.com> <75b3fed9-e549-4ed0-c435-ec4795fc1e39@schaufler-ca.com>
 <20180920085048.tps2v4jkko7zjav4@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: casey@schaufler-ca.com, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, jmorris@namei.org,
        serge@hallyn.com, selinux <selinux@tycho.nsa.gov>,
        linux-security-module@vger.kernel.org
To: fw@strlen.de
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180920085048.tps2v4jkko7zjav4@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

> > > +   for (i = 0; i < ARRAY_SIZE(nft_basic_objects); i++) {
> > > +           err = nft_register_obj(nft_basic_objects[i]);
> > > +           if (err)
> > > +                   goto err;
> > > +   }
> > >
> > > -   for (i = 0; i < ARRAY_SIZE(nft_basic_types); i++) {
> > > -           err = nft_register_expr(nft_basic_types[i]);
> > > +   for (j = 0; j < ARRAY_SIZE(nft_basic_types); j++) {
> > > +           err = nft_register_expr(nft_basic_types[j]);
> > >             if (err)
> > >                     goto err;
> > >     }
> > > @@ -248,8 +260,12 @@ int __init nf_tables_core_module_init(void)
> > >     return 0;
> > >
> > >  err:
> > > +   while (j-- > 0)
> > > +           nft_unregister_expr(nft_basic_types[j]);
> > > +
> > >     while (i-- > 0)
> > > -           nft_unregister_expr(nft_basic_types[i]);
> > > +           nft_unregister_obj(nft_basic_objects[i]);
> > > +
> > >     return err;
>
> Do I read this right in that this is a error unroll bug fix?
> If so, could you please submit this as indepentent patch?
>
> Fixes should go into nf.git whereas feature goes to nf-next.git.

No, that should not be a unroll fix.
Currently there are no objects registered by the main nf_tables
module, so for nft_secmark_obj_type I had to introduce this new logic.

> > > +   if (err) {
> > > +           if (err == -EINVAL)
> > > +                   pr_notice_ratelimited("invalid security context \'%s\'\n", priv->ctx);
> > > +           else
> > > +                   pr_notice_ratelimited("unable to convert security context \'%s\': %d\n", priv->ctx, -err);
> > > +           return;
> > > +   }
>
> Please remove these printks(), they do not really help as user can't
> take any action anyway.

Aren't they helpful?
"invalid security context" can pop up if someone supplies an invalid
SELinux context (nft add secmark inet filter sshtag
\"this_is_invalid\") and uses it
"unable to convert security context" can pop up if no LSM is enabled
"unable to map security context" should never happen, but one never knows
"unable to obtain relabeling permission" can pop up if e.g. the
SELinux permission "kernel_t ssh_server_packet:packet relabelto" is
missing
