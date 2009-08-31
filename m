From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/11] TProxy: reuse a 32bit hole in struct ipv6_pinfo
Date: Mon, 31 Aug 2009 14:27:30 +0200
Message-ID: <4A9BC1B2.6040002@trash.net>
References: <cover.1251295408.git.bazsi@balabit.hu>	 <0a1c3e68b922eef13592d6b6ab9bf4b89251ea3f.1251295408.git.bazsi@balabit.hu>	 <alpine.LSU.2.00.0908291842320.25008@fbirervta.pbzchgretzou.qr> <1251615361.18025.32.camel@bzorp.balabit>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu,
	Harry Mason <harry.mason@smoothwall.net>
To: Balazs Scheidler <bazsi@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60710 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbZHaM1d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:27:33 -0400
In-Reply-To: <1251615361.18025.32.camel@bzorp.balabit>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Balazs Scheidler wrote:
> By the way, what should be the proper procedure for posting patches that
> are tproxy specific but touch the core networking code? Should those go
> through Patrick, or should I just post them to netdev? Or just
> cross-post the patch series to both lists?

When further netfilter patches depend on those changes, they should
probably go through me, but you should CC netdev and the maintainers
of the code in question.
