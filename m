From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH 4/4] Switch xt_target->checkentry to bool
Date: Mon, 4 Jun 2007 17:29:00 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706041728460.20829@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706041707410.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706041711020.20829@yvahk01.tjqt.qr>
	<46642ECE.1090402@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46642ECE.1090402@trash.net>
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


On Jun 4 2007 17:25, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> Switch the return type of target functions to boolean.

Log correction: return type of xt_target's checkentry().


	Jan
-- 
