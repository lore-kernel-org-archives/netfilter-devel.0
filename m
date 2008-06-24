From: David Miller <davem@davemloft.net>
Subject: Re: netfilter: ip6table_mangle: don't reroute in LOCAL_IN
Date: Tue, 24 Jun 2008 13:31:17 -0700 (PDT)
Message-ID: <20080624.133117.80175807.davem@davemloft.net>
References: <4860E371.7090401@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39280
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752220AbYFXUbS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2008 16:31:18 -0400
In-Reply-To: <4860E371.7090401@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 24 Jun 2008 14:07:13 +0200

> Attached is a single fix for 2.6.26 that corrects the LOCAL_IN
> hook function in ip6table_mangle. Please apply, thanks.

Applied and pushed out to net-2.6, thanks1
