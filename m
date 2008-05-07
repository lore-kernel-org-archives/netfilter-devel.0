From: Philip Craig <philipc@snapgear.com>
Subject: Re: How to disable Connection Tracking runtime
Date: Wed, 07 May 2008 14:04:18 +1000
Message-ID: <48212A42.3020001@snapgear.com>
References: <df1bdeb10805052038y43f41d12gf45c7f512aea759@mail.gmail.com>	 <alpine.LNX.1.10.0805060819150.11757@fbirervta.pbzchgretzou.qr>	 <df1bdeb10805062054jc1f0e4dla2979cfe9d065876@mail.gmail.com> <df1bdeb10805062054v1caa7837p54ba9710b09e0392@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Srinivas Murthy <codevana@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:59618 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750807AbYEGEEU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 May 2008 00:04:20 -0400
In-Reply-To: <df1bdeb10805062054v1caa7837p54ba9710b09e0392@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Srinivas Murthy wrote:
> Sorry I installed,
> iptables -t raw -A PREROUTING -p all -j NOTRACK

You'll need this for locally generated packets:
iptables -t raw -A INPUT -j NOTRACK

But note that these only disable conntracking.  You'll still see
ipt_do_table().

If you want to stop iptables too then you'll need to unload the various
iptables/conntrack/nat modules (there are lots of them).  Even this
doesn't quite remove it all: there are still netfilter hooks.

If they aren't built as modules then I don't think there is a solution
other than rebuilding the kernel.

