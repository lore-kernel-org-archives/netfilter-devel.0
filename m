From: =?ISO-8859-1?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [PATCH 0/3] nftables: fix some endian issues
Date: Tue, 19 Aug 2014 19:22:34 +0200
Message-ID: <53F387DA.90205@gmail.com>
References: <1408404451-9075-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55359 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbaHSRW1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:22:27 -0400
Received: by mail-wi0-f178.google.com with SMTP id hi2so5652828wib.17
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2014 10:22:26 -0700 (PDT)
In-Reply-To: <1408404451-9075-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Patrick

El 19/08/14 01:27, Patrick McHardy escribi=F3:
> These patches fix the endian issues Alvaro observed in the bridge tab=
le.
>
> The main problem was that the ETH_P_* values are in host byte order, =
so
> they never matches. This is fixed by simply converting the constants =
to
> big endian.
>
> Two related problems are that symbol table printing and higher layer
> protocol lookup didn't take endianess into account properly. This is
> fixes by exporting the value in the proper byte order before comparis=
on.
>
> With these patches, everything works as expected:
>
> table bridge filter {
> 	chain input {
> 		 type filter hook input priority -200;
> 		 ip daddr 192.168.1.80 tcp dport ssh counter packets 0 bytes 0
> 		 ether type ip counter packets 128 bytes 36734
> 		 ether type arp counter packets 12 bytes 336
> 	}
> }
>

I have been using the patches and it works perfectly. Thank you very mu=
ch.

Alvaro
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
