From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [net-next v2] netfilter: add segment routing header 'srh' match
Date: Mon, 8 Jan 2018 14:37:11 +0100
Message-ID: <20180108133711.dnxope5qjcnl3yvx@salvia>
References: <1515349322-23097-1-git-send-email-amsalam20@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Ahmed Abdelsalam <amsalam20@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515349322-23097-1-git-send-email-amsalam20@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, Jan 07, 2018 at 07:22:02PM +0100, Ahmed Abdelsalam wrote:
> It allows matching packets based on Segment Routing Header
> (SRH) information.
> The implementation considers revision 7 of the SRH draft.
> https://tools.ietf.org/html/draft-ietf-6man-segment-routing-header-07
> 
> Currently supported match options include:
> (1) Next Header
> (2) Hdr Ext Len
> (3) Segments Left
> (4) Last Entry
> (5) Tag value of SRH

net/ipv6/netfilter/ip6t_srh.c: In function ‘srh_mt6’:
net/ipv6/netfilter/ip6t_srh.c:115:10: error: ‘struct ipv6_sr_hdr’ has
no member named ‘tag’
     !(srh->tag == srhinfo->tag)))
          ^
net/ipv6/netfilter/ip6t_srh.c:26:4: note: in definition of macro
‘NF_SRH_INVF’
  ((boolean) ^ !!((ptr)->mt_invflags & (flag)))
    ^

Something breaks compilation here.
