From: Quentin Aebischer <Quentin.Aebischer@USherbrooke.ca>
Subject: Re: [PATCH] conntrackd: basic TIPC implementation for NOTRACK mode
Date: Mon, 23 Jan 2012 13:25:37 -0500
Message-ID: <20120123132537.198937ydqdx1n3gg@www.usherbrooke.ca>
References: <20120121085217.4272940o8fmk4v80@www.usherbrooke.ca>
 <20120122174140.GA18764@1984>
 <20120122162720.10123t2longq3zac@www.usherbrooke.ca>
 <20120123100733.GB23857@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpi4.USherbrooke.ca ([132.210.236.3]:7852 "EHLO
	smtpi4.usherbrooke.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2AWS0D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:26:03 -0500
In-Reply-To: <20120123100733.GB23857@1984>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> a =C3=A9crit=C2=A0:

> Hi Quentin,
>
> On Sun, Jan 22, 2012 at 04:27:20PM -0500, Quentin Aebischer wrote:
>> Ehhr, sorry about that (first time using git/committing a patch here=
 =3DX).
>> Hope I did it well this time.
>>
>> From : Quentin Aebischer <quentin.aebischer@usherbrooke.ca>
>>
>> Basic implementation of a TIPC channel for the conntrackd daemon
>> (successfully tested in NOTRACK and FTFW modes).
>> Any feedback/hints is appreciated.
>
> In general, this looks very good :-).
>
> Some minor comments:
>
>> Signed-off-by: Quentin Aebischer <quentin.aebischer@usherbrooke.ca>
>> ---
>>  include/Makefile.am   |    2 +-
>>  include/channel.h     |   10 ++-
>>  include/tipc.h        |   56 ++++++++++++
>>  src/Makefile.am       |    2 +-
>>  src/channel.c         |    2 +
>>  src/channel_tipc.c    |  139 ++++++++++++++++++++++++++++++
>>  src/read_config_lex.l |    6 ++
>>  src/read_config_yy.y  |   77 ++++++++++++++++-
>>  src/tipc.c            |  224
>> +++++++++++++++++++++++++++++++++++++++++++++++++
>>  9 files changed, 513 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/Makefile.am b/include/Makefile.am
>> index cbbca6b..6147d6b 100644
>> --- a/include/Makefile.am
>> +++ b/include/Makefile.am
>> @@ -1,6 +1,6 @@
>>
>>  noinst_HEADERS =3D alarm.h jhash.h cache.h linux_list.h linux_rbtre=
e.h \
>> -		 sync.h conntrackd.h local.h udp.h tcp.h \
>> +		 sync.h conntrackd.h local.h udp.h tcp.h tipc.h \
>>  		 debug.h log.h hash.h mcast.h conntrack.h \
>>  		 network.h filter.h queue.h vector.h cidr.h \
>>  		 traffic_stats.h netlink.h fds.h event.h bitops.h channel.h \
>> diff --git a/include/channel.h b/include/channel.h
>> index 9b5fad8..704d384 100644
>> --- a/include/channel.h
>> +++ b/include/channel.h
>> @@ -4,6 +4,7 @@
>>  #include "mcast.h"
>>  #include "udp.h"
>>  #include "tcp.h"
>> +#include "tipc.h"
>>
>>  struct channel;
>>  struct nethdr;
>> @@ -13,6 +14,7 @@ enum {
>>  	CHANNEL_MCAST,
>>  	CHANNEL_UDP,
>>  	CHANNEL_TCP,
>> +	CHANNEL_TIPC,
>>  	CHANNEL_MAX,
>>  };
>>
>> @@ -31,6 +33,11 @@ struct tcp_channel {
>>  	struct tcp_sock *server;
>>  };
>>
>> +struct tipc_channel {
>> +	struct tipc_sock *client;
>> +	struct tipc_sock *server;
>> +};
>> +
>>  #define CHANNEL_F_DEFAULT	(1 << 0)
>>  #define CHANNEL_F_BUFFERED	(1 << 1)
>>  #define CHANNEL_F_STREAM	(1 << 2)
>> @@ -41,6 +48,7 @@ union channel_type_conf {
>>  	struct mcast_conf mcast;
>>  	struct udp_conf udp;
>>  	struct tcp_conf tcp;
>> +	struct tipc_conf tipc;
>>  };
>>
>>  struct channel_conf {
>> @@ -97,7 +105,7 @@ void channel_stats(struct channel *c, int fd);
>>  void channel_stats_extended(struct channel *c, int active,
>>  			    struct nlif_handle *h, int fd);
>>
>> -#define MULTICHANNEL_MAX	4
>> +#define MULTICHANNEL_MAX	5
>>
>>  struct multichannel {
>>  	int		channel_num;
>> diff --git a/include/tipc.h b/include/tipc.h
>> new file mode 100644
>> index 0000000..f1cdcfb
>> --- /dev/null
>> +++ b/include/tipc.h
>> @@ -0,0 +1,56 @@
>> +#ifndef _TIPC_H_
>> +#define _TIPC_H_
>> +
>> +#include <stdint.h>
>> +#include <netinet/in.h>
>> +#include <net/if.h>
>> +#include <linux/tipc.h>
>> +
>> +struct tipc_conf {
>> +	int ipproto;
>> +	struct {
>> +		uint32_t type;
>> +		uint32_t instance;
>> +	} client;
>> +	struct {
>> +		uint32_t type;
>> +		uint32_t instance;
>> +	} server;
>> +	// int sndbuf;
>> +	// int rcvbuf;
>
> Please, no code commented, this is ugly. Whether you leave it or you
> remove it. You may also remove and add some comment, something like:
>
> /* TODO: no buffer tuning supported. */

Ok, done.

> Thus, we can notice that there's something pending to be done without
> commenting code.
>
>> diff --git a/src/channel_tipc.c b/src/channel_tipc.c
>> new file mode 100644
>> index 0000000..cd6648c
>> --- /dev/null
>> +++ b/src/channel_tipc.c
>> @@ -0,0 +1,139 @@
>> +/*
>> + * (C) 2009 by Pablo Neira Ayuso <pablo@netfilter.org>
>
> What you usually do here is:
>
> (C) 2012 by Quentin ...
>
> Derived work based on mcast.c from:
>
> (C) 2009 by Pablo ...
>
> This is the sort of header you should made for new files.

Yeah right, I forgot to change the header =3D).
Done.

>> + *
>> + * This program is free software; you can redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; either version 2 of the License, o=
r
>> + * (at your option) any later version.
>> + */
>> +
>> +#include <stdlib.h>
>> +#include <libnfnetlink/libnfnetlink.h>
>> +
>> +#include "channel.h"
>> +#include "tipc.h"
>> +
>> +static void
>> +*channel_tipc_open(void *conf)
>> +{
>> +	struct tipc_channel *m;
>> +	struct tipc_conf *c =3D conf;
>> +
>> +	m =3D calloc(sizeof(struct tipc_channel), 1);
>> +	if (m =3D=3D NULL)
>> +		return NULL;
>> +
>> +	m->client =3D tipc_client_create(c);
>> +	if (m->client =3D=3D NULL) {
>> +		free(m);
>> +		return NULL;
>> +	}
>> +
>> +	m->server =3D tipc_server_create(c);
>> +	if (m->server =3D=3D NULL) {
>> +		tipc_client_destroy(m->client);
>> +		free(m);
>> +		return NULL;
>> +	}
>> +	return m;
>> +}
>> +
>> +static int
>> +channel_tipc_send(void *channel, const void *data, int len)
>> +{
>> +	struct tipc_channel *m =3D channel;
>> +	return tipc_send(m->client, data, len);
>> +}
>> +
>> +static int
>> +channel_tipc_recv(void *channel, char *buf, int size)
>> +{
>> +	struct tipc_channel *m =3D channel;
>> +	return tipc_recv(m->server, buf, size);
>> +}
>> +
>> +static void
>> +channel_tipc_close(void *channel)
>> +{
>> +	struct tipc_channel *m =3D channel;
>> +	tipc_client_destroy(m->client);
>> +	tipc_server_destroy(m->server);
>> +	free(m);
>> +}
>> +
>> +static int
>> +channel_tipc_get_fd(void *channel)
>> +{
>> +	struct tipc_channel *m =3D channel;
>> +	return tipc_get_fd(m->server);
>> +}
>> +
>> +static void
>> +channel_tipc_stats(struct channel *c, int fd)
>> +{
>> +	struct tipc_channel *m =3D c->data;
>> +	char ifname[IFNAMSIZ], buf[512];
>> +	int size;
>> +
>> +	if_indextoname(c->channel_ifindex, ifname);
>> +	size =3D tipc_snprintf_stats(buf, sizeof(buf), ifname,
>> +				    &m->client->stats, &m->server->stats);
>> +	send(fd, buf, size, 0);
>> +}
>> +
>> +static void
>> +channel_tipc_stats_extended(struct channel *c, int active,
>> +			     struct nlif_handle *h, int fd)
>> +{
>> +	struct tipc_channel *m =3D c->data;
>> +	char ifname[IFNAMSIZ], buf[512];
>> +	const char *status;
>> +	unsigned int flags;
>> +	int size;
>> +
>> +	if_indextoname(c->channel_ifindex, ifname);
>> +	nlif_get_ifflags(h, c->channel_ifindex, &flags);
>> +	/*
>> +	 * IFF_UP shows administrative status
>> +	 * IFF_RUNNING shows carrier status
>> +	 */
>> +	if (flags & IFF_UP) {
>> +		if (!(flags & IFF_RUNNING))
>> +			status =3D "NO-CARRIER";
>> +		else
>> +			status =3D "RUNNING";
>> +	} else {
>> +		status =3D "DOWN";
>> +	}
>> +	size =3D tipc_snprintf_stats2(buf, sizeof(buf),
>> +				     ifname, status, active,
>> +				     &m->client->stats,
>> +				     &m->server->stats);
>> +	send(fd, buf, size, 0);
>> +}
>> +
>> +static int
>> +channel_tipc_isset(struct channel *c, fd_set *readfds)
>> +{
>> +	struct tipc_channel *m =3D c->data;
>> +	return tipc_isset(m->server, readfds);
>> +}
>> +
>> +static int
>> +channel_tipc_accept_isset(struct channel *c, fd_set *readfds)
>> +{
>> +	return 0;
>> +}
>> +
>> +struct channel_ops channel_tipc =3D {
>> +	.headersiz	=3D 60, /* IP header (20 bytes) + tipc unicast name
>> message header 40 (bytes) (see
>> http://tipc.sourceforge.net/doc/tipc_message_formats.html for
>> details) */
>> +	.open		=3D channel_tipc_open,
>> +	.close		=3D channel_tipc_close,
>> +	.send		=3D channel_tipc_send,
>> +	.recv		=3D channel_tipc_recv,
>> +	.get_fd		=3D channel_tipc_get_fd,
>> +	.isset		=3D channel_tipc_isset,
>> +	.accept_isset	=3D channel_tipc_accept_isset,
>> +	.stats		=3D channel_tipc_stats,
>> +	.stats_extended =3D channel_tipc_stats_extended,
>> +};
>> diff --git a/src/read_config_lex.l b/src/read_config_lex.l
>> index 01fe4fc..e1c4892 100644
>> --- a/src/read_config_lex.l
>> +++ b/src/read_config_lex.l
>> @@ -47,6 +47,7 @@ ip6_part	{hex_255}":"?
>>  ip6_form1	{ip6_part}{0,16}"::"{ip6_part}{0,16}
>>  ip6_form2	({hex_255}":"){16}{hex_255}
>>  ip6		{ip6_form1}{ip6_cidr}?|{ip6_form2}{ip6_cidr}?
>> +tipc_name	{integer}":"{integer}
>>  string		[a-zA-Z][a-zA-Z0-9\.\-]*
>>  persistent	[P|p][E|e][R|r][S|s][I|i][S|s][T|t][E|e][N|n][T|T]
>>  nack		[N|n][A|a][C|c][K|k]
>> @@ -63,9 +64,12 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
>>  "IPv4_interface"		{ return T_IPV4_IFACE; }
>>  "IPv6_interface"		{ return T_IPV6_IFACE; }
>>  "Interface"			{ return T_IFACE; }
>> +"TIPC_Destination_Name" 	{ return T_TIPC_DEST_NAME; }
>> +"TIPC_Name"			{ return T_TIPC_NAME; }
>>  "Multicast"			{ return T_MULTICAST; }
>>  "UDP"				{ return T_UDP; }
>>  "TCP"				{ return T_TCP; }
>> +"TIPC"                          { return T_TIPC; }
>>  "HashSize"			{ return T_HASHSIZE; }
>>  "RefreshTime"			{ return T_REFRESH; }
>>  "CacheTimeout"			{ return T_EXPIRE; }
>> @@ -149,6 +153,8 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
>>  {signed_integer}	{ yylval.val =3D atoi(yytext); return T_SIGNED_NUM=
BER; }
>>  {ip4}			{ yylval.string =3D strdup(yytext); return T_IP; }
>>  {ip6}			{ yylval.string =3D strdup(yytext); return T_IP; }
>> +{tipc_name}		{ yylval.string =3D strdup(yytext); return T_TIPC_NAME=
_VAL; }
>
> Can you use T_STRING instead? Then, you can check in the parser that
> the TIPC name is well-formed, i.e. integer:integer.
>
> Otherwise, print one parsing error.

I implemented a new type 'tipc_name', since there was such types for =20
IPV4 and IPV6 addresses, and I considered a TIPC name was the =20
equivalent of an IP address, that's why I did this at first.
After thinking about it twice, TIPC name is more like UDP/TCP port, =20
and TIPC node address/network ID would be like the IP address.

I can still correct that if you want me to.

>> +
>>  {path}			{ yylval.string =3D strdup(yytext); return T_PATH_VAL; }
>>  {alarm}			{ return T_ALARM; }
>>  {persistent}		{ fprintf(stderr, "\nWARNING: Now `persistent' mode "
>> diff --git a/src/read_config_yy.y b/src/read_config_yy.y
>> index b22784c..6273caa 100644
>> --- a/src/read_config_yy.y
>> +++ b/src/read_config_yy.y
>> @@ -74,8 +74,9 @@ static void __max_dedicated_links_reached(void);
>>  %token T_SCHEDULER T_TYPE T_PRIO T_NETLINK_EVENTS_RELIABLE
>>  %token T_DISABLE_INTERNAL_CACHE T_DISABLE_EXTERNAL_CACHE =20
>> T_ERROR_QUEUE_LENGTH
>>  %token T_OPTIONS T_TCP_WINDOW_TRACKING T_EXPECT_SYNC
>> +%token T_TIPC_DEST_NAME T_TIPC_NAME T_TIPC
>>
>> -%token <string> T_IP T_PATH_VAL
>> +%token <string> T_IP T_PATH_VAL T_TIPC_NAME_VAL
>>  %token <val> T_NUMBER
>>  %token <val> T_SIGNED_NUMBER
>>  %token <string> T_STRING
>> @@ -381,7 +382,7 @@ multicast_option : T_IPV4_IFACE T_IP
>>  multicast_option : T_IPV6_IFACE T_IP
>>  {
>>  	print_err(CTD_CFG_WARN, "`IPv6_interface' not required, ignoring")=
;
>> -}
>> +};
>
> please, don't include superfluous changes in patches.

Ok, I don't know what I did there, it's not even in my working version =
=20
of the file... sorry about that :x.

>>
>>  multicast_option : T_IFACE T_STRING
>>  {
>> @@ -440,6 +441,77 @@ multicast_option: T_CHECKSUM T_OFF
>>  	conf.channel[conf.channel_num].u.mcast.checksum =3D 1;
>>  };
>>
>> +tipc_line : T_TIPC '{' tipc_options '}'
>> +{
>> +	if (conf.channel_type_global !=3D CHANNEL_NONE &&
>> +	    conf.channel_type_global !=3D CHANNEL_TIPC) {
>> +		print_err(CTD_CFG_ERROR, "cannot use `TIPC' with other "
>> +					 "dedicated link protocols!");
>> +		exit(EXIT_FAILURE);
>> +	}
>> +	conf.channel_type_global =3D CHANNEL_TIPC;
>> +	conf.channel[conf.channel_num].channel_type =3D CHANNEL_TIPC;
>> +	// conf.channel[conf.channel_num].channel_flags =3D CHANNEL_F_BUFF=
ERED;
>> +	conf.channel_num++;
>> +};
>> +
>> +tipc_line : T_TIPC T_DEFAULT '{' tipc_options '}'
>> +{
>> +	if (conf.channel_type_global !=3D CHANNEL_NONE &&
>> +	    conf.channel_type_global !=3D CHANNEL_TIPC) {
>> +		print_err(CTD_CFG_ERROR, "cannot use `TIPC' with other "
>> +					 "dedicated link protocols!");
>> +		exit(EXIT_FAILURE);
>> +	}
>> +	conf.channel_type_global =3D CHANNEL_TIPC;
>> +	conf.channel[conf.channel_num].channel_type =3D CHANNEL_TIPC;
>> +	conf.channel[conf.channel_num].channel_flags =3D CHANNEL_F_DEFAULT=
; //|
>> +						       // CHANNEL_F_BUFFERED;
>> +	conf.channel_default =3D conf.channel_num;
>> +	conf.channel_num++;
>> +};
>> +
>> +tipc_options :
>> +	     | tipc_options tipc_option;
>> +
>> +tipc_option : T_TIPC_DEST_NAME T_TIPC_NAME_VAL
>> +{
>> +	__max_dedicated_links_reached();
>> +
>> +	if(sscanf($2, "%d:%d",
>> &conf.channel[conf.channel_num].u.tipc.client.type,
>> &conf.channel[conf.channel_num].u.tipc.client.instance) !=3D 2) {
>> +		print_err(CTD_CFG_WARN, "Please enter TIPC name in the form
>> type:instance (ex: 1000:50)");
>> +		break;
>> +	}
>> +	conf.channel[conf.channel_num].u.tipc.ipproto =3D AF_TIPC;
>> +};
>> +
>> +tipc_option : T_TIPC_NAME T_TIPC_NAME_VAL
>> +{
>> +	__max_dedicated_links_reached();
>> +
>> +	if(sscanf($2, "%d:%d",
>
> Define one buffer here and use snprintf. This doesn't look safe to me=
=2E

I already have the string buffered, and I want to extract integer =20
values out of it.
I searched for an snscanf() function, but I don't think there's one in =
=20
stdio.h.

>> &conf.channel[conf.channel_num].u.tipc.server.type,
>> &conf.channel[conf.channel_num].u.tipc.server.instance) !=3D 2) {
>> +		print_err(CTD_CFG_WARN, "Please enter TIPC name in the form
>> type:instance (ex: 1000:50)");
>> +		break;
>> +	}
>> +	conf.channel[conf.channel_num].u.tipc.ipproto =3D AF_TIPC;
>> +};
>> +
>> +tipc_option : T_IFACE T_STRING
>> +{
>> +	unsigned int idx;
>> +
>> +	__max_dedicated_links_reached();
>> +
>> +	strncpy(conf.channel[conf.channel_num].channel_ifname, $2, IFNAMSI=
Z);
>> +
>> +	idx =3D if_nametoindex($2);
>> +	if (!idx) {
>> +		print_err(CTD_CFG_WARN, "%s is an invalid interface", $2);
>> +		break;
>> +	}
>> +};
>> +
>> +
>
> remove extra empty line here.

done.

>>  udp_line : T_UDP '{' udp_options '}'
>>  {
>>  	if (conf.channel_type_global !=3D CHANNEL_NONE &&
>> @@ -800,6 +872,7 @@ sync_line: refreshtime
>>  	 | multicast_line
>>  	 | udp_line
>>  	 | tcp_line
>> +	 | tipc_line
>>  	 | relax_transitions
>>  	 | delay_destroy_msgs
>>  	 | sync_mode_alarm
>> diff --git a/src/tipc.c b/src/tipc.c
>> new file mode 100644
>> index 0000000..fb243f8
>> --- /dev/null
>> +++ b/src/tipc.c
>> @@ -0,0 +1,224 @@
>> +/*
>> + * (C) 2006-2009 by Pablo Neira Ayuso <pablo@netfilter.org>
>> + *
>> + * This program is free software; you can redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; either version 2 of the License, o=
r
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public Licens=
e
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>> + *
>> + * Description: multicast socket library
>> + */
>> +
>> +#include "tipc.h"
>> +
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <arpa/inet.h>
>> +#include <unistd.h>
>> +#include <string.h>
>> +#include <sys/ioctl.h>
>> +#include <net/if.h>
>> +#include <errno.h>
>> +#include <limits.h>
>> +#include <libnfnetlink/libnfnetlink.h>
>> +
>> +// #include <fcntl.h> /* used for debug purposes */
>
> you may want to define some constant like:
>
> #define CTD_TIPC_DEBUG 0
>
> #ifdef CTD_TIPC_DEBUG
> ...
> #endif
>
> So you can turn it on in compilation time without the C++ comments.

Ok. I'll go with it.

>> +
>> +struct tipc_sock *tipc_server_create(struct tipc_conf *conf)
>> +{
>> +	struct tipc_sock *m;
>
> Please, you have to use 8-chars indentation similar to other parts in
> the code. You can retab with vim by doing:
>
> :set noet|retab!

Ok, I used this command on tipc.c. Hope it fixed all the non-tabed spac=
es.

>> +	// int val =3D 0;
>> +
>> +	m =3D (struct tipc_sock *) malloc(sizeof(struct tipc_sock));
>> +	if (!m)
>> +		return NULL;
>> +	memset(m, 0, sizeof(struct tipc_sock));
>> +	m->sockaddr_len =3D sizeof(struct sockaddr_tipc);
>> +
>> +	m->addr.family =3D AF_TIPC;
>> +	m->addr.addrtype =3D TIPC_ADDR_NAME;
>> +	m->addr.scope =3D TIPC_CLUSTER_SCOPE;
>> +	m->addr.addr.name.name.type =3D conf->server.type;
>> +	m->addr.addr.name.name.instance =3D conf->server.instance;
>> +
>> +	if ((m->fd =3D socket(AF_TIPC, SOCK_RDM, 0)) =3D=3D -1) {
>> +		free(m);
>> +		return NULL;
>> +	}
>> +
>> +
>> +	// setsockopt(m->fd, SOL_TIPC, TIPC_DEST_DROPPABLE, &val,
>> sizeof(val)); /*used for debug purposes */
>
> Use the CTD_TIPC_DEBUG approach that I propose.
>
> Moreover, add some comment explaining the purpose if this (in this
> case, comment can be very useful).
>
>> +
>> +	if (bind(m->fd, (struct sockaddr *) &m->addr, m->sockaddr_len) =3D=
=3D -1) {
>> +		close(m->fd);
>> +		free(m);
>> +		return NULL;
>> +	}
>> +
>> +	return m;
>> +}
>> +
>> +void tipc_server_destroy(struct tipc_sock *m)
>> +{
>> +	close(m->fd);
>> +	free(m);
>> +}
>> +
>> +struct tipc_sock *tipc_client_create(struct tipc_conf *conf)
>> +{
>> +	struct tipc_sock *m;
>> +	// int val =3D 0;
>> +	int tipc_importance =3D TIPC_CRITICAL_IMPORTANCE;
>
> I think this should be a configurable parameter?

Yeah, fixed.

>> +
>> +	m =3D (struct tipc_sock *) malloc(sizeof(struct tipc_sock));
>> +	if (!m)
>> +		return NULL;
>> +	memset(m, 0, sizeof(struct tipc_sock));
>> +
>> +	m->addr.family =3D AF_TIPC;
>> +        m->addr.addrtype =3D TIPC_ADDR_NAME;
>> +        m->addr.addr.name.name.type =3D conf->client.type;
>> +        m->addr.addr.name.name.instance =3D conf->client.instance;
>
> indent problems, please fix.

done.

>> +	m->addr.addr.name.domain =3D 0;
>> +	m->sockaddr_len =3D sizeof(struct sockaddr_tipc);
>> +
>> +	if ((m->fd =3D socket(AF_TIPC, SOCK_RDM, 0)) =3D=3D -1) {
>> +		free(m);
>> +		return NULL;
>> +	}
>> +
>> +	/* setsockopt(m->fd, SOL_TIPC, TIPC_DEST_DROPPABLE, &val, sizeof(v=
al));
>> +	   fcntl(m->fd, F_SETFL, O_NONBLOCK); */ // used for debug purpose=
s
>
> non-blocking sockets disabled, why?

Actually, I think it allows non-blocking sockets.
I used this during the debug process after discussion with Allan =20
Stephens from the TIPC mailing list, who suggested to introduce some =20
non-blocking receive operation to test the rcv() function return value =
=20
(0 would mean some packets are returned and the other side is =20
congested).

I didn't know where to put that, so I just implemented a non blocking =20
rcv() after we do a tipc_send() (which is called quite often during =20
heavy benchmarks on the primary firewall in a primary-backup =20
configuration).

Maybe just testing the ret value for 0's in the standard =20
tipc_receive() function would have worked just the same, I could try =20
that way and see how it goes.

>> +
>> +	setsockopt(m->fd, SOL_TIPC, TIPC_IMPORTANCE,  &tipc_importance,
>> sizeof(tipc_importance));
>> +
>> +	return m;
>> +}
>> +
>> +void tipc_client_destroy(struct tipc_sock *m)
>> +{
>> +	close(m->fd);
>> +	free(m);
>> +}
>> +
>> +ssize_t tipc_send(struct tipc_sock *m, const void *data, int size)
>> +{
>> +	ssize_t ret;
>> +	// char buf[50];
>> +
>> +	ret =3D sendto(m->fd,
>> +		     data,
>> +		     size,
>> +		     0,
>> +		     (struct sockaddr *) &m->addr,
>> +		     m->sockaddr_len);
>> +	if (ret =3D=3D -1) {
>> +		m->stats.error++;
>> +		return ret;
>> +	}
>> +
>> +	/* if(!recv(m->fd,buf,sizeof(buf),0))
>> +		m->stats.returned_messages++; */ // debug
>> +
>> +	m->stats.bytes +=3D ret;
>> +	m->stats.messages++;
>> +
>> +	return ret;
>> +}
>> +
>> +ssize_t tipc_recv(struct tipc_sock *m, void *data, int size)
>> +{
>> +	ssize_t ret;
>> +	socklen_t sin_size =3D sizeof(struct sockaddr_in);
>> +
>> +        ret =3D recvfrom(m->fd,
>> +		       data,
>> +		       size,
>> +		       0,
>> +		       (struct sockaddr *)&m->addr,
>> +		       &sin_size);
>> +	if (ret =3D=3D -1) {
>> +		if (errno !=3D EAGAIN)
>> +			m->stats.error++;
>> +		return ret;
>> +	}
>> +
>> +	/* if (!ret)
>> +		m->stats.returned_messages++; */ // debug
>> +
>> +	m->stats.bytes +=3D ret;
>> +	m->stats.messages++;
>> +
>> +	return ret;
>> +}
>> +
>> +int tipc_get_fd(struct tipc_sock *m)
>> +{
>> +	return m->fd;
>> +}
>> +
>> +int tipc_isset(struct tipc_sock *m, fd_set *readfds)
>> +{
>> +	return FD_ISSET(m->fd, readfds);
>> +}
>> +
>> +int
>> +tipc_snprintf_stats(char *buf, size_t buflen, char *ifname,
>> +		     struct tipc_stats *s, struct tipc_stats *r)
>> +{
>> +	size_t size;
>> +
>> +	size =3D snprintf(buf, buflen, "tipc traffic (active device=3D%s):=
\n"
>> +				     "%20llu Bytes sent "
>> +				     "%20llu Bytes recv\n"
>> +				     "%20llu Pckts sent "
>> +				     "%20llu Pckts recv\n"
>> +				     "%20llu Error send "
>> +				     "%20llu Error recv\n",
>> +				     //"%20llu Returned messages\n\n",
>> +				     ifname,
>> +				     (unsigned long long)s->bytes,
>> +				     (unsigned long long)r->bytes,
>> +				     (unsigned long long)s->messages,
>> +				     (unsigned long long)r->messages,
>> +				     (unsigned long long)s->error,
>> +				     (unsigned long long)r->error);
>> +				     //(unsigned long long)s->returned_messages);
>> +	return size;
>> +}
>> +
>> +int
>> +tipc_snprintf_stats2(char *buf, size_t buflen, const char *ifname,
>> +		      const char *status, int active,
>> +		      struct tipc_stats *s, struct tipc_stats *r)
>> +{
>> +	size_t size;
>> +
>> +	size =3D snprintf(buf, buflen,
>> +			"tipc traffic device=3D%s status=3D%s role=3D%s:\n"
>> +			"%20llu Bytes sent "
>> +			"%20llu Bytes recv\n"
>> +			"%20llu Pckts sent "
>> +			"%20llu Pckts recv\n"
>> +			"%20llu Error send "
>> +			"%20llu Error recv\n",
>> +			//"%20llu Returned messages\n\n",
>> +			ifname, status, active ? "ACTIVE" : "BACKUP",
>> +			(unsigned long long)s->bytes,
>> +			(unsigned long long)r->bytes,
>> +			(unsigned long long)s->messages,
>> +			(unsigned long long)r->messages,
>> +			(unsigned long long)s->error,
>> +			(unsigned long long)r->error);
>> +			//(unsigned long long)s->returned_messages);
>> +	return size;
>> +}
>
> Some description in the patch will come very useful, for example:
>
> [PATCH] conntrackd: basic TIPC implementation
>
> This patch adds TIPC support for conntrackd, you can enable it with
> the following configuration in conntrackd.conf
>
> ... example here.
>
> TIPC is the the protocol define in RFC ... its purpose is...
>
> I think that TIPC can be useful for the following reasons:
>
> ... reasons here
>
> My initial experiments show that ...
>
> and so on. Thus, people can track this change in the
> git.netfilter.org, this is how it usually works for FOSS projects.

Ok, I'll try to add some more descriptions later on.

Also, do you want me to post another diff with all the fixed changes =20
in this thread ?

Thanks for the feedback.

> Thanks.
>
>



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
