From: Yoshioka Tsuneo <tsuneo.yoshioka@f-secure.com>
Subject: Request: including tproxy patch to official iptables/kernel.
Date: Mon, 16 Oct 2006 12:17:58 +0900
Message-ID: <20061016114331.AF36.TSUNEO.YOSHIOKA@f-secure.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hello netfilter developers

There is tproxy patch for netfilter(iptables).
tproxy enables application to set source IP address.
I think that only tproxy patch can enable transparent proxy keeping
source IP addresses.

And, until now, tproxy is developed and is used for long term, and seems
stable to include official iptables/kernel release. There is also a patch
for latest kernel.

So, I would like to suggest to include tproxy patch to official
iptables/kernel release.
Can you think about including this patch to official iptables/kernel
release, if possible ?

   TPROXY
       http://www.balabit.com/products/oss/tproxy/

   patch-o-matic extra repository
     tproxy - iptables TPROXY target
       http://www.iptables.org/projects/patch-o-matic/pom-extra.html#pom-extra-tproxy


Thank you !

-- 
Nihon F-Secure Corporation
(Yoshioka Tsuneo)
E-MAIL: Tsuneo.Yoshioka@f-secure.com
