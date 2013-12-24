From: Ed W <lists@wildgooses.com>
Subject: Re: [PATCHv2] iptables: link against libnetfilter_conntrack
Date: Tue, 24 Dec 2013 16:00:49 +0000
Message-ID: <52B9AFB1.5070903@wildgooses.com>
References: <1376411824-22311-1-git-send-email-gustavo@zacarias.com.ar> <alpine.LSU.2.10.9.1308132051420.22862@nerf07.vanv.qr> <20130823200346.GC5311@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>, Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:53102 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab3LXQKz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Dec 2013 11:10:55 -0500
In-Reply-To: <20130823200346.GC5311@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23/08/2013 21:03, Florian Westphal wrote:
> Jan Engelhardt <jengelh@inai.de> wrote:
>> On Tuesday 2013-08-13 18:37, Gustavo Zacarias wrote:
>>> diff --git a/iptables/Makefile.am b/iptables/Makefile.am
>>> index a4246eb..6390b7c 100644
>>> --- a/iptables/Makefile.am
>>> +++ b/iptables/Makefile.am
>>> @@ -21,6 +21,9 @@ xtables_multi_SOURCES += ip6tables-save.c ip6tables-restore.c \
>>> xtables_multi_CFLAGS  += -DENABLE_IPV6
>>> xtables_multi_LDADD   += ../libiptc/libip6tc.la ../extensions/libext6.a
>>> endif
>>> +if HAVE_LIBNETFILTER_CONNTRACK
>>> +xtables_multi_LDADD += @libnetfilter_conntrack_LIBS@
>>> +endif
>>> xtables_multi_SOURCES += xshared.c
>>> xtables_multi_LDADD   += ../libxtables/libxtables.la -lm
>> The righteous patch would be something like the following.
> [..]
>
> Applied to stable-1.4.20, thanks everyone.

I don't see this patch in release 1.4.21 ?  Can you please confirm (and 
pull code to master if necessary)

Thanks

Ed W

