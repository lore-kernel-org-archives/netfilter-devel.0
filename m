From: "David S. Miller" <davem@davemloft.net>
Subject: Re: Sparc64 U60: no iptables
Date: Sun, 09 Oct 2005 20:26:46 -0700 (PDT)
Message-ID: <20051009.202646.70198053.davem@davemloft.net>
References: <4347A731.7010509@frankengul.org> <4348EFF4.3040305@frankengul.org>
	<4349614F.1010408@frankengul.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, debian-sparc@lists.debian.org,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: seb@frankengul.org
In-Reply-To: <4349614F.1010408@frankengul.org>
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

From: S=E9bastien Bernard <seb@frankengul.org>
Date: Sun, 09 Oct 2005 20:28:31 +0200

> Can one explain me why this patch works on other archs, and oops on t=
he =

> sparc64 smp ?
> Can one explain why I'm the only one to have this problem ?

On your Ultra60 the two physical cpus are numbered "0" and "2".
