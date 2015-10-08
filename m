From: Feng Gao <gfree.wind@outlook.com>
Subject: RE: [PATCH 1/1] netfilter: ftp: Check data size before copy them into FTP buffer
Date: Thu, 8 Oct 2015 21:32:20 +0800
Message-ID: <BAY403-EAS31918DC7EECB2CBACB04AA195350@phx.gbl>
References: <BAY403-EAS3244BB5B8769FABE83B01EF954E0@phx.gbl> <20151004201620.GA30723@salvia> <alpine.LSU.2.20.1510042338260.19792@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <netfilter-devel@vger.kernel.org>
To: "'Jan Engelhardt'" <jengelh@inai.de>,
	"'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bay004-omc1s22.hotmail.com ([65.54.190.33]:54215 "EHLO
	BAY004-OMC1S22.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964AbbJHNcZ convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2015 09:32:25 -0400
In-Reply-To: <alpine.LSU.2.20.1510042338260.19792@nerf40.vanv.qr>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yes. The features of network interface I pointed are GRO/TSO/LSO and so=
 on.
Then the kernel may aggregate one big packet.

BTW, I am sorry that I don't response the email in time, because I left
internet for days.

-----Original Message-----
=46rom: netfilter-devel-owner@vger.kernel.org
[mailto:netfilter-devel-owner@vger.kernel.org] On Behalf Of Jan Engelha=
rdt
Sent: 2015=C4=EA10=D4=C25=C8=D5 5:39
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Feng Gao <gfree.wind@outlook.com>; netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] netfilter: ftp: Check data size before copy th=
em
into FTP buffer

On Sunday 2015-10-04 22:16, Pablo Neira Ayuso wrote:

>On Tue, Sep 29, 2015 at 04:49:32PM +0800, Feng Gao wrote:
>> When TCP endpoint supports the windows scale option, the data size=20
>> could be more than 65536 easily. And there are some network interfac=
e=20
>> features which could aggregate multiple packets. So we need to check=
=20
>> the datalen before copy data into the FTP buffer.
>
>I don't think you can go over the maximum IPv4/IPv6 packet length with=
=20
>aggregation.

But there are jumbo frames known to IPv6, at least in principle. Dunno =
if
GRO/TSO/.. do that, though.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el"
in the body of a message to majordomo@vger.kernel.org More majordomo in=
fo at
http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
