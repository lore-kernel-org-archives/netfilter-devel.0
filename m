From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 1/2] iptables (userspace): add secmark match
Date: Fri, 22 Mar 2013 18:43:42 +0000
Message-ID: <514CA65E.5030106@googlemail.com>
References: <5135E9AF.6010800@googlemail.com> <20130319233233.GA4172@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Paris <eparis@redhat.com>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Fedora SELinux Users <selinux@lists.fedoraproject.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:58445 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3CVSnz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Mar 2013 14:43:55 -0400
Received: by mail-wi0-f173.google.com with SMTP id ez12so92796wid.12
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Mar 2013 11:43:54 -0700 (PDT)
In-Reply-To: <20130319233233.GA4172@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Pablo Neira Ayuso wrote:
> On Tue, Mar 05, 2013 at 12:48:47PM +0000, Mr Dash Four wrote:
>   
>> This patch is part of the userspace changes needed for the "secmark" match
>> in iptables.
>>     
>
> SELinux already provides the framework to define your network policy
> based on the secmark. I don't see why we need this in iptables.
>   
I am not sure what to make of your response above Pablo. The purpose of 
the patch isn't to replace what SELinux already provides, but to make 
full use of that security framework. Are you questioning the purpose or 
usefulness of the patch in general? Elaborate please.
