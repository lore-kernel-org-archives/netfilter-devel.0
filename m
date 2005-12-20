From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: l3num is u_int16_t
Date: Tue, 20 Dec 2005 14:25:34 +0900 (JST)
Message-ID: <200512200525.jBK5PYag019464@toshiba.co.jp>
References: <43A6F849.6070602@eurodev.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
In-Reply-To: <43A6F849.6070602@eurodev.net>
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

From: Pablo Neira Ayuso <pablo@eurodev.net>
Date: Mon, 19 Dec 2005 19:13:29 +0100

> Hi Yasuyuki,
> 
> /* The manipulable part of the tuple. */
> struct nf_conntrack_man
> {
>         union nf_conntrack_man_l3proto u3;
>         union nf_conntrack_man_proto u;
>         /* Layer 3 protocol */
>         u_int16_t l3num;
> };
>
> struct nfgenmsg {
>         u_int8_t  nfgen_family;         /* AF_xxx */
>         u_int8_t  version;              /* nfnetlink version */
>         u_int16_t res_id;               /* resource id */
> } __attribute__ ((packed));
> 
> There's some inconsistency here: why l3num is u_int16_t but nfgen_family
> in u_int8_t? AFAIK, both designates the same thing, the layer 3 protocol
> number.

I just copied protonum, in old nf_conntrack ;)
I think we can change it to u_int8_t because this definition is for only
kernel. The my remaind concern is alignment. Is there any reason
that we need to add "u_int8_t pad" after l3num ?

-- Yasuyuki Kozakai
