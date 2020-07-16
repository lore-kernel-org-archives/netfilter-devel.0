Return-Path: <SRS0=+/pN=A3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B7AC433E3
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 16:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCC3C2065E
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 16:47:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DplZ5fzU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgGPQrf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 12:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728721AbgGPQre (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 12:47:34 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55020C061755
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2020 09:47:34 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id a1so5229918edt.10
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2020 09:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HkkodpA65bDB7eF7BE2pVlT6iUCtD8FBXXKibgSnJ4o=;
        b=DplZ5fzU1mexdKYRrq+z8tEkK2C7E6OuTuK9DKMoJdwXFpKLV7HgM1jSD/eyHJ42/j
         IlAsvYRXDHLqrjgQeEfrpSPfYX9ApzKlBz6Qb8QC8RtQrKCWko8sTfeLz5SLJx9Kb/1u
         zdjGdxNNO1nQMh0o23BjP7reJRG93zig3jssimexvlTqcHUXk0m8Q7D3Y9nisyoFSBsl
         /cChfenLcz8cB0x4bctJjSJqi0+55GF98J0CAy66WYk4cF6RYCQGFr3ZcEHYOyrl84SL
         /zjsM2bXm5H+qY86kSzpZ5gpqsO2F4A7Un43jDj1gRl9i2G13fHrgs61zdj32EjnfJai
         ACCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HkkodpA65bDB7eF7BE2pVlT6iUCtD8FBXXKibgSnJ4o=;
        b=X21F+fqlZaYudJfr4R1NdEJRe93WYR3v7iGYAK/cB3eQT3e9Z82U0JB5tH9HUG0lLT
         1j1MWslNn7ziFBhTcR68B5eqePAbz136jIpsttpVFQ3nlM4qEUsJRpB6OsXx+PtstJ5I
         tD2AE/ZBpguzW2uj++vqjnw8XH4HNHhpWwbgTu4YXXGeQ2n5UDVgEQA87FlDBUdVLbYG
         DYMfDirRK5c5h15MlACAWn6AcmH/JOKyS6vp+tJX9LpRkWGJybp+H7Unj5acY3JTPc5W
         31biOYjcxOQxavEmEFJ/8rUKrJkWiTo/NG9rSVUvLCRXLT49irAN9hTvq7cCEKQ9SiDJ
         Va9g==
X-Gm-Message-State: AOAM533gDQLo3i4TfdMEfRQYNE/5fYpKO1IyNeH1DsQKu6iGCSdc7ODX
        Y0vgQfSTnkWupBjiFscEnNJwv9DCtoW0CzTLHSg=
X-Google-Smtp-Source: ABdhPJy8C7kSfjfMK/vP1tGdeXEC6xwEJj5uycKNZweF3woyv5RVtzTyuCaJKjMEeZdvXk2gNC2KPm8stiS21dA6AGc=
X-Received: by 2002:aa7:d457:: with SMTP id q23mr5049275edr.376.1594918052989;
 Thu, 16 Jul 2020 09:47:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200716144253.GA29751@xsang-OptiPlex-9020> <20200716161414.GA27494@salvia>
In-Reply-To: <20200716161414.GA27494@salvia>
From:   Andrew Kim <kim.andrewsy@gmail.com>
Date:   Thu, 16 Jul 2020 12:47:21 -0400
Message-ID: <CABc050FZViqeAfLkkn0nQPJ4Zf045aV9gfajzjuGc9Ksnh7_4g@mail.gmail.com>
Subject: Re: [nf-next:master 2/3] net/netfilter/ipvs/ip_vs_conn.c:1394:6:
 sparse: sparse: context imbalance in 'ip_vs_expire_nodest_conn_flush' - wrong
 count at exit
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        Julian Anastasov <ja@ssi.bg>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Will send a patch to fix this shortly :)

On Thu, Jul 16, 2020 at 12:14 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Thu, Jul 16, 2020 at 10:42:53PM +0800, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
> > head:   3354c27699652b271b78c85f275b818e6b9843e6
> > commit: 04231e52d3557475231abe8a8fa1be0330826ed6 [2/3] ipvs: queue delayed work to expire no destination connections if expire_nodest_conn=1
> > :::::: branch date: 5 hours ago
> > :::::: commit date: 5 hours ago
> > config: mips-randconfig-s032-20200715 (attached as .config)
> > compiler: mipsel-linux-gcc (GCC) 9.3.0
> > reproduce:
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # apt-get install sparse
> >         # sparse version: v0.6.2-49-g707c5017-dirty
> >         git checkout 04231e52d3557475231abe8a8fa1be0330826ed6
> >         # save the attached .config to linux build tree
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=mips
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> >
> > sparse warnings: (new ones prefixed by >>)
> >
> > >> net/netfilter/ipvs/ip_vs_conn.c:1394:6: sparse: sparse: context imbalance in 'ip_vs_expire_nodest_conn_flush' - wrong count at exit
> >
> > # https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/commit/?id=04231e52d3557475231abe8a8fa1be0330826ed6
> > git remote add nf-next https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git
> > git remote update nf-next
> > git checkout 04231e52d3557475231abe8a8fa1be0330826ed6
> > vim +/ip_vs_expire_nodest_conn_flush +1394 net/netfilter/ipvs/ip_vs_conn.c
> >
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1392
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1393  #ifdef CONFIG_SYSCTL
> > 04231e52d355747 Andrew Sy Kim 2020-07-08 @1394  void ip_vs_expire_nodest_conn_flush(struct netns_ipvs *ipvs)
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1395  {
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1396        int idx;
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1397        struct ip_vs_conn *cp, *cp_c;
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1398        struct ip_vs_dest *dest;
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1399
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1400        rcu_read_lock();
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1401        for (idx = 0; idx < ip_vs_conn_tab_size; idx++) {
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1402                hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[idx], c_list) {
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1403                        if (cp->ipvs != ipvs)
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1404                                continue;
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1405
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1406                        dest = cp->dest;
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1407                        if (!dest || (dest->flags & IP_VS_DEST_F_AVAILABLE))
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1408                                continue;
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1409
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1410                        if (atomic_read(&cp->n_control))
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1411                                continue;
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1412
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1413                        cp_c = cp->control;
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1414                        IP_VS_DBG(4, "del connection\n");
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1415                        ip_vs_conn_del(cp);
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1416                        if (cp_c && !atomic_read(&cp_c->n_control)) {
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1417                                IP_VS_DBG(4, "del controlling connection\n");
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1418                                ip_vs_conn_del(cp_c);
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1419                        }
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1420                }
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1421                cond_resched_rcu();
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1422
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1423                /* netns clean up started, abort delayed work */
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1424                if (!ipvs->enable)
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1425                        return;
>
>                                         Missing rcu_read_unlock() here ?
>
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1426        }
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1427        rcu_read_unlock();
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1428  }
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1429  #endif
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1430
> >
> > ---
> > 0-DAY CI Kernel Test Service, Intel Corporation
> > https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>
>
