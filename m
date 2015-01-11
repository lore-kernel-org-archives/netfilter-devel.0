From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/6] netlink: style and readability fixes
Date: Sun, 11 Jan 2015 08:09:36 +0000
Message-ID: <1420963782-21189-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54789 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbbAKIJr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jan 2015 03:09:47 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some cleanups for netlink related functions as preparation for the
concat support, mainly consisting of getting rid of style differences,
removing overly long lines and similar reformatting.

