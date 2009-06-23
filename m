From: gmoliveira@inf.ufrgs.br
Subject: Re: nf_unregister_hook problem
Date: Tue, 23 Jun 2009 19:45:37 -0300
Message-ID: <20090623194537.9bqme9ugkkwg4wcw@webmail.inf.ufrgs.br>
References: <20090623154705.pm2z8cfi6oc4w0ow@webmail.inf.ufrgs.br>
	<alpine.LSU.2.00.0906232147280.32190@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from puma.inf.ufrgs.br ([143.54.11.5]:61466 "EHLO puma.inf.ufrgs.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757914AbZFWWph convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:45:37 -0400
In-Reply-To: <alpine.LSU.2.00.0906232147280.32190@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan, thanks for your attention..
yes, i've already tried this way you said but the problem remains the same.
declaring nf_unregister_hook(&nf_hook) in __module_exit function worked well,
but requires user intervention. The problem consists in unregister the  
hook by timers...misunderstandable.

here goes and print screen with the "infinite loop error"
when occurs the BUG caused by nf_unregister_hook handled by a timer.

http://inf.ufrgs.br/~gmoliveira/screen.png

if anyone had a similar problem, pleasa contact me.

Citando Jan Engelhardt <jengelh@medozas.de>:

>
> On Tuesday 2009-06-23 20:47, gmoliveira@inf.ufrgs.br wrote:
>>
>> im using this:
>>
>> init_timer(&foo2);
>> stop_trigger.function = nf_unregister_hook;
>> stop_trigger.data = &nf_hook;
>> stop_trigger.expires = jiffies + msecs_to_jiffies(HZ * 5000);
>> add_timer(&foo2);
>>
>> it works to every function until now, unless nf_unregister_hook.
>
> Does the problem go away if you call it indirectly? Like:
>
>
> stop_trigger.function = myfunc;
> ...
>
> myfunc(void)
> {
> 	nf_unregister_hook(&nf_hook);
> }
>
>



----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.


