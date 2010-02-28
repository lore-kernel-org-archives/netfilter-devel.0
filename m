From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Sun, 28 Feb 2010 17:28:38 +0100
Message-ID: <4B8A99B6.5080708@netfilter.org>
References: <1267217680-22677-1-git-send-email-chifflier@edenwall.com> <1267217680-22677-2-git-send-email-chifflier@edenwall.com> <4B892440.7030002@netfilter.org> <20100228140655.GC16135@piche.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, eleblond@edenwall.com
To: Pierre Chifflier <chifflier@edenwall.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35276 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030247Ab0B1Q2q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Feb 2010 11:28:46 -0500
In-Reply-To: <20100228140655.GC16135@piche.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pierre,

Pierre Chifflier wrote:
> Thanks for the review. I have fixed almost every points you have
> mentioned, there are only a few points to discuss.

Thanks.

>> BTW, how does the "big picture" of this look like? I guess that your
>> nufw daemon is listening to packets via libnetfilter_queue and then it
>> sends unixsock messages that include the packet + extra authentication
>> information to ulogd2 to log them, right?
> 
> Yes. We use ulogd as a central point for logging information, since
> packets (and decision) can come either from iptables (for non-user
> rules) or from the nufw+nuauth chain (for user filtering rules).
> When logging from nufw, we use the unixsock message to include the
> original packet (so the standard code from ulogd2 will be used) and add
> our additional information (user, application, etc).
> 
>           nflog + (drop|accept)
>          /                     \
> netfilter                        ulogd2
>          \                     /
>            (nfq) nufw --> nuauth

Interesting, I have a feeling that it was similar to this ;-).

> Yet this code has nothing specific to nufw, it can be used by any
> application to inject data with extra information.

I think so, but they would need to add new input keys to store that new
extra information or use the _NUFW_ keys. We can add a comment after the
_NUFW_ telling something that "add your new keys here".

>> could this be extended in the future to support flow-based information?
>> I mean, does this really fit into the "packet" directory of ulogd2?
> 
> Well, I don't have any fixed opinion on this. If you want I can move
> this plugin to the flow directory (in some way it is similar to IPFIX).

My question is if this plugin is specific for packet-logging. If so, the
packet/ directory is fine.

>>> +	[UNIXSOCK_KEY_NUFW_USER_NAME] = {
>>> +		.type = ULOGD_RET_STRING,
>>> +		.flags = ULOGD_RETF_NONE,
>>> +		.name = "nufw.user.name",
>>> +	},
>> Could we define some more generic instead of NUFW? I know it's your
>> thing but others may benefit from these fields I guess, right?
>>
>> Well, this is not important anyway, I don't mind too much.
> 
> Sure. Should I use something like 'EXTRA' instead of NUFW in the constants
> names ?

I don't mind too much, I leave it up to you.

> [...]
>>> +
>>> +#define unixpath_ce(x)		((x)->ces[0])
>>> +#define bufsize_ce(x)		((x)->ces[1])
>>> +#define perms_ce(x)		((x)->ces[2])
>>> +#define owner_ce(x)		((x)->ces[3])
>>> +#define group_ce(x)		((x)->ces[4])
>> I know that this is xyz_ce() macros are the "standard way" in ulogd2 but
>> it's ugly. I would do the following:
>>
>> enum {
>> 	UNIXSOCK_OPT_UNIXPATH = 0,
>> 	UNIXSOCK_OPT_BUFSIZE,
>> 	UNIXSOCK_OPT_PERM,
>> 	UNIXSOCK_OPT_OWNER,
>> 	UNIXSOCK_OPT_GROUP,
>> };
>>
>> Then, we can do the transition easily to several functions like:
>>
>> ulogd_option_get_str(UNIXSOCK_OPT_UNIXPATH, upi->config_kset);
>> ulogd_option_get_u32(UNIXSOCK_OPT_PERM, upi->config_kset);
>>
>> and so on... this is something that I had in my head. I'm not asking you
>> to do so but to tell you about my intentions. If we start defining the
>> enums now, we can do the transition in the near future.
> 
> I'd like that too ! I've defined the enum (and kept the xyz_ce macros
> for now). If you want, I can add these functions in another patch ?

Sure, go ahead if you want :-).

[...]
>>> +
>>> +struct ulogd_unixsock_option_t  {
>>> +	uint16_t option_id;
>>> +	uint16_t option_length;
>>> +	char     option_value[0];
>>> +} __attribute__((packed));
>>> +
>>> +#define ALIGN_SIZE 8
>> Minor question: why align this to 64 bits?
> 
> I originally used an alignment to 32 bits, but Jan noticed it would
> break if using options/values on 64 bits (and a test confirmed that). I
> took 64 bits as the biggest allowed value for integers.

I would need to look into this in more detail, not sure where the
problem is. I think that you can use something like `struct nlattr' (see
include/linux/netlink.h) and then nla_put() to add attributes in the TLV
format (see lib/nlattr.c). Those are align-safe. I'm using something
similar for conntrackd for the synchronization messages (src/build.c and
src/parse.c).

> [...]
>>> +/* callback called from ulogd core when fd is readable */
>>> +static int unixsock_instance_read_cb(int fd, unsigned int what, void *param)
>>> +{
>>> +	struct ulogd_pluginstance *upi = param;
>>> +	struct unixsock_input *ui = (struct unixsock_input*)upi->private;
>>> +	int len;
>>> +	u_int16_t needed_len;
>>> +	u_int32_t packet_sig;
>>> +	struct ulogd_unixsock_packet_t *unixsock_packet;
>>> +
>>> +	char buf[4096];
>>> +
>>> +	if (!(what & ULOGD_FD_READ))
>>> +		return 0;
>>> +
>>> +	len = read(fd, buf, sizeof(buf));
>> Ah, looking at this, I think that it would be a good idea to ignore
>> SIGPIPE to avoid crashing ulogd2 if the other peer has gone.
> Yes, I didn't want to do that in the plugin itself. Can I put that in
> src/ulogd.c ?

Yes, you can add a comment in ulogd.c telling that at least UNIXSOCK
needs this so we don't forget ;).
