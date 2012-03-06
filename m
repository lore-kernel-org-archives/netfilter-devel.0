From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: scheduling while atomic followed by oops upon conntrackd -c
 execution
Date: Tue, 6 Mar 2012 12:14:27 +0100
Message-ID: <20120306111427.GA448@1984>
References: <4F50E30B.6000704@gmail.com>
 <20120303133002.GA18802@1984>
 <jitp0d$4lv$1@dough.gmane.org>
 <20120304110151.GA22404@1984>
 <jj2sjo$i8a$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="yNb1oOkm5a9FJOVX"
Cc: netfilter-devel@vger.kernel.org
To: Kerin Millar <kerframil@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45188 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475Ab2CFLOh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Mar 2012 06:14:37 -0500
Content-Disposition: inline
In-Reply-To: <jj2sjo$i8a$1@dough.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kerin,

On Mon, Mar 05, 2012 at 05:19:49PM +0000, Kerin Millar wrote:
> Hi Pablo,
> 
> On 04/03/2012 11:01, Pablo Neira Ayuso wrote:
> >Hi Kerin,
> >
> >On Sat, Mar 03, 2012 at 06:47:27PM +0000, Kerin Millar wrote:
> >>Hi,
> >>
> >>On 03/03/2012 13:30, Pablo Neira Ayuso wrote:
> >>>I just posted another patch to the ML that is a relative fix to
> >>>Jozsef's patch. You have to apply that as well.
> >>
> >>I've now tested 3.3-rc5 with the addition of the above mentioned
> >>follow-on patch. The behaviour during conntrackd -c execution is
> >>clearly much improved - in so far as it doesn't generate much noise
> >>- but the crash that follows remains. Here's a netconsole capture:-
> >>
> >>http://paste.pocoo.org/raw/560439/
> >
> >Great to know :-).
> 
> I apologize but I think I may have led you astray on the nf_nat
> issue. At the time of submitting my original report, I now believe
> that the nf_nat module wasn't loaded prior to starting conntrackd,
> although it was definitely available. For all tests that followed,
> however, I am entirely certain the the nf_nat module was loaded in
> advance. The upshot is that my claim that things had improved may
> have been premature; I need to specifically test under both
> circumstances to be sure that things are improving. That is, both
> with and without the module loaded in advance.
> 
> Following my own advice then, I first tried going through my test
> case *without* loading nf_nat in advance. Alas, conntrackd -c
> triggered hard lockups and didn't return to prompt. Here are the
> results:-
> 
> http://paste.pocoo.org/raw/561350/
> 
> In case it matters, the existing ssh session continued to respond to
> input but I was no longer able to initiate any new sessions.
> 
> >
> >Regarding your previous email, I'm sorry, by reading your email I
> >thought you were using 2.6.32 which was not the case, your
> >configuration is perfectly reasonable.
> >
> >It seems we still have problems regarding early_drop, but this time
> >with reliable event delivery enabled (15 seconds is the time that
> >is required to retry sending the destroy event).
> >
> >If you can test the following patch, I'll appreciate.
> 
> Gladly. I applied the patch to my 3.3-rc5 tree, which is still
> carrying the two patches discussed earlier in the thread. I then
> went through my test case under normal circumstances i.e. all
> firewall rules in place, nf_nat confirmed present before conntrackd
> etc. Again, conntrackd -c did not return to prompt. Here are the
> results:-
> 
> http://paste.pocoo.org/raw/561354/
>
> Well, at least there was no oops this time. I should also add that
> the patch was present for both of the tests mentioned in this email.

Previous patch that I sent you was not OK, sorry. I have committed the
following to my git tree:

http://1984.lsi.us.es/git/net/commit/?id=691d47b2dc8fdb8fea5a2b59c46e70363fa66897

I've been using the following tools that you can find enclosed to this
email, they are much more simple than conntrackd but, they do the same
in essence:

* conntrack_stress.c
* conntrack_events.c

gcc -lnetfilter_conntrack conntrack_stress.c -o ct_stress
gcc -lnetfilter_conntrack conntrack_events.c -o ct_events

Then, to listen to events with reliable event delivery enabled:

# ./ct_events &

And to create loads of flow entries in ASSURED state:

# ./ct_stress 65535 # that's my ct table size in my laptop

You'll hit ENOMEM errors at some point, that's fine, but no oops or
lockups happen here.

I have pushed this tools to the qa/ directory under
libnetfilter_conntrack:

commit 94e75add9867fb6f0e05e73b23f723f139da829e
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue Mar 6 12:10:55 2012 +0100

    qa: add some stress tools to test conntrack via ctnetlink

(BTW, ct_stress may disrupt your network connection since the table
gets filled. You can use conntrack -F to get the ct table empty again).

> ---
> Incidentally, I found out why the internal cache on the master was
> filling up to capacity. It was apparently due to the use of
> "iptables -I PREROUTING -t raw -j CT --ctevents assured". Perhaps
> I'm missing something but doesn't this stop events such as new and
> destroy from being propagated? An inspection with conntrack -E
> suggests so. Once I removed the above rule, I could see destroy
> events being propagated and the number of active connections in the
> cache no longer exceeded my chosen limit of 2097152 ...

Yes, that line was wrong, I have fixed in the documentation, the
correct one must be:

iptables -I PREROUTING -t raw -j CT --ctevents assured,destroy

Thus, destroy events are delivered to user-space.

> # conntrack -S | head -n1; conntrackd -s | head -n2
> entries                 725826
> cache internal:
> current active connections:          1409472
> 
> Whatever the case, I'm quite happy to go without this rule as these
> systems are coping fine with the load incurred by conntrackd.

I want to get things fixed, please, don't give up on using that rule
yet :-).

Regarding the hardlockups. I'd be happy if you can re-do the tests,
both with conntrackd and the tools that I send you.

Make sure you have these three patches, note that the last one has
changed.

http://1984.lsi.us.es/git/net/commit/?id=7d367e06688dc7a2cc98c2ace04e1296e1d987e2
http://1984.lsi.us.es/git/net/commit/?id=a8f341e98a46f579061fabfe6ea50be3d0eb2c60
http://1984.lsi.us.es/git/net/commit/?id=691d47b2dc8fdb8fea5a2b59c46e70363fa66897

Thanks!

--yNb1oOkm5a9FJOVX
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="conntrack_events.c"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include <libnetfilter_conntrack/libnetfilter_conntrack.h>

static int event_cb(enum nf_conntrack_msg_type type,
		    struct nf_conntrack *ct,
		    void *data)
{
	static int i = 0;
	static int new, destroy;

	if (type == NFCT_T_NEW)
		new++;
	else if (type == NFCT_T_DESTROY)
		destroy++;

	if ((++i % 10000) == 0)
		printf("%d events received (%d new, %d destroy)\n",
			i, new, destroy);

	return NFCT_CB_CONTINUE;
}

int main(void)
{
	int ret;
	struct nfct_handle *h;
	int on = 1;

	h = nfct_open(CONNTRACK, NFCT_ALL_CT_GROUPS);
	if (!h) {
		perror("nfct_open");
		return 0;
	}

	setsockopt(nfct_fd(h), SOL_NETLINK,
			NETLINK_BROADCAST_SEND_ERROR, &on, sizeof(int));
	setsockopt(nfct_fd(h), SOL_NETLINK,
			NETLINK_NO_ENOBUFS, &on, sizeof(int));

	nfct_callback_register(h, NFCT_T_ALL, event_cb, NULL);

	printf("TEST: waiting for events...\n");

	ret = nfct_catch(h);

	printf("TEST: conntrack events ");
	if (ret == -1)
		printf("(%d)(%s)\n", ret, strerror(errno));
	else
		printf("(OK)\n");

	nfct_close(h);

	ret == -1 ? exit(EXIT_FAILURE) : exit(EXIT_SUCCESS);
}

--yNb1oOkm5a9FJOVX
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="conntrack_stress.c"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <arpa/inet.h>

#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
#include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>

int main(int argc, char *argv[])
{
	time_t t;
	int ret, i, r;
	struct nfct_handle *h;
	struct nf_conntrack *ct;

	if (argc < 2) {
		fprintf(stderr, "Usage: %s [ct_table_size]\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	time(&t);
	srandom(t);
	r = random();

	ct = nfct_new();
	if (!ct) {
		perror("nfct_new");
		return 0;
	}

	h = nfct_open(CONNTRACK, 0);
	if (!h) {
		perror("nfct_open");
		nfct_destroy(ct);
		return -1;
	}

	for (i = r;i < (r + atoi(argv[1]) * 2); i++) {
		nfct_set_attr_u8(ct, ATTR_L3PROTO, AF_INET);
		nfct_set_attr_u32(ct, ATTR_IPV4_SRC, inet_addr("1.1.1.1") + i);
		nfct_set_attr_u32(ct, ATTR_IPV4_DST, inet_addr("2.2.2.2") + i);

		nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_TCP);
		nfct_set_attr_u16(ct, ATTR_PORT_SRC, htons(10));
		nfct_set_attr_u16(ct, ATTR_PORT_DST, htons(20));

		nfct_setobjopt(ct, NFCT_SOPT_SETUP_REPLY);

		nfct_set_attr_u8(ct, ATTR_TCP_STATE, TCP_CONNTRACK_ESTABLISHED);
		nfct_set_attr_u32(ct, ATTR_TIMEOUT, 1000);
		nfct_set_attr_u32(ct, ATTR_STATUS, IPS_ASSURED);

		if (i % 10000 == 0)
			printf("added %d flow entries\n", i);

		ret = nfct_query(h, NFCT_Q_CREATE, ct);
		if (ret == -1)
			perror("nfct_query: ");
	}
	nfct_close(h);

	nfct_destroy(ct);

	ret == -1 ? exit(EXIT_FAILURE) : exit(EXIT_SUCCESS);
}

--yNb1oOkm5a9FJOVX--
