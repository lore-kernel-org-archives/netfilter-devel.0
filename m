From: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>
Subject: Overlapping IP networks no longer allowed?
Date: Wed, 14 Feb 2018 19:02:32 +0200
Message-ID: <CAPWNY8W5euS6+LrEppdKp81k-Uz48w2WZP8kzu5=cVyhObnVMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pl0-f44.google.com ([209.85.160.44]:46030 "EHLO
        mail-pl0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032907AbeBNRCt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 12:02:49 -0500
Received: by mail-pl0-f44.google.com with SMTP id p5so8847746plo.12
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 09:02:49 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

As of nftables 0.8.1, it seems I can no longer write anonymous sets
which contain overlapping networks (CIDR masks).

For example, I want to write the following ruleset:

#!/usr/bin/nft -f
define users =3D { 10.0.0.0/8, 193.219.181.192/26 }
define admins =3D { 10.123.0.0/24, 31.220.42.129 }
define allowed =3D { $users, $admins }
table inet filter {
        chain foobar {
                ip saddr $allowed accept
        }
}

results in an error message:

    Error: interval overlaps with previous one

I noticed a few nftables.git commits related to disabling auto-merge
for interval sets... but mine don't have the 'interval' flag, and
there doesn't seem to be any way to specify 'auto-merge' for anonymous
sets, either.

--=20
Mantas Mikul=C4=97nas
