From: Patrick McHardy <kaber@trash.net>
Subject: Re: ENOBUFS in nfq under heavy load
Date: Tue, 17 Jul 2007 17:56:10 +0200
Message-ID: <469CE69A.9010509@trash.net>
References: <717e7cba0707170846k1856a1dbub59fc253dbaf070f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: =?ISO-8859-15?Q?Stanis=B3aw_Pitucha?= <viraptor@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <717e7cba0707170846k1856a1dbub59fc253dbaf070f@mail.gmail.com>
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

Stanis=B3aw Pitucha wrote:
> After running nf_queue app under heavy load I get ENOBUFS error. Ok -
> maybe not that heavy - around 100 concurrent voip calls - lots of
> small udp packets. Nfq socket suddenly hangs. recv() from nfnl_fd()
> socket returns -1, errno=3DENOBUFS and when I try to destroy the queue
> it stops:

Which kernel version? What exactly do you mean with "it stops"?
