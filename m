From: <computational_complex-forthespam@yahoo.it>
Subject: Re: download stopper
Date: Sun, 14 May 2006 12:52:20 +0200 (CEST)
Message-ID: <20060514105220.47336.qmail@web86909.mail.ukl.yahoo.com>
References: <4465B6C5.1080006@rocsys.com>
Reply-To: computational_complex-forthespam@yahoo.it
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4465B6C5.1080006@rocsys.com>
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


--- varun <varun@rocsys.com> ha scritto: 
>          Can anyone suggest me a way in which i can
> stop http downloads 
> but not http traffic.

Your request is ambiguous: how do you distinguish
between
(what you defined) file traffic and other http
traffic?
A way to do that is checking download file name, but
it's hard to entrust on it.
Anyway if you want something like this, i think
there's nothing ready out of the box but you've to
implement it, for example on top on libnfnetlink.

Good luck, 

Valerio
