From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] update raw patch in POM
Date: Tue, 28 Jun 2005 08:02:39 +0200
Message-ID: <42C0E7FF.60406@tac.ch>
References: <42A6AB19.2040106@tac.ch>	<42A6E685.3060408@eurodev.net>	<42AEF774.8060300@tac.ch>	<42B67BEC.1090105@tac.ch>	<20050621003441.GI8335@postel.suug.ch>	<42B76474.8080209@eurodev.net>	<20050621111328.GK8335@postel.suug.ch>	<42B81D75.8090205@trash.net>	<20050621215027.GP8335@postel.suug.ch>	<42B8B181.4020607@trash.net>	<20050622005243.GQ8335@postel.suug.ch>	<42B8DA09.9080406@eurodev.net>	<42B8E141.1080902@trash.net>	<42B94DFE.2070205@tac.ch>	<42B9B00F.90601@trash.net>	<42BF9E5D.4000705@tac.ch>	<42BFDBA1.7060002@trash.net>
	<42BFEC10.20102@tac.ch>	<42BFF730.2080300@trash.net>
	<42C004D1.2030304@tac.ch> <42C0201E.3080805@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42C0201E.3080805@trash.net>
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

>>Maybe the above sketch explains the confusion I might have created.
> 
> I think both patches together are the correct fix, I just wanted
> to understand where the hang comes from to be sure.

Ok.

>>>There's no raw table in 2.4, so the wait-for-untracked-refs patch should
>>>go in the 2.4 raw table patch.
>>
>>
>>Pablo, shall I do it and submit for POM?
> 
> Yes, please.

I'll do it tomorrow, today is too a nice day to hack over here.

> It is possible, but it is not yet decided if we're going to
> submit that change.

I could certainly be a test candidate since we still only deploy 2.4.x based
packet filters and have about 200 out there in the world.

Thanks again to all people that helped me chasing down this defect code,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
