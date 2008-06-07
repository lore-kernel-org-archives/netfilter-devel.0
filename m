From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Bug 10875] Oops in nf_nat_setup_info
Date: Sat, 07 Jun 2008 15:54:11 +0200
Message-ID: <484A9303.5030407@trash.net>
References: <Pine.LNX.4.64.0806061931140.12641@bizon.gios.gov.pl> <Pine.LNX.4.64.0806070046360.12641@bizon.gios.gov.pl> <484A788C.3000205@trash.net> <484A798C.6000608@trash.net> <Pine.LNX.4.64.0806071540490.14796@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45426 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbYFGNyQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Jun 2008 09:54:16 -0400
In-Reply-To: <Pine.LNX.4.64.0806071540490.14796@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
> On Sat, 7 Jun 2008, Patrick McHardy wrote:
>> In case its not, does that kernel include commit 86577c661?
> 
> No, it does not but unfortunately this fix does not solve the crash. 
> However, before you spend too much time on this I'll check 2.6.25.6 and 
> 2.6.26-rc to make sure this problem has not been solved already.

Thanks, please let me know how it turns out.
