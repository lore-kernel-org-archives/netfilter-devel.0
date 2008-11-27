From: Jan Engelhardt <jengelh@medozas.de>
Subject: =?UTF-8?Q?Re=3A_=E7=AD=94=E5=A4=8D=3A_Re=3A_NF=5FSTOLEN?=
Date: Thu, 27 Nov 2008 09:25:02 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811270923200.29236@fbirervta.pbzchgretzou.qr>
References: <23c0b023d0f5.23d0f523c0b0@pku.edu.cn> <alpine.LNX.1.10.0811261716140.2741@fbirervta.pbzchgretzou.qr> <000601c9503c$15770030$40650090$@lei129@pku.edu.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Zhao Lei <zhao.lei129@pku.edu.cn>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43168 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbYK0IZE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Nov 2008 03:25:04 -0500
In-Reply-To: <000601c9503c$15770030$40650090$@lei129@pku.edu.cn>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-11-27 03:58, Zhao Lei wrote:

>Thank you for your reply. My problem has been solved. It turns out that 
>if I use skb_copy function to create a new skb instead of using the 
>exsiting one, the program runs perfectly well.

I do not see a problem with just holding the skb. Maybe it is just 
that a refcount needs to be increased (skb_get).

Alternatively, skb_clone might work in pleace of skb_copy for a cheap 
operation.
