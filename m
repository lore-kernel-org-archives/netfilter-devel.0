From: larsbj@birdstep.com (=?iso-8859-1?q?Lars_Gullik_Bj=F8nnes?=)
Subject: Re: Support for ip-ranges.
Date: Tue, 19 Aug 2003 13:43:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <m34r0dub2x.fsf@trylle.birdstep.com>
References: <m3n0ekpevv.fsf@tyfon.gullik.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <m3n0ekpevv.fsf@tyfon.gullik.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

larsbj@birdstep.com (Lars Gullik Bj=F8nnes) writes:

| Are there support for matching on ip ranges in iptables now?
>
| I am thinking of something like:
>
|   --match iprange --iprange-begin 192.168.10.23 --iprange-end 192.168.1=
1.15
>
| Have this been thought of or is it something that would
| be interesting?

[posted several days ago what happened to it?]

Anyway I found the iprange patch on the web page, what are the
prospects on getting this patch into ipfilter/iptables proper?

--=20
	Lgb
