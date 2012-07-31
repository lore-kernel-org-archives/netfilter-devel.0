From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulogd - polling handler - code clarification
Date: Tue, 31 Jul 2012 13:27:56 +0200
Message-ID: <20120731112756.GA3698@1984>
References: <CAAJpzgbKeTz2=Qsf035TSDQ19rvbLxnA2AcwFLHKDSXzZYZtkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43584 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab2GaL16 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Jul 2012 07:27:58 -0400
Content-Disposition: inline
In-Reply-To: <CAAJpzgbKeTz2=Qsf035TSDQ19rvbLxnA2AcwFLHKDSXzZYZtkQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 30, 2012 at 03:18:32PM -0700, Gomathivinayagam Muthuvinayagam wrote:
> Hi,
> 
> I was going through the ulogd_inpflow_NFCT.c : polling_handler code. I
> need few clarifications.
> If someone can answer for that, that will be great.
> 
> 
>  725         case NFCT_T_UPDATE:
>  726                 id = hashtable_hash(cpi->ct_active, ct);
>  727                 ts = (struct ct_timestamp *)
>  728                         hashtable_find(cpi->ct_active, ct, id);
>  729                 if (ts)
>  730                         nfct_copy(ts->ct, ct, NFCT_CP_META);
>  731                 else {
>  732                         ts = calloc(sizeof(struct ct_timestamp), 1);
>  733                         if (ts == NULL)
>  734                                 return NFCT_CB_CONTINUE;
>  735
>  736                         ts->ct = ct;
>  737                         gettimeofday(&ts->time[START], NULL);
>  738
>  739                         ret = hashtable_add(cpi->ct_active,
> &ts->hashnode, id);
>  740                         if (ret < 0) {
>  741                                 free(ts);
>  742                                 return NFCT_CB_CONTINUE;
>  743                         }
>  744                         return NFCT_CB_STOLEN; // Here, why not
> NFCT_CB_CONTINUE is used?
>  745                 }
>  746                 break;
> 
> Here in Line no 744, why NFCT_CB_STOLEN is used instead of
> NFCT_CB_CONTINUE ? I am not able to understand the reason.

NFCT_CB_STOLEN means that the object is not released once the callback
code is done.

That object is released once we notice that the entry is not there in
the kernel anymore.
