From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 03/11] TProxy: reuse a 32bit hole in struct ipv6_pinfo
Date: Sun, 30 Aug 2009 12:49:46 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908301248300.538@fbirervta.pbzchgretzou.qr>
References: <cover.1251295408.git.bazsi@balabit.hu>  <0a1c3e68b922eef13592d6b6ab9bf4b89251ea3f.1251295408.git.bazsi@balabit.hu>  <alpine.LSU.2.00.0908291842320.25008@fbirervta.pbzchgretzou.qr> <1251615361.18025.32.camel@bzorp.balabit>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu,
	Harry Mason <harry.mason@smoothwall.net>
To: Balazs Scheidler <bazsi@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59801 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbZH3Ktq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Aug 2009 06:49:46 -0400
In-Reply-To: <1251615361.18025.32.camel@bzorp.balabit>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-08-30 08:56, Balazs Scheidler wrote:
>
>By the way, what should be the proper procedure for posting patches that
>are tproxy specific but touch the core networking code? Should those go
>through Patrick, or should I just post them to netdev? Or just
>cross-post the patch series to both lists?

Depends on whether you are trying to get attention on a patch or
whether you go for sneaky inclusion ;-)

