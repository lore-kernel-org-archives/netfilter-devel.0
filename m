Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2689C25B41
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Oct 2023 08:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbjJWIb3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Oct 2023 04:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbjJWIbF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2023 04:31:05 -0400
Received: from smtp-8fab.mail.infomaniak.ch (smtp-8fab.mail.infomaniak.ch [IPv6:2001:1600:3:17::8fab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4CE1713
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 01:30:57 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4SDT0s5N12zMq5T6;
        Mon, 23 Oct 2023 08:30:53 +0000 (UTC)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4SDT0s2Qx9zXZK;
        Mon, 23 Oct 2023 10:30:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1698049853;
        bh=Sa8y9t8zzJaOO3fi9Pyo4TJOkjYhu4szCXILEJmE850=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1Z+YTMB7aWgmHuw+0wfOY6Hfs49JtIMKwWsVXiOLB/3cNdELGZYabySXESxyM4u/3
         Tme5RbDXoYbQa2/99gb8zFlT8AFkJwWpEPFJpp0yuc247BuczJ5Em8HI38kdi0HQ9V
         1uNoTVNX5S5v+34+SCRA36DmwBUsWHgStYaaXgWA=
Date:   Mon, 23 Oct 2023 10:30:50 +0200
From:   =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
Subject: Re: [PATCH v13 08/12] landlock: Add network rules and TCP hooks
 support
Message-ID: <20231023.Ahng6xut7aiB@digikod.net>
References: <20231016015030.1684504-1-konstantin.meskhidze@huawei.com>
 <20231016015030.1684504-9-konstantin.meskhidze@huawei.com>
 <20231017.xahKoo9Koo8v@digikod.net>
 <57f150b2-0920-8567-8351-1bdb74684cfa@huawei.com>
 <20231020.ido6Aih0eiGh@digikod.net>
 <ae62c363-e9bf-3ab8-991a-0902b0d195cb@huawei.com>
 <20231020.ooS5Phaiqu6k@digikod.net>
 <ed35b3a1-b060-dec6-fa18-efa6743bd1c2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ed35b3a1-b060-dec6-fa18-efa6743bd1c2@huawei.com>
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 23, 2023 at 10:23:35AM +0300, Konstantin Meskhidze (A) wrote:
> 
> 
> 10/20/2023 6:41 PM, Mickaël Salaün пишет:
> > On Fri, Oct 20, 2023 at 02:58:31PM +0300, Konstantin Meskhidze (A) wrote:
> > > 
> > > 
> > > 10/20/2023 12:49 PM, Mickaël Salaün пишет:
> > > > On Fri, Oct 20, 2023 at 07:08:33AM +0300, Konstantin Meskhidze (A) wrote:
> > > > > > > > > 10/18/2023 3:29 PM, Mickaël Salaün пишет:
> > > > > > On Mon, Oct 16, 2023 at 09:50:26AM +0800, Konstantin Meskhidze wrote:
> > 
> > > > > > > diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> > > > > > > index 4c209acee01e..1fe4298ff4a7 100644
> > > > > > > --- a/security/landlock/ruleset.c
> > > > > > > +++ b/security/landlock/ruleset.c
> > > > > > > @@ -36,6 +36,11 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
> > > > > > >  	refcount_set(&new_ruleset->usage, 1);
> > > > > > >  	mutex_init(&new_ruleset->lock);
> > > > > > >  	new_ruleset->root_inode = RB_ROOT;
> > > > > > > +
> > > > > > > +#if IS_ENABLED(CONFIG_INET)
> > > > > > > +	new_ruleset->root_net_port = RB_ROOT;
> > > > > > > +#endif /* IS_ENABLED(CONFIG_INET) */
> > > > > > > +
> > > > > > >  	new_ruleset->num_layers = num_layers;
> > > > > > >  	/*
> > > > > > >  	 * hierarchy = NULL
> > > > > > > @@ -46,16 +51,21 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
> > > > > > >  }
> > > > > > > > >  struct landlock_ruleset *
> > > > > > > -landlock_create_ruleset(const access_mask_t fs_access_mask)
> > > > > > > +landlock_create_ruleset(const access_mask_t fs_access_mask,
> > > > > > > +			const access_mask_t net_access_mask)
> > > > > > >  {
> > > > > > >  	struct landlock_ruleset *new_ruleset;
> > > > > > > > >  	/* Informs about useless ruleset. */
> > > > > > > -	if (!fs_access_mask)
> > > > > > > +	if (!fs_access_mask && !net_access_mask)
> > > > > > >  		return ERR_PTR(-ENOMSG);
> > > > > > >  	new_ruleset = create_ruleset(1);
> > > > > > > -	if (!IS_ERR(new_ruleset))
> > > > > > > +	if (IS_ERR(new_ruleset))
> > > > > > > +		return new_ruleset;
> > > > > > > +	if (fs_access_mask)
> > > > > > >  		landlock_add_fs_access_mask(new_ruleset, fs_access_mask, 0);
> > > > > > > +	if (net_access_mask)
> > > > > > > +		landlock_add_net_access_mask(new_ruleset, net_access_mask, 0);
> > > > > > > This is good, but it is not tested: we need to add a test that
> > > > > both
> > > > > > handle FS and net restrictions. You can add one in net.c, just handling
> > > > > > LANDLOCK_ACCESS_FS_READ_DIR and LANDLOCK_ACCESS_NET_BIND_TCP, add one
> > > > > > rule with path_beneath (e.g. /dev) and another with net_port, and check
> > > > > > that open("/") is denied, open("/dev") is allowed, and and only the
> > > > > > allowed port is allowed with bind(). This test should be simple and can
> > > > > > only check against an IPv4 socket, i.e. using ipv4_tcp fixture, just
> > > > > > after port_endianness. fcntl.h should then be included by net.c
> > > > > > >   Ok.
> > > > > > > I guess that was the purpose of layout1.with_net (in fs_test.c)
> > > > > but it
> > > > > > >   Yep. I added this kind of nest in fs_test.c to test both
> > > fs and network
> > > > > rules together.
> > > > > > is not complete. You can revamp this test and move it to net.c
> > > > > > following the above suggestions, keeping it consistent with other tests
> > > > > > in net.c . You don't need the test_open() nor create_ruleset() helpers.
> > > > > > > This test must failed if we change
> > > > > "ruleset->access_masks[layer_level] |="
> > > > > > to "ruleset->access_masks[layer_level] =" in
> > > > > > landlock_add_fs_access_mask() or landlock_add_net_access_mask().
> > > > > > >   Do you want to change it? Why?
> > > > > The kernel code is correct and must not be changed. However, if
> > > by
> > > > mistake we change it and remove the OR, a test should catch that. We
> > > > need a test to assert this assumption.
> > > >   OK. I will add additional assert simulating
> > > "ruleset->access_masks[layer_level] =" kernel code.
> > > > >   Fs and network masks are ORed to not intersect with each other.
> > > > > Yes, they are ORed, and we need a test to check that. Noting is
> > > > currently testing this OR (and the different rule type consistency).
> > > > I'm suggesting to revamp the layout1.with_net test into
> > > > ipv4_tcp.with_fs and make it check ruleset->access_masks[] and rule
> > > > addition of different types.
> > > 
> > >   I will move layout1.with_net test into net.c and rename it. Looks like
> > >   it just needed to add "ruleset->access_masks[layer_level] =" assert
> > >   because the test already has rule addition with different types.
> > 
> > The with_net test doesn't have FS rules, which is the main missing part.
> > You'll need to rely on the net.c helpers, use the hardcoded paths, and
> > only handle one access right of each type as I suggested above.
> > 
> 
>  This is with_net code:
> 
>   ....
>   /* Adds a network rule. */
> 	
> ASSERT_EQ(0, landlock_add_rule(ruleset_fd_net, LANDLOCK_RULE_NET_PORT,
> 				       &tcp_bind, 0));
> 
> 	enforce_ruleset(_metadata, ruleset_fd_net);
> 	ASSERT_EQ(0, close(ruleset_fd_net));
> 
> 	ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
> 
> 	ASSERT_LE(0, ruleset_fd);
> 	enforce_ruleset(_metadata, ruleset_fd);
> 	ASSERT_EQ(0, close(ruleset_fd));
> ....
> 
> It has FS rules - just after ruleset_fd_net rule inforced.
> Or maybe I missed something?

ruleset_fd_net and ruleset_fd are two different rulesets, and then
they create two different layers. We need to test support for FS and net
with the same ruleset/layer to check ruleset->access_masks[layer_level].

> 
> > > 
> > >   Do you have any more review updates so far?
> > 
> > That's all for this patch series. :)
> 
>   Ok. Thanks.
> > .
