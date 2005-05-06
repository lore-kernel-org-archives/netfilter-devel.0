From: BJ Premore <bj-netfilter@renesys.com>
Subject: Re: changing packet length?
Date: Fri, 6 May 2005 10:11:59 -0400
Message-ID: <20050506141159.GA17261@tigris.renesys.com>
References: <20050503213406.GE13894@tigris.renesys.com>
	<20050506111410.GG30482@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050506111410.GG30482@sunbeam.de.gnumonks.org>
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

Hi Harald,

On Fri, May 06, 2005 at 01:14:10PM +0200, Harald Welte wrote:
> On Tue, May 03, 2005 at 05:34:06PM -0400, BJ Premore wrote:
> > So my hopefully simple question is, can packet sizes be
> > changed and then reinjected using ipq_set_verdict?  
> 
> Of course. you just reinject the packet with a different
> data_len.

That's what I thought too, but I get the problems described
in my original post (subsequent packets start looking
mangled, basically).  Have you, or has anyone, gotten this
to work?  I've been scouring the net for examples but in no
case has any code that I've found actually changed the
length of the packets before reinjecting them.

I started with the sample code from the libipq man page and
made incremental modifications as I worked toward my goal of
adding extra options to the TCP header.  Everything worked
fine along the way, including changing the contents of the
packet without changing its length, until I tried increasing
the header by 4 bytes with four no-op TCP options.

I've attached my code below.  I've been using tcpdump to
watch packets come and go.  The TCP handshake completes, but
each successive packet's payload starts accumulating extra
bytes (which usually contain recognizable portions of the
headers and payloads of previous packets).  I'm hoping
there's some silly fundamental mistake I've made that I'm
overlooking, but I've been over the code so many times now
that if I have made such a mistake, I'm blind to it.

Thanks in advance,

-BJ


#include <linux/netfilter.h>
#include <libipq.h>
#include <stdio.h>

#define BUFSIZE 65535

static void die(struct ipq_handle *h) {
  ipq_perror("passer");
  ipq_destroy_handle(h);
  exit(1);
}

int main(int argc, char **argv) {
  int status;
  unsigned char buf[BUFSIZE];
  struct ipq_handle *h;

  h = ipq_create_handle(0, PF_INET);
  if (!h)
    die(h);

  status = ipq_set_mode(h, IPQ_COPY_PACKET, BUFSIZE);
  if (status < 0)
    die(h);

  // to reuse for all packets--should be plenty big enough
  unsigned char *pkt = malloc(10000);
  bzero(pkt,10000);

  do {
    bzero(&buf,BUFSIZE);
    
    status = ipq_read(h, buf, BUFSIZE, 0);
    if (status < 0)
      die(h);

    switch (ipq_message_type(buf)) {
    case NLMSG_ERROR:
      fprintf(stderr, "Received error message %d\n",
              ipq_get_msgerr(buf));
      break;

    case IPQM_PACKET: {
      ipq_packet_msg_t *m = ipq_get_packet(buf);

      int debug = 1;

      fprintf(stderr, "\ngot a packet of length %d\n", m->data_len);

      unsigned char *pkt1 = m->payload; // ptr to start of packet

      fprintf(stderr, "packet destination: %d.%d.%d.%d\n",
              pkt1[16], pkt1[17], pkt1[18], pkt1[19]);
      // for now, only deal with outgoing packets to 1.2.3.4
      // [IP address anonymized for posting]
      if (pkt1[16] != 1 || pkt1[17] != 2 || pkt1[18] != 3 || pkt1[19] != 4) {
	fprintf(stderr,"... skipping packet\n");
	status = ipq_set_verdict(h, m->packet_id, NF_ACCEPT, 0, NULL);
	break;
      }

      // calculate the packet length
      int ipHdrLen = ((int)(pkt1[0] & 0x0f))*4;
      if (debug) fprintf(stderr,"IP header len: %d\n",ipHdrLen);
      int ipPktLen = (pkt1[2]<<8) + pkt1[3];
      if (debug) fprintf(stderr,"IP packet len: %d\n",ipPktLen);
      int tcpHdrLen = (((int)pkt1[ipHdrLen+12])>>4)*4;
      if (debug) fprintf(stderr,"TCP header len: %d\n",tcpHdrLen);
      int tcpOptsLen = tcpHdrLen - 20;
      if (debug) fprintf(stderr,"TCP options len: %d\n",tcpOptsLen);
      int tcpDataLen = ipPktLen - (ipHdrLen+tcpHdrLen);
      if (debug) fprintf(stderr,"TCP data len: %d\n",tcpDataLen);
      int tcpDataOffset = ipHdrLen+tcpHdrLen;
      if (debug) fprintf(stderr,"TCP data offset: %d\n",tcpDataOffset);

      // print the bytes, exactly as they have been passed to us
      if (debug) {
	fprintf(stderr, "IP header:");
	int i = 0;
	while (i<m->data_len) {
	  if ((i%4) == 0) {
	    fprintf(stderr, "\n    ");
	  }
	  if ((i==ipHdrLen || i==ipHdrLen+tcpHdrLen)) {
	    fprintf(stderr, "----------\n    ");
	  }
	  fprintf(stderr, "%02x ", pkt1[i]);
	  i++;
	}
	fprintf(stderr, "\n");
      }

      // zero our local copy
      bzero(pkt,10000);

      // copy into our own, safe, reusable memory:
      int i = 0;
      for (i=0; i<ipPktLen; i++) {
	pkt[i] = pkt1[i];
      }

      //
      // Update some of the field values in the IP & TCP headers (such
      // as to account for the increasing length of the packet).
      //

      // The new header length is the previous header length + 4, since
      // we're just adding 4 1-byte no-op options.
      int newTcpHdrLen = tcpHdrLen+4;
      if (newTcpHdrLen > 60) {
	fprintf(stderr,"max TCP header size exceeded (%d)",newTcpHdrLen);
        die(h);
	break;
      }

      int newIpPktLen = ipPktLen+4;
      m->data_len = newIpPktLen;
      // modify the IP packet's total length field
      pkt[2] = (unsigned char)((newIpPktLen>>8) & 0xff);
      pkt[3] = (unsigned char)(newIpPktLen & 0xff);

      // The first 4 bits of this next byte contains the data offset
      // in 4-byte words (aka the header length in bytes, divided by
      // 4), followed by four 0-valued reserved bits.  (The value of
      // newTcpHdrLen is always a multiple of 4 at this point.)
      int newTcpHdrLenWords = (int)(newTcpHdrLen/4.0);
      // update it in the actual packet data
      pkt[ipHdrLen+12] = (unsigned char)((newTcpHdrLenWords<<4) & 0xff);

      // modify TCP packet as necessary: set new header field length,
      // add the no-ops to the options, shift the data back

      // shift the data to make room for the 4 no-op options in the header
      memmove(pkt+tcpDataOffset+4, pkt+tcpDataOffset, tcpDataLen);

      //
      // Update the TCP header.
      //

      // add the 4 no-op options
      pkt[ipHdrLen+tcpHdrLen]   = (unsigned char)1; // option Kind = 1
      pkt[ipHdrLen+tcpHdrLen+1] = (unsigned char)1;
      pkt[ipHdrLen+tcpHdrLen+2] = (unsigned char)1;
      pkt[ipHdrLen+tcpHdrLen+3] = (unsigned char)1;

      // BEGIN: compute the TCP checksum
      int total = 0; 
      i = ipHdrLen; // the offset of the start of the TCP packet header
      int imax = ipHdrLen + 16; // the offset of the TCP checksum field

      while (i < imax) {
	total += ((pkt[i] << 8) | pkt[i+1]);
	i += 2;
      }
      // Skip existing checksum.
      i = ipHdrLen + 18;
      imax = newIpPktLen;

      while (i < imax) {
	total += ((pkt[i] << 8) | pkt[i+1]);
	i += 2;
      }

      // add source and dest addresses, grouped as 16-byte integers
      total += (pkt[12] << 8) | pkt[13];
      total += (pkt[14] << 8) | pkt[15];
      total += (pkt[16] << 8) | pkt[17];
      total += (pkt[18] << 8) | pkt[19];
      total += 6; // add protocol number
      total += newTcpHdrLen+tcpDataLen; // add TCP packet length

      // fold to 16 bits
      while ((total & 0xffff0000) != 0) {
	total = (total & 0xffff) + (total >> 16);
      }
      total = ~total; // take one's complement

      // replace the old checksum value with the new one
      pkt[ipHdrLen+16] = (total >> 8);
      pkt[ipHdrLen+17] = total & 0xff;
      // END: compute the TCP checksum

      // BEGIN: compute the IP checksum
      i = 0;
      total = 0;

      // 10 is the offset of the checksum field itself
      while (i < 10) {
	total += ((pkt[i] << 8) | pkt[i+1]);
	i += 2;
      }

      i = 12; // skip existing checksum field
      while (i < ipHdrLen) {
	total += ((pkt[i] << 8) | pkt[i+1]);
	i += 2;
      }

      // fold to 16 bits
      while ((total & 0xffff0000) != 0) {
	total = (total & 0xffff) + (total >> 16);
      }
      total = ~total; // one's complement

      // put the new checksum in place over the old one
      pkt[10] = (unsigned char)(total >> 8);
      pkt[11] = (unsigned char)(total & 0xff);
      // END: compute the IP checksum

      // print the bytes of the new, modified packet
      if (debug) {
	fprintf(stderr, "new packet:");
	int i = 0;
	while (i<ipHdrLen+newTcpHdrLen+tcpDataLen) {
	  if ((i%4) == 0) {
	    fprintf(stderr, "\n    ");
	  }
	  if ((i==ipHdrLen || i==ipHdrLen+newTcpHdrLen)) {
	    fprintf(stderr, "----------\n    ");
	  }
	  fprintf(stderr, "%02x ", pkt[i]);
	  i++;
	}
	fprintf(stderr, "\n");
      }

      // reinject the modified packet
      fprintf(stderr,"  reinjecting modified packet, length "+ newIpPktLen);
      status = ipq_set_verdict(h, m->packet_id, NF_ACCEPT, m->data_len, pkt);

      if (status < 0)
        die(h);
      break;
    }

    default:
      fflush(stderr);
      fflush(stdout);
      fprintf(stderr, "Unknown message type???\n");
      fflush(stderr);
      fflush(stdout);
      break;
    }
  } while (1);

  ipq_destroy_handle(h);
  return 0;

}
