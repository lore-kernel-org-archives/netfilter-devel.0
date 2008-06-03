From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] libnfnetlink byte alignment
Date: Tue, 03 Jun 2008 15:06:40 +0200
Message-ID: <484541E0.3020900@trash.net>
References: <1212488448.29489.40.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39764 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbYFCNGm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2008 09:06:42 -0400
In-Reply-To: <1212488448.29489.40.camel@pumper.lan.luxnet.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> Aligns buffers to maximum alignment of architecture to make the cast of
> char pointers to struct pointers more portable.
> 
> Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>

They all seem fine to me, but a union might make it look
a bit nicer :)

