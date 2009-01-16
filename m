From: David Murray <30179198@student.murdoch.edu.au>
Subject: Caching packets with libipq
Date: Fri, 16 Jan 2009 10:41:04 +0900
Message-ID: <20090116104104.kzzlq1ol9g80cgok@wwwstudent.murdoch.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hermiod.murdoch.edu.au ([134.115.4.101]:57131 "EHLO
	hermes.murdoch.edu.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756539AbZAPCJb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jan 2009 21:09:31 -0500
Received: from hermes.murdoch.edu.au (unknown [127.0.0.1])
	by hermes.murdoch.edu.au (Symantec Brightmail Gateway) with ESMTP id 61EF6285C4
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Jan 2009 09:41:07 +0900 (WST)
Received: from student.murdoch.edu.au (student.murdoch.edu.au [134.115.4.69])
	by hermes.murdoch.edu.au (Symantec Mail Security) with ESMTP id 2D6652853A
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Jan 2009 09:41:07 +0900 (WST)
Received: from student.murdoch.edu.au (www-data@localhost [127.0.0.1])
	by student.murdoch.edu.au (8.13.4/8.13.4/Debian-3sarge3) with ESMTP id n0G1f5kY023535
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Jan 2009 10:41:05 +0900
Received: (from www-data@localhost)
	by student.murdoch.edu.au (8.13.4/8.13.4/Submit) id n0G1f4Zg023532
	for netfilter-devel@vger.kernel.org; Fri, 16 Jan 2009 10:41:04 +0900
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am trying to build a TCP proxy that is capable of reordering out of 
order TCP segments before delivering them to the end machine. I plan on 
doing this by analyzing the TCP sequence numbers but for now I am just 
trying to get familiar with netfilter.

I am currently writing this using libipq. The reason that I am not 
using the newer libnetfilter is because there seems to be way more 
documentation and examples for libipq rather than libnetfilter. Using 
libipq I am able to print out packet details and NF_ACCEPT or NF_DROP, 
however, the problem I am having is with copying and storing packets.

The program plan is to anticipate the next sequence number for a each 
flow so: nxt_seq_num  = curr_pkt_seq_num + curr_pkt_data_payload. If I 
detect that one packet is missing I want to buffer up to ten packets 
waiting for the delayed packet.

If a segment is missing from the sequence I want to copy packets into 
memory and NF_DROP until the correct segment arrives. We can then 
replay our buffered packets, and the TCP receiver will receive the 
packets in order.

Currently, I am just trying to see if this is possible in libipq 
because I have not found any similar examples of caching packets in 
libipq. So, in the code snippet below I am trying to cache the 50th 
packet, and then NF_DROP it from the queue. The program should then 
NF_ACCEPT packet 51 and inject packet 50. So if the program was working 
correctly, I would be rearranging the sequence of frames such that 
packets would arrive: 48, 49, 51, 50, 52

The problem is that it appears that packet 50 is never being replayed 
and from the terminal I am getting  a ?Received error message 2?. I 
have been unable to get further information on what this error message 
means. Interestingly, when replaying the cached packet I am still able 
to print out information from it, eg TCP sequence number and 
destination IP address.

Can anyone provide any advice as to how I can narrow this problem down 
further.

Thanks for your time
Dave

status = ipq_set_mode(h, IPQ_COPY_PACKET, BUFSIZE);
     if (status < 0)
    die(h);
        do {
    status = ipq_read(h, buf, BUFSIZE, 0);
    if (status < 0)
      die(h);
                  switch (ipq_message_type(buf)) {
                 case NLMSG_ERROR: {
        fprintf(stderr, "Received error message %d\n",
        ipq_get_msgerr(buf));
        break;
        }

        case IPQM_PACKET: /* got a packet */ {

        ipq_packet_msg_t *m = ipq_get_packet(buf);
                       struct iphdr *ip = (struct iphdr*) m->payload;
        struct tcphdr *tcp = (struct tcphdr*) (m->payload + (4 * ip->ihl));

        int unsigned payload_length = (unsigned int) ntohs(ip->tot_len) 
- ((ip->ihl << 2) + (tcp->doff << 2));
                       if (payload_length > 0) {
                         if (count != 50) {

            printf("This is frame %d dest port %u and seq num %u, size 
%d\n", count, htons(tcp->dest), ntohl(tcp->seq), m->data_len);
            status = ipq_set_verdict(h, m->packet_id, NF_ACCEPT, 0, NULL);
                    }
                           if (count == 50) {

            printf("Not sending 50th packet\n");
            printf("The frame was %d dest port %u and seq num %u, size 
%d\n", count, htons(tcp->dest), ntohl(tcp->seq), m->data_len);
            printf("Chaching instead!\n");

            free(store);            store = (ipq_packet_msg_t 
*)calloc(1, BUFSIZE);
             store->packet_id = m->packet_id;        /* ID of queued packet */
            store->mark = m->mark;                  /* Netfilter mark value */
            store->timestamp_sec = m->timestamp_sec;               
store->timestamp_usec = m->timestamp_usec;                store->hook = 
m->hook;           /* Netfilter hook we rode in on */
            store->hw_protocol = m->hw_protocol;              
store->hw_type = m->hw_type;       /* Hardware type */
            store->data_len = m->data_len;         /* Length of packet data */
            memcpy(store->payload, m->payload, m->data_len);

            status = ipq_set_verdict(h, m->packet_id, NF_DROP, 0, NULL);
            printf("Status: %d\n", status);             }
           if (count == 51) {

            struct iphdr *ip = (struct iphdr*) store->payload;
            struct tcphdr *tcp = (struct tcphdr*) (store->payload + (4 
* ip->ihl));
            printf("Replaying missed frame 50 dest port %u and seq num 
%u, size %d\n", htons(tcp->dest), ntohl(tcp->seq), store->data_len);

            printf("Payload: %s\n", store->payload);
            status = ipq_set_verdict(h, store->packet_id, NF_ACCEPT, 
store->data_len, store->payload);
            printf("Status: %d\n", status);
            }

          count++;
          }

        else {
          status = ipq_set_verdict(h, m->packet_id, NF_ACCEPT, 0, NULL);
          }

        break;
        }
                             default:
        fprintf(stderr, "Unknown message type!\n");
        break;
      }     } while (1);


