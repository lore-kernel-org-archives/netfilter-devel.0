From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_RAWNAT target idea
Date: Mon, 14 Jan 2008 07:04:37 +0100
Message-ID: <478AFB75.7040701@trash.net>
References: <Pine.LNX.4.64.0801131648010.21665@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62028 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbYANGJv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jan 2008 01:09:51 -0500
In-Reply-To: <Pine.LNX.4.64.0801131648010.21665@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> the following series implements xt_RAWNAT, a target to do network
> address translation not depending on conntrack. I still have an issue
> though, if you have an idea what could be wrong, please let me know.

Whats the advantage over using the TC NAT action?
