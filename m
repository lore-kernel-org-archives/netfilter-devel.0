From: Dan Carpenter <error27@gmail.com>
Subject: off by one in update_nl_seq()
Date: Sun, 27 Dec 2009 15:12:30 +0200
Message-ID: <20091227131229.GH6075@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:43385 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZL0NMv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Dec 2009 08:12:51 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

net/netfilter/nf_conntrack_ftp.c
   321  /* We don't update if it's older than what we have. */
   322  static void update_nl_seq(struct nf_conn *ct, u32 nl_seq,
   323                            struct nf_ct_ftp_master *info, int dir,
   324                            struct sk_buff *skb)
   325  {
   326          unsigned int i, oldest = NUM_SEQ_TO_REMEMBER;

Should this be oldest = NUM_SEQ_TO_REMEMBER - 1;?  The array is 
defined as:
u_int32_t seq_aft_nl[IP_CT_DIR_MAX][NUM_SEQ_TO_REMEMBER];

   327
   328          /* Look for oldest: if we find exact match, we're done. */
   329          for (i = 0; i < info->seq_aft_nl_num[dir]; i++) {
   330                  if (info->seq_aft_nl[dir][i] == nl_seq)
   331                          return;
   332
   333                  if (oldest == info->seq_aft_nl_num[dir] ||
   334                      before(info->seq_aft_nl[dir][i],
   335                             info->seq_aft_nl[dir][oldest]))  

Line 335 has the possible array out of bounds I am concerned about. 

regards,
dan carpenter
