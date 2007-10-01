From: "Tomas Mandys" <tomas.mandys@2p.cz>
Subject: Netfilter callbacks and UDP fragmenting
Date: Mon, 1 Oct 2007 13:23:40 +0200
Message-ID: <004901c8041d$851a86d0$620aa8c0@nyala>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.wia.cz ([80.250.1.161]:48257 "EHLO mail.wia.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbXJALuI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Oct 2007 07:50:08 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.wia.cz (Postfix) with ESMTP id B22CB178A2F
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Oct 2007 13:31:42 +0200 (CEST)
Received: from mail.wia.cz ([127.0.0.1])
 by localhost (mail.wia.cz [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 16666-50 for <netfilter-devel@vger.kernel.org>;
 Mon,  1 Oct 2007 13:31:37 +0200 (CEST)
Received: from nyala (unknown [192.168.10.98])
	by mail.wia.cz (Postfix) with ESMTP id 35FCE178914
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Oct 2007 13:24:35 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,
are UDP packets defragmented before are passed to netfilter callback
functions (e.g. PREROUTING) or developer has to create buffer and
defragment by himself, to release memory when a fragment is missing,
etc. - is there a working implementation/example? How about locally
generated packets in OUTPUT callback? 

I've looked e.g. in nf_conntrack_sip.c and I can't see any extra
defragmentation code even SIP message can be fragmented, especially SDP
content.

Thanks
Tomas

