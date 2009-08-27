From: Kuzin Andrey <kuzinandrey@yandex.ru>
Subject: Re: Fwd: Modifying TCP packets with libnetfilter_queue
Date: Thu, 27 Aug 2009 09:34:10 +0400
Message-ID: <804829123.20090827093410@yandex.ru>
References: <c97a47b90908262115l1dc29b78q7c02661b64af8cd9@mail.gmail.com>
 <c97a47b90908262116q61d4a77fif52cb49880a4d3d1@mail.gmail.com>
Reply-To: Kuzin Andrey <kuzinandrey@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Michael Lawson (mshindo)" <michael@sphinix.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward15.yandex.ru ([95.108.130.119]:54985 "EHLO
	forward15.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbZH0FkP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Aug 2009 01:40:15 -0400
In-Reply-To: <c97a47b90908262116q61d4a77fif52cb49880a4d3d1@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

MLm> Hi,
MLm> I am attempting to adjust contents of tcp packets using the nf queue
MLm> system, the queue part is working as I expected, however I am running
MLm> into problems recalculating the tcp checksum. At the moment, the
MLm> packet isnt being changed, and I am simply reading the checksum, then
MLm> trying to regenerate it, these values arent matching and I am at a
MLm> loss as to where I am going wrong.
MLm> Any help or suggestions please? I am at a loss

Try this code stolen from tcpdump and other cool stuff.

/*
 * IP header checksum.
 * don't modifiy the packet.
 */
u_short
in_cksum(const u_short *addr, register u_int len, int csum)
{
        int nleft = len;
        const u_short *w = addr;
        u_short answer;
        int sum = csum;

        /*
         *  Our algorithm is simple, using a 32 bit accumulator (sum),
         *  we add sequential 16 bit words to it, and at the end, fold
         *  back all the carry bits from the top 16 bits into the lower
         *  16 bits.
         */
        while (nleft > 1)  {
                sum += *w++;
                nleft -= 2;
        }
        if (nleft == 1)
                sum += htons(*(u_char *)w<<8);

        /*
         * add back carry outs from top 16 bits to low 16 bits
         */
        sum = (sum >> 16) + (sum & 0xffff);     /* add hi 16 to low 16 */
        sum += (sum >> 16);                     /* add carry */
        answer = ~sum;                          /* truncate to 16 bits */
        return (answer);
}

static int tcp_cksum(register const struct ip *ip,
                     register const struct tcphdr *tp,
                     register u_int len)
{
        union phu {
                struct phdr {
                        u_int32_t src;
                        u_int32_t dst;
                        u_char mbz;
                        u_char proto;
                        u_int16_t len;
                } ph;
                u_int16_t pa[6];
        } phu;
        const u_int16_t *sp;

        /* pseudo-header.. */
        phu.ph.len = htons((u_int16_t)len);
        phu.ph.mbz = 0;
        phu.ph.proto = IPPROTO_TCP;
        memcpy(&phu.ph.src, &ip->ip_src.s_addr, sizeof(u_int32_t));
        if ( (ip->ip_hl & 0x0f) == 5)
                memcpy(&phu.ph.dst, &ip->ip_dst.s_addr, sizeof(u_int32_t));
        else
                phu.ph.dst = ip_finddst(ip);

        sp = &phu.pa[0];
        return in_cksum((u_short *)tp, len,
                        sp[0]+sp[1]+sp[2]+sp[3]+sp[4]+sp[5]);
}


void recalculate_tcp_checksum(unsigned char *packet)
{
    struct ip *ip_packet = NULL;
    struct tcphdr *tcp_packet = NULL;
    u_int16_t word16, padd = 0, i, sum = 0, tcp_len;
    unsigned char *buff;
    if (!packet) return;

    ip_packet = (struct ip *)packet;
    tcp_packet = (struct tcphdr *)(packet + (ip_packet->ip_hl << 2));
    tcp_len = ntohs(ip_packet->ip_len) - (ip_packet->ip_hl << 2);

    sum = tcp_cksum(ip_packet,tcp_packet,tcp_len);
    tcp_packet->check = sum; //ntohs(sum);
}


Use recalculate_tcp_checksum() on your modified payload in this way:


    void *packet;
    struct ip *ip_packet = NULL;
    struct tcphdr *tcp_packet = NULL;
    unsigned char *tcp_packet_content = NULL;

.......
    ip_packet = ((struct ip *)packet);

    if (ip_packet->ip_p == IPPROTO_TCP) {
        tcp_packet = (struct tcphdr *)(packet + sizeof(struct ip));
        tcp_packet_content = (unsigned char *)(packet + sizeof(struct ip) + sizeof(struct tcphdr));
        tcp_packet_content_size = htons(ip_packet->ip_len) - sizeof(struct ip) - sizeof(struct tcphdr);
        .......
        // modify payload...
        .......
        // calculate
        tcp_packet->check = 0;
        recalculate_tcp_checksum(packet);
   }

You also can move some of this code to recalculate_tcp_checksum() and
simply call recalculate_tcp_checksum() without any payload preparations.
   
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
Kuzin Andrey  -  kuzinandrey@yandex.ru
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=



