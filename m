From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Question about tcp reopen in tcp_in_window
Date: Thu, 17 Nov 2011 14:52:34 +0800
Message-ID: <4EC4AF32.5050901@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org, xiaosuo@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53888 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754158Ab1KQGvy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Nov 2011 01:51:54 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

I has a question about the tcp reopen request in func tcp_in_window.
The code is below,what confuse me is that the var end is never after sender->td_end.

static int tcp_in_window(struct ip_ct_tcp *state,
		...
	if (sender->td_end == 0) {
		...
	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
                     && dir == IP_CT_DIR_ORIGINAL)
                   || (state->state == TCP_CONNTRACK_SYN_RECV
                     && dir == IP_CT_DIR_REPLY))
                   && after(end, sender->td_end)) {

		...
	}
		...
}


When nf_conn rcv a syn request in TIME_WAIT state,the new_state is SYN_SNET.
in func tcp_packet, this nf_conn will be kill by nf_ct_kill and the syn packet will repeat.
So we will have a new nf_conn,whose sender->td_end is reset in func tcp_new.

finally,when this syn packet arrive tcp_in_window,the var end is equal to sender->td_end.

Maybe there is the other situation Or what I understand is totally wrong?
