From: =?ISO-8859-2?Q?=22Micha=B3_=5C=22dRacek=5C=22_Rupka=22?=
	<dracek@ze94.internetdsl.tpnet.pl>
Subject: Please help !! [long]
Date: Sun, 22 May 2005 08:23:38 +0200
Message-ID: <4290256A.5000807@ze94.internetdsl.tpnet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I write my own module to security data transmition.
I don't now what is wrong.
When I type:

iptables -A INPUT -m sec --szyfr klucz -j ACCEPT

iptables write error:

when in parse function
	default:
		return 0;
	}
return 0;
	" Unknown arg klucz"
when in parse function
	default:
		return 0;
	}
return 1;
	"Invalid argument"

This is source code:

------------------------------
lib_sec.h

#ifndef _IPT_SEC_H
#define _IPT_SEC_H

#define SEC_SZYFR 0x01
#define SEC_DESZYFR 0x02

struct ipt_sec_info
{
	char klucz[2048];
	int wybor;
	u_int8_t flags;
	u_int8_t invert;
};

#endif /* _IPT_SEC_H */

-------------------------------
libipt_sec.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <netdb.h>
#include <ctype.h>

#include <iptables.h>

#include <linux/netfilter_ipv4/ip_tables.h>

#include "ipt_sec.h"

static void init(struct ipt_entry_match *m, unsigned int *nfcache);
static void help(void);
static int parse(int c, char **argv, int invert, unsigned int *flags,=20
const struct ipt_entry *entry, unsigned int *nfcache,struct=20
ipt_entry_match **match);
static void final_check(unsigned int flags);
static void print(const struct ipt_ip *ip, const struct ipt_entry_match=20
*m, int numeric);
static void save(const struct ipt_ip *ip, const struct ipt_entry_match *m=
);

static struct option opts[] =3D {
	{.name =3D "szyfr",  .has_arg =3D 1,.flag =3D 0,.val =3D '1'},
	{.name =3D "deszyfr",.has_arg =3D 1,.flag =3D 0,.val =3D '2'},
	{.name =3D 0}
};

static struct iptables_match sec =3D {
     .name          =3D "sec",
     .version       =3D IPTABLES_VERSION,
     .size          =3D IPT_ALIGN(sizeof(struct ipt_sec_info)),
     .userspacesize =3D IPT_ALIGN(sizeof(struct ipt_sec_info)),
     .init          =3D &init,
     .help	   =3D &help,
     .parse         =3D &parse,
     .final_check   =3D &final_check,
     .print         =3D &print,
     .save          =3D &save,
     .extra_opts    =3D opts
};

static void help(void)
{
     printf ("Security match v%s options:\n"
	    "--szyfr key 	Match is cripto\n"
	    "--deszyfr key	Match is decripto\n",
	    IPTABLES_VERSION);
}

// function read key from file

static void parse_klucz(char *arg, struct ipt_sec_info *sinfo, int wybor)=

{
     char linia[100];
     FILE *fp;
     fp =3D fopen(arg,"r");
     if (fp !=3DNULL)
     {
         while (fgets(linia,100,fp)!=3DNULL)
         {
	strcat(sinfo->klucz,linia);    =09
         sinfo->wybor=3Dwybor;
	}
     fclose(fp);
     }
     else
     {
	exit_error(PARAMETER_PROBLEM, "File is not avable");
     }
}

static int
parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry, unsigned int *nfcache,
       struct ipt_entry_match **match)
{
	struct ipt_sec_info *sinfo =3D (struct ipt_sec_info *) (*match)->data;
=09
	if (*flags)
		exit_error(PARAMETER_PROBLEM, "I don't now what this ?");

	switch (c) {
	case '1':

		if (*flags & SEC_SZYFR)
		exit_error(PARAMETER_PROBLEM, "flags %i",*flags);
=09

	        sinfo->flags =3D SEC_SZYFR;

     		check_inverse(optarg,&invert,&optind,0);
		parse_klucz(argv[optind-1],sinfo,1);
		if (invert) sinfo->invert =3D 1;			=09

//		exit_error(OTHER_PROBLEM, " %i",invert);
//		*flags |=3D SEC_SZYFR;
		*flags =3D 1;

     		break;

	case '2':

		if (*flags & SEC_DESZYFR)
		exit_error(PARAMETER_PROBLEM,"plum");

		sinfo->flags =3D SEC_SZYFR;

		check_inverse(argv[optind-1],&invert,&optind,0);=09
		parse_klucz(argv[optind-1],sinfo,2);

		if (invert) sinfo->invert =3D 1;			=09

//	        exit_error(OTHER_PROBLEM, "B %s", klucz.klu);
//		*flags |=3D SEC_DESZYFR;
		*flags =3D 1;

		break;
         default:
		return 0;
	}
//        exit_error(OTHER_PROBLEM, "test %s",sinfo->klucz);
//	*flags |=3D SEC_SZYFR;
	return 0;
}

static void final_check(unsigned int flags)
{
     if (!flags)
	exit_error(PARAMETER_PROBLEM, "Security match must specify --szyfr=20
--deszyfr");
}

static void print(const struct ipt_ip *ip, const struct ipt_entry_match *=
m,
                   int numeric)
{

}

static void save(const struct ipt_ip *ip, const struct ipt_entry_match *m=
)
{
=09
}

static void init(struct ipt_entry_match *m, unsigned int *nfcache)
{
	*nfcache |=3D NFC_UNKNOWN;
}

void _init(void)
{
	register_match(&sec);
}

-------------------------------------------------------------
ipt_sec.c // kernel module

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/version.h>
#include <linux/skbuff.h>

#include <linux/netfilter_ipv4/ip_tables.h>
#include "ipt_sec.h"

#define DRIVER_AUTHOR "Michal dracek Rupka=20
<dracek@ze94.internetdsl.tpnet.pl>";
#define DRIVER_DESC "Security";

MODULE_LICENSE("GPL");
MODULE_AUTHOR(DRIVER_AUTHOR);
MODULE_DESCRIPTION(DRIVER_DESC);

static int
match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
       int offset,
       const void *hdr,
       u_int16_t datalen,
       int *hotdrop)
{
     printk(KERN_ALERT "klucz ");
     if ((void *) skb !=3D NULL)
     {
     printk(KERN_ALERT "cos jest\n");
     }
return 0;
}

static int
checkentry(const char *tablename,
            const struct ipt_ip *ip,
            void *matchinfo,
            unsigned int matchsize,
            unsigned int hook_mask)
{
return 0;
}

static struct ipt_match sec_match =3D {
	.name        =3D "sec",
	.match       =3D &match,
	.checkentry  =3D &checkentry,
	.me          =3D THIS_MODULE,
};

static int __init sec_init(void)
{
     printk(KERN_ALERT "Zainicjowano modul security ... \n");
     return ipt_register_match(&sec_match);
}

static void __exit sec_exit(void)
{
     ipt_unregister_match(&sec_match);
     printk(KERN_ALERT "Usuniecie modulu ...\n");
}

module_init(sec_init);
module_exit(sec_exit);

PS. My english isn't perfect sorry


--=20
# Micha=B3 "dRacek" Rupka
# dracek(at)ze94(dot)internetdsl(dot)tpnet(dot)pl
# GG 1124108, JID dracek(at)chrome.pl, RLU 314366
# GSM 608-118-007 http://80.53.136.94/dracek ####
