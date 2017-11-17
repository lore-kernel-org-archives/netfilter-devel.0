From: Jason Hendry <jhendry@mintel.com>
Subject: Re: conntracd init.d reload is broken on Centos6
Date: Fri, 17 Nov 2017 22:55:03 +0000
Message-ID: <CAPyb0YcE2FXgvL0HFBVj9gHK7T4jqtvqEpquQNf2y9+QEdwSvQ@mail.gmail.com>
References: <CAPyb0YcPtkruBLSVfxBnU1jrkL_5PgCxLvN56pMgexPHx=RZrQ@mail.gmail.com>
 <20171116132528.GA2159@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:43613 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936951AbdKQWze (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Nov 2017 17:55:34 -0500
Received: by mail-vk0-f51.google.com with SMTP id p80so2585702vkd.10
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Nov 2017 14:55:34 -0800 (PST)
In-Reply-To: <20171116132528.GA2159@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Turns out sending conntrackd a -HUP signal causes it to die. I can not
find any documentation/reference on what signals conntrackd accepts,
is there one to tell it to reload its config?  We are running
conntrackd 0.9.14

Can you also clarify the effect of restarting conntrackd, is it a safe
operation to do? Will it cause any interruption to connections? Will
it re-sync with the kernel state table? Will it re-sync with its peer?

Jason H
Senior Systems Administrator
+44 (0)203 416 4316


On 16 November 2017 at 13:25, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Nov 16, 2017 at 10:47:15AM +0000, Jason Hendry wrote:
>> Hi,
>>
>> Was not sure where to send this so hoping this is the right place.  We
>> am running Centos6 with conntrack-tools.  The reload option to the
>> conntrackd init.d script does not work due to a syntax error on the
>> killproc init function.
> [...]
>> Index: conntrackd
>> ===================================================================
>> --- conntrackd   (revision 46829)
>> +++ conntrackd   (working copy)
>> @@ -85,7 +85,7 @@
>>  # XXX: can conntrackd reload?
>>  reload() {
>>          echo -n $"Reloading $prog configuration: "
>> -        killproc -HUP $prog
>> +        killproc $prog -HUP
>>          retval=$?
>>          echo
>>          return $retval
>>
>>
>> If you prefer this be submitted somewhere else or in a different
>> format I am happy to do so.
>
> I think you have to send this to the CentOS people, I don't see such
> script on our git tree.
>
> Thanks.

-- 

Mintel Group Ltd | 11 Pilgrim Street | London | EC4V 6RN
Registered in England: Number 1475918. | VAT Number: GB 232 9342 72

Contact details for our other offices can be found at 
http://www.mintel.com/office-locations.

This email and any attachments may include content that is confidential, 
privileged 
or otherwise protected under applicable law. Unauthorised disclosure, 
copying, distribution 
or use of the contents is prohibited and may be unlawful. If you have 
received this email in error,
including without appropriate authorisation, then please reply to the 
sender about the error 
and delete this email and any attachments.

