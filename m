From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack (l3 independent conntrack)
Date: Wed, 03 Dec 2003 21:48:29 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200312031249.VAA29743@toshiba.co.jp>
References: <20031118165138.GO5075@sunbeam.de.gnumonks.org>
	<200311190246.LAA10515@toshiba.co.jp>
	<20031119132444.GW5075@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
In-Reply-To: <20031119132444.GW5075@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi, Harald and all,

I've got the permission to publish my nf_conntrack.

In this code, nf_conntrack_tuple use "union" in the l3 part.
But anyway, I send it.

This is alpha version, please use on your responsibility.

And please don't forget that nf_conntrack.o don't work with ip_conntrack.o.

Regards,

----------------------------------------
Yasuyuki KOZAKAI

Communication Platform Laboratory,
Corporate Research & Development Center,
Toshiba Corporation

yasuyuki.kozakai@toshiba.co.jp
----------------------------------------
