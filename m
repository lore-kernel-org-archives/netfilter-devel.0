From: Rohit <will.u.tellmemore@gmail.com>
Subject: Is it ok to create copies of sk_buff in PRE_ROUTING hook and call okfn(sk_buff_ptr) to forward it to multiple machines ?
Date: Wed, 19 Dec 2007 21:04:23 +0530
Message-ID: <97993dc40712190734v707c0f37ufabf281de1249cfc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org,
	netfilter-failover@lists.netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.230]:23564 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbXLSPe2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Dec 2007 10:34:28 -0500
Received: by wr-out-0506.google.com with SMTP id c49so2043094wra.1
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Dec 2007 07:34:26 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

HI all,
I am working on a task which requires my netfilter based  kernel
module (hooks at PRE_ROUTING and POST_ROUTING) to send same tcp packet
to multiple machines. What i have done in my hook is  sk_buff_ptr  =
pskb_copy(pskb) ; where pskb is original packet passed to my hook
function @ PRE_ROUTING by netfilter layer. and after modifying ip
address and ports
i do okfn(sk_buff_ptr). This is working and i am getting the desired output.

    But i am not sure if this is correct way to do this kind of job ??
Or is there any other mechanism to achieve same.?? I want make sure
that the cloned packets travel the correct path in networking code and
not bypass something important.From what i have understood okfn
function will be anyway called with packet pointer passed to it
(ip_rcv_finish or similar) after the hooks . So this should not be an
issue but need confirmation/correction from netfilter community.

Thanks,
 Rohit
