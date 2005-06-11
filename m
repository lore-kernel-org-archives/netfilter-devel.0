From: Patrick McHardy <kaber@trash.net>
Subject: Re: [1/3] OSF: code beautification.
Date: Sat, 11 Jun 2005 18:30:41 +0200
Message-ID: <42AB11B1.6010605@trash.net>
References: <20050530002000.4c63b34b@zanzibar.2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: johnpol@2ka.mipt.ru
In-Reply-To: <20050530002000.4c63b34b@zanzibar.2ka.mipt.ru>
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

Evgeniy Polyakov wrote:
> { placement, copyright data change, list_for_each_entry usage.

The patch fails to apply cleanly:

patching file linux-2.6/net/ipv4/netfilter/ipt_osf.c
Hunk #2 succeeded at 100 (offset -2 lines).
Hunk #3 succeeded at 124 (offset -2 lines).
Hunk #4 succeeded at 154 with fuzz 2 (offset -4 lines).
Hunk #5 FAILED at 177.
Hunk #6 succeeded at 177 (offset -21 lines).
Hunk #7 succeeded at 186 (offset -21 lines).
Hunk #8 succeeded at 216 (offset -21 lines).
Hunk #9 succeeded at 225 (offset -21 lines).
Hunk #10 succeeded at 235 (offset -21 lines).
Hunk #11 succeeded at 244 (offset -21 lines).
Hunk #12 succeeded at 267 (offset -21 lines).
Hunk #13 succeeded at 277 (offset -21 lines).
Hunk #14 succeeded at 312 (offset -21 lines).
Hunk #15 succeeded at 320 (offset -21 lines).
Hunk #16 succeeded at 331 (offset -21 lines).
Hunk #17 FAILED at 340.
Hunk #18 succeeded at 362 (offset -21 lines).
Hunk #19 succeeded at 436 (offset -21 lines).
Hunk #20 succeeded at 467 (offset -21 lines).
Hunk #21 succeeded at 494 (offset -21 lines).
Hunk #22 succeeded at 511 (offset -21 lines).
Hunk #23 succeeded at 547 (offset -21 lines).
Hunk #24 succeeded at 555 (offset -21 lines).
Hunk #25 succeeded at 565 (offset -21 lines).
Hunk #26 succeeded at 592 (offset -21 lines).
Hunk #27 succeeded at 617 (offset -21 lines).
Hunk #28 succeeded at 626 (offset -21 lines).
Hunk #29 succeeded at 643 (offset -21 lines).
Hunk #30 succeeded at 651 (offset -21 lines).
Hunk #31 succeeded at 662 (offset -21 lines).
Hunk #32 succeeded at 698 (offset -21 lines).
Hunk #33 succeeded at 739 (offset -21 lines).
Hunk #34 succeeded at 754 (offset -21 lines).
Hunk #35 succeeded at 766 (offset -21 lines).

It looks like the patch is against the 2.4 version. This is one
of the rejects:

***************
*** 182,193 ****
        df = ((ntohs(ip->frag_off) & IP_DF)?1:0);
        window = ntohs(tcp->window);

-       if (tcp->doff*4 > sizeof(struct tcphdr))
-       {
                optsize = tcp->doff*4 - sizeof(struct tcphdr);

-               if (optsize > sizeof(opts))
-               {
                        log("%s: BUG: too big options size: optsize=%lu,
max=%d.\n",
                                        __func__, optsize, sizeof(opts));
                        optsize = sizeof(opts);

And this is the code in linux-2.6:

        df = ((ntohs(ip->frag_off) & IP_DF)?1:0);
        window = ntohs(tcp->window);

        if (tcp->doff*4 > sizeof(struct tcphdr))
        {
                _optp = optp = (char *)(tcp+1);
                optsize = tcp->doff*4 - sizeof(struct tcphdr);
        }

Please fix this up and resend the entire patchset.

Regards
Patrick
