From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/8] nf_conntrack: sparse warnings
Date: Thu, 24 Jan 2008 19:35:53 +0100
Message-ID: <4798DA89.2000107@trash.net>
References: <20080124181536.446214111@vyatta.com> <20080124181628.162252995@vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49733 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbYAXSf4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:35:56 -0500
In-Reply-To: <20080124181628.162252995@vyatta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephen Hemminger wrote:

 > The hashtable size is really unsigned so sparse complains when you pass
 > a signed integer.  Change all uses to make it consistent.


Applied, thanks.
