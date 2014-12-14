From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 1/4] datatype: missing byteorder in string_type
Date: Sun, 14 Dec 2014 19:01:10 +0100
Message-ID: <4D4832DE-212B-481E-935D-D7B1833D3549@trash.net>
References: <1418576463-3606-1-git-send-email-pablo@netfilter.org> <1418576463-3606-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49274 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbaLNSBO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Dec 2014 13:01:14 -0500
In-Reply-To: <1418576463-3606-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 14. Dezember 2014 18:01:00 MEZ, schrieb Pablo Neira Ayuso <pablo@netfilter.org>:
>nft add rule filter input iifname { "lo", "eth0" } counter
>
>Now the listing shows:
>
>	iifname { "lo", "eth0"}
>
>instead of:
>
>	iifname { "", ""}

Again wondering what broke this. Let me check when I am at home, IIRC we have some check for strings somewhere in the netlink code that relies in this.

>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>---
> src/datatype.c |    1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/src/datatype.c b/src/datatype.c
>index 4519d87..7f73077 100644
>--- a/src/datatype.c
>+++ b/src/datatype.c
>@@ -324,6 +324,7 @@ const struct datatype string_type = {
> 	.type		= TYPE_STRING,
> 	.name		= "string",
> 	.desc		= "string",
>+	.byteorder	= BYTEORDER_HOST_ENDIAN,
> 	.print		= string_type_print,
> 	.parse		= string_type_parse,
> };


