From: "jesse" <jesse@deansoft.com.tw>
Subject: Re: null binding question
Date: Fri, 8 Aug 2003 18:18:18 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <001501c35d96$64f8f260$0f01a8c0@jessepajh2dxik>
References: <20030808081531.GA31190@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Balazs Scheidler" <bazsi@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


----- Original Message -----
From: "Balazs Scheidler" <bazsi@balabit.hu>
To: <netfilter-devel@lists.netfilter.org>
Sent: Friday, August 08, 2003 4:15 PM
Subject: null binding question


> Hi,
>
> I'm reading the source code again to hunt down another Oops and I can't
see
> why null_binding is required. Can anyone explain me? A short hint would be
> enough.
In case some connection  have used this guy's original tupple for its nated
tupple(e.g. steal this guy's client port), So even no nat rule applied to
this guy, then without the null binding check, this guy will eventually fail
to confirm it's reply tupple(stolen by the previous some connection), while
with null binding, this guy may have chance to get it's reply uniche
again(nat will get him a uniche tuple).
Can this be short enough to get? :-)
>
> TPROXY does not allocate NULL bindings on its own, however NAT does this
for
> non-local connections. Quoting ip_nat_standalone.c:
>
> #ifdef CONFIG_IP_NF_NAT_LOCAL
>                                 if (hooknum == NF_IP_LOCAL_IN) {
Currently kernel don't implement nat table at NF_IP_LOCAL_IN, which is only
for LOCAL_OUT dnat thing's reply, so do'nt see any relation to null binding.
>                                         ret = NF_ACCEPT;
>                                 } else
> #endif
>                                 ret = ip_nat_rule_find(pskb, hooknum, in,
out,
>                                                        ct, info);
>
> Therefore as it seems it is not needed for local NATs. Is there a specific
> reason?
>
> --
> Bazsi
> PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C
8EB1
