From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] ip_tables.h does not compile when using g++
Date: Mon, 16 Sep 2002 16:08:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020916140850.GA8967@oknodo.bof.de>
References: <1032190296.458.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter List <netfilter-devel@lists.netfilter.org>,
  Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott Andrew Baillie <sbaillie@bigpond.net.au>
Content-Disposition: inline
In-Reply-To: <1032190296.458.21.camel@localhost.localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> The header file ip_tables.h is included by the kernel and by user
> space programs so it should compile when using g++.

I don't understand why you arrive at this conclusion. ip_tables.h is in
no way a valid documented user level API, and the fact that the existing
iptables user level code base (all implemented in C) is including it,
is a design error in the iptables userlevel - good style would be to
copy those headers into the userlevel distribution, thus properly
seperating kernel and userlevel headers.

A future userlevel C++ API to iptables would indeed need to concern
itself with such things - but there is no such thing in existence
(and I don't know whether it is under consideration to have a C++
callable API).

I strongly disagree with the "void *" -> "char *" conversion in pure
kernel headers, because the kernel is by definition geared towards
gcc with most extensions (and void * arithmetic is one that makes
sense).

best regards
  Patrick
