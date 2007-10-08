From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 11/13] iptables TPROXY target
Date: Mon, 08 Oct 2007 10:34:05 +0200
Message-ID: <4709EB7D.5030806@trash.net>
References: <20071002203942.11052.7303.stgit@nessa.odu> <20071002204522.11052.59717.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55914 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbXJHIg3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2007 04:36:29 -0400
In-Reply-To: <20071002204522.11052.59717.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

KOVACS Krisztian wrote:
> The TPROXY target implements redirection of non-local TCP/UDP traffic to local
> sockets. Additionally, it's possible to manipulate the packet mark if and only
> if a socket has been found. (We need this because we cannot use multiple
> targets in the same iptables rule.)


Same suggestions as for the socket match (EXPERIMENTAL and TCP/UDP check
in ->checkentry).
