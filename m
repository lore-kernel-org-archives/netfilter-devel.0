From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf-next v2 1/1] netfilter: nat: Correct the return value check for nat mangled packet
Date: Fri, 7 Apr 2017 06:20:33 +0800
Message-ID: <001901d2af24$026e6b40$074b41c0$@foxmail.com>
References: <1490627528-32491-1-git-send-email-gfree.wind@foxmail.com> <20170406191819.GA3749@salvia> <20170406192450.GA4195@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>, "'Gao Feng'" <fgao@ikuai8.com>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpproxy19.qq.com ([184.105.206.84]:55919 "EHLO
        smtpproxy19.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752226AbdDFWUg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 18:20:36 -0400
In-Reply-To: 
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: Gao Feng [mailto:gfree.wind@foxmail.com]
> Sent: Friday, April 7, 2017 6:16 AM
> To: 'Pablo Neira Ayuso' <pablo@netfilter.org>
> Cc: 'netfilter-devel@vger.kernel.org' <netfilter-devel@vger.kernel.org>;
'Gao
> Feng' <fgao@ikuai8.com>
> Subject: RE: [PATCH nf-next v2 1/1] netfilter: nat: Correct the return
value
> check for nat mangled packet
> 
> Hi Palbo,
> 
> > -----Original Message-----
> > From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> > Sent: Friday, April 7, 2017 3:25 AM
> > To: gfree.wind@foxmail.com
> > Cc: netfilter-devel@vger.kernel.org; Gao Feng <fgao@ikuai8.com>
> > Subject: Re: [PATCH nf-next v2 1/1] netfilter: nat: Correct the return
> > value check for nat mangled packet
> >
> > On Thu, Apr 06, 2017 at 09:18:19PM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Mar 27, 2017 at 11:12:08PM +0800, gfree.wind@foxmail.com
> > wrote:
> > > > From: Gao Feng <fgao@ikuai8.com>
> > > >
> > > > The return value type of function nf_nat_mangle_tcp/udp_packet is
> > > > int, but actually it is used as bool type. And most codes follow
> > > > this rule, for example, the sip, h323, and ftp. But some codes
> > > > treat the return value as NF_ACCEPT and NF_DROP, like amanda and
irc.
> > > >
> > > > Now use the bool type instead of the int to make it clear.
> > >
> > > One spot still not converted.
> > >
> > > I'm going to collapse this patch to yours. Please review so you
> > > don't have to send a v3.
> >
> > And if this chunk looks good to you, I'll apply this patch with this
> > title:
> >
> > netfilter: nf_nat: nf_nat_mangle_{udp,tcp}_packet returns Boolean
> 
> Thanks, it is ok to me.
> 
> Best Regards
> Feng

Sorry, I misspelled your name in the last email.

Best Regards
Feng



