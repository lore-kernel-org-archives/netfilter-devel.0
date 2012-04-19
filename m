From: Rick Jones <rick.jones2@hp.com>
Subject: Re: concatenate udp payloads of multiple packet
Date: Thu, 19 Apr 2012 11:11:39 -0700
Message-ID: <4F90555B.7070306@hp.com>
References: <CAGuaRCt0Jmj4_prCZVvXi2oijOTprTqUntphjx_9cQqk-nqhCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Arif Hossain <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:26621 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2DSSLk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:11:40 -0400
In-Reply-To: <CAGuaRCt0Jmj4_prCZVvXi2oijOTprTqUntphjx_9cQqk-nqhCQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04/19/2012 07:32 AM, Arif Hossain wrote:
> Thirdly I need to concatenate udp payloads of several packet to
> improve bandwidth usage. how should i approach this?

It isn't clear you can.  An application using UDP is expecting message 
boundaries to be preserved.  That is a fundamental part of the semantics 
of UDP.  So if an application has sent three, 128 byte messages via UDP, 
the receiving side is expecting to receive three, 128 byte messages, not 
one 384 byte message.  If the receiver can indeed deal with just one, 
384 byte message, that is what the sending side should have sent in the 
first place.

rick jones
