From: John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH] More secure SYSRQ for xtables-addons
Date: Mon, 01 Dec 2008 22:02:12 +0000
Message-ID: <49345EE4.3070409@oracle.com>
References: <492E926D.5020807@oracle.com> <alpine.LNX.1.10.0812011952520.17726@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:51301 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbYLAWCW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 17:02:22 -0500
In-Reply-To: <alpine.LNX.1.10.0812011952520.17726@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2008-11-27 13:28, John Haxby wrote:
>
>   
>> Hello All,
>>
>> This is a patch to the SYSRQ xtables-addon that is, I believe, secure enough to
>> use in moderately untrustworthy environments.
>>     
>
> Finally - I wondered when someone will augment it with some crypto
> magic :p
>
> What I did not like with the original ipt_SYSRQ is that it used its
> own copy of the SHA algorithm - while being well aware that
> ipt_SYSRQ's root, if I remember correctly, dates to the time where
> in-kernel crypto did not exist yet.
>
>   
I didn't like that much either: the reason given was that it didn't want 
to rely on kernel resources but that's quite a weak reason for including 
its own sha-1.  On the other hand, for kernels where there isn't an 
sha-1 available that does make sense.
>> Ideally the iptables rules for SYSRQ would include a minimum time
>> between requests to avoid the worst effects of sysrq-request
>> bombing, although I haven't mentioned that in the updated man page
>> (mostly because I'm not sure how to do it).
>>     
>
> -p udp --dport discard -m limit --limit 5/minute -j SYSRQ ...
>
>   
Thanks, I'll work that into the man page.
>> .IP
>> -echo -n "password" >/sys/.../password
>> +echo "password" >/sys/module/xt_SYSRQ/parameters/password
>> .PP
>>     
>
> I think we should not rely on \n being there. Checking for \0
> should also catch the echo -n (or open from a perl/c program) case:
>
>   
>> +	for (i = 0; sysrq_password[i]; i++)
>> +		if (sysrq_password[i] == '\n')
>>     
> 		|| sysrq_password[i] == '\0'
>
> (assuming that echoing into string module parameters at least adds a \0)
>
>   
I think it does this anyway doesn't it?   The "sysrq_password[i]" loop 
test stops at the '\0' and the "if (sysrq_password[i] == '\n') break" 
breaks out early if there's a '\n' in the string.  The next assignment 
either overwrites the trailing '\0' with another one or null-terminates 
the string at the first LF.
>> +	sg_init_table(sg, 2);
>> +	sg_set_buf(&sg[0], data, n);
>> +	strcpy(digest_password, sysrq_password);
>> +	i = strlen(digest_password);
>> +	sg_set_buf(&sg[1], digest_password, i);
>>     
>
> Could we directly use sysrq_password instead of copying it
> to digest_password first?
>
>   
No :-)   Eventually I discovered the reason my code wasn't working boils 
down to the definition of sg_set_buf:

    sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf))

which doesn't work for sysrq_password.   I don't know why I'll double check.
>> +	for (i = 0; i < len && data[i] != ','; i++) {
>> +		printk(KERN_INFO KBUILD_MODNAME ": SysRq %c\n", data[i]);
>> #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
>> -	handle_sysrq(c, NULL);
>> +		handle_sysrq(data[i], NULL);
>> #else
>> -	handle_sysrq(c, NULL, NULL);
>> +		handle_sysrq(data[i], NULL, NULL);
>> #endif
>> +	}
>>     
>
> I see you handle multiple sysrq requests in one packet. This should be 
> reflected in the manual/comments (e.g. <keys> instead of <key>).
>
>   
Yes.

> Care to fix it up? This looks good :)
>   

Yes.

Thanks again.

jch
