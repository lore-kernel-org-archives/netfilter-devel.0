From: "Rick Xu" <rickxbx@gmail.com>
Subject: Something like a bug
Date: Mon, 14 Apr 2008 03:27:31 -0400
Message-ID: <dbdd0cc00804140027y54a00ca7pdef3b091dde33bf6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:38810 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759157AbYDNH1c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:27:32 -0400
Received: by an-out-0708.google.com with SMTP id d31so389205and.103
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Apr 2008 00:27:31 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-- 
Thanks,
Rick
Hi, I found something strange in libnfnetlink.c, have a look at the
following function:

int nfnl_nfa_addattr_l(struct nfattr *nfa, int maxlen, int type,
               const void *data, int alen)
{
 ......

    if ((NFA_OK(nfa, nfa->nfa_len) + len) > maxlen) {
        errno = ENOSPC;
        return -1;
    }

    subnfa = (struct nfattr *)(((char *)nfa) + NFA_OK(nfa, nfa->nfa_len));

.....
}

NFA_OK looks so weird here. I think it should be:
int nfnl_nfa_addattr_l(struct nfattr *nfa, int maxlen, int type,
               const void *data, int alen)
{
 ......

    if ( NFA_ALIGN(nfa->nfa_len) + NFA_LENGTH(len) > maxlen) {
        errno = ENOSPC;
        return -1;
    }

    subnfa = (struct nfattr *)(((char *)nfa) + NFA_ALIGN( nfa->nfa_len));

.....
}

Please kindly correct me if I made a mistake.
