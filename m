From: Murat Sezgin <msezgin@codeaurora.org>
Subject: "notification events for routing changes" patch
Date: Mon, 16 Nov 2015 20:26:14 -0800
Message-ID: <D26FEC66.2884B%msezgin@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55889 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbbKQE0l convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Nov 2015 23:26:41 -0500
Received: from [192.168.0.104] (c-50-131-113-95.hsd1.ca.comcast.net [50.131.113.95])
	(using TLSv1 with cipher DES-CBC3-SHA (128/168 bits))
	(No client certificate requested)
	(Authenticated sender: msezgin@smtp.codeaurora.org)
	by smtp.codeaurora.org (Postfix) with ESMTPSA id 6729513FAF3
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2015 04:26:37 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi Jozsef,

While I was looking for a solution in the kernel for general routing
change notification implementation, I came across your following patch.

http://www.spinics.net/lists/netfilter-devel/msg24239.html


In this email chain, you said that you found another simple solution an=
d
implemented it in the masquerade module. I saw that commit in the upstr=
eam
kernel.

But I think the patch you proposed before also very useful for the fast
path implementations. Because when a connection starts to flow through =
the
fast path, linux networking stack no longer sees those packets. Then, i=
f
the route table is changed in some way, let=B9s say user add/delete a r=
oute
with the =B3route=B2 or =B3ip route=B2 command, the fast path traffic w=
ill not
aware of this change. So, if we have a notification mechanism like you
have implemented, the fast path manager module can register itself to
these events and manage its connections accordingly.

Do you have any plan to push and merge this path to the upstream kernel=
?

Regards,
Murat


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
