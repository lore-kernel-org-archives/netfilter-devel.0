Return-Path: <SRS0=RVZI=YP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,HK_RANDOM_REPLYTO,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA632CA9EA0
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 13:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 284D12184C
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 13:04:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="MHMqUZb+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731868AbfJVNEh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 09:04:37 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:16312 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731848AbfJVNEg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 09:04:36 -0400
Date:   Tue, 22 Oct 2019 13:04:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1571749474;
        bh=J02+z6N0OImzY90ezirAO66MBw0GrT4R50v9V06BjQA=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=MHMqUZb++G0gc4zQmDQ2NuK3L4C69GKHIP1n3+z2xL8Wk2knodGr83mrTcRKq/iMi
         OdQlR5QFQx7u2jqZ8H0Uqilhvyr+frkIqSeiNm6ilrrw9rUK7zrHCKxEnq2ILuhKoi
         Gj19iqvStcZnb9pftidee/lID7D6pi34YNCxRbQ8=
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From:   Ttttabcd <ttttabcd@protonmail.com>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: How to implement transparent proxy in bridge through nftables
Message-ID: <0nkwkdhigGlVkVliaeVhuQ2wMq-np7v0sEG1lwiwI8fKYJg8plX19uqIPiONNMpUQbIluwVsyIPsVyEs7MTE_zGRJWgaYCYdchwRs16fRHk=@protonmail.com>
Feedback-ID: EvWK9os_-weOBrycfL_HEFp-ixys9sxnciOqqctCHB9kjCM4ip8VR9shOcMQZgeZ7RCnmNC4HYjcUKNMz31NBA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In ebtables, I can pull the direct Layer 2 forwarding traffic to the networ=
k layer through the "broute" table, but I can't find the "broute" table in =
nftables.

Later, I want to perform target MAC address redirection in PREROUTING, and =
change the target MAC to the bridge itself or the MAC of the slave interfac=
e, so that the data frame can reach the network layer.

But nftables doesn't seem to be able to perform MAC address redirection in =
bridge families, so there is no way to use it.

Finally, I searched the Internet for a long time, found br_netfilter, can o=
pen bridge-nf-call-iptables to pass the bridge frame to the iptables hook p=
rocessing, but nftables does not support this feature.

Now I have tried all the methods that I can think of and can search. All of=
 them are not working. I can only come here for help.

Can someone tell me how to run transparent proxy in the bridge with nftable=
s, and the transparent proxy uses the tproxy module.

Does anyone know how to do it?
