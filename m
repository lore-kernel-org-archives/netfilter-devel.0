From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] netfilter: implement TCPMSS target for IPv6
Date: Mon, 15 Jan 2007 15:38:48 +0100
Message-ID: <45AB91F8.1050802@trash.net>
References: <20070114192011.GA6270@clipper.ens.fr>
	<Pine.LNX.4.61.0701142110250.11926@yvahk01.tjqt.qr>
	<45AB3DCA.9020204@trash.net>
	<Pine.LNX.4.61.0701151109540.32479@yvahk01.tjqt.qr>
	<45AB54E5.6060103@trash.net>
	<Pine.LNX.4.61.0701151358130.13639@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0701151358130.13639@yvahk01.tjqt.qr>
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

[CC-list trimmed]

Jan Engelhardt wrote:
> On Jan 15 2007 11:18, Patrick McHardy wrote:
> 
>>If you're talking about using the xt-structures in net/ipv[46]/netfilter
>>and removing the ipt/ip6t-wrappers, that would make sense IMO.
> 
> 
> Yup. Should the files then be renamed/moved to net/netfilter/xt_[foobaz].c
> in a second step?

No, the address family dependant stuff should stay where it is.

> Should I leave ipt_TCPMSS/ip6t_TCPMSS untouched while you are working on 
> that one?

Yes, I'm done porting it to x_tables, but it still needs testing.
