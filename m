From: Patrick Schaaf <bof@bof.de>
Subject: Re: how to add packet or byte couters to connection tracking module
Date: Thu, 20 Feb 2003 19:33:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030220183340.GA17248@oknodo.bof.de>
References: <Pine.LNX.4.44.0302200959310.13403-100000@ski.isi.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Xuan Chen <xuanc@isi.edu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0302200959310.13403-100000@ski.isi.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> I want to add a packet or byte counter to the connection tracking module 
> in netfilter. That is, I want to track how many packets and bytes having 
> been sent through one connection. Where should I start?

1) Get the kernel source code.

2) Get enough RAM to hold the full kernel source code, and your normal apps.
   To test whether you have enough RAM, use 'vmstat' to see whether you
   start swapping on this command:
	find /usr/src/linux -type f | grep -l 'struct ip_conntrack'

3) you are set up for work with the kernel. "grep for this" is the
   basic navigation aid. Now that you have found the include file
   (they end in '.h') where 'struct ip_conntrack' is defined,
   add the neccessary counter fields to it.

4) Study the other files the find/grep above found, especially the files
   with 'conntrack' in their names. Add the counter updates to the
   relevant files.

5) Provide ways for userlevel to access those counters. I would be
   interested to hear about the access methods you imagine.

6) Test. Test. Test.

> Any examples will be very helpful!

A concrete example, would mean writing the code. I hope you persist
and implement and share your code, because if you do, we will have
an example. I hope my six step program, above, helps you along a bit.
 
> btw, is there a search engine on netfilter's web page? I think that's 
> really helpful if people want to search for previous work and discussions.

I'm sure that google has it indexed fully; use the advanced search
features, there, to restrict any search to a particular domain.
An example URL, searching for "byte counters" on www.netfilter.org,
would be:

	http://www.google.com/search?q=+site%3Awww.netfilter.org+byte+counters

best regards
  Patrick
