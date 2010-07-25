From: Karl Hiramoto <karl@hiramoto.org>
Subject: Re: [RFC 0/4] nfnetlink_queue bypass queue to userspace X bytes of
 connection
Date: Sun, 25 Jul 2010 08:55:40 +0200
Message-ID: <4C4BDFEC.4080600@hiramoto.org>
References: <1279986285-11665-1-git-send-email-karl@hiramoto.org> <4C4B305F.2070005@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from caiajhbdcbhh.dreamhost.com ([208.97.132.177]:51848 "EHLO
	homiemail-a35.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750893Ab0GYGzy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Jul 2010 02:55:54 -0400
In-Reply-To: <4C4B305F.2070005@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 On 07/24/2010 08:26 PM, Pablo Neira Ayuso wrote:
> On 24/07/10 17:44, Karl Hiramoto wrote:
>> Hi, I'm working on a nf_queue based HTTP filter. Sometimes I want to
>> NF_ACCEPT X bytes of a connection. In a HTTP connection its part of the
>> Content-Length.  Being able to directly NF_ACCEPT large parts of a connection
>> is a 2X to 3X speedup, by not queuing these packets to user-space.
> I think that you could avoid this extensions by means of conntrack marks
> and the string match. Could you elaborate your application, please?
I thought about that before i made the extension but there's no way, to do it reliably and avoid race conditions.  string matches are also really inefficient, with string matches every packet with a certain mark would be scanned, but its not necessary since in HTTP because you know which part of the message you want to scan, but it changes on every request/response.

It's  a HTTP 1.1 filter, so it has to support persistent connections, multiple requests per connection.  There is the possibility that some requests are allowed and others are not.   Using connmark its posible to allow an entire connection to NF_ACCEPT bypassing the queue, however not really possible when there are multiple requests per connection.

Some of the features of my app are:
* Filter Accept/block  by URL, or HTTP "Host:" tag
* Log all request/responses,   URL, content length, time duration of request / response.
* Parts of a HTTP 1.1 persistent connection can be rejected, other parts accepted.


--
Karl Hiramoto

