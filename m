From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] addrtype match
Date: 09 Apr 2003 13:21:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049887278.3282.138.camel@tux.rsn.bth.se>
References: <3E92F28B.2020401@trash.net>
	 <1049833895.1309.40.camel@tux.rsn.bth.se>  <3E937951.6070500@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3E937951.6070500@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2003-04-09 at 03:37, Patrick McHardy wrote:
> Hi Martin,
> this is an updated version of the addrtype match with the changes you
> suggested. it's probably not be the most useful match in the world but as
> you said, it might come handy ;)

Don't know why I didn't think of this last night... I plead temporary
insanity :)
> 
> ______________________________________________________________________

> ++/* from linux/rtnetlink.h, renumbered to be useable as a bitmap */
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

There actually isn't any real need to duplicate and renumber.. just use
(1 << RTN_UNSPEC) .... I think enum starts at 1 but that will only mean
you loose one bit, you don't need 32 bits anyway :)

> ++static int match_type(u_int32_t addr, u_int16_t types)
> ++{
> ++	unsigned type = inet_addr_type(addr);
> ++

	if (type <= 31)
		if (types & (1 << type))
			return 1;

> ++	return 0;
> ++}

Maybe that would do it? I don't like big switch statements if they can
be avoided.

userspace below:

> +static int
> +parse_type(const char *type, size_t strlen, u_int16_t *i)
> +{
> +	if (strncasecmp(type, "UNSPEC", strlen) == 0)
> +		*i |= IPT_ADDRTYPE_RTN_UNSPEC;
> +	else if (strncasecmp(type, "UNICAST", strlen) == 0)
> +		*i |= IPT_ADDRTYPE_RTN_UNICAST;

Maybe this can be solved by a table that's looped through?

> +static void print_type(u_int16_t types) {
> +	const char *sep = "";
> +	if (types & IPT_ADDRTYPE_RTN_UNSPEC) {
> +		printf("%sUNSPEC", sep);
> +		sep = ",";
> +	}

Same table could be used here

Oh, it could be used in the help() function as well.

Sorry about all the extra comments now after you've already made a new
patch... the only thing I really want to see is the removal of the code
duplication in the kernel. The table in userspace would just be a lot
nicer than all the if-statements, and to me almost more readable.

-- 
/Martin
