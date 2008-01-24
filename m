From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/8] nf_conntrack-h323: sparse fixes
Date: Thu, 24 Jan 2008 19:44:13 +0100
Message-ID: <4798DC7D.2040709@trash.net>
References: <20080124181536.446214111@vyatta.com> <20080124181628.392423639@vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49939 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbYAXSoQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:44:16 -0500
In-Reply-To: <20080124181628.392423639@vyatta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephen Hemminger wrote:

 > Sparse complains when a function is not really static. Putting static
 > on the function prototype is not enough.

Applied, thanks.
