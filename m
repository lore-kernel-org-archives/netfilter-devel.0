From: "David S. Miller" <davem@davemloft.net>
Subject: Re: ip{,6}t_random / fix build warnings.
Date: Sat, 17 Sep 2005 23:15:27 -0700 (PDT)
Message-ID: <20050917.231527.36915714.davem@davemloft.net>
References: <200509171330.59410.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp-2
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pluto@agmk.net
In-Reply-To: <200509171330.59410.pluto@agmk.net>
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

From: Pawe$,1 b(B Sikora <pluto@agmk.net>
Date: Sat, 17 Sep 2005 13:30:59 +0200

> Attached patch fixes gcc warnings:
> 

Don't cast the value, use the correct "%Zu" and "%Zd"
size_t printf format strings instead as that's what the
compiler is warning about.
