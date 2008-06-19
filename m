From: "Adelson O. Junior" <jroliv@gmail.com>
Subject: Re: NFNETLINK answers: No such file or directory
Date: Thu, 19 Jun 2008 10:50:30 -0300
Message-ID: <7b0a40830806190650g6ccacd5br3bc3c9088c73dd2c@mail.gmail.com>
References: <7b0a40830806181538s40efbd70s66aec17d5c04933@mail.gmail.com>
	 <485A3E81.5070100@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.248]:54211 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867AbYFSNud (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 09:50:33 -0400
Received: by hs-out-0708.google.com with SMTP id 4so44657hsl.5
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2008 06:50:31 -0700 (PDT)
In-Reply-To: <485A3E81.5070100@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, thanks for reply

I'm using the versions:

libnfnetlink-0.0.25-1
libnetfilter_conntrack-0.0.50-2
conntrack-1.0-0.1.beta2

We have an application Java based that uses this tools, and uses these versions.
I need to know which of this packets is causing the problem, and which
version is fixing it, before a apply new versions on the Java App.
There are any place thats show the problems fixed in each version?

Thanks again!

Adelson.

On Thu, Jun 19, 2008 at 8:09 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Adelson O. Junior wrote:
>> Hi netfiltel mail list,
>> it's my first time here.
>>
>> My question is:
>> I'm trying to delete a entry in the conntrack and an Error is shown:
>>
>> "NFNETLINK answers: No such file or directory"
>>
>> I did a "small" search on the Internet, mail list and I saw that this
>> is a bug and is already fixed.
>> Can you tell if this is true, and if is, what the version of
>> libnfnetlink, libnetfilter_conntrack or
>> conntrack packets (and witch of them have a problem) that the bug is fixed?
>
> Which version of the tools are you using? It seems to me that you're
> using a pretty old one. Please see:
>
> http://www.netfilter.org/news.html#2008-05-31
>
> --
> "Los honestos son inadaptados sociales" -- Les Luthiers
>



-- 
[]'s
