From: "Pito Breizh" <pito_breizh@hotmail.com>
Subject: Memory leak problem
Date: Wed, 06 Nov 2002 10:47:41 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <F76W2ufyWOxbCJnEMzA000311db@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I've got a problem of memory leak with iptables. I'm using iptables
1.2.7a. I've linked libiptc.a and iptables.o with my application.

I'm setting up some NAT rules by using do_command and iptc_commit
functions.

I've seen a mail on netfilter-devel list (dated of 2 september) dealing
with this problems. Here is this mail :

>You expect the iptables source components to be more than a short->running 
>one-shot application; you expect them to be usable in a library in a 
>longer-running process. That expectation is wrong, the current userlevel 
>iptables source was not designed with that goal in mind.

>This is currently tackled by some developers (not me), who are working
>on an all-new userlevel and user/kernel interface that _is_ designed
>to support efficient use from many different userlevel applications.

>However, as far as I know, this reimplementation is currently not
>in a form that you may use.

>best regards
>  Patrick

First of all, I would want to know if the developers team in charge of
the developement of the new userlevel interface is on this list?

Secondly, are there news about this subject ? If developement's
resources are needed, perhaps I can help !

Best regards,
   Mickael





_________________________________________________________________
MSN Search, le moteur de recherche qui pense comme vous ! 
http://search.msn.fr/worldwide.asp
