From: Fabrice MARIE <fabrice@celestix.com>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Wed, 3 Jul 2002 20:41:48 +0800
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207032041.49134.fabrice@celestix.com>
References: <Pine.LNX.4.33.0207031255220.17202-100000@blackhole.kfki.hu>
Reply-To: fabrice@celestix.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Harald Welte <laforge@gnumonks.org>
In-Reply-To: <Pine.LNX.4.33.0207031255220.17202-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello,

On Wednesday 03 July 2002 19:24, Jozsef Kadlecsik wrote:
>[...]
> new action class:
> 	pro: no ordering problem
> 	pro: clean separation of functionalities
> 	con: naming issue
> match module:
> 	pro: no naming issue, current well known concepts can be kept
> 	pro: couple of modules can be unified
> 	con: ordering issue
> multiple targets:
> 	pro: no naming issue, current well known concepts can be kept
> 	pro: no change required in the existing modules
> 	con: ordering issue (-j ACCEPT -j TTL)

I proposed the last one some time ago. A solution to the ordering
issue is to have two kind of targets:
1- terminal target (ie ACCEPT, DROP, REJECT, jump to chain, etc...)
2- non terminal target (ie TTL, MARK, IPV4OPTSSTRIP, etc...)
The userland would basically use the order the admin provide,
and would reply with an error if a non-terminal target is used
after a terminal target.

But I was answered that it was impossible/difficult with the current
framework (which I agree).

I was also answered that it would break what people are used to,
(having only one target) which I don't really agree with.
I believe it's very natural to want to perform several things if a condition
match, just like you would do in C a
if (condition1) {
   action1();
   action2();
   action3();
}
instead of a
if (condition1)
   action1();
if (condition1)
   action2();
if (condition1)
   action3();

I believe it's important to be able to have several targets,
or whatever you call them, since you will avoid testing the condition
several times (which you cannot do with some matches without changing
their returned value : nth, random, recent, etc...etc...).

This might be something we can think about when designing the
framework for 2.5, since it's got to be rewritten to support
netlink.

Have a nice day,

Fabrice.
--
Fabrice MARIE
Senior R&D Engineer
Celestix Networks
http://www.celestix.com/

"Silly hacker, root is for administrators"
       -Unknown
