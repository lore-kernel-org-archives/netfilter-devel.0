From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 01/02: nf_conntrack_tcp: fix endless loop
Date: Wed, 09 Jul 2008 15:07:03 -0700 (PDT)
Message-ID: <20080709.150703.263188494.davem@davemloft.net>
References: <4874EB63.6090304@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35125
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751562AbYGIWHD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:07:03 -0400
In-Reply-To: <4874EB63.6090304@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 09 Jul 2008 18:46:27 +0200

> following is a bugfix for an endless loop in TCP conntrack triggered
> by a rare race condition, as well as a fix for a warning introduced
> by the SNMP ASN.1 parser fixes. The first one is of course also a
> -stable candidate.
> 
> Please apply, thanks.

Both applied to net-2.6, thanks Patrick!
