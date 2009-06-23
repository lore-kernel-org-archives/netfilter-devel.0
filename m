From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: null-pointer deref in ulogd2
Date: Tue, 23 Jun 2009 17:40:39 +0200
Message-ID: <4A40F777.7010505@netfilter.org>
References: <h1q05h$o8h$1@ger.gmane.org> <h1q3tu$2vi$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080300030502080509070703"
Cc: netfilter-devel@vger.kernel.org
To: Bernhard Schmidt <berni@birkenwald.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42471 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbZFWPks (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:40:48 -0400
In-Reply-To: <h1q3tu$2vi$1@ger.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080300030502080509070703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Bernhard Schmidt wrote:
> Bernhard Schmidt <berni@birkenwald.de> wrote:
> 
>> now it seems to work okay. In the database about 90% of the flows have
>> flow_end_sec NULL.

Please, rise "netlink_socket_buffer_size" and
"netlink_socket_buffer_maxsize". If you use the default buffer, it's
likely to overrun and, thus, to lose events.

[...]
> What is happening here?

I think that you're using the default "hash_max_entries" which is too
small. I suggest you to rise this value. I'm going to push a patch that
includes information on these parameter tweaking to the example config file.

BTW, could you give a quick test to this patch, yours seems to leak
memory since NFCT_CB_STOLEN means not to release the ct object (no
problem, I guess that you're not familiar with libnetfilter_conntrack).

Thanks for testing.

--------------080300030502080509070703
Content-Type: text/x-diff;
 name="fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix.patch"

NFCT: fix NULL dereference when hashtable is full

This patch fixes a NULL dereference to the timestamp structure when
hashtable_add() fails, for example, because the hashtable is full.

Reported-by: Bernhard Schmidt <berni@birkenwald.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 input/flow/ulogd_inpflow_NFCT.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)


diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index b8278af..b16687e 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -596,6 +596,9 @@ static int event_handler(enum nf_conntrack_msg_type type,
 	switch(type) {
 	case NFCT_T_NEW:
 		ts = hashtable_add(cpi->ct_active, &tmp);
+		if (ts == NULL)
+			return NFCT_CB_CONTINUE;
+
 		gettimeofday(&ts->time[START], NULL);
 		return NFCT_CB_STOLEN;
 	case NFCT_T_UPDATE:
@@ -604,6 +607,9 @@ static int event_handler(enum nf_conntrack_msg_type type,
 			nfct_copy(ts->ct, ct, NFCT_CP_META);
 		else {
 			ts = hashtable_add(cpi->ct_active, &tmp);
+			if (ts == NULL)
+				return NFCT_CB_CONTINUE;
+
 			gettimeofday(&ts->time[START], NULL);
 			return NFCT_CB_STOLEN;
 		}
@@ -734,6 +740,9 @@ static int overrun_handler(enum nf_conntrack_msg_type type,
 	/* if it does not exist, add it */
 	if (!hashtable_get(cpi->ct_active, &tmp)) {
 		ts = hashtable_add(cpi->ct_active, &tmp);
+		if (ts == NULL)
+			return NFCT_CB_CONTINUE;
+
 		gettimeofday(&ts->time[START], NULL); /* do our best here */
 		return NFCT_CB_STOLEN;
 	}

--------------080300030502080509070703--
