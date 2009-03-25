From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch 2/3] netfilter: add generic function to get len of generic
 policy
Date: Wed, 25 Mar 2009 21:53:19 +0100
Message-ID: <49CA99BF.5060002@trash.net>
References: <20090325203404.581023828@jonathan.eitzenberger.org> <20090325204601.730465387@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39748 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbZCYUx1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:53:27 -0400
In-Reply-To: <20090325204601.730465387@jonathan.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Holger Eitzenberger wrote:
> Usefull for all protocols which do not add additional data, such
> as GRE or UDPlite.

Applied, thanks.
