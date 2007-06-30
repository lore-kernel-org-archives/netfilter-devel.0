From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: mss to pmtu clamping partially broken?
Date: Sat, 30 Jun 2007 10:35:26 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706301034320.22579@fbirervta.pbzchgretzou.qr>
References: <4684E853.20900@domdv.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	netfilter-devel@lists.netfilter.org
To: Andreas Steinmetz <ast@domdv.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755237AbXF3Ifj@vger.kernel.org>
In-Reply-To: <4684E853.20900@domdv.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Jun 29 2007 13:09, Andreas Steinmetz wrote:
>
>There seems to be a problem with mss to pmtu clamping for incoming syn
>packets on reply to an outgoing connection on a ppp interface. The mss
>of the outgoing syn packets is always always clamped to the pmtu, I did
>check this with a target host I do have access to. The incoming syn
>reply to such a packet, however, is mss clamped only sometimes and this
>seems to depend on the DSL line used.

Do you really need clamping? It's a hack, since TCP should do MSS negotiation
itself. (Of course it may happen that some routers are broken.) But usually not
for incoming packets.



	Jan
-- 
