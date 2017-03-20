From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH nf 1/1] netfilter: snmp: Fix one possible panic when
 snmp_trap_helper fail to register
Date: Mon, 20 Mar 2017 12:37:23 +0300
Message-ID: <b2344023-5045-a127-a3f2-0fc7ef898505@cogentembedded.com>
References: <1489974248-60293-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: fgao@ikuai8.com, pablo@netfilter.org, jolsa@redhat.com,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, gfree.wind@gmail.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1489974248-60293-1-git-send-email-fgao@ikuai8.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello!

On 3/20/2017 4:44 AM, fgao@ikuai8.com wrote:

> From: Gao Feng <fgao@ikuai8.com>
>
> In the commit ("netfilter: nf_conntrack: nf_conntrack snmp helper"),

    Need to specify the 12-digit SHA1 ID as well.

> the snmp_helper is replaced by nf_nat_snmp_hook. So the snmp_helper
> is never registered. But it still tries to unregister the snmp_helper,
> it could cause the panic.
>
> Now remove the useless snmp_helper and the unregister call in the
> error handler.
>
> Fixes: 93557f53e1fb ("netfilter: nf_conntrack: nf_conntrack snmp helper")
>
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
[...]

MBR, Sergei
