From: David Murray <30179198@student.murdoch.edu.au>
Subject: Re: Caching packets with libipq
Date: Mon, 19 Jan 2009 09:31:23 +0900
Message-ID: <4973C9DB.4060902@student.murdoch.edu.au>
References: <20090116104104.kzzlq1ol9g80cgok@wwwstudent.murdoch.edu.au> <1232090567.3789.2.camel@ice-age>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eleblond@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:25360
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753942AbZASAmK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Jan 2009 19:42:10 -0500
In-Reply-To: <1232090567.3789.2.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
>
> What about:
> 	http://www.nufw.org/doc/libnetfilter_queue/
>
> Real question: what is missing here ?
>
> BR,
>   
Thanks for the reply Eric. In my own opinion (things that could be done 
to improve that documentation:

1. Navigation seems a little cluttered. I think it would be better to 
just have a link to documentation on the first page and then a link on 
every subsequent page to page x + 1.

2. On the main page it would be nice to have a description of why 
libnetfilter_queue is better than libipq

3. The page needs to be easier to find. Why is there not a link to it on 
the netfilter site?

4. You don't specify the compile time commands that must be used with 
libnet filter -lnfnetlink -lnetfilter_queue

5. The example code you give includes a callback function. Can you write 
a libnetfilter_queue program without a call back? It might be easier for 
people without lots of c experience to modify and start doing things.

All of these suggestions might not be correct / easy to implement. It is 
just my opinion that they might improve the site.

Thanks for your time
Dave
