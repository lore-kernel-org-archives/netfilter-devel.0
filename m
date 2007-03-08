From: "Julien DHERSIN" <dhersin@gmail.com>
Subject: Problem with libnetfilter_queue and recvmsg (IPv6) ?
Date: Thu, 8 Mar 2007 15:57:15 +0100
Message-ID: <2e25cc380703080657n29ef4420q2eabceee166bda4e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hello,

I think that there is an issue using both libnetfilter_queue library
and recvmsg function to get packets from network.

Here is my code, it's a modification of the utils/nfqnl_test.c file
but I've changed the recv() call by recvmsg(). It seems to me that the
msghdr structure is always empty.

Has anyone tested this before ? And can say me where is my mistake.

Thanks,
Julien

int main(int argc, char **argv) {
	int fd, rv = 0;
	char buffer[4096];
	struct nfq_handle *h;
	struct nfq_q_handle *qh;
	struct nfnl_handle *nh;

	static struct msghdr msg_hdr;
	struct cmsghdr *cmsg;
	struct iovec iov[1];

	h = nfq_open();					/* opening library handle */
	if (!h) {
		fprintf(stderr, "(E) nfq_open()\n"); exit(1);
	}
	if (nfq_unbind_pf(h, AF_INET6) < 0) {		/* unbinding existing nf_queue
handler for AF_INET6 (if any) */
		fprintf(stderr, "(E) nfq_unbind_pf()\n"); exit(1);
	}
	if (nfq_bind_pf(h, AF_INET6) < 0) {		/* binding nfnetlink_queue as
nf_queue handler for AF_INET6 */
		fprintf(stderr, "(E) nfq_bind_pf()\n"); exit(1);
	}
	qh = nfq_create_queue(h,  0, &cb, NULL);	/* binding this socket to queue '0' */
	if (!qh) {
		fprintf(stderr, "(E) nfq_create_queue()\n"); exit(1);
	}
	if (nfq_set_mode(qh, NFQNL_COPY_PACKET, 0xffff) < 0) {	/* setting
copy_packet mode, Oxffff ??? */
		fprintf(stderr, "(E) packet_copy mode\n"); exit(1);
	}
	nh = nfq_nfnlh(h);
	fd = nfnl_fd(nh);

 	memset(&msg_hdr, 0, sizeof(struct msghdr));
 	memset(iov, 0, sizeof(iov));
 	iov[0].iov_base = buffer;
 	iov[0].iov_len = sizeof(buffer);
 	msg_hdr.msg_iov = iov;
 	msg_hdr.msg_iovlen = 1;
	msg_hdr.msg_name = NULL;
	msg_hdr.msg_namelen = 0;
	msg_hdr.msg_control = (struct cmsghdr *) cmsg;
	msg_hdr.msg_controllen = sizeof (struct cmsghdr);
	msg_hdr.msg_flags = 0;

	while(1) {
		rv = recvmsg(fd, &msg_hdr, 0);
		if (rv < 0) {
			printf("(E) recvmsg()\n");
		} else {
			printf("(I) Name len : %d - Control len : %d\n",
msg_hdr.msg_namelen, msg_hdr.msg_controllen);
			printf("*****\n(I) nfq_handle_packet() : %d\n",
nfq_handle_packet(h, (char *) iov[0].iov_base, rv));
		}

	}
	nfq_destroy_queue(qh);				/* unbinding from queue 0 */
	nfq_close(h);					/* closing library handle */
	exit(0);
}
