From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Small project: outgoing connection notifier
Date: Sat, 7 Jul 2007 13:27:32 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707071327220.1536@fbirervta.pbzchgretzou.qr>
References: <61663a950707070115r4d6111f4x733d9868e31ca21f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: NetFilter ML <netfilter-devel@lists.netfilter.org>
To: Marco Bridge <bridge.on.blue@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <61663a950707070115r4d6111f4x733d9868e31ca21f@mail.gmail.com>
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


On Jul 7 2007 10:15, Marco Bridge wrote:
>
> Ciao guys, i'm a student from Switzerland
> My summer is just begun and i have a small project that would like to
> start in the following weeks, before is september again...
>
> The idea is to implement a small applet that notifies whenever a program
> tries to access the internet.
> For example it pops up a little window that says: "The application
> Azureus is trying to access the internet" and the user can choose
> allow/deny,  once or permanently.
>
> Such application exists for Mac, it is called LittleSnitch
> http://www.obdev.at/products/littlesnitch/index.html
> I'm pretty sure WinXP as it as part of the system itself.
>
> I didn't find something similar for Linux so it would be fun and
> interesting for me to do it.

http://tuxguardian.sf.net/

>
> My thoughts about the project  are still really fuzzy, my major doubts
> regard:
> - where/how to intercept outbound connection requests from the application
> - how to temporarily suspend the connection request until user
> acknowledgment, if that's possible
> - how to understand which application made the request while the
> request is being submitted.
>
> I'm writing to this mailing list since you're probably the most
> competent in that...
>
> I never developed for Linux so i read what i found on network related
> kernel events but i still don't know where to start from...
> For example, i could write a kernel module that overrides the
> "connection request" syscall (if any) and matches my rules before
> allowing it.
> Or it could be possible to simply create what i want as an extension
> for netfilter.
> Does that make any sense?
>
> Any kind of pointer or suggestion to where to start from is really appreciated!
>
> Ciao
> Marco
>

	Jan
-- 
