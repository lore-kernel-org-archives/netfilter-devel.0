From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] ip_tables.h does not compile when using g++
Date: Mon, 16 Sep 2002 19:16:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020916171640.GA9020@oknodo.bof.de>
References: <1032190296.458.21.camel@localhost.localdomain> <20020916140850.GA8967@oknodo.bof.de> <20020916184417.P3810@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>,
  Scott Andrew Baillie <sbaillie@bigpond.net.au>,
  netfilter List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Content-Disposition: inline
In-Reply-To: <20020916184417.P3810@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > I strongly disagree with the "void *" -> "char *" conversion in pure
> > kernel headers, because the kernel is by definition geared towards
> > gcc with most extensions (and void * arithmetic is one that makes
> > sense).
> 
> I share this disagreemenent.  However, if it's the only way we can make
> C++ apps use libiptc (for now), I am willing to pay this 'price'.

Fully agreed. I did not know about the "libiptc" connection.

Sorry for my intervention, Scott, your problem analysis and solution
is completely appropriate.

Would you agree, Harald, and maybe work towards that goal, that a future
new pkttables structure should have a clean seperation between kernel
and userspace headers?

best regards
  Patrick
