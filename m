From: Jan Holmberg <jan@artech.net>
Subject: Fix ipt_TCPMSS.c for kernel 2.5.47
Date: Wed, 13 Nov 2002 17:58:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DD284A9.EA60D065@artech.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,


Minor fix for ipt_TCPMSS.c since pmtu don't exsist anymore...


*** linux-2.5.47-org/net/ipv4/netfilter/ipt_TCPMSS.c Thu Nov 14 01:24:42
2002
--- linux-2.5.47/net/ipv4/netfilter/ipt_TCPMSS.c Mon Nov 11 04:28:16
2002
***************
*** 92,98 ****
     return NF_DROP; /* or IPT_CONTINUE ?? */
    }

!   newmss = dst_pmtu((*pskb)->dst->pmtu) - sizeof(struct iphdr) -
sizeof(struct tcphdr);
   } else
    newmss = tcpmssinfo->mss;

--- 92,98 ----
     return NF_DROP; /* or IPT_CONTINUE ?? */
    }

!   newmss = dst_pmtu((*pskb)->dst) - sizeof(struct iphdr) -
sizeof(struct tcphdr);
   } else
    newmss = tcpmssinfo->mss;

regards

Jan Holmberg, sysadm artech
