From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf-next v2 1/1] netfilter: SYNPROXY: Return NF_STOLEN instead of NF_DROP during handshaking
Date: Fri, 14 Apr 2017 07:04:44 +0800
Message-ID: <001201d2b4aa$57bc8ba0$0735a2e0$@foxmail.com>
References: <1491963290-84377-1-git-send-email-gfree.wind@foxmail.com> <20170413215749.GA4208@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>,
        <gfree.wind@foxmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg202.qq.com ([184.105.206.29]:47973 "EHLO smtpbg202.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751576AbdDMXEt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 19:04:49 -0400
In-Reply-To: <20170413215749.GA4208@salvia>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> 
> On Wed, Apr 12, 2017 at 10:14:50AM +0800, gfree.wind@foxmail.com wrote:
> >
> > Current SYNPROXY codes return NF_DROP during normal TCP handshaking,
> > it is not friendly to caller. Because the nf_hook_slow would treat the
> > NF_DROP as an error, and return -EPERM.
> > As a result, it may cause the top caller think it meets one error.
> >
> > So use NF_STOLEN instead of NF_DROP now because there is no error
> > happened indeed, and free the skb directly.
> 
> Is this really addressing a real problem? How did you reproduce it?

We defined the NF_DROP and NF_STOLEN, I think we should use them clearly.
When NF_DROP happens, it means one error happened.

In this case, when synproxy returns NF_DROP, it would be returned as the
return
value of netif_receive_skb.
And some driver would check the return value, like sb1250-mac.c.
Its function "sbdma_rx_process" checks the return value of
"netif_receive_skb".

dropped = netif_receive_skb(sb);
if (dropped == NET_RX_DROP) {
    dev->stats.rx_dropped++;
........

The "NET_RX_DROP" is same as NF_DROP. When return NF_DROP, it would add the 
dropped counter.


> 
> BTW, your patch title is wrong.
> 
> [PATCH nf-next v2 1/1]
>                   ^^^
> 
> This 1/1 is completely useless, please remove it in your follow up
patches.

Sorry, I always use one command "git format-patch -s -n master..XX"
according to one document
whose title is "HOWTO: Create and submit your first Linux kernel patch using
GIT".

It generate the "1/1" by default.

I will try to lookup other documents about the patch rule, and correct the
current command.

> 
> Moreover, you should be more careful, *really*, this is not a speed coding
> contest. You tend to send me follow up patch version just hours afterwards
> because you rush too much.

Yes, it is my fault. I would pay more attention on it.
I treated the patch commit as the power which could push me investigate the
kernel codes.
When one commit is accept, it would excite me a lot.

>From now on, I would use the power more carefully, and don't rush more.

> 
> Be more careful, use the same email address to send your patches. Drop
quote
> the full email in your replies...

I would drop the quote by manual carefully. 
As mentioned in other email, I have to change my email from gmail, and try
to find one which could support text email well recently

More carefully, and don't rush more.
I must follow it.

Best Regards
Feng

> 
> Other than that, I may start ignoring your patches, it's too hard to keep
up with
> this.



