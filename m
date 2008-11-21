From: =?gb2312?B?1dTA2g==?= <zhao.lei129@pku.edu.cn>
Subject: NF_STOLEN
Date: Fri, 21 Nov 2008 10:17:06 +0800
Message-ID: <1abcda1a9175.1a91751abcda@pku.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sunrise.pku.edu.cn ([162.105.129.21]:52429 "HELO
	sunrise.pku.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752132AbYKUCTf convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2008 21:19:35 -0500
Content-Language: zh-CN
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I register a NF_IP_PRE_ROUTING hook that check the incoming packets. I=A1=
=AFm
trying to return NF_STOLEN on particular TCP packets and later pass the=
m
to the TCP module of the kernel. Any advice about how this can be achie=
ved?=20

Thanks a lot.


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
