From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] RPC match and conntrack modules v2.1
Date: Fri, 10 Jan 2003 14:45:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030110134553.GT1353@sunbeam.de.gnumonks.org>
References: <200301100926.h0A9QwA05558@singularity.tronunltd.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TegBI+r9roYdcP94"
Cc: netfilter-devel@lists.netfilter.org, marcelo.lima@dcc.unicamp.br
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ian Latter <Ian.Latter@mq.edu.au>
Content-Disposition: inline
In-Reply-To: <200301100926.h0A9QwA05558@singularity.tronunltd.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--TegBI+r9roYdcP94
Content-Type: multipart/mixed; boundary="jPC/Tkukgh9ZDT79"
Content-Disposition: inline


--jPC/Tkukgh9ZDT79
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2003 at 07:26:57PM +1100, Ian Latter wrote:
> Hello all,
>   I have uploaded, to the ftp.netfilter.org site, a copy of the new patch-
> o-matic ready code.  Let me know what you think of it ... I don't have a
> lot of need for RPC traffic filtering, but when I realised that the Linux
> kernel filtering for RPCs was limited to the old "record-rpc" modules, I
> had to upgrade them ... I wanted some of that CheckPoint functionality
> in my favourite filtering API  :oP

This is cool stuff.  Thanks a lot.  The kind of contribution I really
like :)

> Also note that I've updated the module for newnat, and it compiles
> cleanly against 2.4.20.  I was half tempted to author the NAT module
> to go with the conntrack and match, but this code has taken too=20
> much time already.

Sorry, I didn't understand the part about the NAT module.  Are you
saying that NAT support is not functional right now?

>   Comments welcome and appreciated.

See attached patch.  Mostly CodingStyle updates (you seem to like 8 spaces
instead of tab), but also a minor fix:

- when unloading, only unregister up to ports_n_c ports

btw: I'd really love to see the large chunk of code in the switch
statement of the match() function in ipt_rpc.c be split up in seperate
functions (thus reducing indentation and improving readability).

I don't know, but I think esp. in cases where you have lots of rpc
activity (NFS?, I'm not an RPC expert) it might be wise to use a slab
cache for the 'struct request_p' list items.

Please integrate my patch [and maybe consider my suggestions, that's of
course up to you], test it and resubmit it.

Thanks!

> Regards,
> Ian Latter

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--jPC/Tkukgh9ZDT79
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rpc.patch.update"
Content-Transfer-Encoding: quoted-printable

--- rpc.patch	Fri Jan 10 14:24:58 2003
+++ rpc.patch.new	Fri Jan 10 14:40:40 2003
@@ -1,6 +1,6 @@
 --- linux/net/ipv4/netfilter/ip_conntrack_rpc_tcp.c.old	Thu Jan  1 10:00:0=
0 1970
 +++ linux/net/ipv4/netfilter/ip_conntrack_rpc_tcp.c	Fri Jan 10 18:53:15 20=
03
-@@ -0,0 +1,477 @@
+@@ -0,0 +1,482 @@
 +/* RPC extension for IP (TCP) connection tracking, Version 2.1
 + * (C) 2000 by Marcelo Barbosa Lima <marcelo.lima@dcc.unicamp.br>
 + *       - original rpc tracking module
@@ -28,20 +28,20 @@
 + **
 + *      Note to all:
 + *
-+ *        RPCs should not be exposed to the internet - ask the Pentagon;
++ *	RPCs should not be exposed to the internet - ask the Pentagon;
 + *
-+ *          "The unidentified crackers pleaded guilty in July to charges
-+ *           of juvenile delinquency stemming from a string of Pentagon
-+ *           network intrusions in February.
-+ *
-+ *           The youths, going by the names TooShort and Makaveli, used
-+ *           a common server security hole to break in, according to
-+ *           Dane Jasper, owner of the California Internet service
-+ *           provider, Sonic. They used the hole, known as the 'statd'
-+ *           exploit, to attempt more than 800 break-ins, Jasper said."
++ *	  "The unidentified crackers pleaded guilty in July to charges
++ *	   of juvenile delinquency stemming from a string of Pentagon
++ *	   network intrusions in February.
++ *
++ *	   The youths, going by the names TooShort and Makaveli, used
++ *	   a common server security hole to break in, according to
++ *	   Dane Jasper, owner of the California Internet service
++ *	   provider, Sonic. They used the hole, known as the 'statd'
++ *	   exploit, to attempt more than 800 break-ins, Jasper said."
 + *
-+ *        From: Wired News; "Pentagon Kids Kicked Off Grid" - Nov 6, 1998
-+ *        URL:  http://www.wired.com/news/politics/0,1283,16098,00.html
++ *	From: Wired News; "Pentagon Kids Kicked Off Grid" - Nov 6, 1998
++ *	URL:  http://www.wired.com/news/politics/0,1283,16098,00.html
 + **
 + */
 +
@@ -88,12 +88,13 @@
 +#include <linux/netfilter_ipv4/listhelp.h>
 +
 +/* For future conections RPC, using client's cache bindings
-+ * I'll use ip_conntrack_lock to lock these lists           */
++ * I'll use ip_conntrack_lock to lock these lists	   */
 +
 +LIST_HEAD(request_p_list_tcp);
 +
 +
-+static void delete_request_p(unsigned long request_p_ul) {
++static void delete_request_p(unsigned long request_p_ul)=20
++{
 +	struct request_p *p =3D (void *)request_p_ul;
 +=09
 +	WRITE_LOCK(&ipct_rpc_tcp_lock);
@@ -104,7 +105,8 @@
 +}
 +
 +
-+static void req_cl(struct request_p * r){
++static void req_cl(struct request_p * r)
++{
 +	WRITE_LOCK(&ipct_rpc_tcp_lock);
 +	del_timer(&r->timeout);
 +	LIST_DELETE(&request_p_list_tcp, r);
@@ -114,38 +116,41 @@
 +}
 +
 +
-+static void clean_request(struct list_head *list){
++static void clean_request(struct list_head *list)
++{
 +	struct list_head *first =3D list->prev;
 +	struct list_head *temp =3D list->next;
 +	struct list_head *aux;
 +
-+	if(list_empty(list)) return;
++	if (list_empty(list))
++		return;
 +
-+	    while(first !=3D temp) {
++	while (first !=3D temp) {
 +		aux =3D temp->next;
 +		req_cl((struct request_p *)temp);
 +		temp =3D aux;=09
-+	    }
++	}
 +	req_cl((struct request_p *)temp);
 +	return;
 +}
 +
 +
 +static void alloc_request_p(u_int32_t xid, u_int16_t proto, u_int32_t ip,
-+		     u_int16_t port){
++		     u_int16_t port)
++{
 +	struct request_p *req_p;
-+       =20
-+        /* Verifies if entry already exists */
-+        WRITE_LOCK(&ipct_rpc_tcp_lock);
-+        req_p =3D LIST_FIND(&request_p_list_tcp, request_p_cmp,
++=09
++	/* Verifies if entry already exists */
++	WRITE_LOCK(&ipct_rpc_tcp_lock);
++	req_p =3D LIST_FIND(&request_p_list_tcp, request_p_cmp,
 +		struct request_p *, xid, ip, port);
 +
-+        if(req_p){
++	if (req_p) {
 +		/* Refresh timeout */
 +		if (del_timer(&req_p->timeout)) {
-+		   req_p->timeout.expires =3D jiffies + EXP;
-+		   add_timer(&req_p->timeout);=09
-+	        }=20
++			req_p->timeout.expires =3D jiffies + EXP;
++			add_timer(&req_p->timeout);=09
++		}=20
 +		WRITE_UNLOCK(&ipct_rpc_tcp_lock);
 +		return;=09
 +
@@ -154,7 +159,7 @@
 +=09
 +	/* Allocate new request_p */
 +	req_p =3D (struct request_p *) kmalloc(sizeof(struct request_p), GFP_ATO=
MIC);
-+        if(!req_p) {
++	if (!req_p) {
 + 		DEBUGP("can't allocate request_p\n");
 +		return;		=09
 +	}
@@ -162,10 +167,10 @@
 +		{ { NULL, NULL }, jiffies + EXP, (unsigned long)req_p,
 +			NULL }});=20
 +     =20
-+        /*Initialize timer */
++	/* Initialize timer */
 +	init_timer(&req_p->timeout);
 +	req_p->timeout.function =3D delete_request_p;
-+        add_timer(&req_p->timeout);=20
++	add_timer(&req_p->timeout);=20
 +
 +	/* Put in list */
 +	WRITE_LOCK(&ipct_rpc_tcp_lock);
@@ -194,8 +199,8 @@
 +
 +	DEBUGP("new packet to evaluate ..\n");
 +
-+        /* This works for packets like handshake packets, ignore */
-+        if (len =3D=3D ((tcph->doff + iph->ihl) * 4)) {
++	/* This works for packets like handshake packets, ignore */
++	if (len =3D=3D ((tcph->doff + iph->ihl) * 4)) {
 +		DEBUGP("packet has no data (may still be handshaking). [skip]\n");
 +		return NF_ACCEPT;
 +	}
@@ -228,13 +233,13 @@
 +	}
 +
 +
-+        /* If packet is client packet */
++	/* If packet is client packet */
 +	if (dir =3D=3D IP_CT_DIR_ORIGINAL) {
 +
 +		DEBUGP("packet is from the initiator. [cont]\n");
 +
 +		/* Tests if packet len is ok */
-+		if((tcplen - (tcph->doff * 4)) !=3D 60) {
++		if ((tcplen - (tcph->doff * 4)) !=3D 60) {
 +			DEBUGP("packet length is not correct. [skip]\n");
 +			return NF_ACCEPT;
 +		}
@@ -249,7 +254,7 @@
 +		data =3D data + 5;
 +
 +		/* Is one get port procedure? */
-+		if(IXDR_GET_INT32(data) =3D=3D 3) {=20
++		if (IXDR_GET_INT32(data) =3D=3D 3) {=20
 +
 +			data++;
 +	=09
@@ -285,7 +290,7 @@
 +	DEBUGP("packet is from the receiver. [cont]\n");
 +
 +	/* Tests if packet len is ok */
-+	if((tcplen - (tcph->doff * 4)) !=3D 32) {
++	if ((tcplen - (tcph->doff * 4)) !=3D 32) {
 +		DEBUGP("packet length is not correct. [skip]\n");
 +		return NF_ACCEPT;
 +	}
@@ -299,21 +304,21 @@
 +		ct->tuplehash[!dir].tuple.src.u.all);
 +
 +	/* Drop unexpected packets */
-+	if(!req_p) {
++	if (!req_p) {
 +		DEBUGP("packet is not expected. [skip]\n");
 +		return NF_ACCEPT;
 +	}
 +	data =3D data++;
 +
 +	/* Verifies if packet is really a reply packet */
-+	if(IXDR_GET_INT32(data) !=3D 1) {
++	if (IXDR_GET_INT32(data) !=3D 1) {
 +		DEBUGP("packet is not a valid RPC reply. [skip]\n");
 +		return NF_ACCEPT;
 +	}
 +	data++;
 +
 +	/* Is status accept? */
-+	if(IXDR_GET_INT32(data)) {
++	if (IXDR_GET_INT32(data)) {
 +		DEBUGP("packet is not an RPC accept. [skip]\n");
 +		return NF_ACCEPT;
 +	}
@@ -323,18 +328,18 @@
 +	data =3D data + IXDR_GET_INT32(data) + 2;
 +
 +	/* Is accpet status "success"? */
-+	if(IXDR_GET_INT32(data)) {
++	if (IXDR_GET_INT32(data)) {
 +		DEBUGP("packet is not an RPC accept status of success. [skip]\n");
 +		return NF_ACCEPT;
 +	}
 +	data++;
 +
-+	/* Get server port number */         =20
++	/* Get server port number */	 =20
 +	port_buf =3D (u_int16_t) IXDR_GET_INT32(data);
 +
 +	/* Alright. This binding must be in internal expect list;
 +	 * If port =3D=3D 0, then this service is not registred.   */
-+	if(port_buf) {
++	if (port_buf) {
 +		DEBUGP("port found: %u\n", port_buf);
 +
 +		memset(&expect, 0, sizeof(expect));
@@ -345,7 +350,7 @@
 +		exp->mask.src.ip =3D 0xffffffff;
 +		exp->mask.dst.ip =3D 0xffffffff;
 +
-+		switch(req_p->proto) {
++		switch (req_p->proto) {
 +			case IPPROTO_UDP:
 +				exp->tuple.src.u.udp.port =3D 0;
 +				exp->tuple.dst.u.udp.port =3D htons(port_buf);
@@ -463,7 +468,7 @@
 +	DEBUGP("cleaning request list\n");
 +	clean_request(&request_p_list_tcp);
 +
-+	for (port =3D 0; (port < MAX_PORTS) && ports[port]; port++) {
++	for (port =3D 0; (port < ports_n_c) && ports[port]; port++) {
 +		DEBUGP("unregistering port %d\n", ports[port]);
 +		ip_conntrack_helper_unregister(&rpc_helpers[port]);
 +	}
@@ -480,7 +485,7 @@
 +
 --- linux/net/ipv4/netfilter/ip_conntrack_rpc_udp.c.old	Thu Jan  1 10:00:0=
0 1970
 +++ linux/net/ipv4/netfilter/ip_conntrack_rpc_udp.c	Fri Jan 10 18:53:09 20=
03
-@@ -0,0 +1,466 @@
+@@ -0,0 +1,471 @@
 +/* RPC extension for IP (UDP) connection tracking, Version 2.1
 + * (C) 2000 by Marcelo Barbosa Lima <marcelo.lima@dcc.unicamp.br>
 + *       - original rpc tracking module
@@ -508,20 +513,20 @@
 + **
 + *      Note to all:
 + *
-+ *        RPCs should not be exposed to the internet - ask the Pentagon;
++ *	RPCs should not be exposed to the internet - ask the Pentagon;
 + *
-+ *          "The unidentified crackers pleaded guilty in July to charges
-+ *           of juvenile delinquency stemming from a string of Pentagon
-+ *           network intrusions in February.
-+ *
-+ *           The youths, going by the names TooShort and Makaveli, used
-+ *           a common server security hole to break in, according to
-+ *           Dane Jasper, owner of the California Internet service
-+ *           provider, Sonic. They used the hole, known as the 'statd'
-+ *           exploit, to attempt more than 800 break-ins, Jasper said."
++ *	  "The unidentified crackers pleaded guilty in July to charges
++ *	   of juvenile delinquency stemming from a string of Pentagon
++ *	   network intrusions in February.
++ *
++ *	   The youths, going by the names TooShort and Makaveli, used
++ *	   a common server security hole to break in, according to
++ *	   Dane Jasper, owner of the California Internet service
++ *	   provider, Sonic. They used the hole, known as the 'statd'
++ *	   exploit, to attempt more than 800 break-ins, Jasper said."
 + *
-+ *        From: Wired News; "Pentagon Kids Kicked Off Grid" - Nov 6, 1998
-+ *        URL:  http://www.wired.com/news/politics/0,1283,16098,00.html
++ *	From: Wired News; "Pentagon Kids Kicked Off Grid" - Nov 6, 1998
++ *	URL:  http://www.wired.com/news/politics/0,1283,16098,00.html
 + **
 + */
 +
@@ -573,7 +578,8 @@
 +LIST_HEAD(request_p_list_udp);
 +
 +
-+static void delete_request_p(unsigned long request_p_ul) {
++static void delete_request_p(unsigned long request_p_ul)
++{
 +	struct request_p *p =3D (void *)request_p_ul;
 +=09
 +	WRITE_LOCK(&ipct_rpc_udp_lock);
@@ -584,7 +590,8 @@
 +}
 +
 +
-+static void req_cl(struct request_p * r){
++static void req_cl(struct request_p * r)
++{
 +	WRITE_LOCK(&ipct_rpc_udp_lock);
 +	del_timer(&r->timeout);
 +	LIST_DELETE(&request_p_list_udp, r);
@@ -594,25 +601,28 @@
 +}
 +
 +
-+static void clean_request(struct list_head *list){
++static void clean_request(struct list_head *list)
++{
 +	struct list_head *first =3D list->prev;
 +	struct list_head *temp =3D list->next;
 +	struct list_head *aux;
 +
-+	if(list_empty(list)) return;
++	if (list_empty(list))
++		return;
 +
-+	    while(first !=3D temp) {
++	while (first !=3D temp) {
 +		aux =3D temp->next;
 +		req_cl((struct request_p *)temp);
 +		temp =3D aux;=09
-+	    }
++	}
 +	req_cl((struct request_p *)temp);
 +	return;
 +}
 +
 +
 +static void alloc_request_p(u_int32_t xid, u_int16_t proto, u_int32_t ip,
-+		     u_int16_t port){
++		     u_int16_t port)
++{
 +	struct request_p *req_p;
 +
 +	/* Verifies if entry already exists */
@@ -620,7 +630,7 @@
 +	req_p =3D LIST_FIND(&request_p_list_udp, request_p_cmp,
 +			struct request_p *, xid, ip, port);
 +
-+	if(req_p) {
++	if (req_p) {
 +		/* Refresh timeout */
 +		if (del_timer(&req_p->timeout)) {
 +			req_p->timeout.expires =3D jiffies + EXP;
@@ -634,7 +644,7 @@
 +=09
 +	/* Allocate new request_p */
 +	req_p =3D (struct request_p *) kmalloc(sizeof(struct request_p), GFP_ATO=
MIC);
-+	if(!req_p) {
++	if (!req_p) {
 + 		DEBUGP("can't allocate request_p\n");
 +		return;		=09
 +	}
@@ -686,7 +696,7 @@
 +
 +
 +	/* FIXME: Source route IP option packets --RR */
-+	if(*chsm){
++	if (*chsm) {
 +		if (csum_tcpudp_magic(iph->saddr, iph->daddr, udplen, IPPROTO_UDP,
 +		    csum_partial((char *)udph, udplen, 0))) {
 +			DEBUGP("[note: failure to get past this error may indicate source rout=
ing]\n");
@@ -757,7 +767,7 @@
 +	}
 +
 +	/* Tests if packet len is ok */
-+	if((udplen - sizeof(struct udphdr)) !=3D 28) {
++	if ((udplen - sizeof(struct udphdr)) !=3D 28) {
 +		DEBUGP("packet length is not correct. [skip]\n");
 +		return NF_ACCEPT;
 +	}
@@ -768,21 +778,21 @@
 +		ct->tuplehash[!dir].tuple.src.u.all);
 +
 +	/* Drop unexpected packets */
-+	if(!req_p) {
++	if (!req_p) {
 +		DEBUGP("packet is not expected. [skip]\n");
 +		return NF_ACCEPT;
 +	}
 +	data =3D data++;
 +
 +	/* Verifies if packet is really a reply packet */
-+	if(IXDR_GET_INT32(data) !=3D 1) {
++	if (IXDR_GET_INT32(data) !=3D 1) {
 +		DEBUGP("packet is not a valid RPC reply. [skip]\n");
 +		return NF_ACCEPT;
 +	}
 +	data++;
 +
 +	/* Is status accept? */
-+	if(IXDR_GET_INT32(data)) {
++	if (IXDR_GET_INT32(data)) {
 +		DEBUGP("packet is not an RPC accept. [skip]\n");
 +		return NF_ACCEPT;
 +	}
@@ -792,7 +802,7 @@
 +	data =3D data + IXDR_GET_INT32(data) + 2;
 +
 +	/* Is accpet status "success"? */
-+	if(IXDR_GET_INT32(data)) {
++	if (IXDR_GET_INT32(data)) {
 +		DEBUGP("packet is not an RPC accept status of success. [skip]\n");
 +		return NF_ACCEPT;
 +	}
@@ -803,7 +813,7 @@
 +
 +	/* Alright. This binding must be in internal expect list;
 +	 * If port =3D=3D 0, then this service is not registred.   */
-+	if(port_buf) {
++	if (port_buf) {
 +		DEBUGP("port found: %u\n", port_buf);
 +
 +		memset(&expect, 0, sizeof(expect));
@@ -932,7 +942,7 @@
 +	DEBUGP("cleaning request list\n");
 +	clean_request(&request_p_list_udp);
 +
-+	for (port =3D 0; (port < MAX_PORTS) && ports[port]; port++) {
++	for (port =3D 0; (port < ports_n_c) && ports[port]; port++) {
 +		DEBUGP("unregistering port %d\n", ports[port]);
 +		ip_conntrack_helper_unregister(&rpc_helpers[port]);
 +	}
@@ -977,20 +987,20 @@
 + **
 + *      Note to all:
 + *
-+ *        RPCs should not be exposed to the internet - ask the Pentagon;
++ *	RPCs should not be exposed to the internet - ask the Pentagon;
 + *
-+ *          "The unidentified crackers pleaded guilty in July to charges
-+ *           of juvenile delinquency stemming from a string of Pentagon
-+ *           network intrusions in February.
-+ *
-+ *           The youths, going by the names TooShort and Makaveli, used
-+ *           a common server security hole to break in, according to
-+ *           Dane Jasper, owner of the California Internet service
-+ *           provider, Sonic. They used the hole, known as the 'statd'
-+ *           exploit, to attempt more than 800 break-ins, Jasper said."
++ *	  "The unidentified crackers pleaded guilty in July to charges
++ *	   of juvenile delinquency stemming from a string of Pentagon
++ *	   network intrusions in February.
++ *
++ *	   The youths, going by the names TooShort and Makaveli, used
++ *	   a common server security hole to break in, according to
++ *	   Dane Jasper, owner of the California Internet service
++ *	   provider, Sonic. They used the hole, known as the 'statd'
++ *	   exploit, to attempt more than 800 break-ins, Jasper said."
 + *
-+ *        From: Wired News; "Pentagon Kids Kicked Off Grid" - Nov 6, 1998
-+ *        URL:  http://www.wired.com/news/politics/0,1283,16098,00.html
++ *	From: Wired News; "Pentagon Kids Kicked Off Grid" - Nov 6, 1998
++ *	URL:  http://www.wired.com/news/politics/0,1283,16098,00.html
 + **
 + */
 +
@@ -1082,22 +1092,22 @@
 +{
 +	int   proc_ctr;
 +	char *proc_ptr;
-+        unsigned int proc_num;
++	unsigned int proc_num;
 +
 +	DEBUGP("entered match_rpcs [%i] [%i] ..\n", i_procs, proc);
 +
-+	if(i_procs =3D=3D -1)
++	if (i_procs =3D=3D -1)
 +		return 1;
 +
-+        for (proc_ctr=3D0; proc_ctr <=3D i_procs; proc_ctr++) {
++	for (proc_ctr=3D0; proc_ctr <=3D i_procs; proc_ctr++) {
 +
-+                proc_ptr =3D c_procs;
-+                proc_ptr +=3D proc_ctr * IPT_RPC_CHAR_LEN;
-+                proc_num =3D k_atoi(proc_ptr);
++		proc_ptr =3D c_procs;
++		proc_ptr +=3D proc_ctr * IPT_RPC_CHAR_LEN;
++		proc_num =3D k_atoi(proc_ptr);
 +
-+		if(proc_num =3D=3D proc)
++		if (proc_num =3D=3D proc)
 +			return 1;
-+        }
++	}
 +	return 0;
 +}
 +
@@ -1111,7 +1121,7 @@
 +	const u_int32_t *data;
 +	enum ip_conntrack_dir dir;
 +	const struct tcphdr *tcp;
-+        const struct ipt_rpc_info *rpcinfo =3D matchinfo;
++	const struct ipt_rpc_info *rpcinfo =3D matchinfo;
 +	struct request_p *req_p;
 +	u_int32_t xid;
 +	int port, portsok;
@@ -1125,7 +1135,7 @@
 +		dir =3D CTINFO2DIR(ctinfo);
 +
 +		/* we only want the client to server packets for matching */
-+		if(dir !=3D IP_CT_DIR_ORIGINAL)
++		if (dir !=3D IP_CT_DIR_ORIGINAL)
 +			return 0;
 +
 +		/* This does sanity checking on UDP or TCP packets,
@@ -1134,24 +1144,24 @@
 +		 * communications with the portmapper.
 +		 */
 +
-+		switch(ct->tuplehash[0].tuple.dst.protonum) {
++		switch (ct->tuplehash[0].tuple.dst.protonum) {
 +
 +		case IPPROTO_UDP:
 +			DEBUGP("PROTO_UDP [cont]\n");
-+			if(offset =3D=3D 0 && datalen < sizeof(struct udphdr)) {
++			if (offset =3D=3D 0 && datalen < sizeof(struct udphdr)) {
 +				DEBUGP("UDP packet does not contain a complete UDP header. [drop]\n");
 +				return 0;
 +			}
-+			for(port=3D0,portsok=3D0; port <=3D ports_n_c; port++) {
-+				if(ntohs(ct->tuplehash[dir].tuple.dst.u.all) =3D=3D ports[port]) {
++			for (port=3D0,portsok=3D0; port <=3D ports_n_c; port++) {
++				if (ntohs(ct->tuplehash[dir].tuple.dst.u.all) =3D=3D ports[port]) {
 +					portsok++;
 +					break;
 +				}
 +			}
-+			if(portsok =3D=3D 1) {
-+				if((datalen - sizeof(struct udphdr)) !=3D 56) {
++			if (portsok =3D=3D 1) {
++				if ((datalen - sizeof(struct udphdr)) !=3D 56) {
 +					DEBUGP("UDP packet length is not correct for RPC content. [skip]\n");
-+					if(rpcinfo->strict =3D=3D 1)
++					if (rpcinfo->strict =3D=3D 1)
 +						*hotdrop =3D 1;
 +					return 0;
 +				}
@@ -1165,7 +1175,7 @@
 +
 +				/* Get RPC requestor */
 +				data =3D (const u_int32_t *)hdr + 7;
-+				if(IXDR_GET_INT32(data) !=3D 3) {
++				if (IXDR_GET_INT32(data) !=3D 3) {
 +					DEBUGP("UDP packet contains an invalid (non \"get\") requestor. [ski=
p]\n");
 +					if(rpcinfo->strict =3D=3D 1)
 +						*hotdrop =3D 1;
@@ -1175,8 +1185,8 @@
 +
 +				/* Get RPC procedure */
 +				data =3D (const u_int32_t *)hdr + 12;
-+                		if(match_rpcs((char *)&rpcinfo->c_procs,
-+				   rpcinfo->i_procs, IXDR_GET_INT32(data)) =3D=3D 0) {
++				if (match_rpcs((char *)&rpcinfo->c_procs,
++				    rpcinfo->i_procs, IXDR_GET_INT32(data)) =3D=3D 0) {
 +					DEBUGP("UDP packet contains illegal procedure request [%u]. [drop]\n=
",
 +						(unsigned int)IXDR_GET_INT32(data));
 +
@@ -1187,7 +1197,7 @@
 +							  ct->tuplehash[dir].tuple.src.ip,
 +							  ct->tuplehash[dir].tuple.src.u.all);
 +
-+					if(req_p){
++					if (req_p) {
 +						DEBUGP("found req_p for xid=3D%u proto=3D17 %u.%u.%u.%u:%u\n", xid,=
=20
 +						NIPQUAD(ct->tuplehash[dir].tuple.src.ip),
 +						ntohs(ct->tuplehash[dir].tuple.src.u.all));
@@ -1217,20 +1227,20 @@
 +	=09
 +		case IPPROTO_TCP:
 +			DEBUGP("PROTO_TCP [cont]\n");
-+			if(offset =3D=3D 0 && datalen < sizeof(struct tcphdr)) {
++			if (offset =3D=3D 0 && datalen < sizeof(struct tcphdr)) {
 +				DEBUGP("TCP packet does not contain a complete TCP header. [drop]\n");
 +				return 0;
 +			}=09
-+			if(ntohs(ct->tuplehash[dir].tuple.dst.u.all) =3D=3D 111) {=20
++			if (ntohs(ct->tuplehash[dir].tuple.dst.u.all) =3D=3D 111) {=20
 +
 +				tcp =3D hdr;
-+				if(datalen =3D=3D (tcp->doff * 4)) {
++				if (datalen =3D=3D (tcp->doff * 4)) {
 +					DEBUGP("TCP packet does not contain any data. [match]\n");
 +					return (1 && (!offset));
 +				}
 +
 +				/* Tests if packet len is ok */
-+				if((datalen - (tcp->doff * 4)) !=3D 60) {
++				if ((datalen - (tcp->doff * 4)) !=3D 60) {
 +					DEBUGP("TCP packet length is not correct for RPC content. [skip]\n");
 +					if(rpcinfo->strict =3D=3D 1)
 +						*hotdrop =3D 1;
@@ -1246,9 +1256,9 @@
 +
 +				/* Get RPC requestor */
 +				data =3D (const u_int32_t *)tcp + tcp->doff + 6;=09
-+				if(IXDR_GET_INT32(data) !=3D 3) {
++				if (IXDR_GET_INT32(data) !=3D 3) {
 +					DEBUGP("TCP packet contains an invalid (non \"get\") requestor. [ski=
p]\n");
-+					if(rpcinfo->strict =3D=3D 1)
++					if (rpcinfo->strict =3D=3D 1)
 +						*hotdrop =3D 1;
 +					return 0;
 +				}
@@ -1256,8 +1266,8 @@
 +
 +				/* Get RPC procedure */
 +				data =3D (const u_int32_t *)tcp + tcp->doff + 11;
-+                		if(match_rpcs((char *)&rpcinfo->c_procs,
-+				   rpcinfo->i_procs, IXDR_GET_INT32(data)) =3D=3D 0) {
++				if (match_rpcs((char *)&rpcinfo->c_procs,
++				    rpcinfo->i_procs, IXDR_GET_INT32(data)) =3D=3D 0) {
 +					DEBUGP("TCP packet contains illegal procedure request [%u]. [drop]\n=
",
 +						(unsigned int)IXDR_GET_INT32(data));
 +
@@ -1267,7 +1277,7 @@
 +							  ct->tuplehash[dir].tuple.src.ip,
 +							  ct->tuplehash[dir].tuple.src.u.all);
 +
-+					if(req_p){
++					if (req_p) {
 +						DEBUGP("found req_p for xid=3D%u proto=3D6 %u.%u.%u.%u:%u\n", xid,=
=20
 +							NIPQUAD(ct->tuplehash[dir].tuple.src.ip),
 +							ntohs(ct->tuplehash[dir].tuple.src.u.all));
@@ -1306,19 +1316,19 @@
 +
 +
 +static int checkentry(const char *tablename, const struct ipt_ip *ip, voi=
d *matchinfo,
-+                   unsigned int matchsize, unsigned int hook_mask)
++		   unsigned int matchsize, unsigned int hook_mask)
 +{
-+        if (hook_mask
-+            & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_FORWARD) | (1 << N=
F_IP_POST_ROUTING)
++	if (hook_mask
++	    & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_FORWARD) | (1 << NF_IP_PO=
ST_ROUTING)
 +		| (1 << NF_IP_LOCAL_IN) | (1 << NF_IP_LOCAL_OUT))) {
 +		printk("ipt_rpc: only valid for PRE_ROUTING, FORWARD, POST_ROUTING, LOC=
AL_IN and/or LOCAL_OUT targets.\n");
-+                return 0;
-+        }
++		return 0;
++	}
 +
-+        if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_rpc_info)))
-+                return 0;
++	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_rpc_info)))
++		return 0;
 +
-+        return 1;
++	return 1;
 +}
 +
 +
@@ -1331,7 +1341,7 @@
 +{
 +	int port;
 +
-+        DEBUGP("incrementing usage counts\n");
++	DEBUGP("incrementing usage counts\n");
 +	__MOD_INC_USE_COUNT(ip_conntrack_rpc_udp);
 +	__MOD_INC_USE_COUNT(ip_conntrack_rpc_tcp);
 +
@@ -1354,7 +1364,7 @@
 +	DEBUGP("unregistering match\n");
 +	ipt_unregister_match(&rpc_match);
 +
-+        DEBUGP("decrementing usage counts\n");
++	DEBUGP("decrementing usage counts\n");
 +	__MOD_DEC_USE_COUNT(ip_conntrack_rpc_tcp);
 +	__MOD_DEC_USE_COUNT(ip_conntrack_rpc_udp);
 +}
@@ -1411,25 +1421,25 @@
 +#define EXPIRES (180 * HZ)
 +
 +/* For future conections RPC, using client's cache bindings
-+ * I'll use ip_conntrack_lock to lock these lists           */
++ * I'll use ip_conntrack_lock to lock these lists	   */
 +
 +/* This identifies each request and stores protocol */
 +struct request_p {
-+   struct list_head list;
++	struct list_head list;
 +
-+   u_int32_t xid;  =20
-+   u_int32_t ip;
-+   u_int16_t port;
++	u_int32_t xid;  =20
++	u_int32_t ip;
++	u_int16_t port;
 +=09
-+   /* Protocol */
-+   u_int16_t proto;
++	/* Protocol */
++	u_int16_t proto;
 +
-+   struct timer_list timeout;
++	struct timer_list timeout;
 +};
 +
 +static inline int request_p_cmp(const struct request_p *p, u_int32_t xid,=
=20
 +				u_int32_t ip, u_int32_t port) {
-+	return(p->xid =3D=3D xid && p->ip =3D=3D ip && p->port);
++	return (p->xid =3D=3D xid && p->ip =3D=3D ip && p->port);
 +
 +}
 +

--jPC/Tkukgh9ZDT79--

--TegBI+r9roYdcP94
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Hs6RXaXGVTD0i/8RAkecAJ9LGNBebBlH5sFVgDaXQg6JoF4e2QCdFKVj
yX1Gdbfzf0ZZUZkFDwS5cBE=
=UzDp
-----END PGP SIGNATURE-----

--TegBI+r9roYdcP94--
