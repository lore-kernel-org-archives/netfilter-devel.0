From: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Subject: ulogd - polling handler - code clarification
Date: Mon, 30 Jul 2012 15:18:32 -0700
Message-ID: <CAAJpzgbKeTz2=Qsf035TSDQ19rvbLxnA2AcwFLHKDSXzZYZtkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51218 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab2G3WSx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jul 2012 18:18:53 -0400
Received: by yhmm54 with SMTP id m54so5429762yhm.19
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Jul 2012 15:18:52 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I was going through the ulogd_inpflow_NFCT.c : polling_handler code. I
need few clarifications.
If someone can answer for that, that will be great.


 725         case NFCT_T_UPDATE:
 726                 id = hashtable_hash(cpi->ct_active, ct);
 727                 ts = (struct ct_timestamp *)
 728                         hashtable_find(cpi->ct_active, ct, id);
 729                 if (ts)
 730                         nfct_copy(ts->ct, ct, NFCT_CP_META);
 731                 else {
 732                         ts = calloc(sizeof(struct ct_timestamp), 1);
 733                         if (ts == NULL)
 734                                 return NFCT_CB_CONTINUE;
 735
 736                         ts->ct = ct;
 737                         gettimeofday(&ts->time[START], NULL);
 738
 739                         ret = hashtable_add(cpi->ct_active,
&ts->hashnode, id);
 740                         if (ret < 0) {
 741                                 free(ts);
 742                                 return NFCT_CB_CONTINUE;
 743                         }
 744                         return NFCT_CB_STOLEN; // Here, why not
NFCT_CB_CONTINUE is used?
 745                 }
 746                 break;

Here in Line no 744, why NFCT_CB_STOLEN is used instead of
NFCT_CB_CONTINUE ? I am not able to understand the reason.


Thanks & Regards,
