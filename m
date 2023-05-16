Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 215E4C77B75
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 May 2023 18:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjEPSg2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 May 2023 14:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjEPSg1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2023 14:36:27 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93B576BA;
        Tue, 16 May 2023 11:36:22 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id 6a1803df08f44-61b5de68cd5so64631826d6.1;
        Tue, 16 May 2023 11:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684262182; x=1686854182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5gA/ZhK6rG1w7UVEKWB315CkZf+v0mhXE8jp3JzXj7E=;
        b=pd9n7qvS1PL27YiPlclBotRTByA80goGg+6VR3nBEb4ZMDEHGq/g1Y/9jIlIAU74nM
         FWNdilFyNvTt1MK4cEMkJ2KSkYdwo7TW9JNOWYPGihrcJVVdo/PLtzYd6Smf/7NWiMUE
         aS961AlI9IKUwZzB31w20+/Jv2Yx+vTn6sbbmZxzFEejffioWNvOs0lBgKjBSgJToR9o
         vobxP7ei1G+Rl/vAfKZ27vLo4DpDiovdA8J5+7Ge0Klr62V4xf3JZaSRlgJt2OgC5Sv4
         VbWA4lxfQxp3RmrjCSOiZeo4C5Q4/Oay2QQzsD3GcOcxUWFkusJE3nq0kBbkEH+74q0L
         f3Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684262182; x=1686854182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5gA/ZhK6rG1w7UVEKWB315CkZf+v0mhXE8jp3JzXj7E=;
        b=TztWcIrWs706oEFrYdljk0VsIRgyMKPBav1SBsxS/oFXwDYnlC9ApM/On+4dFCZ7Qi
         Jh0bmgLfg/aTvQILL5bXCIIU3dlIl6/Ul/1yv2DNUILPevWZ0O3jhgODFcJk3Z8NxzcQ
         Zd/+ydAb+Qja14ew/2Op0u8E6HL0sRPbSiQHC/RvAii2a/vXOIvDk15jQa6jEjxVKn88
         o2eJIxewdKFsEhfBeQVXMpm84kUGCX4KWX+7I/nz/6KWgT1Gg/2gyUAxyotgPYk12zTW
         6paL8lCB9lfwdsagMSb65/zmAr1QWozjbYtYUImY6/mFzhhaK1Dx6/8KYfKSC10mk/bf
         PcXw==
X-Gm-Message-State: AC+VfDzkD+7sOHy0mpHxwvKWRM26sGbJZUYzzGQrXOcp+GhUq3QrP1RD
        rnsTa4JjgHGcPRjpQn0YQHeKCcPhvcn2lQ==
X-Google-Smtp-Source: ACHHUZ7PNIShBXbZcXVkgF6I0bnARL1tSCvzs4A1Q1sDysCwf6Pc79YgiMjksG5/HcxkT/qKwfp3Ng==
X-Received: by 2002:a05:6214:262f:b0:623:81f4:dac2 with SMTP id gv15-20020a056214262f00b0062381f4dac2mr2976712qvb.33.1684262181618;
        Tue, 16 May 2023 11:36:21 -0700 (PDT)
Received: from playground (c-73-148-50-133.hsd1.va.comcast.net. [73.148.50.133])
        by smtp.gmail.com with ESMTPSA id w6-20020a05620a148600b0074de8d07052sm55695qkj.47.2023.05.16.11.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 11:36:21 -0700 (PDT)
Date:   Tue, 16 May 2023 14:36:18 -0400
From:   <imnozi@gmail.com>
To:     Joshua Moore <j@jcm.me>
Cc:     netfilter-devel@vger.kernel.org,
        Reindl Harald <h.reindl@thelounge.net>,
        "Kevin P. Fleming" <lists.netfilter@kevin.km6g.us>,
        netfilter@vger.kernel.org
Subject: Re: How to configure "full cone" NAT using iptables
Message-ID: <20230516143618.6ad67810@playground>
In-Reply-To: <F42FAE74-FDFE-4DC8-896A-2CFBDCCB6D84@jcm.me>
References: <167f2029-5978-dffa-3cf2-0ede9ade4fdf@thelounge.net>
        <F42FAE74-FDFE-4DC8-896A-2CFBDCCB6D84@jcm.me>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Would an example of full cone NAT be the following?
  - Site A uses 192.168.100.0/24 internally
  - Site B uses 192.168.100/0/24 internally
  - There is a VPN between the two sites
  - Site A addresses hosts at Site B using 10.168.255.0/24
  - Site B addresses hosts at Site A using 10.168.1.0/24
  - Site A SNATs packets sent from 192.168.100.0/24 to 10.168.1.0/24, and S=
ite B
    DNATs packets sent to 10.168.255.0/24 to 192.168.100.0/24
  - Site B SNATs packets sent from 192.168.100.0/24 to 10.168.255.0/24, and=
 Site A
    DNATs packets sent to 10.168.1.0/24 to 192.168.100.0/24

The result is that packets at either site have a 192.* and a 10.* address, =
and packets in transit between the sites have only 10.* addresses. In short=
, each site uses the same LAN address and cannot ordinarily exchange packet=
s using normal packet routing. But they *are* able to exchange packets by u=
sing full-cone NAT to translate their addresses to and from intermediary LA=
N addresses.

Full cone NAT allows Linux to do the impossible right away.

N


On Tue, 16 May 2023 07:59:40 -0700
Joshua Moore <j@jcm.me> wrote:

> Full cone isn=E2=80=99t about accepting incoming connections on the same =
public IP:port and then translating to different local IPs. This is a misun=
derstanding. It=E2=80=99s about accepting connections from different REMOTE=
 IPs and allowing it to the same local IP on the same original source port.
>=20
> The practical purpose here is for a more transparent connection and allow=
ing NAT pinholes to poke a hole through the firewall so any destination on =
the Internet can now communicate on that port to the host.
>=20
> > On May 16, 2023, at 7:48 AM, Reindl Harald <h.reindl@thelounge.net> wro=
te:
> >=20
> > =EF=BB=BF
> >  =20
> >> Am 16.05.23 um 16:32 schrieb Joshua Moore:
> >> =EF=BB=BF=E2=80=9CFull cone=E2=80=9D NAT simply means that there is no=
 longer a strict connection tracking or enforcement of what IPs can connect=
 back to the ports that are associated with the internal IP.
> >> Traditional NAT:
> >> - TCP connection to 1.1.1.1 from 192.168.1.10 over outside translated =
TCP source port 45619. All packets destined to port 45619 MUST come from 1.=
1.1.1.
> >> Full cone NAT:
> >> - TCP connection to 1.1.1.1 from 192.168.1.10 over outside translated =
TCP source port 45619. All packets destined to port 45619 are allowed from =
ANY IP.
> >> Another word for this behavior is =E2=80=9Cendpoint independent=E2=80=
=9D NAT/filtering. =20
> >=20
> > but it can not work like that which don't make any sense:
> > iptables -t nat -A PREROUTING -i eth0 -j DNAT --to-destination 10.0.0.1
> > iptables -t nat -A PREROUTING -i eth0 -j DNAT --to-destination 10.0.0.2
> >=20
> > offlist the OP pointed me to https://github.com/Chion82/netfilter-full-=
cone-nat where i ask myself who needs that nonsense which sounds to be writ=
ten by someone which hasn't more clues about networking/NAT the the OP
> >=20
> > Implementation of RFC3489-compatible full cone SNAT
> > https://www.rfc-editor.org/rfc/rfc3489 =3D STUN
> >  =20
> > >> iptables -t nat -A POSTROUTING -o eth0 -j FULLCONENAT
> > >> #same as MASQUERADE =20
> >=20
> > so who needs that module?
> >  =20
> > >> iptables -t nat -A PREROUTING -i eth0 -j FULLCONENAT
> > >> #automatically restore NAT for inbound packets =20
> >=20
> > restore WHAT based on WHAT for new packets?
> >=20
> > it's simple: when you only have a single public IP there is no way to a=
ccept NEW incoming packets to different local machines without explicit por=
t-forwarding
> >=20
> > and ESTABLISHED/RELATED is the job of conntrack
> >  =20
> >>>> On May 16, 2023, at 4:46 AM, Kevin P. Fleming <lists.netfilter@kevin=
.km6g.us> wrote: =20
> >>>=20
> >>> =EF=BB=BFOn Tue, May 16, 2023, at 07:07, Shane Wang wrote: =20
> >>>> Thanks for your reply.
> >>>> I think the "--to-destination 10.0.0.1" rule will be matched, and the
> >>>> "--to-destination 10.0.0.2" rule will never be matched.
> >>>> Does iptables unsupported "full cone" NAT for multiple internal IP a=
ddresses? =20
> >>>=20
> >>> Does *any* platform support such a configuration? Based on my underst=
anding of what 'full cone' means, every internal address needs a separate e=
xternal address to be fully mapped to it. Your example shows that you have =
one external address,  =20

