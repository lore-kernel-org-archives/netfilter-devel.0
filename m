Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5017C6FD1C
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Mar 2023 21:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjCTVoM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Mar 2023 17:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjCTVoL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2023 17:44:11 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671AA4695
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2023 14:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TZKqKACmv8AONyHaQNTYU9c4zwhE0hZmuwOIIcwBxlw=; b=qeBcrr/Zs9OHg2xLGK5hb47pGn
        HEylMVROvThSBbpvHpKyujeLUIMobVeUMtQHvCraMBi1O7nATONF8XXejh+xCkGd5PPtagqbQRV7W
        Y32yh0M+ymUhs6/wFX3ivwi7lPl86c+yETaRXTz0ZkPbCHEz6gaI87PirGrYO8cgWvBDOsFeTHwmf
        NmdGfhvCa5xQhNLptTqVfqAltQOTxXJH19ARRzDkeQjZJWUx8hz7JLQ+3SXdKm15g7ULEk9U7lbj4
        WqgvJO5c99PoFFdAvjTKwotAvNj6K0yyyf/IlAPXpFRSgFPXydYvfxWBhqAyGDn/p3rBXtk9h+Gbb
        ynZ31U1A==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1peNHf-00GbN4-13; Mon, 20 Mar 2023 21:43:15 +0000
Date:   Mon, 20 Mar 2023 21:43:13 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Kyuwon Shim <Kyuwon.Shim@alliedtelesis.co.nz>
Cc:     "fw@strlen.de" <fw@strlen.de>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH v2] ulogd2: Avoid use after free in unregister on global
 ulogd_fds linked list
Message-ID: <20230320214313.GB80565@celephais.dreamlands>
References: <1678233154187.35009@alliedtelesis.co.nz>
 <20230309012447.201582-1-kyuwon.shim@alliedtelesis.co.nz>
 <ZBL9TEfTBqwoEZH5@strlen.de>
 <7ee33839d49fe210dfb7347ea25724e9f43046e0.camel@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dXVGGtqxIm724HJ7"
Content-Disposition: inline
In-Reply-To: <7ee33839d49fe210dfb7347ea25724e9f43046e0.camel@alliedtelesis.co.nz>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--dXVGGtqxIm724HJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-20, at 20:41:46 +0000, Kyuwon Shim wrote:
> On Thu, 2023-03-16 at 12:28 +0100, Florian Westphal wrote:
> > Kyuwon Shim <kyuwon.shim@alliedtelesis.co.nz> wrote:
> > > The issue "core dumped" occurred from ulogd_unregister_fd(). One
> > > of the processes is unlink from list and remove, but some struct
> > > 'pi' values freed without ulogd_unregister_fd().  Unlink process
> > > needs to access the previous pointer value of struct 'pi', but it
> > > was already freed.
> > >=20
> > > Therefore, the free() process moved location after finishing all
> > > ulogd_unregister_fd().
> >=20
> > I don't understand this patch.
> >=20
> > llist_for_each_entry_safe() doesn't dereference 'pi' after its
> > free'd.
> >=20
> > Where does this deref happen?  Can you share a backtrace?
> >=20
> > > +		}
> > > +	}
> > > +
> > > +	llist_for_each_entry(stack, &ulogd_pi_stacks, stack_list) {
> > > +		llist_for_each_entry_safe(pi, npi, &stack->list, list)
> > > {
> > >  			free(pi);
> >=20
> > Perhaps there should be a 'llist_del' before pi gets free'd instead?
>
> This is valgrind logs.
>=20
> =3D=3D4797=3D=3D Memcheck, a memory error detector
> =3D=3D4797=3D=3D Copyright (C) 2002-2022, and GNU GPL'd, by Julian Seward=
 et al.
> =3D=3D4797=3D=3D Using Valgrind-3.19.0 and LibVEX; rerun with -h for copy=
right info
> =3D=3D4797=3D=3D Command: ulogd -v -c /etc/ulogd.conf
> =3D=3D4797=3D=3D Invalid read of size 4
> =3D=3D4797=3D=3D    at 0x405F60: ulogd_unregister_fd (select.c:74)
> =3D=3D4797=3D=3D    by 0x4E4E3DF: ??? (in /usr/lib/ulogd/ulogd_inppkt_NFL=
OG.so)
> =3D=3D4797=3D=3D    by 0x405003: stop_pluginstances (ulogd.c:1335)
> =3D=3D4797=3D=3D    by 0x405003: sigterm_handler_task (ulogd.c:1383)
> =3D=3D4797=3D=3D    by 0x405153: call_signal_handler_tasks (ulogd.c:424)
> =3D=3D4797=3D=3D    by 0x405153: signal_channel_callback (ulogd.c:443)
> =3D=3D4797=3D=3D    by 0x406163: ulogd_select_main (select.c:105)
> =3D=3D4797=3D=3D    by 0x403CF3: ulogd_main_loop (ulogd.c:1070)
> =3D=3D4797=3D=3D    by 0x403CF3: main (ulogd.c:1649)
> =3D=3D4797=3D=3D  Address 0x4a84f40 is 160 bytes inside a block of size 4=
,848 free'd
> =3D=3D4797=3D=3D    at 0x4847551: free (in /usr/libexec/valgrind/vgpreloa=
d_memcheck-amd64-linux.so)
> =3D=3D4797=3D=3D    by 0x40500E: stop_pluginstances (ulogd.c:1338)
> =3D=3D4797=3D=3D    by 0x40500E: sigterm_handler_task (ulogd.c:1383)
> =3D=3D4797=3D=3D    by 0x405153: call_signal_handler_tasks (ulogd.c:424)
> =3D=3D4797=3D=3D    by 0x405153: signal_channel_callback (ulogd.c:443)
> =3D=3D4797=3D=3D    by 0x406163: ulogd_select_main (select.c:105)
> =3D=3D4797=3D=3D    by 0x403CF3: ulogd_main_loop (ulogd.c:1070)
> =3D=3D4797=3D=3D    by 0x403CF3: main (ulogd.c:1649)
> =3D=3D4797=3D=3D  Block was alloc'd /usr/libexec/valgrind/vgpreload_memch=
eck-amd64-linux.so)
> =3D=3D4797=3D=3D    by 0x405504: pluginstance_alloc_init (ulogd.c:664)
> =3D=3D4797=3D=3D    by 0x405504: create_stack (ulogd.c:1014)
> =3D=3D4797=3D=3D    by 0x406FCE: config_parse_file (conffile.c:225)
> =3D=3D4797=3D=3D    by 0x403949: parse_conffile (ulogd.c:1107)
> =3D=3D4797=3D=3D    by 0x403949: main (ulogd.c:1589)
> =3D=3D4797=3D=3D=20
> =3D=3D4797=3D=3D Invalid read of size 8
> =3D=3D4797=3D=3D    at 0x405F6E: ulogd_unregister_fd (select.c:73)
> =3D=3D4797=3D=3D    by 0x4E4E3DF: ??? (in /usr/lib/ulogd/ulogd_inppkt_NFL=
OG.so)
> =3D=3D4797=3D=3D    by 0x405003: stop_pluginstances (ulogd.c:1335)
> =3D=3D4797=3D=3D    by 0x405003: sigterm_handler_task (ulogd.c:1383)
> =3D=3D4797=3D=3D    by 0x405153: call_signal_handler_tasks (ulogd.c:424)
> =3D=3D4797=3D=3D    by 0x405153: signal_channel_callback (ulogd.c:443)
> =3D=3D4797=3D=3D    by 0x406163: ulogd_select_main (select.c:105)
> =3D=3D4797=3D=3D    by 0x403CF3: ulogd_main_loop (ulogd.c:1070)
> =3D=3D4797=3D=3D    by 0x403CF3: main (ulogd.c:1649)
> =3D=3D4797=3D=3D  Address 0x4a84f30 is 144 bytes inside a block of size 4=
,848 free'd
> =3D=3D4797=3D=3D    at 0x4847551: free (in /usr/libexec/valgrind/vgpreloa=
d_memcheck-amd64-linux.so)
> =3D=3D4797=3D=3D    by 0x40500E: stop_pluginstances (ulogd.c:1338)
> =3D=3D4797=3D=3D    by 0x40500E: sigterm_handler_task (ulogd.c:1383)
> =3D=3D4797=3D=3D    by 0x405153: call_signal_handler_tasks (ulogd.c:424)
> =3D=3D4797=3D=3D    by 0x405153: signal_channel_callback (ulogd.c:443)
> =3D=3D4797=3D=3D    by 0x406163: ulogd_select_main (select.c:105)
> =3D=3D4797=3D=3D    by 0x403CF3: ulogd_main_loop (ulogd.c:1070)
> =3D=3D4797=3D=3D    by 0x403CF3: main (ulogd.c:1649)
> =3D=3D4797=3D=3D  Block was alloc'd at
> =3D=3D4797=3D=3D    at 0x4849D82: calloc (in /usr/libexec/valgrind/vgprel=
oad_memcheck-amd64-linux.so)
> =3D=3D4797=3D=3D    by 0x405504: pluginstance_alloc_init (ulogd.c:664)
> =3D=3D4797=3D=3D    by 0x405504: create_stack (ulogd.c:1014)
> =3D=3D4797=3D=3D    by 0x406FCE: config_parse_file (conffile.c:225)
> =3D=3D4797=3D=3D    by 0x403949: parse_conffile (ulogd.c:1107)
> =3D=3D4797=3D=3D    by 0x403949: main (ulogd.c:1589)
> =3D=3D4797=3D=3D
> Tue Mar 14 11:18:20 2023 <1> ulogd.c:1333 calling stop for IFINDEX
> =3D=3D4797=3D=3D Invalid write of size 8
> =3D=3D4797=3D=3D    at 0x405F31: __llist_del (linuxlist.h:107)
> =3D=3D4797=3D=3D    by 0x405F31: llist_del (linuxlist.h:119)
> =3D=3D4797=3D=3D    by 0x405F31: ulogd_unregister_fd (select.c:69)
> =3D=3D4797=3D=3D    by 0x4E6427F: ??? (in /usr/lib/ulogd/ulogd_filter_IFI=
NDEX.so)
> =3D=3D4797=3D=3D    by 0x405003: stop_pluginstances (ulogd.c:1335)
> =3D=3D4797=3D=3D    by 0x405003: sigterm_handler_task (ulogd.c:1383)
> =3D=3D4797=3D=3D    by 0x405153: call_signal_handler_tasks (ulogd.c:424)
> =3D=3D4797=3D=3D    by 0x405153: signal_channel_callback (ulogd.c:443)
> =3D=3D4797=3D=3D    by 0x406163: ulogd_select_main (select.c:105)
> =3D=3D4797=3D=3D    by 0x403CF3: ulogd_main_loop (ulogd.c:1070)
> =3D=3D4797=3D=3D    by 0x403CF3: main (ulogd.c:1649)
> =3D=3D4797=3D=3D  Address 0x4a84f38 is 152 bytes inside a block of size 4=
,848 free'd
> =3D=3D4797=3D=3D    at 0x4847551: free (in /usr/libexec/valgrind/vgpreloa=
d_memcheck-amd64-linux.so)
> =3D=3D4797=3D=3D    by 0x40500E: stop_pluginstances (ulogd.c:1338)
> =3D=3D4797=3D=3D    by 0x40500E: sigterm_handler_task (ulogd.c:1383)
> =3D=3D4797=3D=3D    by 0x405153: call_signal_handler_tasks (ulogd.c:424)
> =3D=3D4797=3D=3D    by 0x405153: signal_channel_callback (ulogd.c:443)
> =3D=3D4797=3D=3D    by 0x406163: ulogd_select_main (select.c:105)
> =3D=3D4797=3D=3D    by 0x403CF3: ulogd_main_loop (ulogd.c:1070)
> =3D=3D4797=3D=3D    by 0x403CF3: main (ulogd.c:1649)
> =3D=3D4797=3D=3D  Block was alloc'd at
> =3D=3D4797=3D=3D    at 0x4849D82: calloc (in /usr/libexec/valgrind/vgprel=
oad_memcheck-amd64-linux.so)
> =3D=3D4797=3D=3D    by 0x405504: pluginstance_alloc_init (ulogd.c:664)
> =3D=3D4797=3D=3D    by 0x405504: create_stack (ulogd.c:1014)
> =3D=3D4797=3D=3D    by 0x406FCE: config_parse_file (conffile.c:225)
> =3D=3D4797=3D=3D    by 0x403949: parse_conffile (ulogd.c:1107)
> =3D=3D4797=3D=3D    by 0x403949: main (ulogd.c:1589)
> =3D=3D4797=3D=3D=20
> =3D=3D4797=3D=3D Invalid read of size 4
> =3D=3D4797=3D=3D    at 0x405F60: ulogd_unregister_fd (select.c:74)
> =3D=3D4797=3D=3D    by 0x4E6427F: ??? (in /usr/lib/ulogd/ulogd_filter_IFI=
NDEX.so)
> =3D=3D4797=3D=3D    by 0x405003: stop_pluginstances (ulogd.c:1335)
> =3D=3D4797=3D=3D    by 0x405003: sigterm_handler_task (ulogd.c:1383)
> =3D=3D4797=3D=3D    by 0x405153: call_signal_handler_tasks (ulogd.c:424)
> =3D=3D4797=3D=3D    by 0x405153: signal_channel_callback (ulogd.c:443)
> =3D=3D4797=3D=3D    by 0x406163: ulogd_select_main (select.c:105)
> =3D=3D4797=3D=3D    by 0x403CF3: ulogd_main_loop (ulogd.c:1070)
> =3D=3D4797=3D=3D    by 0x403CF3: main (ulogd.c:1649)
> =3D=3D4797=3D=3D  Address 0x4a84f40 is 160 bytes inside a block of size 4=
,848 free'd
> =3D=3D4797=3D=3D    at 0x4847551: free (in /usr/libexec/valgrind/vgpreloa=
d_memcheck-amd64-linux.so)
> =3D=3D4797=3D=3D    by 0x40500E: stop_pluginstances (ulogd.c:1338)
> =3D=3D4797=3D=3D    by 0x40500E: sigterm_handler_task (ulogd.c:1383)
> =3D=3D4797=3D=3D    by 0x405153: call_signal_handler_tasks (ulogd.c:424)
> =3D=3D4797=3D=3D    by 0x405153: signal_channel_callback (ulogd.c:443)
> =3D=3D4797=3D=3D    by 0x406163: ulogd_select_main (select.c:105)
> =3D=3D4797=3D=3D    by 0x403CF3: ulogd_main_loop (ulogd.c:1070)
> =3D=3D4797=3D=3D    by 0x403CF3: main (ulogd.c:1649)
> =3D=3D4797=3D=3D  Block was alloc'd at
> =3D=3D4797=3D=3D    at 0x4849D82: calloc (in /usr/libexec/valgrind/vgprel=
oad_memcheck-amd64-linux.so)
> =3D=3D4797=3D=3D    by 0x405504: pluginstance_alloc_init (ulogd.c:664)
> =3D=3D4797=3D=3D    by 0x405504: create_stack (ulogd.c:1014)
> =3D=3D4797=3D=3D    by 0x406FCE: config_parse_file (conffile.c:225)
> =3D=3D4797=3D=3D    by 0x403949: parse_conffile (ulogd.c:1107)
> =3D=3D4797=3D=3D    by 0x403949: main (ulogd.c:1589)
> =3D=3D4797=3D=3D=20
> =3D=3D4797=3D=3D Invalid read of size 8
> =3D=3D4797=3D=3D    at 0x405F6E: ulogd_unregister_fd (select.c:73)
> =3D=3D4797=3D=3D    by 0x4E6427F: ??? (in /usr/lib/ulogd/ulogd_filter_IFI=
NDEX.so)
> =3D=3D4797=3D=3D    by 0x405003: stop_pluginstances (ulogd.c:1335)
> =3D=3D4797=3D=3D    by 0x405003: sigterm_handler_task (ulogd.c:1383)
> =3D=3D4797=3D=3D    by 0x405153: call_signal_handler_tasks (ulogd.c:424)
> =3D=3D4797=3D=3D    by 0x405153: signal_channel_callback (ulogd.c:443)
> =3D=3D4797=3D=3D    by 0x406163: ulogd_select_main (select.c:105)
> =3D=3D4797=3D=3D    by 0x403CF3: ulogd_main_loop (ulogd.c:1070)
> =3D=3D4797=3D=3D    by 0x403CF3: main (ulogd.c:1649)
> =3D=3D4797=3D=3D  Address 0x4a84f30 is 144 bytes inside a block of size 4=
,848 free'd
> =3D=3D4797=3D=3D    at 0x4847551: free (in /usr/libexec/valgrind/vgpreloa=
d_memcheck-amd64-linux.so)
> =3D=3D4797=3D=3D    by 0x40500E: stop_pluginstances (ulogd.c:1338)
> =3D=3D4797=3D=3D    by 0x40500E: sigterm_handler_task (ulogd.c:1383)
> =3D=3D4797=3D=3D    by 0x405153: call_signal_handler_tasks (ulogd.c:424)
> =3D=3D4797=3D=3D    by 0x405153: signal_channel_callback (ulogd.c:443)
> =3D=3D4797=3D=3D    by 0x406163: ulogd_select_main (select.c:105)
> =3D=3D4797=3D=3D    by 0x403CF3: ulogd_main_loop (ulogd.c:1070)
> =3D=3D4797=3D=3D    by 0x403CF3: main (ulogd.c:1649)
> =3D=3D4797=3D=3D  Block was alloc'd at
> =3D=3D4797=3D=3D    at 0x4849D82: calloc (in /usr/libexec/valgrind/vgprel=
oad_memcheck-amd64-linux.so)
> =3D=3D4797=3D=3D    by 0x405504: pluginstance_alloc_init (ulogd.c:664)
> =3D=3D4797=3D=3D    by 0x405504: create_stack (ulogd.c:1014)
> =3D=3D4797=3D=3D    by 0x406FCE: config_parse_file (conffile.c:225)
> =3D=3D4797=3D=3D    by 0x403949: parse_conffile (ulogd.c:1107)
> =3D=3D4797=3D=3D    by 0x403949: main (ulogd.c:1589)
> =3D=3D4797=3D=3D=20
> Tue Mar 14 11:18:20 2023 <1> ulogd.c:1333 calling stop for SYSLOG
> =3D=3D4797=3D=3D=20
> =3D=3D4797=3D=3D HEAP SUMMARY:
> =3D=3D4797=3D=3D     in use at exit: 301,152 bytes in 10 blocks
> =3D=3D4797=3D=3D   total heap usage: 1,133 allocs, 1,123 frees, 1,852,378=
 bytes allocated
> =3D=3D4797=3D=3D=20
> =3D=3D4797=3D=3D LEAK SUMMARY:
> =3D=3D4797=3D=3D    definitely lost: 300,928 bytes in 4 blocks
> =3D=3D4797=3D=3D    indirectly lost: 224 bytes in 6 blocks
> =3D=3D4797=3D=3D      possibly lost: 0 bytes in 0 blocks
> =3D=3D4797=3D=3D    still reachable: 0 bytes in 0 blocks
> =3D=3D4797=3D=3D         suppressed: 0 bytes in 0 blocks
> =3D=3D4797=3D=3D Rerun with --leak-check=3Dfull to see details of leaked =
memory
> =3D=3D4797=3D=3D=20
> =3D=3D4797=3D=3D Use --track-origins=3Dyes to see where uninitialised val=
ues come from
> =3D=3D4797=3D=3D For lists of detected and suppressed errors, rerun with:=
 -s
> =3D=3D4797=3D=3D ERROR SUMMARY: 12 errors from 6 contexts (suppressed: 0 =
=66rom 0)

I've seen these traces myself.  Never got round to diagnosing and fixing
them.

J.

> This is coredump backtrace.
>=20
> -------------------------------------------------------------------------=
-------
> Thread Information:
>   Id   Target Id         Frame=20
> * 1    LWP 170           0x00007fa985225d40 in main_arena ()
>    from /tmp/tmp1fbxh6bj/vfw_x86_64/output/awplus-
> vfw_x86_64/image/rootfs/staging/lib64/libc.so.6
> -------------------------------------------------------------------------=
-------
> Current Thread Local Variables:
> No symbol table info available.
> -------------------------------------------------------------------------=
-------
> Thread Backtraces:
> Thread 1 (LWP 170):
> #0  0x00007fa985225d40 in main_arena () from /tmp/tmp1fbxh6bj/vfw_x86_64/=
output/awplus-vfw_x86_64/image/rootfs/staging/lib64/libc.so.6
> #1  0x0000000000405ca7 in ulogd_propagate_results (pi=3Dpi@entry=3D0x8ebc=
50) at ulogd.c:617
> #2  0x00007fa9850376b9 in interp_packet (upi=3Dupi@entry=3D0x8ebc50, pf_f=
amily=3D<optimized out>, ldata=3Dldata@entry=3D0x7ffe805c2648) at ulogd_inp=
pkt_NFLOG.c:400
> #3  0x00007fa985037c55 in msg_cb (gh=3D<optimized out>, nfmsg=3D0x7ffe805=
c2770, nfa=3D0x7ffe805c2648, data=3D0x8e2d90) at ulogd_inppkt_NFLOG.c:479
> #4  0x00007fa98503023e in __nflog_rcv_pkt (nlh=3D<optimized out>, nfa=3D<=
optimized out>, data=3D<optimized out>) at libnetfilter_log.c:162
> #5  0x00007fa9850288fc in nfnl_step (h=3Dh@entry=3D0x8e6f80, nlh=3Dnlh@en=
try=3D0x7ffe805c2760) at libnfnetlink.c:1365
> #6  0x00007fa985028ff8 in nfnl_process (h=3Dh@entry=3D0x8e6f80,  buf=3Dbu=
f@entry=3D0x7ffe805c2760 "\214", len=3Dlen@entry=3D140) at libnfnetlink.c:1=
410
> #7  0x00007fa985029344 in nfnl_catch (h=3D<optimized out>) at libnfnetlin=
k.c:1564
> #8  nfnl_catch (h=3D0x8e6f80) at libnfnetlink.c:1546
> #9  0x00007fa985030612 in __build_send_cfg_msg (pf=3D0 '\000', groupnum=
=3D<optimized out>, command=3D2 '\002', h=3D0x8dfbc0) at libnetfilter_log.c=
:143
> #10 nflog_unbind_group (gh=3D0x8e71a0) at libnetfilter_log.c:439
> #11 0x00007fa9850373ec in stop (pi=3D0x8e2d90) at ulogd_inppkt_NFLOG.c:638
> #12 0x0000000000405004 in stop_pluginstances () at ulogd.c:1335
> #13 sigterm_handler_task (signal=3Dsignal@entry=3D15) at ulogd.c:1383
> #14 0x0000000000405154 in call_signal_handler_tasks (sig=3D15) at ulogd.c=
:423
> #15 signal_channel_callback (fd=3D4, what=3D<optimized out>, data=3D<opti=
mized out>) at ulogd.c:442
> #16 0x0000000000406184 in ulogd_select_main (tv=3Dtv@entry=3D0x0) at sele=
ct.c:105
> #17 0x0000000000403cf4 in ulogd_main_loop () at ulogd.c:1070
> #18 main (argc=3D<optimized out>, argv=3D<optimized out>) at ulogd.c:1649
> -------------------------------------------------------------------------=
-------

--dXVGGtqxIm724HJ7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQY02QACgkQKYasCr3x
BA3OwA/9FhHaQ89vdww9uNbbhRhNPeKJAwD1OIhVdcScku3pXbYeo0L3AN1P7MuI
RDWijf3Os36M100nF8+SzbF7SRb0wb1/OH+AGEUTkNln+eEDd4fCETA+qT1UaSBL
u2RWtp/rnOKOS3efb4e7d7rdtqZAFaoXoEsmkAPRRGKfu1CdRNsvudqiHuEePmgm
IS6E1hkfgppwIWXtxuoqtb8cmBW0ndTb7qfuVgMezBKzxDU5YTlq1P0YXSlFdH+A
6ERAkTYNtxeLkJiRd1dBH6fa9aMbxslrnHdHOEbP8Bu/t0SucCXpHhweliE93Goh
p05bJjeYm0Pb1yvHZsd3WtUdyNQdboiMVX5iRTW6q7bYZ10ruxvvSAcx+2FAhyGR
7tr74OJfF6BdvyjI3dBP4uZ44jWf5YARRFAYXL3pCKBmIxu9XPKAfpMnZlCPI5Uc
+PneAMVijqsaLijYAwtkZGK0IAZ6VNDCzR/+mnnk1bwTXwEg9jW8XIRrEtCR5nXx
TdFfI6200ouPQzD2Xae8yUTjReGJ/q2xC+/Y0JsV4Gmomlf9YpX3dsusohCQgoza
IPkBEDhAIFw2RmIgzJvW7wvH/4iaSe0mbDMsO5MkG1hBYSQBz38RKY/Rmiey0Gmt
mwfE5gzJiEKoEst1yX7vmLwO6di2h2xOnIavUltb8z0yf7B/IJY=
=sX97
-----END PGP SIGNATURE-----

--dXVGGtqxIm724HJ7--
