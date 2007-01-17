From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: ipt->xt [p2]
Date: Wed, 17 Jan 2007 13:38:23 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701171337520.18562@yvahk01.tjqt.qr>
References: <20070114192011.GA6270@clipper.ens.fr>
	<Pine.LNX.4.61.0701142110250.11926@yvahk01.tjqt.qr>
	<45AB3DCA.9020204@trash.net>
	<Pine.LNX.4.61.0701151109540.32479@yvahk01.tjqt.qr>
	<45AB54E5.6060103@trash.net>
	<Pine.LNX.4.61.0701151526300.13639@yvahk01.tjqt.qr>
	<45AB94F7.6040806@trash.net>
	<Pine.LNX.4.61.0701151725490.23841@yvahk01.tjqt.qr>
	<45ABAD74.7010808@trash.net>
	<Pine.LNX.4.61.0701151737240.23841@yvahk01.tjqt.qr>
	<45AE0919.2040109@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45AE0919.2040109@trash.net>
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


On Jan 17 2007 12:31, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> Ok, here you go, two diffs, one for the xt (did I catch all the compat 
>> stuff?) and the error value propagation.
>
>You seem to be missing ip6_tables.

I have not yet gone through net/ipv6/netfilter/, right.

>Also please remove the registration wrappers.

How do you mean?


	-`J'
-- 
