From: Patrick Schaaf <bof@bof.de>
Subject: Re: policy routing on locally generated packets
Date: Tue, 26 Aug 2003 13:09:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030826110913.GI423@oknodo.bof.de>
References: <1061813400.1289.36.camel@drs0.manchotnetworks.net> <3F4A01BE.1090805@trash.net> <3F4A2795.3030805@trash.net> <1061837608.1333.9.camel@drs0.manchotnetworks.net> <20030825190750.GH423@oknodo.bof.de> <1061887675.1273.37.camel@drs0.manchotnetworks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "lartc@manchotnetworks.net" <lartc@manchotnetworks.net>
Content-Disposition: inline
In-Reply-To: <1061887675.1273.37.camel@drs0.manchotnetworks.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Charles,

> > What about mangle/PREROUTING? Doesn't it / shouldn't it sit before a
> > routing decision for locally generated packets?
> PREROUTING is "before" a routing decision. but only affects packets
> coming in over the wire, and not locally generated. 

To me, it could/would be the most logical extension to make PREROUTING
also see outbound locally generated packets, before the routing step.

What do others think?

[snip per-uid accounting requirement]

> So I am searching for a hopefully simple way to implement this without
> having to recompile a bunch of stuff.

Your application would be far better served, IMHO, by a suitable, small
piece of code that does exactly what you need, instead of invoking complex
configuration all over the place.

First, the kernel already has a nice per-uid data structure, the
'struct user_struct'. It is used today to count the number of
processes a uid posesses. It could certainly be easily extended
with some counters. Second, those counters would get incremented
whenever a socket-using user level process sends or receives something.
Third, add some /proc/ file to read out the current counters, and a way
to reset the counters to 0.

Anybody here who A) needs the feature and B) has the skill to write the code?
If I'm not mistaken, it's 1-2 days of work.

best regards
  Patrick
