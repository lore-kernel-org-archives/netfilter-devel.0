From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/6] Core changes for better error reporting to
 userspace.
Date: Sun, 21 Jun 2009 02:53:36 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906210252050.8096@fbirervta.pbzchgretzou.qr>
References: <alpine.DEB.2.00.0906202348470.11764@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48256 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbZFUAxe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Jun 2009 20:53:34 -0400
In-Reply-To: <alpine.DEB.2.00.0906202348470.11764@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-06-20 23:56, Jozsef Kadlecsik wrote:
> 
>+struct xt_error_entry {
>+	__u8 errcode;
>+	__u8 match;
>+	unsigned char data[0];
>+};
>+
>+#define XT_PTR_ERR	(MAX_ERRNO+1)
>+

Also, the extensions return a positive non-zero value which is, if I
paid attention correctly, passed back up to userspace unmodified. Old
iptables may not expect that anything besides {-Inf..0} at all.

