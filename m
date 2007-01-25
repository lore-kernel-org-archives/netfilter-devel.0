From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Patch 1/2] libnfnetlink, iface conversion to string
Date: Thu, 25 Jan 2007 02:46:35 +0100
Message-ID: <45B80BFB.2060203@netfilter.org>
References: <1167257854.31765.21.camel@localhost>
	<45940145.3020003@netfilter.org>
	<1167349247.15420.13.camel@localhost>
	<20070107142607.GC13543@prithivi.gnumonks.org>
	<1168296086.12298.6.camel@localhost>
	<20070109115120.GX7655@prithivi.gnumonks.org>
	<1169162676.8926.14.camel@localhost>
	<1169163050.8926.16.camel@localhost>
	<45B0E24A.7040906@trash.net> <45B10222.1040806@netfilter.org>
	<20070122123618.GM9631@prithivi.gnumonks.org>
	<59155.90.13.189.211.1169586830.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, Vincent Deffontaines <vincent@inl.fr>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <59155.90.13.189.211.1169586830.squirrel@mail.inl.fr>
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

Hi Eric,

Eric Leblond wrote:
>> On Fri, Jan 19, 2007 at 06:38:42PM +0100, Pablo Neira Ayuso wrote:
>>> Patrick McHardy wrote:
>>> Indeed. Eric, all this global stuff below must dissapear at all, from
>>> rtnl.c:
> 
> I've done a big cleaning and I hope I will not annoy Patrick with my
> coding style problem this time.
> 
> I've introduced two structures:
> 
> struct rtnl_inst {
              ^^^^
please, rename this to _handle

>        int rtnl_fd;
>        int rtnl_seq;
>        int rtnl_dump;
>        struct sockaddr_nl rtnl_local;
>        struct rtnl_handler *handlers;
> };
> 
> struct nlif_inst {
              ^^^^
same thing here

>        struct ifindex_map *ifindex_map[16];
>        struct rtnl_inst *rtnl_inst;
>        struct rtnl_handler *ifadd_handler;
>        struct rtnl_handler *ifdel_handler;
> };
> 
> which hide all previously defined global variables.
> 
> The list of exported functions is the following:
> 
> struct nlif_inst *nlif_table_init(void);
> void nlif_table_fini(struct nlif_inst *orig);
> int nlif_get_fd(struct nlif_inst *nlif_inst); /* to be used in select */
> int nlif_treat_msg(struct nlif_inst *nlif_inst);

I prefer keeping it homogeneous with libnfnetlink, I would rename the
functions above to:

struct nlif_handle *nlif_open(void);
void nlif_close(struct nlif_handle *h);
int nlif_fd(struct nlif_handle *h);
int nlif_catch(struct nlif_handle *h);
char *nlif_index2name(struct nlif_handle *h, unsigned int index);

BTW, could you spend some time on documenting the API in docbook format?
I know that this is not available in all netfilter libraries but I'd
appreciate it, we should start getting use to do these things ;)

> === include/libnfnetlink/libnfnetlink.h
> ==================================================================
> --- include/libnfnetlink/libnfnetlink.h	(revision 5686)
> +++ include/libnfnetlink/libnfnetlink.h	(local)
> @@ -176,6 +176,22 @@
>  
>  extern void nfnl_dump_packet(struct nlmsghdr *, int, char *);
>  
> +struct nlif_inst {
> +	struct ifindex_map *ifindex_map[16];
> +	struct rtnl_inst *rtnl_inst;
> +	struct rtnl_handler *ifadd_handler;
> +	struct rtnl_handler *ifdel_handler;
> +};

move this definition to an internal header file and just put an empty
definition inside libnfnetlink.h like:

struct nlif_handle;

This is better for encapsulation, if we have to modify the layout later
for whatever reason, we will not break backward binary compatibility. We
just give a pointer to an object with private attributes that are only
accesible through the appropiate functions like the nlif_fd() getter.

> === src/iftable.c
> ==================================================================
> --- src/iftable.c	(revision 5686)
> +++ src/iftable.c	(local)
> @@ -19,6 +19,7 @@
>  
>  #include <linux/netdevice.h>
>  
> +#include <libnfnetlink/libnfnetlink.h>
>  #include "rtnl.h"
>  
>  #define iftb_log(x, ...)
> @@ -34,28 +35,6 @@
>  	char		name[16];
>  };
>  
> -static struct ifindex_map *ifindex_map[16];
> -
> -/* iftable_dump - Dump the interface table to a given file stream
> - * @outfd:	file stream to which table should be dumped
> - */
> -int iftable_dump(FILE *outfd)
> -{
> -	int i;
> -
> -	for (i = 0; i < 16; i++) {
> -		struct ifindex_map *im;
> -		for (im = ifindex_map[i]; im; im = im->next) {
> -			fprintf(outfd, "%u %s", im->index, im->name);
> -			if (!(im->flags & IFF_UP))
> -				fputs(" DOWN", outfd);
> -			fputc('\n', outfd);
> -		}
> -	}
> -	fflush(outfd);
> -	return 0;
> -}

We can introduce some kind of iterator, later:
int nlif_iterate(struct nlif_handle *h, int (*iterate)(void *data));

That's enough for now, we can revisit this later and clean it up a bit
more. Thanks.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
