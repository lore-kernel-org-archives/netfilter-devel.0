From: "Gael Mauleon" <gmauleon@free.fr>
Subject: Re: Concerning ULOG and the MAC logging bug
Date: Mon, 9 Dec 2002 20:28:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <002601c29fb9$260345b0$0200a8c0@KevlarPC>
References: <003101c29ca5$289c8b40$0200a8c0@KevlarPC> <20021209183930.GN2223@sunbeam.de.gnumonks.org>
Reply-To: "Gael Mauleon" <gmauleon@free.fr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Harald Welte" <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I think I had read the ulog_packet struct the wrong way.
That's why i was talking about the payload, but it was mistake.

So the else is probably more efficient :)
But in absolute, i think memset  on a struct is probably
more efficient than many strncpy in some "else" statements.

Thx for the reply :)

----- Original Message ----- 
From: "Harald Welte" <laforge@gnumonks.org>
To: "Gael Mauleon" <gmauleon@free.fr>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Monday, December 09, 2002 7:39 PM
Subject: Re: Concerning ULOG and the MAC logging bug


Indeed this is an alternative solution. The question is: What is more
efficient: Memsetting the whole structure or a potential branch
introduced by the 'else' clause.  

And: What do you mean by 'payload can be exploited with wrong data'. Are
you talking about the to-be-logged packet which will become the payload
of the netlink message?  How could this contain wrong data?

> And let me know if there is a better way to tell about bugs and put
> some code changes.

for code changes we usually use unified diff (diff -u) between original
and changed code.  It can easily be read by a human being and also
automatically applied in case we really want to accept this change.
