From: Olivier Blin <dev@blino.org>
Subject: [PATCH] ipset tool: Fix link with libtool >= 2.4.4
Date: Thu,  7 Jan 2016 00:21:08 +0100
Message-ID: <1452122469-22209-1-git-send-email-dev@blino.org>
Cc: kadlec@sunserv.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nan92-5-82-235-5-110.fbx.proxad.net ([82.235.5.110]:45416 "EHLO
	euphor.blino.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbcAFXb1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Jan 2016 18:31:27 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This is a simple patch to fix link of ipset with latest libtool
versions.

Cheers
