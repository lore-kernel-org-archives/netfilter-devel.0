From: "Maciej Soltysiak" <solt@dns.toxicfilms.tv>
Subject: [RFC]correction - cloned skbs - if i am right there is a bug in ipt_ECN.c
Date: Fri, 12 Dec 2003 21:10:00 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <003001c3c0eb$ede8cb50$0e25fe0a@southpark.ae.poznan.pl>
References: <002701c3c0ea$e26efa70$0e25fe0a@southpark.ae.poznan.pl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Maciej Soltysiak" <solt@dns.toxicfilms.tv>,
	<netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> But iph is not used, we are using tcph later on in the code, so we should:
>                 tcph = (*pskb)->nh.tcph;
Of course I meant:
                tcph = (*pskb)->h.th;

Regards,
Maciej
