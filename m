From: Francesco Ciocchetti <primero@fastwebnet.it>
Subject: Re: libiptc ... and matches , seg fault
Date: Fri, 15 Jul 2005 12:29:43 +0200
Message-ID: <42D79017.2080009@fastwebnet.it>
References: <42D6AD2C.5070304@fastwebnet.it>
	<Pine.LNX.4.63.0507142117170.29183@localhost.localdomain>
	<42D76E84.7080906@fastwebnet.it>
	<Pine.LNX.4.61.0507151008050.20435@yvahk01.tjqt.qr>
	<42D77F23.80403@fastwebnet.it>
	<Pine.LNX.4.63.0507151142180.29785@localhost.localdomain>
	<42D78883.9010008@fastwebnet.it>
	<20050715101112.GA32319@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.netfilter.org
In-Reply-To: <20050715101112.GA32319@oknodo.bof.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf wrote:

>>in libipt_tcp.c ... what i'm wondering now is why my "me->version" could
>>be or is NULL or maybe program_version could be NULL too.
>>    
>>
>
>Why are you wondering about these two alternatives, instead of testing it
>(by inserting suitable printing before the problem point, and/or using
>a debugger)?
>  
>

just done it ... and had not time to say "Thanks to all that ansered me
i found the problem and solved" before u post.

>Please note that this mailing list is not meant as an educational
>forum for beginning C programmers... And the iptables userlevel
>libraries are not targeted to be standalone libraries for easy
>use by casual programmers... 
>
it does not seems that i asked for a "fast tutorial on C programming"
but i asked for a problem related to libiptc libs ... there is a "more
suitable" mailing list for such a question ? sorry if , once found the
problem, i asked for something as "why i'm getting this problem with
strcmp?" but u know, not everyone has borned expert C programmer as u
did ... and, AFAIK asking is the only way to get there .

I really don't understand this kind of "witch hunting" against little OT
in ML and Forums ... i know that years ago this was not the "common way
to act" maybe today it is , but this is really really sad.

Sharing , Asking and Answering is what lead us here where we are .... i
hope we are not loosing this for an "expert C programmers closed  shrine".

>So it is to be expected that you
>must be a C expert if you want to use those libraries... And be
>prepared that they may change radically with the next release
>of iptables...
>
>  
>

no problem with that, i was born "ready" ....



Btw thanks to all that helped me solving the problem.

Sincerly yours
Francesco, casual programmer ;)


>The official interfaces for manipulating iptables rules, are the
>iptables and iptables-restore PROGRAMS.
>
>best regards
>  Patrick
>  
>
