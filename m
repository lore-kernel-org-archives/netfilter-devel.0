From: Jonas Berlin <jberlin@niksula.hut.fi>
Subject: [PATCH] conntrack-acct "workaround" for 2.6.9+
Date: Thu, 17 Feb 2005 02:20:32 +0200
Message-ID: <4213E350.8060604@niksula.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

patch-o-matic-ng fails to detect that conntrack-acct is already applied 
(I don't know how it does the detection) and thus fails when trying to 
apply it.

However, if an empty file called linux-2.6.9.patch is placed in the 
conntrack-acct/ directory, everything works just fine.

I noticed this problem when I was trying to patch connbytes into the 
kernel (which depends on conntrack-acct). After adding the empty patch 
file, connbytes also went in just fine.

So unless there's a better way of fixing it in the patch-o-matic-ng 
detection code, maybe someone with commit rights just create an empty 
conntrack-acct/linux-2.6.9.patch file :)

(I verified that the original patch worked until 2.6.8 ; hence my choice 
of 2.6.9)

-- 
- xkr47
