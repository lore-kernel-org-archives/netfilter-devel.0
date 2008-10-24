From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: netfilter 00/03: netfilter -stable fixes
Date: Fri, 24 Oct 2008 02:31:13 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0810240229550.4386@bizon.gios.gov.pl>
References: <20081022174126.21341.38231.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-1847519921-1224808274=:4386"
Cc: stable@kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([195.187.34.71]:44736 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYJXAbd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 20:31:33 -0400
In-Reply-To: <20081022174126.21341.38231.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-1847519921-1224808274=:4386
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Wed, 22 Oct 2008, Patrick McHardy wrote:

> The following three patches for -stable fix some netfilter issues:
>
> - a regression in the iprange match, causing mismatches with inversion
> - a memory leak in the SNMP NAT helper
> - a lost #ifdef, allowing user-triggerable WARN_ONs with NETFILTER_DEBUG
>  (and some minor runtime misbehaviour)

Which kernels need above patches? Only 2.6.27 or also 2.6.25/2.6.26?

Best regards,

 			Krzysztof Olêdzki
---1144830174-1847519921-1224808274=:4386--
