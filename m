From: Balazs Scheidler <bazsi@balabit.hu>
Subject: null binding question
Date: Fri, 8 Aug 2003 10:15:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030808081531.GA31190@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm reading the source code again to hunt down another Oops and I can't see
why null_binding is required. Can anyone explain me? A short hint would be
enough.

TPROXY does not allocate NULL bindings on its own, however NAT does this for
non-local connections. Quoting ip_nat_standalone.c: 

#ifdef CONFIG_IP_NF_NAT_LOCAL
                                if (hooknum == NF_IP_LOCAL_IN) {
                                        ret = NF_ACCEPT;
                                } else
#endif
                                ret = ip_nat_rule_find(pskb, hooknum, in, out,
                                                       ct, info);

Therefore as it seems it is not needed for local NATs. Is there a specific
reason?

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
