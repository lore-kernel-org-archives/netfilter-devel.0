From: tuXit <tuxit@netcourrier.com>
Subject: Re: New standalone nat helper module which help function is never
 called
Date: Thu, 20 Nov 2003 10:54:23 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031120105423.27d84443.tuxit@netcourrier.com>
References: <20031117174829.711e2e82.tuxit@netcourrier.com>
	<20031117223129.GF5075@sunbeam.de.gnumonks.org>
	<20031118005846.06befa0d.tuxit@netcourrier.com>
	<20031118004931.GH5075@sunbeam.de.gnumonks.org>
	<20031118100449.4815515b.tuxit@netcourrier.com>
	<20031118165904.GQ5075@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031118165904.GQ5075@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 18 Nov 2003 17:59:04 +0100
Harald Welte <laforge@netfilter.org> wrote:

> On Tue, Nov 18, 2003 at 10:04:49AM +0100, tuXit wrote:
> > On Tue, 18 Nov 2003 01:49:31 +0100
> > Harald Welte <laforge@netfilter.org> wrote:
> > 
> > > On Tue, Nov 18, 2003 at 12:58:46AM +0100, tuXit wrote:
> > > > 	ascii.flags = IP_NAT_HELPER_F_STANDALONE;
> > > 
> > > you are missing IP_NAT_HELPER_F_ALWAYS here.  otherwise a nat helper
> > > will only be called if a connection tracking helper has issued an
> > > expectation within that packet.
> > 
> > That's true; I added this flag so now, I have :
> > ascii.flags = IP_NAT_HELPER_F_STANDALONE + IP_NAT_HELPER_F_ALWAYS;
> > I also changed 
> > char ascii_names[10];
> > that was in my previous post from the function 
> > __init 
> > outside of it (because it is in the stack, so deleted whenever this
> > function is finished).
> >
> > But it still doesn't help. 
> 
> Flags in a bitmask have to be bit-wise or'ed
> (IP_NAT_HELPER_F_STANDALONE|IP_NAT_HELPER_F_ALWAYS).  Please see the
> existing code.

I checked the code from the cuseeme-nat patch from the extra part of the
patch-o-matic
(http://cvs.netfilter.org/~checkout~/netfilter/patch-o-matic//extra/cuseeme-n
at.patch), but that's true it is a bitmask...
Anyway, I changed this, and the nat helper function is not called. I put back
my code to remind it:

----------8<----------8<----------8<----------8<----------8<----------8<-----

/* ASCII extension for TCP NAT alteration. */
#include <linux/module.h>
#include <linux/netfilter_ipv4.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <net/tcp.h>
#include <linux/netfilter_ipv4/ip_nat.h>
#include <linux/netfilter_ipv4/ip_nat_helper.h>
#include <linux/netfilter_ipv4/ip_nat_rule.h>

#if 1
#define DEBUGP printk
#else
#define DEBUGP(format, args...)
#endif

#define ASCII_PORT 119

static int port;

static unsigned int ascii_help(struct ip_conntrack *ct,
			 struct ip_conntrack_expect *exp,
			 struct ip_nat_info *info,
			 enum ip_conntrack_info ctinfo,
			 unsigned int hooknum,
			 struct sk_buff **pskb)
{
        DEBUGP("ip_nat_ascii: The nat helper is called\n");
	return NF_ACCEPT;
}

static struct ip_nat_helper ascii;
static char ascii_names[10];

static void fini(void)
{
	DEBUGP("ip_nat_ascii: unregistering port %d\n", port);
	ip_nat_helper_unregister(&ascii);
}

static int __init init(void)
{
	int ret = 0;
	char *tmpname;

	port = ASCII_PORT;
	ascii.list.next = NULL;
	ascii.list.prev = NULL;
	tmpname = &ascii_names[0];
	sprintf(tmpname, "ascii");
	ascii.name = tmpname;
	ascii.flags = (IP_NAT_HELPER_F_STANDALONE | IP_NAT_HELPER_F_ALWAYS);
	ascii.me = THIS_MODULE;
	ascii.tuple.src.ip = 0;
	ascii.tuple.src.u.tcp.port = 0;
	ascii.tuple.dst.ip = 0;
	ascii.tuple.dst.u.tcp.port = __constant_htons(port);
	ascii.tuple.dst.protonum = IPPROTO_TCP;
	ascii.mask.src.ip = 0;
	ascii.mask.src.u.tcp.port = 0xFFFF;
	ascii.mask.dst.ip = 0;
	ascii.mask.dst.u.tcp.port = 0;
	ascii.mask.dst.protonum = 0xFFFF;
	ascii.help = ascii_help;
	ascii.expect = NULL;

	DEBUGP("ip_nat_ascii: Trying to register for port %d\n",
	       port);

	ret = ip_nat_helper_register(&ascii);
	
	if (ret) {
	  printk("ip_nat_ascii: error registering "
		 "helper for port %d\n", port);
	  fini();
	  return ret;
	}
	return ret;
}

----------8<----------8<----------8<----------8<----------8<----------8<-----

The do_bindings function from the ip_nat_core.c file tells me while debugging
that info->helper is NULL just before trying to call the helper if it exists.
This function seems to be called by ip_nat_fn from the ip_nat_standalone.c
file. At the end of ip_nat_fn, the call to do_bindings passes info as a
parameter. Just before the call, info->helper is NULL.

Thanks in advance,

-- 
Florian Pouradier
echo '|^H_!Xn|^H_' | less 
EpX Member - Debian GNU/Linux user
GPG FP: B0D7 1F53 94DA 0BCA C11E  F417 094B 49F3 D5DD F5EC 
