From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrackd: basic TIPC implementation for NOTRACK mode
Date: Tue, 24 Jan 2012 02:01:45 +0100
Message-ID: <20120124010145.GA28314@1984>
References: <20120121085217.4272940o8fmk4v80@www.usherbrooke.ca>
 <20120122174140.GA18764@1984>
 <20120122162720.10123t2longq3zac@www.usherbrooke.ca>
 <20120123100733.GB23857@1984>
 <20120123132537.198937ydqdx1n3gg@www.usherbrooke.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Quentin Aebischer <Quentin.Aebischer@USherbrooke.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45148 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab2AXBBu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jan 2012 20:01:50 -0500
Content-Disposition: inline
In-Reply-To: <20120123132537.198937ydqdx1n3gg@www.usherbrooke.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 23, 2012 at 01:25:37PM -0500, Quentin Aebischer wrote:
[...]
> >>index 01fe4fc..e1c4892 100644
> >>--- a/src/read_config_lex.l
> >>+++ b/src/read_config_lex.l
> >>@@ -47,6 +47,7 @@ ip6_part	{hex_255}":"?
> >> ip6_form1	{ip6_part}{0,16}"::"{ip6_part}{0,16}
> >> ip6_form2	({hex_255}":"){16}{hex_255}
> >> ip6		{ip6_form1}{ip6_cidr}?|{ip6_form2}{ip6_cidr}?
> >>+tipc_name	{integer}":"{integer}
> >> string		[a-zA-Z][a-zA-Z0-9\.\-]*
> >> persistent	[P|p][E|e][R|r][S|s][I|i][S|s][T|t][E|e][N|n][T|T]
> >> nack		[N|n][A|a][C|c][K|k]
> >>@@ -63,9 +64,12 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
> >> "IPv4_interface"		{ return T_IPV4_IFACE; }
> >> "IPv6_interface"		{ return T_IPV6_IFACE; }
> >> "Interface"			{ return T_IFACE; }
> >>+"TIPC_Destination_Name" 	{ return T_TIPC_DEST_NAME; }
> >>+"TIPC_Name"			{ return T_TIPC_NAME; }
> >> "Multicast"			{ return T_MULTICAST; }
> >> "UDP"				{ return T_UDP; }
> >> "TCP"				{ return T_TCP; }
> >>+"TIPC"                          { return T_TIPC; }
> >> "HashSize"			{ return T_HASHSIZE; }
> >> "RefreshTime"			{ return T_REFRESH; }
> >> "CacheTimeout"			{ return T_EXPIRE; }
> >>@@ -149,6 +153,8 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
> >> {signed_integer}	{ yylval.val = atoi(yytext); return T_SIGNED_NUMBER; }
> >> {ip4}			{ yylval.string = strdup(yytext); return T_IP; }
> >> {ip6}			{ yylval.string = strdup(yytext); return T_IP; }
> >>+{tipc_name}		{ yylval.string = strdup(yytext); return T_TIPC_NAME_VAL; }
> >
> >Can you use T_STRING instead? Then, you can check in the parser that
> >the TIPC name is well-formed, i.e. integer:integer.
> >
> >Otherwise, print one parsing error.
> 
> I implemented a new type 'tipc_name', since there was such types for
> IPV4 and IPV6 addresses, and I considered a TIPC name was the
> equivalent of an IP address, that's why I did this at first.
> After thinking about it twice, TIPC name is more like UDP/TCP port,
> and TIPC node address/network ID would be like the IP address.
> 
> I can still correct that if you want me to.

Make sense what you say, keep using the new type.

> >>+	conf.channel_type_global = CHANNEL_TIPC;
> >>+	conf.channel[conf.channel_num].channel_type = CHANNEL_TIPC;
> >>+	// conf.channel[conf.channel_num].channel_flags = CHANNEL_F_BUFFERED;

Hm, I missed this. Using the buffered flag may be useful, why did you
decided to remove it?

I think there are other flags that are useful in case you use TIPC in
stream mode:

CHANNEL_F_STREAM
CHANNEL_F_ERRORS

BTW, does your patch support selecting what communication semantics you
want to use for TIPC? In other words, what TIPC working mode are we
using with your patch? (sorry, I'm lazy to look at your original patch
to see it by myself). Please, justify.

[...]
> >>+	if(sscanf($2, "%d:%d",
> >
> >Define one buffer here and use snprintf. This doesn't look safe to me.
> 
> I already have the string buffered, and I want to extract integer
> values out of it.
> I searched for an snscanf() function, but I don't think there's one
> in stdio.h.

You're alright. Sorry, I misread the code. sscanf seems fine.

> >>+	   fcntl(m->fd, F_SETFL, O_NONBLOCK); */ // used for debug purposes
> >
> >non-blocking sockets disabled, why?
> 
> Actually, I think it allows non-blocking sockets.
> I used this during the debug process after discussion with Allan
> Stephens from the TIPC mailing list, who suggested to introduce some
> non-blocking receive operation to test the rcv() function return
> value (0 would mean some packets are returned and the other side is
> congested).
> 
> I didn't know where to put that, so I just implemented a non
> blocking rcv() after we do a tipc_send() (which is called quite
> often during heavy benchmarks on the primary firewall in a
> primary-backup configuration).
> 
> Maybe just testing the ret value for 0's in the standard
> tipc_receive() function would have worked just the same, I could try
> that way and see how it goes.

I think so.

> >Some description in the patch will come very useful, for example:
> >
> >[PATCH] conntrackd: basic TIPC implementation
> >
> >This patch adds TIPC support for conntrackd, you can enable it with
> >the following configuration in conntrackd.conf
> >
> >... example here.
> >
> >TIPC is the the protocol define in RFC ... its purpose is...
> >
> >I think that TIPC can be useful for the following reasons:
> >
> >... reasons here
> >
> >My initial experiments show that ...
> >
> >and so on. Thus, people can track this change in the
> >git.netfilter.org, this is how it usually works for FOSS projects.
> 
> Ok, I'll try to add some more descriptions later on.

Don't leave things for "later on", please include it in the the patch.
This is very useful for others to understand and track your changes.

> Also, do you want me to post another diff with all the fixed changes
> in this thread ?

As soon as we finish discussing this, feel free to do it.

> Thanks for the feedback.

Thanks for the patch.
