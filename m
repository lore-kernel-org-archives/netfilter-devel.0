From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables 1,4,1 install error
Date: Thu, 12 Jun 2008 12:11:29 +0200
Message-ID: <4850F651.9080904@trash.net>
References: <66c5208e0806112212o47bc2c54l87be5d49b4548834@mail.gmail.com> <alpine.LNX.1.10.0806120842340.23098@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: michael <mteicher@gmail.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35393 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbYFLKLe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:11:34 -0400
In-Reply-To: <alpine.LNX.1.10.0806120842340.23098@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> build: fix `make install` when --disable-shared is used
> 
> When --disable-shared is used, there are no .so files to install, and
> the argument order for install would get messed up.
> 
> Reported-by: Michael Teicher <mteicher@gmail.com>
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

Applied, thanks.
