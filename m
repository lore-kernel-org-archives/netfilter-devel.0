From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Building nth and random matches
Date: Tue, 3 Jul 2007 12:33:17 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707031233030.1536@fbirervta.pbzchgretzou.qr>
References: <468A244B.20806@8networks.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Robie Basak <robie@8networks.co.uk>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <468A244B.20806@8networks.co.uk>
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


On Jul 3 2007 11:26, Robie Basak wrote:
>Subject: Building nth and random matches

Because they are named statistic now...



>
> Hi,
>
> I can't seem to get the nth or random match extensions working. Ultimately I
> want to create custom installable Debian packages which give me them for
> deployment across our network.
>
> Evidently they exist as the manpage for iptables in Ubuntu (version
> 1.3.5.0debian1-1ubuntu2) as does the Netfilter Extensions HOWTO.
>
> However, I can't find them in vanilla linux-2.6.21.5, in Debian linux
> 2.6.18.dfsg.1 (current stable) nor in patch-o-matic-ng, and the original
> patch-o-matic is listed as obsolete and doesn't apply the patch ("2 files
> missing")
>
> Incidentally, the Extensions HOWTO is presumably outdated as it refers to CVS
> but you seem to have moved to Subversion at some point.
>
> What do I need to do? In particular I could do with having the random match. Is
> it a case of porting it from the old p-o-m to ng?
>
> I'm happy to attempt the port if this is what is needed. Is there anything in
> particular I need to change or does it just boil down to build system
> differences?
>
> Thanks,
> Robie.
>
>

	Jan
-- 
