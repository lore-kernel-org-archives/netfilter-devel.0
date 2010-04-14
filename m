From: Ali Hamidi <ali.hamidi759@gmail.com>
Subject: Re: Packet Injection within netfilter module
Date: Wed, 14 Apr 2010 19:27:23 +0430
Message-ID: <h2v6a3fa21004140757y68bb686g5f0a122b80df922@mail.gmail.com>
References: <m2v6a3fa21004130113tbb35e00cp788616f0ae22a591@mail.gmail.com>
	 <n2r8363055a1004130947r17b18e9dgf33b38f8648b3f82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Justin Yaple <yaplej@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:63842 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab0DNO50 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:57:26 -0400
Received: by mail-bw0-f225.google.com with SMTP id 25so267204bwz.28
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Apr 2010 07:57:25 -0700 (PDT)
In-Reply-To: <n2r8363055a1004130947r17b18e9dgf33b38f8648b3f82@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear Justin,
I just want to thank you for you good reply. Your code saved my life
in a school project. It is well-written and I learned many things from
it, because I am a newbie in netfilter kernel modules programming. Any
way Thanks again for your reply. You gave me new hope to continue.

On 4/13/10, Justin Yaple <yaplej@gmail.com> wrote:
> Ali,
>
> Are you sending this copied packet somewhere else?  If your goal is
> just to modify the skb why make a copy before you modify it?  I have
> written a kernel module that can compress/decompresses TCP payloads
> for traffic between any number of hosts if the traffic is routed
> through two systems running my module.  If you want to download the
> source you can get it from
> http://packetsqueezer.portal.codespaces.com.
>
> To send a new skb though you can do this.  It assumes all the required
> fields are already populated correctly.
> NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, skb, NULL, skb->dst->dev,
> dst_output); // Sent the packet.
>
>
> On Tue, Apr 13, 2010 at 1:13 AM, Ali Hamidi <ali.hamidi759@gmail.com> wrote:
>> Is there any way to inject a newly created packet based on the
>> captured packet inside a netfilter hook call back function?
>> My Goal is to capture a packet change compress its tcp payload and
>> send it. i read ipcomp.c and i used its source. when i change skb size
>> (like len) and tail pointer kernel hangs. maybe the way to do, is to
>> create a new packet based on captured packet and ask kernel to send
>> it. I just don't know how to ask kernel to send a newly created
>> packet?
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
