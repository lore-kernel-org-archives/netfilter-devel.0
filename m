From: Richard Bishop <R.J.Bishop@exeter.ac.uk>
Subject: Help writing netfilter match
Date: Sun, 28 Mar 2004 17:33:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <406E0129@minerva.ex.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm trying to write a netfilter match and have run into some problems. I've
read through the how-to documents, though they only seem to skim over things
and don't really explain what I need to know.

As I understand it, in order to write a netfilter match, you have a kernel
level module that integrates with the ip_tables module in the kernel and does
your classification of packets coming to it and telling the iptables module
what to drop etc. You then have a userspace shared library (or a furby in
Rusty's case :-) ) which you call with "iptables -A [table] -m [matchname]"
which then determines what to send to the kernel module. - Can somebody
confirm that my interpretation of things is right here please.

I have a kernel module working, though the userspace module is elluding me
somewhat.  I have the following skeleton code, put together from various match
libraries that I've found, saved as libipt_net.c

----------------------------------------------------------------------------
#include <stdio.h>
#include <netdb.h>
#include <string.h>
#include <stdlib.h>
#include <stddef.h>
#include <getopt.h>
#include <iptables.h>
#include <linux/netfilter_ipv4/ip_conntrack.h>

static void help(void) {
	print("iptables v%s options:\n some options here\n)",IPTABLES_VERSION);
}

static struct option opts[] = {
	{ "option", 1, 0, '1' },
	{0}
};

static void init(struct ipt_entry_match *m, unsigned int *nfcache) {
	printf("Hello from iptables match library\n");
}

/* Function which parses command options; returns true if it
   ate an option */
static int parse(int c, char **argv,
		int invert,
		unsigned int *flags,
		const struct ipt_entry *entry,
		unsigned int *nfcache,
		struct ipt_entry_match **match)
{
	return 1;
}

/* Final check - we really don't care in this instance */
static void final_check(unsigned int flags) {
}

/* Print the match info to stdout */
static void print(	const struct ipt_ip *ip,
			const struct ipt_entry_match *match,
			int numeric) {
	int *net = (int*)match->data;

	printf("net %d");
}

/* Dump the match info in a parseable form to stdout */
static void save(	const struct ipt_ip *ip,
			const struct ipt_entry_match *match) {

	int *net = (int*)match->data;

	printf("--option %d",*net);
}

static struct iptables_match net = {
	.name		= "net",
	.version	= IPTABLES_VERSION,
	.size		= IPT_ALIGN(sizeof(int)),
	.userspacesize	= IPT_ALIGN(sizeof(int)),
	.help		= &help,
	.init		= &init,
	.parse		= &parse,
	.final_check	= &final_check,
	.print		= &print,
	.save		= &save,
	.extra_opts	= opts
};

void __init(void) {
	register_match(&net);
}
----------------------------------------------------------------------------

This is compiled with the command  "gcc -shared -o libipt_net.so
-DIPTABLES_VERSION=\"1.2.9\" -I/usr/src/linux/include libipt_net.c"  and the
.so file placed in /lib/iptables. Incidentally I'm compiling and running on
Debian with kernel 2.4.24-1-k7.

As root I then run "iptables -A INPUT -m net --help" and get "iptables v1.2.9:
Couldn't load match `net'". I've obviously missed something somewhere - can
somebody point me in the right direction please?!  After a day or so of
googling I've got nowhere. I've also tried compiling with the '-c' option, but
get an error that "ELF file's phentsize not the expected size".

Can anybody help please!

Many thanks in advance


Richard

---
Richard Bishop
Department of Computer Science
University of Exeter. UK
