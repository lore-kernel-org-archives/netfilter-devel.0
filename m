From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: xt_AUDIT additions
Date: Fri, 01 Jul 2011 12:31:52 +0100
Message-ID: <4E0DB027.3000309@googlemail.com>
References: <4E0CFBF2.9000500@googlemail.com> <alpine.LNX.2.01.1107011005060.7813@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, hch@infradead.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42222 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab1GALcB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2011 07:32:01 -0400
Received: by wwe5 with SMTP id 5so3148025wwe.1
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Jul 2011 04:32:00 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1107011005060.7813@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> xt_owner did the same - it scanned the process table. According to 
> Christoph Hellwig, this was declared as some gross abuse, and, IIRC, the 
> reason was something like the tasklist lock was held "quite long" (which 
> makes sense).
Yep, it is the reason I was very reluctant to use this approach and seek 
to find another, more "efficient" way.

> However, xt_owner did not held the tasklist [write] lock, 
> just entered a RCU read section. hch: Was this RCU section also too 
> long?
>
> xt_owner had the bonus that it only had to check whether the socket was 
> owned by a particular user/group/pid/sid, which means it can stop 
> looping the tasklist as soon as it found a match.
>   
I'll have a look at the xt_owner code later to see if there is something 
I could use/learn.

> But with xt_AUDIT, you would have to traverse the entire list, because 
> you would want to find all PIDs - since a socket may be shared between 
> multiple threads/processes - which in itself may generate a huge list 
> (=another problem) in the audit records.
>   
Isn't there a more efficient solution to this? The thought of scanning 
the task list to find ids for a single packet makes my head hurt!

> Also, the PID owner may not be the socket owner for the same reason.
>   
That's where auid comes in - it determines, unequivocally, the "root" 
process owner.

For example: if I log in as root and start a process, which then uses 
another id (say process squid using user id _squid), which spawns 
further processes under the same id, the "normal" uid (i.e. the 
information of the socket "owner") is probably going to show me uid = 
_squid, but the auid will show "root" as this is the "root" session 
which started all sub-processes and I suspect was one of the reasons 
auid was introduced in the first place - to remove this ambiguity.
