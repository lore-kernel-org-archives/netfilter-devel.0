From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Bugme-new] [Bug 9920] New: kernel panic when using ebtables
 redirect target
Date: Tue, 19 Feb 2008 12:56:29 +0100
Message-ID: <47BAC3ED.1030101@trash.net>
References: <bug-9920-10286@http.bugzilla.kernel.org/>	<20080208175942.a8b495ac.akpm@kernel.org>	<20080219025324.GA27084@ehus.geninetworks.com> <20080218.205317.62981417.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: joonwpark81@gmail.com, akpm@kernel.org,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	bugme-daemon@bugzilla.kernel.org, mingching.tiew@redtone.com
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:52565 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751785AbYBSL4p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:56:45 -0500
In-Reply-To: <20080218.205317.62981417.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller wrote:
> From: Joonwoo Park <joonwpark81@gmail.com>
> Date: Tue, 19 Feb 2008 11:53:24 +0900
> 
>> [PATCH] netfilter: fix incorrect use of skb_make_writable
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=9920
>> The function skb_make_writable returns true or false.
>>
>> Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
> 
> I'll let Patrick pull this in, thanks!


Applied, thanks.
