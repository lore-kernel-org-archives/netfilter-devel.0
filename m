From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Does netfilter disable TCP checksum offload? (fwd)
Date: Thu, 6 Nov 2003 13:43:53 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0311061338200.18271-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Actually, I cannot myself answer why skb->ip_summed is set to
CHECKSUM_NONE in nf_hook_slow.

Shouldn't we simply remove that little part from the code and reset
skb->ip_summed only in the relevant targets (as it is already done in
ipt_TCPMSS.c).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary

---------- Forwarded message ----------
Date: Mon, 20 Oct 2003 08:08:46 -0700 (PDT)
From: Bluesea Yreen <big_bluesea@yahoo.com>
To: netfilter@lists.netfilter.org
Subject: Does netfilter disable TCP checksum offload?

Hi There,

I am trying to use TCP checksum offload under Linux. I
found that if I install the netfilter, I cannot use
TCP checksum offload feature. Because "nf_hook_slow"
is called if there is any HOOK registered in the
output path, and "skb->ip_summed" is set to
"CHECKSUM_NONE" eventually.

Am I right about that I cannot use TCP checksum
offload feature if there is any HOOK registered in the
output path? If it's right, how can I use TCP checksum
offload feature while having the netfilter installed.
Can I do it but disabling some netfilter options?

Thanks,

Bluesea

__________________________________
Do you Yahoo!?
The New Yahoo! Shopping - with improved product search
http://shopping.yahoo.com
