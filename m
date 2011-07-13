From: =?UTF-8?Q?Michal_Pokrywka?= <wolfmoon@o2.pl>
Subject: =?UTF-8?Q?Re:_HFSC_warning_issue?=
Date: Wed, 13 Jul 2011 11:21:45 +0200
Message-ID: <1282b78c.566ec172.4e1d63a9.af9f8@o2.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org, 631945@bugs.debian.org
To: soltys@ziu.info
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tur.go2.pl ([193.17.41.50]:49255 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965108Ab1GMJVz convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jul 2011 05:21:55 -0400
Received: from moh1-ve3.go2.pl (moh1-ve3.go2.pl [193.17.41.134])
	by tur.go2.pl (Postfix) with ESMTP id 32EFC232596
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jul 2011 11:21:54 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Through serveral days my friend has done some tests with kernels 2.6.39.x

2.6.39.1, 2.6.39.2 and 2.6.39.3 are still affected.

2.6.39 (debian version 2.6.39-1 from http://snapshot.debian.org/binary/?cat=l)
works for several hours without triggering the bug. If it persist for some hours
more we will bisect 2.6.39 and 2.6.39.1 and try to find the related patch.
