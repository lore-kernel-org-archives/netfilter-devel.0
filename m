From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: REJECT target
Date: Wed, 25 Jun 2003 09:17:56 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0306250916010.7456-100000@blackhole.kfki.hu>
References: <19527171580.20030625023903@habitat-b.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: DarKRaveR <DarKRaveR@habitat-b.de>
In-Reply-To: <19527171580.20030625023903@habitat-b.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 25 Jun 2003, DarKRaveR wrote:

>   I know this is not really a developers question, but maybe the
>   developers are the right people at hand, to explain this.
>   From what I read, the REJECT target is only valid in
>   INPUT/OUPUT/FORWARD. Is there any particular reason why ? I read in
>   one of the tutorials, that you wouldn't need it at any other place,
>   but I think this is not perfectly true.

The REJECT target is for filtering. The filter table has got the
INPUT/OUPUT/FORWARD chains, therfore the REJECT target can be used in
those chains (and sub-chains, naturally).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
