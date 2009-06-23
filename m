From: bcfiss@inf.ufrgs.br
Subject: Re: nf_unregister_hook problem
Date: Tue, 23 Jun 2009 18:12:12 -0300
Message-ID: <20090623181212.pnqcn6qtescwwckg@webmail.inf.ufrgs.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from puma.inf.ufrgs.br ([143.54.11.5]:61416 "EHLO puma.inf.ufrgs.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbZFWVYo convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:24:44 -0400
Received: from localhost (localhost [127.0.0.1])
	by puma.inf.ufrgs.br (Postfix) with ESMTP id 8FA6A61C84
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2009 18:12:13 -0300 (BRT)
Received: from inf.ufrgs.br (webmail.inf.ufrgs.br [143.54.11.45])
	by puma.inf.ufrgs.br (Postfix) with ESMTP id 18DE561C7C
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2009 18:12:12 -0300 (BRT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry for duplicates.

--- Em ter, 23/6/09, Jan Engelhardt <jengelh@medozas.de> escreveu:

>
> Does the problem go away if you call it indirectly? Like:
>
>
> stop_trigger.function = myfunc;
> ...
>
> myfunc(void)
> {
>     nf_unregister_hook(&nf_hook);
> }
>


Hi,

I've got a very similar question, about scheduling nf_register_hook,  
and since I'm already calling it indirectly, I think this could prove  
useful to both of us. I'd appreciate if anybody could help.

This is what I'm trying to do:

void foo () {
         unsigned long parameter;
         ...
         DEFINE_TIMER( timer, secfoo, jiffies + 250, parameter);
         ...
         add_timer(timer);
}

void secfoo( unsigned long param ) {
         ...
         nf_register_hook(...);
         ...
}

If I comment the "add_timer(timer);" and put "secfoo( parameter );"  
instead, it works out, though it doesn't help me, because I wanted to  
schedule it. The way it is, I get a kernel panic.

Good day,

Bruno Fiss

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.


