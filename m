From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ip6tables formatting problem
Date: Tue, 19 Feb 2008 16:11:12 +0100
Message-ID: <47BAF190.1050408@trash.net>
References: <20080206005132.GD7357@lupin.strandboge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jamie Strandboge <jamie@strandboge.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:9331 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbYBSPLb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:11:31 -0500
In-Reply-To: <20080206005132.GD7357@lupin.strandboge.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jamie Strandboge wrote:
> I am sending this here as bugzilla.netfilter.org is down. I am not
> subscribed to the list, so please CC me on replies.
> 
> ip6tables improperly displays the destination address when the address
> is longer than 18 characters.  Here is example output:
> # ip6tables -L -n
> ...
> DROP       tcp      2001:db8::/32        2001:db8:3:4:5:6:7:8/128tcp spt:25
> ...
> 
> Proper formatting should have a space between '2001:db8:3:4:5:6:7:8/128'
> and 'tcp'.


Thanks, but this doesn't apply to the current version. Could you
send a patch against SVN (or a daily snapshot) please?
