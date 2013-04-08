From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 1/2] iptables (userspace): add secmark match
Date: Mon, 08 Apr 2013 03:32:24 +0100
Message-ID: <51622C38.60109@googlemail.com>
References: <5135E9AF.6010800@googlemail.com> <20130319233233.GA4172@localhost> <514CA65E.5030106@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Paris <eparis@redhat.com>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Fedora SELinux Users <selinux@lists.fedoraproject.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:55218 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759239Ab3DHCcc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Apr 2013 22:32:32 -0400
Received: by mail-wg0-f52.google.com with SMTP id n12so5427739wgh.7
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Apr 2013 19:32:31 -0700 (PDT)
In-Reply-To: <514CA65E.5030106@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Mr Dash Four wrote:
>
>
> Pablo Neira Ayuso wrote:
>> On Tue, Mar 05, 2013 at 12:48:47PM +0000, Mr Dash Four wrote:
>>  
>>> This patch is part of the userspace changes needed for the "secmark" 
>>> match
>>> in iptables.
>>>     
>>
>> SELinux already provides the framework to define your network policy
>> based on the secmark. I don't see why we need this in iptables.
>>   
> I am not sure what to make of your response above Pablo. The purpose 
> of the patch isn't to replace what SELinux already provides, but to 
> make full use of that security framework. Are you questioning the 
> purpose or usefulness of the patch in general? Elaborate please.
So?
