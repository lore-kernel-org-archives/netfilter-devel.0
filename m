From: =?gb2312?B?1dTA2g==?= <zhao.lei129@pku.edu.cn>
Subject: reinject packets
Date: Sun, 23 Nov 2008 16:51:42 +0800
Message-ID: <1f058a1f0804.1f08041f058a@pku.edu.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="--d7dfd319bd6f89"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sunrise.pku.edu.cn ([162.105.129.21]:49099 "HELO
	sunrise.pku.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752168AbYKWIry (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Nov 2008 03:47:54 -0500
Content-Language: zh-CN
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.

----d7dfd319bd6f89
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi=2C

I register an NF=5FIP=5FPRE=5FROUTING hook that check all the incoming pa=
ckets
and return NF=5FSTOLEN on particular TCP packets=2E I=A1=AFm trying to re=
inject
them into the TCP/IP stack later=2E Any advice about how this can be
achieved in a module=3F Does netfilter provide such a functionality=3F

Thanks a lot=2E

----d7dfd319bd6f89
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Received: from [162.105.75.167] by water.pku.edu.cn (mshttpd); Fri, 21
 Nov 2008 10:17:06 +0800
From: =?gb2312?B?1dTA2g==?= <zhao.lei129@pku.edu.cn>
To: netfilter-devel@vger.kernel.org
Message-ID: <1abcda1a9175.1a91751abcda@pku.edu.cn>
Date: Fri, 21 Nov 2008 10:17:06 +0800
X-Mailer: iPlanet Messenger Express 5.2 Patch 2 (built Jul 14 2004)
MIME-Version: 1.0
Content-Language: zh-CN
Subject: NF_STOLEN
X-Accept-Language: zh-CN
Priority: normal
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi=2C

I register a NF=5FIP=5FPRE=5FROUTING hook that check the incoming packets=
=2E I=A1=AFm
trying to return NF=5FSTOLEN on particular TCP packets and later pass the=
m
to the TCP module of the kernel=2E Any advice about how this can be achie=
ved=3F =


Thanks a lot=2E


----d7dfd319bd6f89--

