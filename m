From: Umut Yerci <umutyerci@gmail.com>
Subject: ulogd unexpected character problem
Date: Tue, 13 Jan 2015 08:27:41 +0200
Message-ID: <CAHeaXY44KpK-DX3ZkLLQSV=n8mZ=cJXbPgDMzYepf+37iwujFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:43445 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbbAMG1m convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2015 01:27:42 -0500
Received: by mail-wg0-f46.google.com with SMTP id x13so988377wgg.5
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2015 22:27:41 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I use ulogd in my system version 2.0.2. It write logs to syslog.
However there is unexpected characters in log rows like;
IN=3D=EF=BF=BD=EF=BF=BD OUT=3D MAC=3D LEN=3D0 TOS=3D00 PREC=3D0x00 TTL=3D=
0 ID=3D0 PROTO=3D0 MARK=3D10dcc00
IN=3D\"6 OUT=3D MAC=3D LEN=3D0 TOS=3D00 PREC=3D0x00 TTL=3D0 ID=3D0 PROT=
O=3D0 MARK=3D123_123
IN=3D=EF=BF=BD6 OUT=3D MAC=3D LEN=3D0 TOS=3D00 PREC=3D0x00 TTL=3D0 ID=3D=
0 PROTO=3D0 MARK=3D10dcc00
IN=3DI=EF=BF=BD OUT=3D MAC=3D LEN=3D0 TOS=3D00 PREC=3D0x00 TTL=3D0 ID=3D=
0 PROTO=3D0 MARK=3D10dcc00
IN=3DM OUT=3D MAC=3D LEN=3D0 TOS=3D00 PREC=3D0x00 TTL=3D0 ID=3D0 PROTO=3D=
0 MARK=3D123_123
IN=3D]4 OUT=3D MAC=3D LEN=3D0 TOS=3D00 PREC=3D0x00 TTL=3D0 ID=3D0 PROTO=
=3D0 MARK=3D123_123
IN=3Dr4 OUT=3D MAC=3D LEN=3D0 TOS=3D00 PREC=3D0x00 TTL=3D0 ID=3D0 PROTO=
=3D0 MARK=3D123_123
IN=3D=EF=BF=BD4 OUT=3D MAC=3D LEN=3D0 TOS=3D00 PREC=3D0x00 TTL=3D0 ID=3D=
0 PROTO=3D0 MARK=3D10dcc00
IN=3D=EF=BF=BD=EF=BF=BD OUT=3D MAC=3D LEN=3D0 TOS=3D00 PREC=3D0x00 TTL=3D=
0 ID=3D0 PROTO=3D0 MARK=3D10dcc00

I add file destination to ulogd. It is created internal of it. After
that I watch strace command for ulogd. I see that it read wrong file
destination from RAM ( There is some unrelated keyword in recvfrom).
What is cause of this bug?

Thanks for helping.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
