From: Mike Wright <nobody@nospam.hostisimo.com>
Subject: Re: ipset website
Date: Sat, 29 Nov 2014 09:29:27 -0800
Message-ID: <547A0277.3040301@nospam.hostisimo.com>
References: <547919CB.7030202@nospam.hostisimo.com> <alpine.LSU.2.11.1411290212430.31411@nerf08.vanv.qr> <547946BA.106@nospam.hostisimo.com> <alpine.LSU.2.11.1411291212290.5728@nerf08.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from theorb.net ([204.11.228.190]:39623 "HELO b.mx.theorb.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751605AbaK2R3Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Nov 2014 12:29:24 -0500
In-Reply-To: <alpine.LSU.2.11.1411291212290.5728@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On 11/29/2014 03:33 AM, Jan Engelhardt wrote:
>
>> Those solutions won't work.  The scroll bar is added to the page by the
>> browser, outside of the body, which causes the body width to narrow
>
> "overflow-y: scroll" though is better-suited than "height: 100.1%",
> and according to http://stackoverflow.com/a/7607206 , should be on
> the html object, not body.
>
Much better solution.  Done.

Ready for review.

site: http://ipset.hostisimo.com
diff: http://ipset.hostisimo.com/diff
bzip: http://ipset.hostisimo.com/ipset.netfilter.org.tar.bz2

Does anybody else have any comments?

If not, please push the new site to the server.

Mike Wright
