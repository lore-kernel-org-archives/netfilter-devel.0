From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: ip_queue questions
Date: Sat, 26 Mar 2005 09:54:40 +0200
Message-ID: <42451540.4060800@outerspace.dyndns.org>
References: <42450A7E.8050404@ufh.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter <netfilter-devel@lists.netfilter.org>
To: Peter Enderborg <pme@ufh.se>
In-Reply-To: <42450A7E.8050404@ufh.se>
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

Peter Enderborg wrote:

> Is there any non trivial example of howto use netlink?

No, it's pretty trivial to do anything with libipq imo :D

> A non trivial is something that use do something with the packet and 
> returns a modifyed packet form userland.

This code has never been used, I just wrote it for you :)

void handle(void)
{
    static unsigned char packet[65536];

    // fetch data
    if(ipq_read(ipq_h, packet, sizeof(packet), 0) < 0) {
       ipq_perror("ipq_read");
       return;
    }

    // check type
    if (ipq_message_type(packet) != IPQM_PACKET) {
       fprintf(stderr, "Received error message %d\n",
               ipq_get_msgerr(packet));
       return;
    }

    ipq_packet_msg_t *msg = ipq_get_packet(packet);

    // ensure we got some data (maybe I'm paranoid)
    if(msg->data_len == 0) {
       ipq_set_verdict(ipq_h, msg->packet_id, NF_DROP, 0, 0);
       return;
    }

    // IP, TCP etc structs I have copypasted from /usr/include/linux/ip.h etc
    struct iphdr *iph = (struct iphdr *)msg->payload;

    // let's say we want to remove all ip options
    // get pointer to start of ip options..
    unsigned char *options = &iph[1];
    // .. and current end of ip header = end of ip options
    unsigned char *options_end = ((unsigned *)iph) + iph->ihl;

    if(end_of_options == options) {
       // no options, do nothing and accept
       ipq_set_verdict(ipq_h, msg->packet_id, NF_ACCEPT, 0, 0);
       return;
    }

    // kill!
    memmove(options, options_end,
           (unsigned char *)iph + msg->data_len - options_end);

    // update lengths
    iph->ihl = sizeof(struct iphdr) / 4;
    iph->tot_len -= options_end - options;

    // ##TODO## update checksum maybe

    ipq_set_verdict(ipq_h, msg->packet_id, NF_ACCEPT,
                    msg->data_len - (options_end - options), msg->payload);
}

Hope you get some idea.. And hope I didn't do it the wrong way or something :)

> And is there any way to do matching rule in userland? ipq_set_verdict() 
> must have NF_ACCEPT or NF_DROP.
> I whould like to do something similar to the MARK, just modify the data 
> and then continue.

Currently, no :/

Maybe some day.. I don't know enough (yet) to do it myself..

-- 
- xkr47
