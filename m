From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] uncast some ip_conntrack_get callsites
Date: Tue, 09 Jan 2007 12:21:07 +0100
Message-ID: <45A37AA3.8040309@trash.net>
References: <Pine.LNX.4.61.0612281820590.23545@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0612281820590.23545@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> ip_conntrack_get already takes a const struct sk_buff *, so no need to 
> cast the const away.


While the patch is obvious and small, I won't apply any cleanup patches
for ip_conntrack anymore since its scheduled for removal in 2.6.22.
Please put all your energy in nf_conntrack :)
