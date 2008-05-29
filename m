From: "Sarge Gorden" <metalblade@gmail.com>
Subject: Re: About IPSec ALG
Date: Thu, 29 May 2008 19:53:29 +0800
Message-ID: <182d06220805290453n2b637d32x417d52794cda9709@mail.gmail.com>
References: <182d06220805290231w314e2f16v4f38bfde69055e6f@mail.gmail.com>
	 <alpine.LNX.1.10.0805291148210.19264@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:38114 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYE2Lxa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2008 07:53:30 -0400
Received: by an-out-0708.google.com with SMTP id d40so59107and.103
        for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2008 04:53:29 -0700 (PDT)
In-Reply-To: <alpine.LNX.1.10.0805291148210.19264@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the VPN server or client doesn't support NAT-T.
Then multiple hosts behind a single NAT address couldn't
simultaneously establish and maintain tunnels to the multiple exterior
hosts.
Only one host could establish...

But if both side support NAT-T, it works.


On Thu, May 29, 2008 at 5:49 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Thursday 2008-05-29 11:31, Sarge Gorden wrote:
>
>>Hi all,
>>
>>Now I was using a Linux box as a gateway (Ver: 2.6.18). But without
>>NAT-T there gona some problems when connecting a L2TP-over-IPSec VPN
>>server.
>
> What problem?
>
>>I wonder if there's a "IPSec ALG" could port into the kernel. (Just
>>like ip_conntack_ipsec/ip_nat_ipsec)
>>Is there is a patch availiable now?
>
> AH and ESP is handled by nf_conntrack_proto_generic (always built-in).
>
