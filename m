From: Felipe W Damasio <felipewd@gmail.com>
Subject: Re: Help: Cycle through iptables rules
Date: Thu, 27 May 2010 17:55:32 -0300
Message-ID: <AANLkTin1DlsWoARkPj8_Ut758a8j-ONfgkms6c8N7Of-@mail.gmail.com>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
	<1274861468.2672.9.camel@edumazet-laptop>
	<alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
	<AANLkTilFXTT5kKPCTD7Re8Xzeg6UoKlDUJJvWPCGJXRd@mail.gmail.com>
	<alpine.LSU.2.01.1005262215010.30857@obet.zrqbmnf.qr>
	<1274905649.2542.1.camel@edumazet-laptop>
	<alpine.LSU.2.01.1005270008520.30857@obet.zrqbmnf.qr>
	<AANLkTilwGbJn20DXLtyDCHFQm8eS4g3_AUyLrI-huNi8@mail.gmail.com>
	<1274992813.2446.22.camel@edumazet-laptop>
	<AANLkTinfHPE1YjwfHE-R-4CukNjXosQBKtD0T8A7nm4b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63073 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891Ab0E0Uze convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 16:55:34 -0400
Received: by fxm10 with SMTP id 10so227023fxm.19
        for <netfilter-devel@vger.kernel.org>; Thu, 27 May 2010 13:55:33 -0700 (PDT)
In-Reply-To: <AANLkTinfHPE1YjwfHE-R-4CukNjXosQBKtD0T8A7nm4b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi again :)

2010/5/27 Felipe W Damasio <felipewd@gmail.com>:
> =A0So your suggestion is to mark everything with 0x0 to make sure tha=
t
> if something goes wrong the first port will get the packet, right?

 The resulting extrachain was:

Chain extrachain (1 references)
target     prot opt source               destination
CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           CONNMARK a=
nd 0x0
CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           statistic
mode nth every 3 CONNMARK and 0x0
CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           statistic
mode nth every 3 packet 1 CONNMARK xset 0x1/0xffffffff
CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           statistic
mode nth every 3 packet 2 CONNMARK xset 0x2/0xffffffff

  Everything gets marked right up front, and later the statistic stuff
is used to evenly mark the packets to be forwarded to each squid port.

  Thanks for your help.

  Cheers,

=46elipe Damasio
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
