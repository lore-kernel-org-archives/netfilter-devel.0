From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Help writing netfilter match
Date: Sun, 28 Mar 2004 20:57:38 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403282047480.9284-100000@filer.marasystems.com>
References: <406DFCFE@minerva.ex.ac.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Richard Bishop <R.J.Bishop@exeter.ac.uk>
In-Reply-To: <406DFCFE@minerva.ex.ac.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 28 Mar 2004, Richard Bishop wrote:

> I'm trying to write a netfilter match and have run into some problems. I've 
> read through the how-to documents, though they only seem to skim over things 
> and don't really explain what I need to know.

The source documents the details, the howto the principles..

> As I understand it, in order to write a netfilter match, you have a kernel 
> level module that integrates with the ip_tables module in the kernel and does 
> your classification of packets coming to it and telling the iptables module 
> what to drop etc. You then have a userspace shared library (or a furby in 
> Rusty's case :-) ) which you call with "iptables -A [table] -m [matchname]" 
> which then determines what to send to the kernel module. - Can somebody 
> confirm that my interpretation of things is right here please.

Correct.

> I have a kernel module working, though the userspace module is elluding me 
> somewhat.  I have the following skeleton code, put together from various match 
> libraries that I've found, saved as libipt_net.c
> 
> ----------------------------------------------------------------------------
> #include <stdio.h>
> #include <netdb.h>
> #include <string.h>
> #include <stdlib.h>
> #include <stddef.h>
> #include <getopt.h>
> #include <iptables.h>
> #include <linux/netfilter_ipv4/ip_conntrack.h>

What I am missing here is your include file for the match structure used
by your match.. and you should not include ip_conntrack.h unless you have
a specific reason to..

Even if your match takes a very simple argument it is better to 
encapsulate it into a structure to make typecasing, sizing etc more 
obvious.

> /* Function which parses command options; returns true if it
>    ate an option */
> static int parse(int c, char **argv,
> 		int invert,
> 		unsigned int *flags,
> 		const struct ipt_entry *entry,
> 		unsigned int *nfcache,
> 		struct ipt_entry_match **match)
> {
> 	return 1;
> }

This needs to fill in your match structure... 'c' is the option number 
and the global "optarg" is the value.. 

> /* Print the match info to stdout */
> static void print(	const struct ipt_ip *ip,
> 			const struct ipt_entry_match *match,
> 			int numeric) {
> 	int *net = (int*)match->data;
> 
> 	printf("net %d");

Missing some data there..

> As root I then run "iptables -A INPUT -m net --help" and get "iptables v1.2.9: 
> Couldn't load match `net'". I've obviously missed something somewhere - can 
> somebody point me in the right direction please?!

Make sure the permissions of your .so is correct, and that it is in the 
correct directory for the iptables binary you are using (maybe you have 
more than one?)

Also try building your userspace module as part of building iptables. This 
is the method I use for building my extensions. Just place the file in 
userspace/extensions/ and a correstponding .<modulename>-test file

Regards
Henrik
