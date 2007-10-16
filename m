From: "Yakov Lerner" <iler.ml@gmail.com>
Subject: NF_IP_POST_ROUTING hook question (2.4)
Date: Tue, 16 Oct 2007 12:28:43 +0200
Message-ID: <f36b08ee0710160328h3a45d18k41a32dcb8f6f3d4e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.226]:33958 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbXJPK2p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:28:45 -0400
Received: by nz-out-0506.google.com with SMTP id s18so1178437nze
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Oct 2007 03:28:44 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

In the NF_IP_POST_ROUTING hook function, how can I
tell that packet originated locally vs was forwarded ?
I need to hook NF_IP_POST_ROUTING not NF_IP_FORWARD.

I'd expect that 'net_device *in' argument to be  not NULL for
forwarded packets.

But what I see is NULL for both forwarded  and locally sent packets
(in NF_IP_POST_ROUTING hook).
Which field of skb can  tell me that packet originated locally ?

Yakov
