From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnetfilter_queue and pid of process owning packet.
Date: Fri, 17 Apr 2009 17:54:16 +0200
Message-ID: <49E8A628.6070808@trash.net>
References: <20090417145949.GS3600@finnois.psycho-hazard.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?ISO-8859-15?Q?G=E9rald_Colangelo?= <binarym@psycho-hazard.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56656 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbZDQPyS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:54:18 -0400
In-Reply-To: <20090417145949.GS3600@finnois.psycho-hazard.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

G=E9rald Colangelo wrote:
> Is there a simple way to get the pid of the process owning the packet=
 throught
> libnetfilter_queue ?
> I know that this parameters would only be revelant in case of OUPUTed=
 packet,
> but i would be really useful for me ... :)

Currently not, but I'd take a patch to add fsuid/fsgid support.
Check out the nfnetlink_log code for reference if needed.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
