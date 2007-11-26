From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCHv5 1/2] Find address type on a specific or on any interface
Date: Mon, 26 Nov 2007 08:53:22 +0100
Message-ID: <474A7B72.8040105@trash.net>
References: <11955456442652-git-send-email-panther@balabit.hu> <11955456451525-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48321 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbXKZHyM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 02:54:12 -0500
In-Reply-To: <11955456451525-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Laszlo Attila Toth wrote:
> Address type search can be limited to an interface by
> inet_dev_addr_type function.


Applied with some minor fixups:

- fix lines over 80 characters
- use "unsigned int" instead of just "unsigned"
- reorder dev and addr arguments to inet_dev_addr_type since
   that matches the function name

