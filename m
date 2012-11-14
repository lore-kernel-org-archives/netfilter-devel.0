From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: VoIP conntrack issue
Date: Thu, 15 Nov 2012 00:38:09 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1211150035180.32273@nerf07.vanv.qr>
References: <CABY2qi8n0ttC99_UktcT+Jwnd9WCCsvk5+ug1GXrrYbd9ixxWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?J=C3=B6rn_Krebs?= <jk@smartbyte.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38722 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216Ab2KNXiL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2012 18:38:11 -0500
In-Reply-To: <CABY2qi8n0ttC99_UktcT+Jwnd9WCCsvk5+ug1GXrrYbd9ixxWw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2012-11-14 23:41, J=C3=B6rn Krebs wrote:
>
>The problem I have with case 1 is that Linux is assigning a new extern=
al port.
>So and my router Case 1 looks more like this:
>A:5000 <-> router:5000 <-> C
>A:5000 <-> router:1030 <-> D
>Which causes a big issue with my VoIP setup!
>(VoIP is negotiating the ports inside the SIP protocol. They are not
>detected and they are fixed and not detected on the fly)

Are you sure you have tried loading nf_nat_sip, like I mentioned
in the thread[1] on netfilter@ ? Or the extra DNAT rule?

[1] http://marc.info/?l=3Dnetfilter&m=3D135289221821117&w=3D2

>(Hope I made my case clear)

(The conntrack -E dump made a lot more sense to me.)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
