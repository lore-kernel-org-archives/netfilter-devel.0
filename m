From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] addrtype match
Date: 08 Apr 2003 22:31:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049833895.1309.40.camel@tux.rsn.bth.se>
References: <3E92F28B.2020401@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3E92F28B.2020401@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2003-04-08 at 18:02, Patrick McHardy wrote:
> This patch adds a new match "addrtype" which can be used to match
> the result of inet_addr_type, which is what routing thinks of an address.
> We use it for automatic generated rules where DNAT rules can be
> generated with just an interface match because the local ip may be
> unknown at rule generation time. The match is then used to exclude
> local addresses from DNAT. Please consider for inclusion.

Might come in handy.

> ++/* from linux/rtnetlink.h */
> ++
> ++#define IPT_ADDRTYPE_RTN_UNSPEC		0x0001
> ++#define IPT_ADDRTYPE_RTN_UNICAST	0x0002
> ++#define IPT_ADDRTYPE_RTN_LOCAL		0x0004
> ++#define IPT_ADDRTYPE_RTN_BROADCAST	0x0008
> ++#define IPT_ADDRTYPE_RTN_ANYCAST	0x0010
> ++#define IPT_ADDRTYPE_RTN_MULTICAST	0x0020
> ++#define IPT_ADDRTYPE_RTN_BLACKHOLE	0x0040
> ++#define IPT_ADDRTYPE_RTN_UNREACHABLE	0x0080
> ++#define IPT_ADDRTYPE_RTN_PROHIBIT	0x0100
> ++#define IPT_ADDRTYPE_RTN_THROW		0x0200
> ++#define IPT_ADDRTYPE_RTN_NAT		0x0400
> ++#define IPT_ADDRTYPE_RTN_XRESOLVE	0x0800

Ok, duplicated and renumbered so you can use them as a bitmap.
Might deserve a comment as to why they were duplicated, might not be
totally obvious (took me a moment to realize it :)

> ++	switch(type) {
> ++		case RTN_UNSPEC:
> ++			if (types&IPT_ADDRTYPE_RTN_UNSPEC)
> ++				return 1;
> ++			break;

The kernel codingstyle says that there should be spaces around the & .

> ++static int checkentry(const char *tablename, const struct ipt_ip *ip,
> ++		      void *matchinfo, unsigned int matchsize,
> ++		      unsigned int hook_mask)
> ++{
> ++	if (matchsize != IPT_ALIGN(sizeof(struct ipt_addrtype_info)))
> ++		return 0;
> ++
> ++	return 1;
> ++}

A printk that tells the user what went wrong might be a nice thing. It's
missing from a lot of modules and I plan to fix that in the future.

> diff -urN a/userspace/extensions/libipt_addrtype.c b/userspace/extensions/libipt_addrtype.c
> --- a/userspace/extensions/libipt_addrtype.c	1970-01-01 01:00:00.000000000 +0100
> +++ b/userspace/extensions/libipt_addrtype.c	2003-04-08 16:50:24.000000000 +0200
> @@ -0,0 +1,245 @@
> +/* Shared library add-on to iptables to add TTL matching support 

copy-and-forgot-to-edit? :)

> +static void print_type(u_int16_t types) {
> +	const char *sep = "";
> +	if (types&IPT_ADDRTYPE_RTN_UNSPEC) {
> +		printf("%sUNSPEC", sep);
> +		sep = ",";
> +	}

Sure this is userspace but I'd like to see spaces around & here as well
:)

-- 
/Martin
