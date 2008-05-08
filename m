From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 1/2]: nf_conntrack_sip: restrict RTP expect
 flushing on error to last request
Date: Thu, 08 May 2008 01:15:30 -0700 (PDT)
Message-ID: <20080508.011530.40088674.davem@davemloft.net>
References: <48215E94.7070308@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46440
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759672AbYEHIPg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 May 2008 04:15:36 -0400
In-Reply-To: <48215E94.7070308@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 07 May 2008 09:47:32 +0200

> [NETFILTER]: nf_conntrack_sip: restrict RTP expect flushing on error to last request
> 
> Some Inovaphone PBXs exhibit very stange behaviour: when dialing for example
> "123", the device sends INVITE requests for "1", "12" and "123" back to back.
> The first requests will elicit error responses from the receiver, causing
> the SIP helper to flush the RTP expectations even though we might still see
> a positive response.
> 
> Note the sequence number of the last INVITE request that contained a media
> description and only flush the expectations when receiving a negative
> response for that sequence number.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
