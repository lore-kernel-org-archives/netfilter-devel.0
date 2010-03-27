From: =?ISO-8859-1?Q?Piotr_Pir=F3g?= <pirogpiotr@gmail.com>
Subject: Patch for ipset/setlist
Date: Sat, 27 Mar 2010 12:59:44 +0100
Message-ID: <d85152341003270459t30d2960cxb71a349b217cef77@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56587 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab0C0L7q convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Mar 2010 07:59:46 -0400
Received: by wyb39 with SMTP id 39so258245wyb.19
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Mar 2010 04:59:45 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello.

This patch adds =91=97matchall=92 argument to setlist. By default, setl=
ist
returns true if packet match to any of it members. With =96matchall
packet must match to every member of setlist.
This is my first patch, so sorry if I do something wrong. Comments are =
welcome.

Piotr Pir=F3g

diff -pruN ipset-4.2.orig/ipset_setlist.c ipset-4.2/ipset_setlist.c
--- ipset-4.2.orig/ipset_setlist.c	2010-03-18 14:59:55.000000000 +0100
+++ ipset-4.2/ipset_setlist.c	2010-03-18 19:07:40.000000000 +0100
@@ -32,6 +32,7 @@ setlist_create_init(void *data)
 	struct ip_set_req_setlist_create *mydata =3D data;
 =09
 	mydata->size =3D 8;
+	mydata->matchall =3D 0;
 }

 /* Function which parses command options; returns true if it ate an op=
tion */
@@ -50,6 +51,9 @@ setlist_create_parse(int c, char *argv[]
 				   "between 1-255", optarg);
 		mydata->size =3D size;
 		break;
+	case '2':
+		mydata->matchall =3D 1;
+		break;
 	default:
 		return 0;
 	}
@@ -65,6 +69,7 @@ setlist_create_final(void *data UNUSED,
 /* Create commandline options */
 static const struct option create_opts[] =3D {
 	{.name =3D "size",	.has_arg =3D required_argument,	.val =3D '1'},
+	{.name =3D "matchall",	.has_arg =3D no_argument, 	.val =3D '2'},
 	{NULL},
 };

@@ -124,6 +129,7 @@ setlist_initheader(struct set *set, cons
 	=09
 	memset(map, 0, sizeof(struct ip_set_setlist));
 	map->size =3D header->size;
+	map->matchall =3D header->matchall;
 }

 static void
@@ -131,6 +137,8 @@ setlist_printheader(struct set *set, uns
 {
 	struct ip_set_setlist *mysetdata =3D set->settype->header;

+	if (mysetdata->matchall =3D=3D 1)
+		printf(" matchall");
 	printf(" size: %u\n", mysetdata->size);
 }

@@ -161,9 +169,12 @@ setlist_saveheader(struct set *set, unsi
 {
 	struct ip_set_setlist *mysetdata =3D set->settype->header;

-	printf("-N %s %s --size %u\n",
+	printf("-N %s %s --size %u",
 	       set->name, set->settype->typename,
 	       mysetdata->size);
+	if (mysetdata->matchall =3D=3D 1)
+		printf(" --matchall");
+	printf("\n");
 }

 static void
@@ -189,7 +200,7 @@ static void
 setlist_usage(void)
 {
 	printf
-	    ("-N set setlist --size size\n"
+	    ("-N set setlist --size size [--matchall]\n"
 	     "-A set setname[,before|after,setname]\n"
 	     "-D set setname\n"
 	     "-T set setname\n");
diff -pruN ipset-4.2.orig/kernel/include/linux/netfilter_ipv4/ip_set_se=
tlist.h
ipset-4.2/kernel/include/linux/netfilter_ipv4/ip_set_setlist.h
--- ipset-4.2.orig/kernel/include/linux/netfilter_ipv4/ip_set_setlist.h=
	2010-03-18
14:59:54.000000000 +0100
+++ ipset-4.2/kernel/include/linux/netfilter_ipv4/ip_set_setlist.h	2010=
-03-18
19:02:42.000000000 +0100
@@ -10,11 +10,13 @@

 struct ip_set_setlist {
 	uint8_t size;
+	uint8_t matchall;
 	ip_set_id_t index[0];
 };

 struct ip_set_req_setlist_create {
 	uint8_t size;
+	uint8_t matchall;
 };

 struct ip_set_req_setlist {
diff -pruN ipset-4.2.orig/kernel/ip_set_setlist.c
ipset-4.2/kernel/ip_set_setlist.c
--- ipset-4.2.orig/kernel/ip_set_setlist.c	2010-03-18 14:59:55.00000000=
0 +0100
+++ ipset-4.2/kernel/ip_set_setlist.c	2010-03-18 19:02:42.000000000 +01=
00
@@ -75,11 +75,11 @@ setlist_ktest(struct ip_set *set,
 	      const u_int32_t *flags)
 {
 	struct ip_set_setlist *map =3D set->data;
-	int i, res =3D 0;
+	int i, res =3D map->matchall;
 =09
 	for (i =3D 0; i < map->size
 		    && map->index[i] !=3D IP_SET_INVALID_ID
-		    && res =3D=3D 0; i++)
+		    && res =3D=3D map->matchall; i++)
 		res =3D ip_set_testip_kernel(map->index[i], skb, flags);
 	return res;
 }
@@ -251,6 +251,7 @@ setlist_create(struct ip_set *set, const
 	if (!map)
 		return -ENOMEM;
 	map->size =3D req->size;
+	map->matchall =3D req->matchall;
 	for (i =3D 0; i < map->size; i++)
 		map->index[i] =3D IP_SET_INVALID_ID;
 =09
@@ -292,6 +293,7 @@ setlist_list_header(const struct ip_set
 	struct ip_set_req_setlist_create *header =3D data;
 =09
 	header->size =3D map->size;
+	header->matchall =3D map->matchall;
 }

 static int

--
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
