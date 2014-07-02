From: giorgio.nicole@arcor.de
Subject: patches for an autotooled version of 'nftables'.
Date: Wed, 2 Jul 2014 17:37:44 +0200 (CEST)
Message-ID: <1092838908.652005.1404315464881.JavaMail.ngmail@webmail07.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:48038 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125AbaGBPhq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:37:46 -0400
Received: from mail-in-18-z2.arcor-online.net (mail-in-18-z2.arcor-online.net [151.189.8.35])
	by mx.arcor.de (Postfix) with ESMTP id DD0381975DE
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Jul 2014 17:37:44 +0200 (CEST)
Received: from mail-in-09.arcor-online.net (mail-in-09.arcor-online.net [151.189.21.49])
	by mail-in-18-z2.arcor-online.net (Postfix) with ESMTP id D88FA33B049
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Jul 2014 17:37:44 +0200 (CEST)
Received: from webmail07.arcor-online.net (webmail07.arcor-online.net [151.189.8.8])
	by mail-in-09.arcor-online.net (Postfix) with ESMTP id D47D91975DE
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Jul 2014 17:37:44 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

attached is a git repo and a couple of commits patches to add autotools support
to the 'nftables' project.

I would like to have some feedback on it and eventually see the patches
merged on the main 'nftables' repo.

The patches are based on the version 0.3 of nftable.

The whole changes are divided in different commits for the sake of clarity
and documentation but it's not really possible to build any of the tree states
in between, only the last 'autotool conversion: ...' state is usable.

One of my tests was to unpack the tar under /tmp, then create a new build
dir., say /tmp/nft_build, and then create a release distribution from there:

# cd /tmp
# tar xf /tmp/nftables-0.3_autotooled.tar.xz
# mkdir nft_build
# cd nft_build
# /tmp/nftable-0.3_autotooled/autogen.sh
# /tmp/nftable-0.3_autotooled/configure
# make distcheck

The 'distcheck' target tries to configure/build/install the package and if it's all
right it produces a tar archive with all that's needed for a release.

On the top of the 'autotool conversion: ...' commits there are two more commits that fix
some gcc warnings and a build failure because of the function 'xfree()'; these commits
obviously do not belong to the added autotools support.

giorgio
