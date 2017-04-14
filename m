From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf-next v2 1/1] netfilter: SYNPROXY: Return NF_STOLEN instead of NF_DROP during handshaking
Date: Fri, 14 Apr 2017 12:52:05 +0800
Message-ID: <001401d2b4da$dd757ba0$986072e0$@foxmail.com>
References: <1491963290-84377-1-git-send-email-gfree.wind@foxmail.com> <20170413215749.GA4208@salvia> <001201d2b4aa$57bc8ba0$0735a2e0$@foxmail.com> <20170413231135.GA7158@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg62.qq.com ([103.7.29.139]:46315 "EHLO smtpbg64.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750888AbdDNEwH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Apr 2017 00:52:07 -0400
In-Reply-To: <20170413231135.GA7158@salvia>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: netfilter-devel-owner@vger.kernel.org
> On Fri, Apr 14, 2017 at 07:04:44AM +0800, Gao Feng wrote:
> > > -----Original Message-----
> > > From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> > >
> > > On Wed, Apr 12, 2017 at 10:14:50AM +0800, gfree.wind@foxmail.com
> wrote:
> > > >
> > > > Current SYNPROXY codes return NF_DROP during normal TCP
> > > > handshaking, it is not friendly to caller. Because the
> > > > nf_hook_slow would treat the NF_DROP as an error, and return -EPERM.
> > > > As a result, it may cause the top caller think it meets one error.
> > > >
> > > > So use NF_STOLEN instead of NF_DROP now because there is no error
> > > > happened indeed, and free the skb directly.
> > >
> > > Is this really addressing a real problem? How did you reproduce it?
> >
> > We defined the NF_DROP and NF_STOLEN, I think we should use them
> clearly.
> > When NF_DROP happens, it means one error happened.
> 
> That's a valid concern. How did you tested this change?

The test is a little hacker. The following is my whole test process.
1. Add one "print" member in the struct sk_buff; it would be zero by
default;
2. Add one log in the netif_receive_skb_internal 
+       if (skb->print)
+               pr_info("skb(%p) ret is %d\n", skb, ret);
3. the iptable rule is "iptables -A INPUT -p tcp --dport 12345 -m conntrack
--ctstate NEW -j SYNPROXY"

Test NF_DROP with the original codes:
1. I comment out the "kfree_skb" in the NF_DROP handler of nf_hook_slow.
2. Add one log before return NF_DROP in the synproxy codes
pr_info("skb(%p) is dropped\n", skb);

The result is following:
[   71.765035] skb(ffff9a6208bd7500) is dropped
[   71.765049] skb(ffff9a6208bd7500) ret is -1

Test NF_STOLEN with the patch:
1. I comment out the "consume_skb" before return NF_STOLEN;
2. Add the log before return NF_STOLEN in the synproxy codes
pr_info("skb(%p) is stolen\n", skb);

The test result is following:
[  221.564370] skb(ffff9a01214a8c00) is stolen
[  221.564383] skb(ffff9a01214a8c00) ret is 0

To summary, netif_receive_skb would return -EPERM when Netfilter returns
NF_DROP,
but NF_STOLEN not.
For the caller which cares about the return value of netif_receive_skb would
treat it
as one error.
Like cfv_rx_poll() in drivers/net/caif/caif_virtio.c.
                err = netif_receive_skb(skb);
                if (unlikely(err)) {
                        ++cfv->ndev->stats.rx_dropped;
                } else {
                        ++cfv->ndev->stats.rx_packets;
                        cfv->ndev->stats.rx_bytes += skb_len;
                }
It would cause the driver increase the dropped counter.

Best Regards
Feng

> 
> [...]
> > Sorry, I always use one command "git format-patch -s -n master..XX"
> > according to one document
> > whose title is "HOWTO: Create and submit your first Linux kernel patch
> > using GIT".
> >
> > It generate the "1/1" by default.
> 
> There are ways to avoid that. Only you send 1/1 patches.
> 
> > I will try to lookup other documents about the patch rule, and correct
> > the current command.
> 
> OK.
> 
> [...]
> > More carefully, and don't rush more.
> 
> Thank you.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

