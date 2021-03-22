Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF972C433C1
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Mar 2021 18:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B33F61930
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Mar 2021 18:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhCVSuz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 14:50:55 -0400
Received: from mail.balasys.hu ([185.199.30.237]:35507 "EHLO mail.balasys.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231660AbhCVSu2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 14:50:28 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Mar 2021 14:50:27 EDT
Received: from [10.90.6.8] (dmajor.balasys [10.90.6.8])
        by mail.balasys.hu (Postfix) with ESMTPSA id 625377A0EDF
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Mar 2021 19:44:47 +0100 (CET)
From:   =?UTF-8?Q?Major_D=c3=a1vid?= <major.david@balasys.hu>
Subject: Associate extra information to conntrack entries
To:     netfilter-devel@vger.kernel.org
Message-ID: <5e681031-b426-7446-d2dc-9e3c87261ca6@balasys.hu>
Date:   Mon, 22 Mar 2021 19:44:47 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JboWBnRlEwUvQzg94iIYcRslKNwotbjl9"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JboWBnRlEwUvQzg94iIYcRslKNwotbjl9
Content-Type: multipart/mixed; boundary="o6o1ZkIVP4bXOAyFIF0NZl4x7IW2AtQJ5"

--o6o1ZkIVP4bXOAyFIF0NZl4x7IW2AtQJ5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

I am working on a small kernel module and iptables target which try to as=
sociate some extra information to conntrack entries. I've created a hash =
table (struct rhashtable) with u32 hash keys generated from the conntrack=
 entry's tuple (struct nf_conntrack_tuple). When a connection ends and th=
e conntrack entries are destroyed I have to remove my own data as well, f=
or this purpose I've registered with nf_conntrack_register_notifier to IP=
CT_DESTROY events. This works almost every time but there are cases when =
(as I saw when a connection is not became ESTABLISHED) there is no destro=
y event.

What I would like to ask that is there any reason why the IPCT_DESTROY ev=
ent is omitted in some cases or is there a better approach to attach info=
rmation to conntrack entries?

I thought maybe I have to implement some kind of time based GC to remove =
my entries regardless of the conntrack entry status.

Thanks for your help,
D=C3=A1vid Major



--o6o1ZkIVP4bXOAyFIF0NZl4x7IW2AtQJ5--

--JboWBnRlEwUvQzg94iIYcRslKNwotbjl9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEER03rcYnw4KZJv+zKDM6gQF4hB5sFAmBY5Z8ACgkQDM6gQF4h
B5v5Xw//d1ba3VUT/D4F4/66FXAqvDPSN7K8FLrHRpUYNwiLzBeWd9K/+x6ekyGI
973uyOYAxGy8I6OkwoDzufCK78gx51iwYXHYKytL++2e7jLU4ALzCL95jpwj/GFL
2kP19kZpVzwzEdF6PNw51yV81G5HeEenXwMl0jP4MogKu+ZnwGe1pJfLu3W+H4Ro
GKnP7YmKGmkFDasEF92J3/3Wn4ieHfSAs3z/adWL4nafvrlk7z411eUFGs0Ja4Ko
qwpmbdHcnFzuK2UGhepwlmsnAhJPDx+8RYDbM7e0obTBc2ivkqp290FiShxerp1M
RwmYC4HFVeH9zMXoOqaAn6xso4pigQ/PRrNNm/jeOtEmETV3jc3Okjvc1yoD539P
P+rUHo3g5HWhfLuM1Dr6yg/DFqyQOLZ0p1hxZvU9+pRrPhaz/610Vk9PzL9mOtDX
+yGaZW+GlXteLl3AT7dHbObqZMTsZjXldwcVpn+GEhTgprQezeshR1vf+roLdSNA
VUSpQkBVUfOQtCUUj+n5SSEyxYuE4R6RZdX30LQWpYcW7u7rjiNoxELTGsmm7Y39
TbJ5hGBDJtOMqMUXMRTDdk2zefvry0qw88i62UJhcofcEH6rTNzg4yOWcTJOwuCH
LwNDxaDkwaAhwHEctKAufIbMx50wL3zF8+Hc+NJ71gNRc6JKiCo=
=tz3s
-----END PGP SIGNATURE-----

--JboWBnRlEwUvQzg94iIYcRslKNwotbjl9--

