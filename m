From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] xt_socket: checks for the state of nf_conntrack
Date: Fri, 01 May 2009 15:22:33 -0700 (PDT)
Message-ID: <20090501.152233.267014258.davem@davemloft.net>
References: <1241105755-10017-1-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, mingo@elte.hu, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, hidden@sch.bme.hu,
	linux-kernel@vger.kernel.org
To: panther@balabit.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55043
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755616AbZEAWWj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 May 2009 18:22:39 -0400
In-Reply-To: <1241105755-10017-1-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Laszlo Attila Toth <panther@balabit.hu>
Date: Thu, 30 Apr 2009 17:35:55 +0200

> xt_socket can use connection tracking, and checks whether it is a module.
> 
> Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>

Applied, thanks.
