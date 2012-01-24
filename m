From: Quentin Aebischer <Quentin.Aebischer@USherbrooke.ca>
Subject: Re: [PATCH] conntrackd: basic TIPC implementation for NOTRACK mode
Date: Tue, 24 Jan 2012 12:00:58 -0500
Message-ID: <20120124120058.234342gq75ohof6s@www.usherbrooke.ca>
References: <20120121085217.4272940o8fmk4v80@www.usherbrooke.ca>
 <20120122174140.GA18764@1984>
 <20120122162720.10123t2longq3zac@www.usherbrooke.ca>
 <20120123100733.GB23857@1984>
 <20120123132537.198937ydqdx1n3gg@www.usherbrooke.ca>
 <20120124010145.GA28314@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpi4.USherbrooke.ca ([132.210.236.3]:12626 "EHLO
	smtpi4.usherbrooke.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2AXRBd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jan 2012 12:01:33 -0500
In-Reply-To: <20120124010145.GA28314@1984>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> a =C3=A9crit=C2=A0:

> On Mon, Jan 23, 2012 at 01:25:37PM -0500, Quentin Aebischer wrote:
> [...]
>> >>index 01fe4fc..e1c4892 100644
>> >>--- a/src/read_config_lex.l
>> >>+++ b/src/read_config_lex.l
>> >>@@ -47,6 +47,7 @@ ip6_part	{hex_255}":"?
>> >> ip6_form1	{ip6_part}{0,16}"::"{ip6_part}{0,16}
>> >> ip6_form2	({hex_255}":"){16}{hex_255}
>> >> ip6		{ip6_form1}{ip6_cidr}?|{ip6_form2}{ip6_cidr}?
>> >>+tipc_name	{integer}":"{integer}
>> >> string		[a-zA-Z][a-zA-Z0-9\.\-]*
>> >> persistent	[P|p][E|e][R|r][S|s][I|i][S|s][T|t][E|e][N|n][T|T]
>> >> nack		[N|n][A|a][C|c][K|k]
>> >>@@ -63,9 +64,12 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
>> >> "IPv4_interface"		{ return T_IPV4_IFACE; }
>> >> "IPv6_interface"		{ return T_IPV6_IFACE; }
>> >> "Interface"			{ return T_IFACE; }
>> >>+"TIPC_Destination_Name" 	{ return T_TIPC_DEST_NAME; }
>> >>+"TIPC_Name"			{ return T_TIPC_NAME; }
>> >> "Multicast"			{ return T_MULTICAST; }
>> >> "UDP"				{ return T_UDP; }
>> >> "TCP"				{ return T_TCP; }
>> >>+"TIPC"                          { return T_TIPC; }
>> >> "HashSize"			{ return T_HASHSIZE; }
>> >> "RefreshTime"			{ return T_REFRESH; }
>> >> "CacheTimeout"			{ return T_EXPIRE; }
>> >>@@ -149,6 +153,8 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
>> >> {signed_integer}	{ yylval.val =3D atoi(yytext); return T_SIGNED_N=
UMBER; }
>> >> {ip4}			{ yylval.string =3D strdup(yytext); return T_IP; }
>> >> {ip6}			{ yylval.string =3D strdup(yytext); return T_IP; }
>> >>+{tipc_name}		{ yylval.string =3D strdup(yytext); return T_TIPC_NA=
ME_VAL; }
>> >
>> >Can you use T_STRING instead? Then, you can check in the parser tha=
t
>> >the TIPC name is well-formed, i.e. integer:integer.
>> >
>> >Otherwise, print one parsing error.
>>
>> I implemented a new type 'tipc_name', since there was such types for
>> IPV4 and IPV6 addresses, and I considered a TIPC name was the
>> equivalent of an IP address, that's why I did this at first.
>> After thinking about it twice, TIPC name is more like UDP/TCP port,
>> and TIPC node address/network ID would be like the IP address.
>>
>> I can still correct that if you want me to.
>
> Make sense what you say, keep using the new type.
>
>> >>+	conf.channel_type_global =3D CHANNEL_TIPC;
>> >>+	conf.channel[conf.channel_num].channel_type =3D CHANNEL_TIPC;
>> >>+	// conf.channel[conf.channel_num].channel_flags =3D CHANNEL_F_BU=
=46FERED;
>
> Hm, I missed this. Using the buffered flag may be useful, why did you
> decided to remove it?

Actually, I don't know what CHANNEL_F_BUFFERED flag would do here, so =20
I decided to temporarily remove it for the first tests, and then I =20
forgot to reactivate it.

> I think there are other flags that are useful in case you use TIPC in
> stream mode:
>
> CHANNEL_F_STREAM
> CHANNEL_F_ERRORS
>
> BTW, does your patch support selecting what communication semantics y=
ou
> want to use for TIPC? In other words, what TIPC working mode are we
> using with your patch? (sorry, I'm lazy to look at your original patc=
h
> to see it by myself). Please, justify.

We are not using stream mode at the moment. We are using TIPC =20
SOCK_RDM, which is like SOCK_DGRAM, but guarantees that every messages =
=20
sent over the network is properly delivered to its destination node.

There's no flow control mechanism when using SOCK_RDM in =20
connectionless mode though (which is our case here), so if packets are =
=20
not consumed fast enough on the receiver node side, they are queued up =
=20
until we reach the maximum number of allowed messages in the queue. =20
This maximum number is defined by the importance level of the TIPC =20
messages sent by the sender (which is now a custom parameter in =20
conntrackd.conf like you suggested).
When we hit the limit, we then enter congestion mode on the receiving n=
ode.

Here, depending on the value of SRC_DEST_DROPPABLE, we either silently =
=20
drop the packets, or return them with an error code (which we can =20
detect on the sender side by looking for the return value of rcv(), =20
that's what I tried to implement for my debug operations).

So yeah, basically I don't know what CHANNEL_BUFFER does :X.




--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
