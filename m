From: Patrick McHardy <kaber@trash.net>
Subject: Re: cups slow on linux-2.6.24
Date: Fri, 01 Feb 2008 07:10:09 +0100
Message-ID: <47A2B7C1.7070505@trash.net>
References: <Pine.LNX.4.64.0801311136540.23769@blackhole.kfki.hu>	<47A21945.2050005@trash.net>	<47A26C12.9020801@davidnewall.com> <20080131.181209.193710785.davem@davemloft.net> <47A2B71A.4090203@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, kadlec@blackhole.kfki.hu,
	jeff.chua.linux@gmail.com, linux-kernel@vger.kernel.org,
	ole@ans.pl, cups-bugs@easysw.com, netfilter-devel@vger.kernel.org
To: David Newall <davidn@davidnewall.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37831 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYBAGKQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 01:10:16 -0500
In-Reply-To: <47A2B71A.4090203@davidnewall.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Newall wrote:
> I'm not debating that checksums are wrong. The question was how and
> where? It's not as if there are any unreliable communication paths in a
> loopback interface, so it's surprising that they could be wrong. How? Where?
> 

As I said, loopback doesn't perform full checksum calculation.
Its simply an optimization, nothing to worry about ...

