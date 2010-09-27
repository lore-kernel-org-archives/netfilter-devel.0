From: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 5/6] conntrack: export lsm context rather than internal
 secid	via netlink
Date: Mon, 27 Sep 2010 12:51:06 -0400
Message-ID: <1285606266.2815.21.camel@localhost.localdomain>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>
	 <20100924204545.28355.92767.stgit@paris.rdu.redhat.com>
	 <4CA0799E.4010200@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
	netfilter-devel@vger.kernel.org, jmorris@namei.org,
	sds@tycho.nsa.gov, jengelh@medozas.de, paul.moore@hp.com,
	casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
	netfilter@vger.kernel.org, mr.dash.four@googlemail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <4CA0799E.4010200@netfilter.org>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2010-09-27 at 13:01 +0200, Pablo Neira Ayuso wrote:
> On 24/09/10 22:45, Eric Paris wrote:
> > @@ -172,4 +173,11 @@ enum ctattr_help {
> >   };
> >   #define CTA_HELP_MAX (__CTA_HELP_MAX - 1)
> >
> > +enum ctattr_secctx {
> > +	CTA_SECCTX_UNSPEC,
> > +	CTA_SECCTX_NAME,
> > +	__CTA_SECCTX_MAX
> > +};
> > +#define CTA_SECCTX_MAX (__CTA_SECCTX_MAX - 1)
> 
> I guess that you have included this nest for consistency with CTA_HELP. 
> My question: do you think that we'll include more attributes in that 
> nest in the future? Otherwise, I would remove that nest and put 
> CTA_SECCTX_NAME in the first level, since the nest would increase the 
> message size.

My initial thought was that you were right (and I did just copy the
CTA_HELP implementation), but now I've decided that I like that nest.  I
have no idea what future representation an LSM might use.  The only 2
LSMs that make sense to use this interface SELinux and SMACK both use a
string, but I don't know why we have to limit it to that....

-Eric

