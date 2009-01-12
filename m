From: "Giant Sand Fan's" <rampxxxx@gmail.com>
Subject: Re: ip_route_me_harder question
Date: Mon, 12 Jan 2009 10:43:21 +0100
Message-ID: <417f50830901120143t1ad797d6m98fa519b5be7a8e7@mail.gmail.com>
References: <417f50830901070919u7c90ac16x5771bece809568e4@mail.gmail.com>
	 <496AD28B.5070300@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:1837 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZALJnX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 04:43:23 -0500
Received: by mu-out-0910.google.com with SMTP id g7so4211805muf.1
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2009 01:43:21 -0800 (PST)
In-Reply-To: <496AD28B.5070300@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks, yes, i had check the sk_buff->entry in prerouting and post and
saw how it changes.

I understand that only had to call ip_route_me_harder in a hook
handler after a "routing block" if you have change the ip addresses.

2009/1/12 Patrick McHardy <kaber@trash.net>:
> Giant Sand Fan's wrote:
>>
>> Hi,
>>
>> I have a netfilter module that needs to reroute a packet after
>> unpacking it (minimal encap) in NF_IP_PRE_ROUTING, because the dst
>> changes. But even when a ip_route_me_harder with RTN_LOCAL works
>> (ret==0) the packet disappears.
>>
>> The question is , do i need to use ip_route_me_harder? because when
>> the dst of encapsulated packet is the local machine it works.
>
> You don't need rerouting in *PRE*ROUTING, regular routing will
> take care of this.
>



-- 
Please avoid sending me Word or PowerPoint attachments.
See http://www.gnu.org/philosophy/no-word-attachments.html
