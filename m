From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: RE: Memory leaks in ip_conntrack?
Date: Wed, 12 Nov 2003 13:54:43 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0311121353180.26788-100000@blackhole.kfki.hu>
References: <EFBADA8C200C2B418DA39734FD15475B0B2061@skat.sky.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter@lists.netfilter.org>,
	"'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kishore Dharmavaram <kishored@servgate.com>
In-Reply-To: <EFBADA8C200C2B418DA39734FD15475B0B2061@skat.sky.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 11 Nov 2003, Kishore Dharmavaram wrote:

> It seems some patches were already applied on base 2.4.20 kernel netfilter
> sources that iam working with, is there a way to findout what patches were
> applied on netfilter code? and are some must-apply patches for 2.4.20?, if
> so can you please give me a list or pointout few?

Run './runme extra' from patch-o-matic with pointing to the correct kernel
tree and don't apply any patches. The already applied ones will be listed
on your screen.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
