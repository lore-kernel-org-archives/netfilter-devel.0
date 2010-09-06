From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: fragmented packet
Date: Mon, 6 Sep 2010 08:09:43 +0800
Message-ID: <AANLkTi=tx3esVsiFiuHCcL3nxX+7EPfKPwW9ts+MOzqt@mail.gmail.com>
References: <AANLkTikniSd5X_ryuhWbAyDLPa7oDSDULe1iYfG02vuP@mail.gmail.com>
 <alpine.LNX.2.01.1009050017350.15290@obet.zrqbmnf.qr> <AANLkTimmN8T4fw=kW+CB0Oh285wrVb4BD4_bx9k_kVxs@mail.gmail.com>
 <AANLkTinNdSq-PMnsYQ7Qb6E0tkhuUF71F2+9ux5OFM3h@mail.gmail.com>
 <AANLkTi=Gv7J5K7kip0JzvDtybsF-hJV_oBm6pQpezhWb@mail.gmail.com>
 <alpine.LNX.2.01.1009051754280.9116@obet.zrqbmnf.qr> <AANLkTik03N1ZRKeF=0YGWSvXOhccrVKMwHEQHB_TVjR6@mail.gmail.com>
 <AANLkTi=LVLd2YxkDDeh3uGpW2R3n_QC-F=SHM115bY6b@mail.gmail.com>
 <AANLkTi=G5LY--8_-o7yEsLZYvwdXxUpLAF6v2iRpqTEh@mail.gmail.com> <AANLkTin4Kn5Ueb0QqquoEmSx6abbRtda62=X=NKC4yQU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34610 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab0IFAKE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:10:04 -0400
Received: by wwj40 with SMTP id 40so5696079wwj.1
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Sep 2010 17:10:03 -0700 (PDT)
In-Reply-To: <AANLkTin4Kn5Ueb0QqquoEmSx6abbRtda62=X=NKC4yQU@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 6, 2010 at 8:04 AM, Nicola Padovano
<nicola.padovano@gmail.com> wrote:
> those 140 bytes are the __tcp payload__ so the payload of IP is: Ip
> header +TCP payload = 180...
> isn't it?

After checking the code of hping, I find the 'mtu' parameter of hping
is the payload of a IP packet.

So the packet you captured should be 20iphdr + 20tcphdr + 140data,
20tcphdr + 140data == 160("mtu" of hping), no fragmentation is needed.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
