From: "David S. Miller" <davem@redhat.com>
Subject: Re: Extremely slow network with e1000 & ip_conntrack
Date: Tue, 2 Dec 2003 21:03:37 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031202210337.5dda502f.davem@redhat.com>
References: <20031130074532.0105.MUKANSAI@emailplus.org>
	<20031130155236.GJ26749@obroa-skai.de.gnumonks.org>
	<20031202204404.9ADD.MUKANSAI@emailplus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
        linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephen Lee <mukansai@emailplus.org>
In-Reply-To: <20031202204404.9ADD.MUKANSAI@emailplus.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 02 Dec 2003 20:44:06 +0900
Stephen Lee <mukansai@emailplus.org> wrote:

> After lots of trial-and-error, I can make the problem disappear by
> backing these 4 files out from 2.5.44 to their 2.5.43 versions.
> 
> net/ipv4/icmp.c
> net/ipv4/ip_output.c
> net/ipv4/raw.c
> net/ipv4/udp.c

Interesting, but not very.  This essentially backs out the whole
ipv4 packet sending engine rewrite we did to support IPSEC and
UDP sendfile support.

Ie. it's a lot of large interrelated changes.  We know now what
introduced the problem, but this hasn't really narrowed it down
much.
