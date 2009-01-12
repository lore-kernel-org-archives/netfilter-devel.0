From: Patrick McHardy <kaber@trash.net>
Subject: Re: doc: escape minus sign in manpages
Date: Mon, 12 Jan 2009 07:20:56 +0100
Message-ID: <496AE148.6000909@trash.net>
References: <alpine.LSU.2.00.0901090313110.16418@fbirervta.pbzchgretzou.qr> <496A9E8A.10405@netfilter.org> <alpine.LSU.2.00.0901120339080.20867@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0901120706460.21692@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56656 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZALGU6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:20:58 -0500
In-Reply-To: <alpine.LSU.2.00.0901120706460.21692@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hm I noticed I still had something in my index that
> puts back hyphens where they belong. Here goes:
> 
> 
> parent fea74bf74ff524431ce65145f1523584edf99dc9 (v1.4.3-rc1-16-gfea74bf)
> commit de2a83cb5022c429ccf1b852688481a0d8ad95e5
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Mon Jan 12 07:06:12 2009 +0100
> 
> doc: escape minus sign in manpage (2)

Something in this patch seems to be confusing "patch":

patching file ip6tables.8.in
patching file iptables.8.in
Hunk #1 FAILED at 23.
1 out of 1 hunk FAILED -- saving rejects to file iptables.8.in.rej
missing header for unified diff at line 388 of patch
can't find file to patch at input line 388
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
| tables of IPv4 packet
--------------------------
File to patch:
Skip this patch? [y]
Skipping patch.
9 out of 9 hunks ignored
