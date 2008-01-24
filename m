From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/8] netfilter: get rid of sparse warning
Date: Thu, 24 Jan 2008 19:34:35 +0100
Message-ID: <4798DA3B.4030309@trash.net>
References: <20080124181536.446214111@vyatta.com> <20080124181628.087126298@vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49710 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYAXSei (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:34:38 -0500
In-Reply-To: <20080124181628.087126298@vyatta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephen Hemminger wrote:

 > Tell sparse about lock assumption here.

Thanks, but I already have an identical patch queued from
Eric Dumazet. Will send everything to Dave soon.
