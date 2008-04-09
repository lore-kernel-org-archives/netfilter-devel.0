From: Patrick McHardy <kaber@trash.net>
Subject: Re: Ebtables hook order anomaly
Date: Wed, 09 Apr 2008 17:23:57 +0200
Message-ID: <47FCDF8D.8050107@trash.net>
References: <925A849792280C4E80C5461017A4B8A226A019@mail733.InfraSupportEtc.com> <alpine.LNX.1.10.0803250301140.9368@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0803250455030.9368@fbirervta.pbzchgretzou.qr> <47E8F6B4.4030800@trash.net> <alpine.LNX.1.10.0804081645450.2229@fbirervta.pbzchgretzou.qr> <47FCD47A.7060600@trash.net> <alpine.LNX.1.10.0804091639210.3866@fbirervta.pbzchgretzou.qr> <925A849792280C4E80C5461017A4B8A226A0F7@mail733.InfraSupportEtc.com> <47FCDC8F.5030701@trash.net> <925A849792280C4E80C5461017A4B8A226A0F9@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Greg Scott <GregScott@InfraSupportEtc.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50745 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYDIPX7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:23:59 -0400
In-Reply-To: <925A849792280C4E80C5461017A4B8A226A0F9@mail733.InfraSupportEtc.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Greg Scott wrote:
>> I forgot why exactly you need the bridge port in iptables.
> 
> We crossed in the email a minute ago when I described my H.323 stuff.  

Yes, but I was wondering more about the exact rules where
this would be helpful. The things you described in your
other mail sounds easily doable by simply exluding port
1723 from NAT without any knowledge of bridge ports.
