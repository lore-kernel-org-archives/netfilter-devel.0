From: "Richard" <richard@o-matrix.org>
Subject: RE: [NEW TARGET] target for modifying conntrack timeout value
Date: Sun, 2 Jan 2005 09:42:13 -1000
Message-ID: <EINSTEINI9IJsaJbqJG0000077c@einstein.systemmetrics.com>
References: <20050102193559.GA2558@home.tig-grr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: 'Netfilter Development Mailinglist' <netfilter-devel@lists.netfilter.org>,
	'Pablo Neira' <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Tom Marshall'" <tommy@home.tig-grr.com>
In-Reply-To: <20050102193559.GA2558@home.tig-grr.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> > >
> > ok, I changed the code to this,
> > +	/* To refresh the expire timer value of a conntrack,
> > +	 * linux 2.6.9 kernel starts using ip_ct_refresh_acct(),
> > +	 * while older ones use ip_ct_refresh()
> > +	 */
> > +#ifdef ip_ct_refresh_acct
> > +	ip_ct_refresh_acct(ct, 0, NULL, new_expires);
> > +#else
> > +	ip_ct_refresh(ct, new_expires);
> > +#endif
> 
> Did you actually verify this works?
> 
> I don't see ip_ct_refresh_acct defined as a macro, only a forward decl.
> Forward decls don't count because ifdef operates on the preprocessor
level.
> You'll need another way to test (netfilter version, kernel version, etc.)
> 
I tried the following and it worked on 2.4.25, so I assume that the above
code works. And both versions compile without a problem.

#ifdef ip_ct_refresh
        ip_ct_refresh(ct, new_expires);
#else
        ip_ct_refresh_acct(ct, 0, NULL, new_expires);
#endif

Richard
