From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Caching packets with libipq
Date: Mon, 19 Jan 2009 01:47:31 +0100
Message-ID: <4973CDA3.1050408@netfilter.org>
References: <20090116104104.kzzlq1ol9g80cgok@wwwstudent.murdoch.edu.au> <1232090567.3789.2.camel@ice-age> <4973C9DB.4060902@student.murdoch.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eleblond@inl.fr>, netfilter-devel@vger.kernel.org
To: David Murray <30179198@student.murdoch.edu.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56180 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755031AbZASArq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Jan 2009 19:47:46 -0500
In-Reply-To: <4973C9DB.4060902@student.murdoch.edu.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Murray wrote:
> Eric Leblond wrote:
>>
>> What about:
>>     http://www.nufw.org/doc/libnetfilter_queue/
>>
>> Real question: what is missing here ?
>>
>> BR,
>>   
> Thanks for the reply Eric. In my own opinion (things that could be done
> to improve that documentation:
> 
> 1. Navigation seems a little cluttered. I think it would be better to
> just have a link to documentation on the first page and then a link on
> every subsequent page to page x + 1.
> 
> 2. On the main page it would be nice to have a description of why
> libnetfilter_queue is better than libipq
> 
> 3. The page needs to be easier to find. Why is there not a link to it on
> the netfilter site?

There will be one soon, I have no time to upload it. The patch to
convert documentation barely hit the git tree weeks ago. There was no
documentation months ago, so we're getting better in this field ;)

> 4. You don't specify the compile time commands that must be used with
> libnet filter -lnfnetlink -lnetfilter_queue
> 
> 5. The example code you give includes a callback function. Can you write
> a libnetfilter_queue program without a call back? It might be easier for
> people without lots of c experience to modify and start doing things.

IIRC nfq_handle_packet uses that callback internally.

> All of these suggestions might not be correct / easy to implement. It is
> just my opinion that they might improve the site.

They are welcome.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
