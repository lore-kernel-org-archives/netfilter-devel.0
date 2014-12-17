From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] add systemd service file
Date: Wed, 17 Dec 2014 21:55:55 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1412172155030.32713@nerf08.vanv.qr>
References: <20141217205407.06558f65@turingmachine> <20141217214032.569fbfac@turingmachine>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?J=C3=B6rg_Thalheim?= <joerg@higgsboson.tk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:37137 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbaLQUz4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2014 15:55:56 -0500
In-Reply-To: <20141217214032.569fbfac@turingmachine>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2014-12-17 21:40, J=C3=B6rg Thalheim wrote:
>
>Instead of storing all rules in a single file (/etc/nftables.conf), it
>applys all files ending with .rules from directory /etc/nftables/ in
>lexical order, which make it more useful for configuration management
>like chef/puppet/ansible, where generating a single file from multiple
>modules is a pain.

But it means there will be a time where only half of the ruleset is
loaded.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
