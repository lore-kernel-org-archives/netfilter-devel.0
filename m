From: Pierre Chifflier <chifflier@edenwall.com>
Subject: Re: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Sun, 28 Feb 2010 15:06:56 +0100
Message-ID: <20100228140655.GC16135@piche.inl.fr>
References: <1267217680-22677-1-git-send-email-chifflier@edenwall.com>
 <1267217680-22677-2-git-send-email-chifflier@edenwall.com>
 <4B892440.7030002@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pierre Chifflier <chifflier@edenwall.com>,
	netfilter-devel@vger.kernel.org, eleblond@edenwall.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:56662 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965988Ab0B1OHQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Feb 2010 09:07:16 -0500
Content-Disposition: inline
In-Reply-To: <4B892440.7030002@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Feb 27, 2010 at 02:55:12PM +0100, Pablo Neira Ayuso wrote:
> Hi Pierre,
> 
> Pierre Chifflier wrote:
> > This input plugins creates a unix socket which can be used to log packets.
> > Scripts or applications can connect to the socket (only one client allowed
> > per socket) and send data in a Key-Length-Value format (including the
> > payload).
> 
> I'm proposing some minor changes, they are mostly cleanups and comestic.

Hi Pablo,

Thanks for the review. I have fixed almost every points you have
mentioned, there are only a few points to discuss.

> 
> BTW, how does the "big picture" of this look like? I guess that your
> nufw daemon is listening to packets via libnetfilter_queue and then it
> sends unixsock messages that include the packet + extra authentication
> information to ulogd2 to log them, right?

Yes. We use ulogd as a central point for logging information, since
packets (and decision) can come either from iptables (for non-user
rules) or from the nufw+nuauth chain (for user filtering rules).
When logging from nufw, we use the unixsock message to include the
original packet (so the standard code from ulogd2 will be used) and add
our additional information (user, application, etc).

          nflog + (drop|accept)
         /                     \
netfilter                        ulogd2
         \                     /
           (nfq) nufw --> nuauth

Yet this code has nothing specific to nufw, it can be used by any
application to inject data with extra information.


> could this be extended in the future to support flow-based information?
> I mean, does this really fit into the "packet" directory of ulogd2?

Well, I don't have any fixed opinion on this. If you want I can move
this plugin to the flow directory (in some way it is similar to IPFIX).

[...]
> > +++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
> > @@ -0,0 +1,815 @@
> > +/*
> > + ** Copyright(C) 2008-2010 INL
> > + ** Written by  Pierre Chifflier <chifflier@edenwall.com>
> 
> Minor nitpick: please, add licensing terms here in a short header.
Done

[...]
> > +/* Default unix socket path */
> > +#define UNIXSOCK_UNIXPATH_DEFAULT	"/var/run/ulogd/ulogd2.sock"
> 
> These extra lines below are unnecessarly, I'd say. They don't help to
> make the code more readable.
Fixed

> > +
> > +/* Unique value used as a signature to ensure received data is really
> > + * a packet
> > + */
> > +#define ULOGD_SOCKET_MARK	0x41c90fd4
> > Same here
Fixed

[...]
> > +	[UNIXSOCK_KEY_NUFW_USER_NAME] = {
> > +		.type = ULOGD_RET_STRING,
> > +		.flags = ULOGD_RETF_NONE,
> > +		.name = "nufw.user.name",
> > +	},
> 
> Could we define some more generic instead of NUFW? I know it's your
> thing but others may benefit from these fields I guess, right?
> 
> Well, this is not important anyway, I don't mind too much.

Sure. Should I use something like 'EXTRA' instead of NUFW in the constants
names ?

[...]
> > +
> > +#define unixpath_ce(x)		((x)->ces[0])
> > +#define bufsize_ce(x)		((x)->ces[1])
> > +#define perms_ce(x)		((x)->ces[2])
> > +#define owner_ce(x)		((x)->ces[3])
> > +#define group_ce(x)		((x)->ces[4])
> 
> I know that this is xyz_ce() macros are the "standard way" in ulogd2 but
> it's ugly. I would do the following:
> 
> enum {
> 	UNIXSOCK_OPT_UNIXPATH = 0,
> 	UNIXSOCK_OPT_BUFSIZE,
> 	UNIXSOCK_OPT_PERM,
> 	UNIXSOCK_OPT_OWNER,
> 	UNIXSOCK_OPT_GROUP,
> };
> 
> Then, we can do the transition easily to several functions like:
> 
> ulogd_option_get_str(UNIXSOCK_OPT_UNIXPATH, upi->config_kset);
> ulogd_option_get_u32(UNIXSOCK_OPT_PERM, upi->config_kset);
> 
> and so on... this is something that I had in my head. I'm not asking you
> to do so but to tell you about my intentions. If we start defining the
> enums now, we can do the transition in the near future.

I'd like that too ! I've defined the enum (and kept the xyz_ce macros
for now). If you want, I can add these functions in another patch ?

> > +
> > +struct ulogd_unixsock_packet_t {
> > +	uint32_t marker;
> > +	uint16_t total_size;
> > +	uint16_t payload_length;
> > +	uint32_t reserved;
> > +	struct iphdr payload;
> > +} __attribute__((packed));
> 
> Probably you can add a version here (even if unused, I'd suggest some
> bits of the reserved field), so if you have a change the header layout
> you can support both versions without breaking backward compatibility.
> 

Indeed, thanks for the suggestion.

> > +
> > +struct ulogd_unixsock_option_t  {
> > +	uint16_t option_id;
> > +	uint16_t option_length;
> > +	char     option_value[0];
> > +} __attribute__((packed));
> > +
> > +#define ALIGN_SIZE 8
> 
> Minor question: why align this to 64 bits?

I originally used an alignment to 32 bits, but Jan noticed it would
break if using options/values on 64 bits (and a test confirmed that). I
took 64 bits as the biggest allowed value for integers.

> 
> Same thing, I'd remove those extra lines here below.
I've removed empty lines and extra line breaks.

> > +
> > +	/* options */
> > +	if (total_len > payload_len + sizeof(u_int16_t)) {
> > +		/* option starts at the next aligned address after the payload */
> > +		new_offset = ALIGN_SIZE + ((payload_len - 1) & ~(ALIGN_SIZE - 1));
> 
> I'd define a macro like NLMSG_ALIGN(), those who are familiar with
> Netlink would easily notice what you're doing :-).
Will do :)

[...]
> > +
> > +	server_sock.sun_family = AF_UNIX;
> > +	strncpy(server_sock.sun_path, unix_path, sizeof(server_sock.sun_path));
> > +	server_sock.sun_path[sizeof(server_sock.sun_path)-1] = '\0';
> > +
> > +	/* remove existing socket, if any */
> > +	unlink(unix_path);
> 
> Probably it's a good idea to check if there's another socket still open.
> You can avoid having two ulogd2 instances by mistake.
Agreed, it's safer.

[...]
> > +/* callback called from ulogd core when fd is readable */
> > +static int unixsock_instance_read_cb(int fd, unsigned int what, void *param)
> > +{
> > +	struct ulogd_pluginstance *upi = param;
> > +	struct unixsock_input *ui = (struct unixsock_input*)upi->private;
> > +	int len;
> > +	u_int16_t needed_len;
> > +	u_int32_t packet_sig;
> > +	struct ulogd_unixsock_packet_t *unixsock_packet;
> > +
> > +	char buf[4096];
> > +
> > +	if (!(what & ULOGD_FD_READ))
> > +		return 0;
> > +
> > +	len = read(fd, buf, sizeof(buf));
> 
> Ah, looking at this, I think that it would be a good idea to ignore
> SIGPIPE to avoid crashing ulogd2 if the other peer has gone.
Yes, I didn't want to do that in the plugin itself. Can I put that in
src/ulogd.c ?

> 
> > +	if (len < 0) {
> > +		ulogd_log(ULOGD_NOTICE, "  read returned %d, errno is %d (%s)\n",
> > +					len, errno, strerror(errno));
> > +		exit(-1);
> > +		return len;
> > +	}
> > +	if (len == 0) {
> > +		_disconnect_client(ui);
> > +		ulogd_log(ULOGD_DEBUG, "  client disconnected\n");
> > +		return 0;
> > +	}
> > +
> > +	//ulogd_log(ULOGD_DEBUG, "  read %d bytes\n", len);
> > +	//ulogd_log(ULOGD_DEBUG, "  buffer [%s]\n", buf);
> 
> Remove or leave the lines above, but those double slashs looks a bit
> ugly to me.
Oops, debug code (removed).

> 
> > +
> > +	if (ui->unixsock_buf_avail + len > ui->unixsock_buf_size) {
> > +		ulogd_log(ULOGD_NOTICE,
> > +			  "We are losing events. Please consider using the clause "
> > +			  "bufsize\n");
> > +		return -1;
> > +	}
> > +
> > +	memcpy(ui->unixsock_buf + ui->unixsock_buf_avail,
> > +	       buf,
> > +	       len);
> 
> We need that line break above, really?
> 
> > +	ui->unixsock_buf_avail += len;
> > +
> > +	do {
> > +		unixsock_packet = (void*)ui->unixsock_buf;
> > +		packet_sig = ntohl(unixsock_packet->marker);
> > +		if (packet_sig != ULOGD_SOCKET_MARK) {
> > +			ulogd_log(ULOGD_ERROR,
> > +				"ulogd2: invalid packet marked received (read %lx, expected %lx), closing socket.\n",
> 
> This line above goes over 80 chars per column?
I've changed some lines to be more 80-chars friendly.

> 
> > +				packet_sig, ULOGD_SOCKET_MARK);
> > +			_disconnect_client(ui);
> > +			return -1;
> > +
> > +		}
> > +
> > +		needed_len = ntohs(unixsock_packet->total_size);
> > +
> > +		if (ui->unixsock_buf_avail >= needed_len + sizeof(u_int32_t)) {
> > +			ulogd_log(ULOGD_DEBUG, "  We have enough data (%d bytes required), handling packet\n", needed_len);
> > +
> > +			if (handle_packet(upi, unixsock_packet, needed_len) != 0) {
> > +				return -1;
> > +			}
> > +			/* consume data */
> > +			ui->unixsock_buf_avail -= (sizeof(u_int32_t) + needed_len);
> > +			if (ui->unixsock_buf_avail > 0) {
> > +				/* we need to shift data .. */
> > +				memmove(ui->unixsock_buf,
> > +						ui->unixsock_buf + (sizeof(u_int32_t) + needed_len) ,
> > +						ui->unixsock_buf_avail);
> > +			} else {
> > +				/* input buffer is empty, do not loop */
> > +				return 0;
> > +			}
> > +
> > +		} else {
> > +			ulogd_log(ULOGD_DEBUG, "  We have %d bytes, but need %d. Requesting more\n",
> > +					ui->unixsock_buf_avail, needed_len + sizeof(u_int32_t));
> > +			return 0;
> > +		}
> > +
> > +		/* handle_packet has shifted data in buffer */
> > +	} while (1);
> 
> I'd put this while(1) above for readability so I don't need to go until
> the end of the code to notice that this is an endless loop ;-).
Heh :)

[...]

Thanks again,
Pierre

