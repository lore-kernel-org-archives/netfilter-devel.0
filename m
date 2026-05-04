Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEBC3988E4;
	Mon,  4 May 2026 23:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777936571; cv=none; b=UpomWA5Nn+Aygk3QOMcBLF5akA+oBjrqluS0jiHodv0MT2YvZ8k+G2OB3hqu/bw7lMlFUIWE6Uf4J8oamNhjEKTLd6n50lS+WmV2sGMBSgymOiJTRf/w3BNDa4qExcytlBbSxyjBQflvSxtg2sAPlajvsJ2yEJtcZmnMEHFenvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777936571; c=relaxed/simple;
	bh=z/IwEabEGMkMutEiXXMOngJfCaGhkT9gsXkp1eMqZ8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+VbsDNEAPkxFrStVgeZOTeMEr0IGzAI8lvauFVE0T8r20w6eZ5Nti+/ks2yTu2QN0sQyVtCAj3ptUMooG6zslKfiW79g3E1K2JZYGK+V4l05fSz+yiavQvFEqjop49SqeRSfqWxRwLj3J4dHqTTPgKALrrJCBkSmmPvjEyAEMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eZfiXreV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eZfiXreV"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B380E6017D;
	Tue,  5 May 2026 01:16:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777936564;
	bh=VT5MwRkATQPD60mCpAYF97d9SCIKVmkZ8YSLwDvh06I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eZfiXreVeBV6zU5zGnTUYG1rXWcDBubUTWpBVbsOJnFM7KNoCvSAAXqYuhgun0RBD
	 yUuDsTa3eOVlethGbVzvhtk13P8pjjPQSo6uRPvyP4xt2fICPrhI0UBd4pOSQ3PNLK
	 oFPiAQtqvZfMGX+LZ8/Cx4QtoeU6uo1Dd1BB7c24Cl1X0JiPqfOCTutjXeBUSfiUp7
	 cVeNqNvBBMM4P6j5kGLKFaOO39EcK+dKsFaMAsnUl3HRZ32wedcKP7BUvavNPTPT1h
	 eO/CuK+ri76ysqut7wn4mGQpjiLsvAS35Lda8xtGCzkrqDuZmw2ia7JiT2APBiMuHR
	 0C7uzyIDnScyQ==
Date: Tue, 5 May 2026 01:16:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ilya Maximets <i.maximets@ovn.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org,
	Eelco Chaudron <echaudro@redhat.com>,
	Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH net 06/12] netfilter: nf_conntrack_expect: honor
 expectation helper field
Message-ID: <afkosr2fDEPA_jX9@chamomile>
References: <20260326125153.685915-1-pablo@netfilter.org>
 <20260326125153.685915-7-pablo@netfilter.org>
 <8fd5d3a3-d1d7-4542-a0db-1678989940d4@ovn.org>
 <afSCXEg-X-ieL9cY@chamomile>
 <ef01005e-d867-4936-b138-b98f37e5f394@ovn.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BoDvjb+CgOGFYgDu"
Content-Disposition: inline
In-Reply-To: <ef01005e-d867-4936-b138-b98f37e5f394@ovn.org>


--BoDvjb+CgOGFYgDu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Ilya,

On Mon, May 04, 2026 at 02:19:20PM +0200, Ilya Maximets wrote:
> On 5/1/26 12:37 PM, Pablo Neira Ayuso wrote:
> > Hi Ilya,
> > 
> > On Thu, Apr 30, 2026 at 10:58:38PM +0200, Ilya Maximets wrote:
> >> On 3/26/26 1:51 PM, Pablo Neira Ayuso wrote:
> >>> The expectation helper field is mostly unused. As a result, the
> >>> netfilter codebase relies on accessing the helper through exp->master.
> >>>
> >>> Always set on the expectation helper field so it can be used to reach
> >>> the helper.
> >>>
> >>> nf_ct_expect_init() is called from packet path where the skb owns
> >>> the ct object, therefore accessing exp->master for the newly created
> >>> expectation is safe. This saves a lot of updates in all callsites
> >>> to pass the ct object as parameter to nf_ct_expect_init().
> >>>
> >>> This is a preparation patches for follow up fixes.
> >>>
> >>> Signed-off-by: Florian Westphal <fw@strlen.de>
> >>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> >>> ---
> >>
> >> Hi, Pablo and Florian.
> >>
> >> I was investigating FTP test failures in OVS with 7.0 kernel and bisected
> >> the issue down to this commit.  AFAIU, with this change all the related
> >> connections over time gain their parents' helpers,.  This is causing a change
> >> visible to the userspace, because FTP data connections are now reported to
> >> have helpers in the conntrack dump:
> >>
> >> # conntrack -L
> >> tcp      6 119 TIME_WAIT src=10.1.1.1 dst=10.1.1.2 sport=59534 dport=21 \
> >>                          src=10.1.1.2 dst=10.1.1.1 sport=21    dport=59534 \
> >>            [ASSURED] mark=0 helper=ftp use=2
> >> tcp      6 119 TIME_WAIT src=10.1.1.2 dst=10.1.1.1 sport=52709 dport=52381 \
> >>                          src=10.1.1.1 dst=10.1.1.2 sport=52381 dport=52709 \
> >>            [ASSURED] mark=0 helper=ftp use=1
> >>
> >> Before this commit only the control connection had helper=ftp reported in
> >> the dump.  The traffic seems to work fine, but our tests fail because we
> >> do not expect the helper attached.
> >>
> >> AFAIU, it's generally not something that should be happening, as helpers
> >> on data connections do not really make much sense.  But I'm just trying to
> >> figure out if you would consider this as a regression and fix in the kernel
> >> or if we should adjust our userspace components for this new dump content,
> >> which would not be very straightforward to do if we want to be able to run
> >> tests on both old and the new versions.
> >>
> >> What do you think?
> > 
> > It seems previous behaviour to 9c42bc9db90a was inconsistent, ie. only
> > the h323 helper sets on exp->helper, then it shows helper= in expected
> > connections via ctnetlink. I guess this is for debugging given that
> > h323 is actually a family of helpers.
> > 
> > To consistently skip dumping this for expected connections, probably
> > this is the way to do:
> > 
> > diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conn
> > index eda5fe4a75c8..9491ae9e080e 100644
> > --- a/net/netfilter/nf_conntrack_netlink.c
> > +++ b/net/netfilter/nf_conntrack_netlink.c
> > @@ -226,7 +226,7 @@ static int ctnetlink_dump_helpinfo(struct sk_buff *sk
> >         const struct nf_conn_help *help = nfct_help(ct);
> >         struct nf_conntrack_helper *helper;
> >  
> > -       if (!help)
> > +       if (!help || ct->status & IPS_EXPECTED)
> >                 return 0;
> >  
> >         rcu_read_lock();
> 
> I'm not sure.  I tried this change and it fixed one case but broke another.
> Looking at what we're testing, the old behavior (at least for FTP) was:
> "if helper was committed - report it, if not - don't".  i.e. it's not really
> about the connection being expected it's about if the user committed the
> helper for the connection or not.
>
> Let me explain a few scenarios that we have in the OVS system tests and what
> I see with the old kernel (6.19), the new (7.0) and the patch above.
> 
> A) The first scenario has the following OpenFlow rules (simplified):
> 
>   table=0,in_port=1,tcp,action=ct(alg=ftp,commit),2
>   table=0,in_port=2,tcp,action=ct(table=1)
>   table=1,in_port=2,tcp,ct_state=+trk+est,action=1
>   table=1,in_port=2,tcp,ct_state=+trk+rel,action=1
> 
> This set of rule blindly commits every packet coming from port 1 with the
> helper and sends to port 2.  Packets from port 2 are passed through ct and
> only related or established traffic is passed to port 1.  This is a very
> rudimentary setup that users can make to allow ftp from port 1 towards port 2,
> but not in the opposite direction.
> 
> For this scenario regardless of the kernel version or the patch above I see
> that both the data and the control connections have a helper reported in the
> ctnetlink dump.

This ruleset then is attached the conntrack helper to data connection,
that is, ALG is inspecting the FTP data connection but it will just
find no patterns because it is only the FTP control connection that
creates expectations?

> B) The second scenario:
> 
>   table=0,in_port=1,tcp,action=ct(table=1)
>   table=1,in_port=1,tcp,ct_state=+trk+new,action=ct(commit,alg=ftp),2
>   table=1,in_port=1,tcp,ct_state=+trk+est,action=2
> 
>   table=0,in_port=2,tcp,action=ct(table=1)
>   table=1,in_port=2,tcp,ct_state=+trk+new+rel,action=ct(commit),1
>   table=1,in_port=2,tcp,ct_state=+trk+est,action=1
> 
> This is a more reasonable setup where new connections are committed on the
> way from 1 to 2 and new related connections are committed on the way from
> 2 to 1.  This allows port 1 to initiate the control connection and the port
> 2 to initiate the related data connection.
> 
> In case of active FTP (port 1 initiates control, port 2 initiates the data):
> - old:   control has the helper, data does not.
> - new:   both have the helper.
> - patch: control has the helper, data does not.
> 
> In case of passive FTP (port 1 initiates both the control and data):
> - old:   both have the helper (because both are +new traffic from port 1).
> - new:   both have the helper.
> - patch: control has the helper, data does not.
>
> C) We can modify the scenario B to avoid committing the helper on related:
> 
>   table=0,in_port=1,tcp,action=ct(table=1)
>   table=1,in_port=1,tcp,ct_state=+trk+new-rel,action=ct(commit,alg=ftp),2
>   table=1,in_port=1,tcp,ct_state=+trk+new+rel,action=ct(commit),2
>   table=1,in_port=1,tcp,ct_state=+trk+est,action=2
> 
>   table=0,in_port=2,tcp,action=ct(table=1)
>   table=1,in_port=2,tcp,ct_state=+trk+new+rel,action=ct(commit),1
>   table=1,in_port=2,tcp,ct_state=+trk+est,action=1
> 
> Here we have (same for active and passive):
> - old:   control has the helper, data does not.
> - new:   both have the helper.
> - patch: control has the helper, data does not.
>
> I hope that clarifies the situation a little bit.
> 
> So, if we want to restore the old behavior, the we'd probably need to track
> how connection gained the helper, i.e. was it via commit or was it inherited.
>
> I'm also not sure why we see the helper with the patch above in scenario A that
> commits established traffic, but not in B or C that only commits new traffic.

Thanks for the detailed report. It seems I changed the semantics of
exp->helper, this used to be use to set a new helper for an expected
connection, which is the case for sip and h323.

Would this patch help address the issue you are observing?

Thanks.

--BoDvjb+CgOGFYgDu
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="fix-exp-helper.patch"

commit 39b6894dd511e14450e2a640eeaa83379e0f8eb1
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue May 5 01:15:19 2026 +0200

    x

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index e9a8350e7ccf..80f50fd0f7ad 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -45,9 +45,12 @@ struct nf_conntrack_expect {
 	void (*expectfn)(struct nf_conn *new,
 			 struct nf_conntrack_expect *this);
 
-	/* Helper to assign to new connection */
+	/* Helper that created this expectation */
 	struct nf_conntrack_helper __rcu *helper;
 
+	/* Helper to assign to new connection */
+	struct nf_conntrack_helper __rcu *assign_helper;
+
 	/* The conntrack of the master connection */
 	struct nf_conn *master;
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b08189226320..656287d16d86 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1815,10 +1815,10 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 			__set_bit(IPS_EXPECTED_BIT, &ct->status);
 			/* exp->master safe, refcnt bumped in nf_ct_find_expectation */
 			ct->master = exp->master;
-			if (exp->helper) {
+			if (exp->assign_helper) {
 				help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 				if (help)
-					rcu_assign_pointer(help->helper, exp->helper);
+					rcu_assign_pointer(help->helper, exp->assign_helper);
 			}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 3f5c50455b71..b2fe6554b9cf 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -643,7 +643,7 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_TCP, NULL, &port);
-	rcu_assign_pointer(exp->helper, &nf_conntrack_helper_h245);
+	rcu_assign_pointer(exp->assign_helper, &nf_conntrack_helper_h245);
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
@@ -767,7 +767,7 @@ static int expect_callforwarding(struct sk_buff *skb,
 	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
-	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
 	if (memcmp(&ct->tuplehash[dir].tuple.src.u3,
@@ -1234,7 +1234,7 @@ static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 				&ct->tuplehash[!dir].tuple.src.u3 : NULL,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_TCP, NULL, &port);
-	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
 	exp->flags = NF_CT_EXPECT_PERMANENT;	/* Accept multiple calls */
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
@@ -1306,7 +1306,7 @@ static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_UDP, NULL, &port);
-	rcu_assign_pointer(exp->helper, nf_conntrack_helper_ras);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_ras);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect RAS ");
@@ -1523,7 +1523,7 @@ static int process_acf(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
@@ -1577,7 +1577,7 @@ static int process_lcf(struct sk_buff *skb, struct nf_conn *ct,
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
-	rcu_assign_pointer(exp->helper, nf_conntrack_helper_q931);
+	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931);
 
 	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 1eb55907d470..d24bfa9e8234 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1383,7 +1383,7 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 	nf_ct_expect_init(exp, SIP_EXPECT_SIGNALLING, nf_ct_l3num(ct),
 			  saddr, &daddr, proto, NULL, &port);
 	exp->timeout.expires = sip_timeout * HZ;
-	rcu_assign_pointer(exp->helper, helper);
+	rcu_assign_pointer(exp->assign_helper, helper);
 	exp->flags = NF_CT_EXPECT_PERMANENT | NF_CT_EXPECT_INACTIVE;
 
 	hooks = rcu_dereference(nf_nat_sip_hooks);

--BoDvjb+CgOGFYgDu--
