From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] xt_request_find_match
Date: Tue, 19 Dec 2006 14:07:17 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0612191405160.24179@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0612161851180.30896@yvahk01.tjqt.qr>
	<4587D227.1000003@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4587D227.1000003@trash.net>
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


On Dec 19 2006 12:51, Patrick McHardy wrote:
>> Reusing code is a good idea, and I would like to do so from my 
>> match modules. netfilter already provides a xt_request_find_target() but 
>> an xt_request_find_match() does not yet exist. This patch adds it.
>
>Why does your match module needs to lookup other matches?

To use them?

I did not want to write


some_xt_target() {
    if(skb->nh.iph->protocol == IPPROTO_TCP)
        do_this();
    else
        do_that();
}

since the xt_tcpudp module provides far more checks than just the protocol
(TCP/UDP), like

    /* To quote Alan:

       Don't allow a fragment of TCP 8 bytes in. Nobody normal
       causes this. Its a cracker trying to break in by doing a
       flag overwrite to pass the direction checks.
    */

(see xt_tcpudp.c)



	-`J'
-- 
