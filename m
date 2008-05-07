From: Philip Craig <philipc@snapgear.com>
Subject: Re: How to disable Connection Tracking runtime
Date: Wed, 07 May 2008 14:05:35 +1000
Message-ID: <48212A8F.6000102@snapgear.com>
References: <df1bdeb10805052038y43f41d12gf45c7f512aea759@mail.gmail.com>	 <alpine.LNX.1.10.0805060819150.11757@fbirervta.pbzchgretzou.qr>	 <df1bdeb10805062054jc1f0e4dla2979cfe9d065876@mail.gmail.com> <df1bdeb10805062054v1caa7837p54ba9710b09e0392@mail.gmail.com> <48212A42.3020001@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Srinivas Murthy <codevana@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:59735 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752671AbYEGEFg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 May 2008 00:05:36 -0400
In-Reply-To: <48212A42.3020001@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Philip Craig wrote:
> You'll need this for locally generated packets:
> iptables -t raw -A INPUT -j NOTRACK

Sorry:
iptables -t raw -A OUTPUT -j NOTRACK

