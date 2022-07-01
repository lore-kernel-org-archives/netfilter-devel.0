Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27670C43334
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Jul 2022 01:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiGABcw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Jun 2022 21:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiGABcu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Jun 2022 21:32:50 -0400
X-Greylist: delayed 90 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 30 Jun 2022 18:32:48 PDT
Received: from omta021.useast.a.cloudfilter.net (omta021.useast.a.cloudfilter.net [34.195.253.212])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C1141635
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jun 2022 18:32:48 -0700 (PDT)
Received: from mdc-obgw-6001a.ext.cloudfilter.net ([10.0.22.169])
        by cmsmtp with ESMTP
        id 75QYo8mfLgloz75V7oYa85; Fri, 01 Jul 2022 01:31:17 +0000
Received: from wolfie.tirsek.com ([208.107.53.155])
        by cmsmtp with ESMTP
        id 75V6oi1ow8iSy75V6o1QzN; Fri, 01 Jul 2022 01:31:17 +0000
X-Authority-Analysis: v=2.4 cv=bc947cDB c=1 sm=1 tr=0 ts=62be4e65
 a=33qCnF4DYEf8DFTG4eNaxA==:117 a=33qCnF4DYEf8DFTG4eNaxA==:17
 a=JPEYwPQDsx4A:10 a=nlC_4_pT8q9DhB4Ho9EA:9 a=Uoowuq6kZl6j9kMxgGQA:9
 a=PUjeQqilurYA:10
Received: by wolfie.tirsek.com (Postfix, from userid 1000)
        id 646838E03B7; Thu, 30 Jun 2022 20:31:15 -0500 (CDT)
Date:   Thu, 30 Jun 2022 20:31:14 -0500 (CDT)
From:   Peter Tirsek <peter@tirsek.com>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables] Allow resetting the include search path
In-Reply-To: <20220630205620.cy5qblj2zq5pwjaw@House>
Message-ID: <974e8f58-f902-6cbe-08d6-81b5bfb3a710@wolfie.tirsek.com>
References: <Yrs2nn/amfnaUDk8@salvia> <Yrs3kkbc4z5AMF+W@salvia> <20220628190101.76cmatthftrsxbja@House> <YryJ1NXNy5zZb5r+@salvia> <20220630205620.cy5qblj2zq5pwjaw@House>
User-Agent: Alpine 2.25.1 (LNX 637 2022-01-15)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="655616-1758579919-1656633186=:1093"
Content-ID: <aec88150-bbc1-ab73-13c5-066ac3ade932@wolfie.tirsek.com>
X-CMAE-Envelope: MS4xfA4b0GUw3SngJI0T2RWIyP6xowI08MNXWbNzU8NkVF2Cfposk91j+n/vgDiJMljsls8cXhJyM+Ew6KJH4adgm/LuR8JGH2EjcvpeqSYKZCGqhcDWmViM
 I/XuT0TpBLhZK8Tt4Ov86r6mVZwC+eOiObiYBUl5jXR1hAlYMdS4nam7Xm2+sGSkJcIUNoljrPQVdhTv5zzZpGt/HUvv+c99P7A=
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655616-1758579919-1656633186=:1093
Content-Type: text/plain; CHARSET=ISO-8859-15; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <f25162cf-00e8-abc0-4106-8fa94f0c15fd@wolfie.tirsek.com>

On Thu, 30 Jun 2022, Daniel Gr=F6ber wrote:

>> You also consider that using absolute path in includes is suboptimal?
> Ok so what I want to do is load an about to be deployed nftables config
> without making it permanent yet as it might be buggy and cause an ssh
> lockout. To prevent this I first load the temporary config with `nft -f`,
> check ssh still works and only then commit the config to the final locati=
on
> in /etc.
>
> This works all fine and dandy when only one nftables.conf file is involve=
d,
> but as soon as I have includes I need to deploy the entire config directo=
ry
> tree somewhere out-of-the-way.

We're probably getting a little off topic for netfilter-devel, but=20
could you do this using a mount namespace? For example (as root, since=20
you indicated that you want to really load the actual ruleset into the=20
main firewall):

Set up the nft config to test:

     root@nftest /tmp# mkdir -p nft-test/etc/nft.d
     root@nftest /tmp# cat > nft-test/etc/nft.conf <<<'include "/etc/nft.d/=
nft.included.conf"'
     root@nftest /tmp# cat > nft-test/etc/nft.d/nft.included.conf <<<$'flus=
h ruleset\ncreate table inet filter'

Set up a temporary separate mount namespace. Here, this launches a new=20
shell, so if you're automating this, the rest of the commands need to=20
be in a separate script, and unshare can invoke that script instead of=20
an interactive shell:

     root@nftest /tmp# unshare --mount

Set up the "fake" /etc to allow the absolute paths to work. This could=20
probably also be done with an overlay mount if you need to preserve=20
visibility of the underlying files in /etc, but it's a little more=20
complicated and probably not necessary.

     root@nftest /tmp# mount -o bind nft-test/etc /etc
     root@nftest /tmp# ls -l /etc
     total 4
     -rw-r--r-- 1 0 0 39 Jul  1 00:02 nft.conf
     drwxr-xr-x 2 0 0 60 Jul  1 00:02 nft.d/

Now you can load the ruleset fully using absolute paths, even though=20
the files are stored somewhere else:

     root@nftest /tmp# nft flush ruleset
     root@nftest /tmp# nft -f /etc/nft.conf
     root@nftest /tmp# nft list ruleset
     table inet filter {
     }

--=20
Peter Tirsek
--655616-1758579919-1656633186=:1093--
