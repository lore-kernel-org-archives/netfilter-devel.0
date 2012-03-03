From: Kerin Millar <kerframil@gmail.com>
Subject: Re: scheduling while atomic followed by oops upon conntrackd -c execution
Date: Sat, 03 Mar 2012 18:47:27 +0000
Message-ID: <jitp0d$4lv$1@dough.gmane.org>
References: <4F50E30B.6000704@gmail.com> <20120303133002.GA18802@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51452 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab2CCSsA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Mar 2012 13:48:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1S3tzl-0002aM-Cc
	for netfilter-devel@vger.kernel.org; Sat, 03 Mar 2012 19:47:53 +0100
Received: from cpc2-enfi16-2-0-cust659.hari.cable.virginmedia.com ([94.170.82.148])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 03 Mar 2012 19:47:53 +0100
Received: from kerframil by cpc2-enfi16-2-0-cust659.hari.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 03 Mar 2012 19:47:53 +0100
In-Reply-To: <20120303133002.GA18802@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On 03/03/2012 13:30, Pablo Neira Ayuso wrote:
> I just posted another patch to the ML that is a relative fix to
> Jozsef's patch. You have to apply that as well.

I've now tested 3.3-rc5 with the addition of the above mentioned 
follow-on patch. The behaviour during conntrackd -c execution is clearly 
much improved - in so far as it doesn't generate much noise - but the 
crash that follows remains. Here's a netconsole capture:-

http://paste.pocoo.org/raw/560439/

Cheers,

--Kerin

