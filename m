From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Thu, 17 Jul 2008 16:15:10 +0100
Message-ID: <487F61FE.1050508@gmx.ch>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org> <487F5874.3000905@gmx.ch>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000001090603090903030205"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36134 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756220AbYGQPPM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:15:12 -0400
In-Reply-To: <487F5874.3000905@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000001090603090903030205
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Fabian Hugelshofer wrote:
> To reduce any side effects I wrote a small test application which just 
> reads the ctevent socket and does nothing else. You find it attached to 
> this email.

Forgot to attach, you find it in this email...

--------------000001090603090903030205
Content-Type: text/x-csrc;
 name="ctevtest.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctevtest.c"

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <signal.h>

#include <libnfnetlink/libnfnetlink.h>
#include <libnetfilter_conntrack/libnetfilter_conntrack.h>


volatile sig_atomic_t terminate;


static void __sig_handler(int sig)
{
	switch (sig) {
		case SIGTERM:
		case SIGINT:
			terminate = 1;
			break;
	}
}

int main(int argc, char* argv[])
{
	struct nfct_handle *h;
	struct sigaction sigact;
	char buf[NFNL_BUFFSIZE] __attribute__ ((aligned));
	int len;
	int events = 0;
	int overflows = 0;

	terminate = 0;
	sigact.sa_handler = &__sig_handler;
	sigaction(SIGINT, &sigact, NULL);
	sigaction(SIGTERM, &sigact, NULL);

	h = nfct_open(NFNL_SUBSYS_CTNETLINK,
			NF_NETLINK_CONNTRACK_NEW | NF_NETLINK_CONNTRACK_DESTROY);
	if (h == NULL) {
		perror("opening ctnetlink failed");
		exit(EXIT_FAILURE);
	}
	
	while (!terminate) {
		len = recv(nfct_fd(h), buf, sizeof(buf), 0);
		if (len < 0) {
			if (errno == ENOBUFS) {
				overflows++;
			} else if (errno != EINTR) {
				perror("recv failed");
				nfct_close(h);
				exit(EXIT_FAILURE);
			}
		} else {
			events++;
		}
	}

	printf("%d events received (%d overflows)\n", events, overflows);

	nfct_close(h);

	exit(EXIT_SUCCESS);
}

--------------000001090603090903030205--
