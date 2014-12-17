From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] add systemd service file
Date: Wed, 17 Dec 2014 21:55:00 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1412172152440.32713@nerf08.vanv.qr>
References: <20141217205407.06558f65@turingmachine>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?J=C3=B6rg_Thalheim?= <joerg@higgsboson.tk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:37133 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaLQUzC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2014 15:55:02 -0500
In-Reply-To: <20141217205407.06558f65@turingmachine>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2014-12-17 20:54, J=C3=B6rg Thalheim wrote:
>+
>+nft_clear_table() {
>+	@sbindir@nft flush table "$1" "$2"
>+	@sbindir@nft list table "$1" "$2" \
>+		| awk '/^[ \t]+chain/{ print $2 }' \
>+		| xargs -r -L 1 @sbindir@nft delete chain "$1" "$2"
>+	@sbindir@nft list sets "$1" "$2" \
>+		| awk '/^[ \t]+set/{ print $2 }' \
>+		| xargs -r -L 1 @sbindir@nft delete set "$1" "$2"
>+}

Loading an empty ruleset would be a lot better (and likely faster too) =
-
iptables was able to do that.

>+nft_delete_table() {
>+	nft_clear_table "$1" "$2"
>+	if @sbindir@nft list table "$1" "$2" > /dev/null
>+	then
>+		@sbindir@nft delete table "$1" "$2"
>+	fi
>+}

This too should perhaps become some single step in some way.


>+nft_clear_protocol() {
>+	for T in $(@sbindir@nft list tables "$1" | cut -d ' ' -f 2)
>+	do
>+		nft_delete_table "$1" "$T"
>+	done
>+}

as should this.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
