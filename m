From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 08/14] Add state option to NFLOG input plugin.
Date: Wed, 16 Apr 2008 13:39:18 +0200
Message-ID: <4805E566.7010902@netfilter.org>
References: <1206289522679-git-send-email-eric@inl.fr> <12062895233806-git-send-email-eric@inl.fr> <47F79683.8070801@netfilter.org> <20080405191512.GJ5333@bayen.regit.org> <47FAB4C4.8050908@netfilter.org> <20080410045648.GA5526@bayen.regit.org> <20080413070324.GK20469@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53984 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752063AbYDPLj0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2008 07:39:26 -0400
In-Reply-To: <20080413070324.GK20469@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> On Thursday, 2008 April 10 at  6:56:48 +0200, Eric Leblond wrote:
>> Hello,
>>
>> On Tuesday, 2008 April  8 at  1:56:52 +0200, Pablo Neira Ayuso wrote:
>>> Eric Leblond wrote:
>>>> On Saturday, 2008 April  5 at 17:10:59 +0200, Pablo Neira Ayuso wrote:
>>>>> Eric Leblond wrote:
>>>> 'decision' keyword is not really a good choice.
>>> I see, however, why isn't --nflog-prefix enough to label the logs from
>>> iptables?
>> Yes, but it forces user to define a system to be able to know if
>> decision is DROP or ACCEPT. For example, all prefix have to be labelled
>> like [DA]:$MYSTRING. Well, it works but it overload prefix which is less
>> human readable. Furthermore, it steals some bits in the prefix field
>> which is in ULOG rather small.
> 
> Not receiving a response to this mail make me thing about what I will
> need to do to have the same feature without the 'state' flag:
> 
> A standard logging packet logging table contains packet that have been
> dropped or accepted. One of the most relevant question for an
> administrator is: "Which packet have been dropped with this criteria ?".
> Thus, we need an easy and *fast* mean to differentiate dropped and
> aceepted packet. IMHO, a 'state' flag is one of the easiest and cleanest
> solution. The computation overload is really small compares to a parsing
> of the prefix. Furthermore, this approach is not disruptive with
> firewall rules generator who already have their log prefix.

I see. It makes sense. Please, could you resend this patch using 'label'
instead of 'state' which seems more to me more appropriate for this feature?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
