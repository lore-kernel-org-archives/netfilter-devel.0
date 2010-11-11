From: Patrick McHardy <kaber@trash.net>
Subject: Re: Verdict with ebtables?
Date: Thu, 11 Nov 2010 11:48:09 +0100
Message-ID: <4CDBC9E9.2010508@trash.net>
References: <AANLkTinCazaFKSXnfGe2e0nnfeRorV7AHcadQaxGvWg+@mail.gmail.com> <AANLkTikxkvB2pagQswH1S8=sxA+OVfWrqO45FD6+hDQE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Kfir Lavi <lavi.kfir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35895 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab0KKKsJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:48:09 -0500
In-Reply-To: <AANLkTikxkvB2pagQswH1S8=sxA+OVfWrqO45FD6+hDQE@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11.11.2010 11:05, Kfir Lavi wrote:
> Hi,
> It seems to me that its not possible to do a verdict in userspace of
> ethernet packets, like it is done with nfqueue and iptables.
> Why it is not implemented?

Nobody ever implemented it. IIRC the main problem is that under
certain circumstances the packets need to be passed back to
__netif_receive_skb() when queuing in LOCAL_IN, which isn't
possible from the completion handler.
