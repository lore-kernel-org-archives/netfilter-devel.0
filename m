From: gmoliveira@inf.ufrgs.br
Subject: nf_unregister_hook problem
Date: Tue, 23 Jun 2009 15:47:05 -0300
Message-ID: <20090623154705.pm2z8cfi6oc4w0ow@webmail.inf.ufrgs.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from puma.inf.ufrgs.br ([143.54.11.5]:58262 "EHLO puma.inf.ufrgs.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZFWS7n convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:59:43 -0400
Received: from localhost (localhost [127.0.0.1])
	by puma.inf.ufrgs.br (Postfix) with ESMTP id 572CF61C7C
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2009 15:47:08 -0300 (BRT)
Received: from inf.ufrgs.br (webmail.inf.ufrgs.br [143.54.11.45])
	by puma.inf.ufrgs.br (Postfix) with ESMTP id 86E0661C6B
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2009 15:47:05 -0300 (BRT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi all,

im trying to develop a software to emulate network partitioning to  
evaluate distributed applications. in the code i need to specify some  
temporal triggers like:

init_timer(&foo);
start_trigger.function = some_function;
start_trigger.data = arguments;
start_trigger.expires = jiffies + msecs_to_jiffies(HZ * 1000);
add_timer(&foo);

im using it to register a netfilter hook and it works perfectly.  
however, when i need to set up a trigger do unregister the netfilter  
hook, the system gets itself slow, dmesg returns lots of information  
about BUG SCHEDULING and stuff like that.

im using this:

init_timer(&foo2);
stop_trigger.function = nf_unregister_hook;
stop_trigger.data = &nf_hook;
stop_trigger.expires = jiffies + msecs_to_jiffies(HZ * 5000);
add_timer(&foo2);

it works to every function until now, unless nf_unregister_hook.

best regards,
Gustavo.

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.


